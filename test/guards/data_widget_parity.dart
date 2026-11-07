// Parity guard, its checks listed in APPENDIX.md#parity-guard.

// This guard declares several private visitor / record classes in one file.
// ignore_for_file: prefer-match-file-name

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/lib_src.dart';

/// The method each look builds in, a `PlatformWidgetBase` half or a `PlatformAppBarData` builder.
final _halfNames = {
  'material': {lookHalves.material, 'materialBuilder'},
  'cupertino': {lookHalves.cupertino, 'cupertinoBuilder'},
};

void dataWidgetParityGuard() {
  late final List<LibSrcUnit> units;
  late final List<_Base> bases;
  late final Map<String, _Widget> widgetsByName;

  group('Data/widget parity guard', () {
    setUpAll(() async {
      units = await analyzedLibSrc;
      bases = _collectBases(units).toList(growable: false);
      widgetsByName = _collectWidgetClasses(units);
    });

    test('finds the bases at all (guards against a vacuous pass)', () {
      check(
        because:
            'Found no `_PlatformXxxData` base, so `_collectBases` is looking in the wrong place and '
            'every check below passes on nothing.',
        bases,
      ).isNotEmpty();
    });

    test('finds fields on every base (guards against checks passing on none)', () {
      check(
        because:
            'A base exists to share fields, so one with none found means `instanceFieldNames` '
            'missed how they are declared, and the checks below pass on an empty set.',
        bases.where((base) => base.fields.isEmpty).map((base) => base.location),
      ).isEmpty();
    });

    test('every shared-visual `_PlatformXxxData` field is mirrored flat on '
        'its `PlatformXxx` widget', () {
      final offenders = bases.expand((base) {
        final widget = widgetsByName[base.widgetName];
        if (widget == null) {
          final missingWidget =
              '${base.location}: base `${base.name}` has no widget class '
              '`${base.widgetName}`';

          return [missingWidget];
        }

        return base.fields
            .difference(widget.fieldNames)
            .map(
              (field) =>
                  '${widget.location}: `${base.widgetName}` is missing flat '
                  'field `$field` (declared on `${base.name}`)',
            );
      });
      check(
        because:
            'A `_PlatformXxxData` base field has no matching flat field on its '
            '`PlatformXxx` widget. Shared-visual fields must live in BOTH places '
            '(widget default + per-platform override), the compiler checks '
            'neither direction. Add the flat field to the widget, or, if the '
            'field is genuinely platform-only, move it onto the Material / '
            'Cupertino record instead of the shared base. See '
            'APPENDIX.md#field-classification.',
        offenders,
      ).isEmpty();
    });

    test('every shared-visual field is merged via `data.field ?? field` in '
        'both build methods', () {
      final offenders = bases.expand((base) {
        final widget = widgetsByName[base.widgetName];
        if (widget == null) return const <String>[]; // reported by the test above

        return widget.halves.expand(
          (half) => base.fields
              .difference(half.merged)
              .map(
                (field) =>
                    '${widget.location}: ${half.name} does not merge `$field` '
                    'via `${half.look}XxxData.$field ?? $field`',
              ),
        );
      });
      check(
        because:
            'A missing `materialXxxData.field ?? field` / `cupertinoXxxData.field ?? field` merge '
            'compiles, but silently drops the per-platform override (or the flat default). Wire the '
            'field in both halves. See APPENDIX.md#field-classification.',
        offenders,
      ).isEmpty();
    });

    test('every per-look record field is read somewhere in lib/src', () {
      // A deprecated field can do nothing until it goes.
      final fields = _recordFields(units).where((field) => !field.metadata.hasDeprecated).toSet();
      check(
        because: 'Found no record field at all, so the check below passes on nothing.',
        fields,
      ).isNotEmpty();
      final read = visitAll(
        units,
        (_) => _FieldReadVisitor(),
      ).expand((visitor) => visitor.read).toSet();
      check(
        because: 'A field nothing reads drops what the caller set. Pass it on, or remove it.',
        fields.difference(read).map((field) => '${field.enclosingElement.name}.${field.name}'),
      ).isEmpty();
    });
  });
}

/// The instance fields of every per-look record, and of the bases it shares them from.
Set<FieldElement> _recordFields(List<LibSrcUnit> units) {
  final records = units
      .expand((unit) => unit.ast.declaredFragment!.classes)
      .map((fragment) => fragment.element)
      .where((element) => isLookRecord(element.thisType));
  final owners = <InterfaceElement>{};
  for (final record in records) {
    InterfaceElement? owner = record;
    // Up the superclass chain, stopping at a base another record already took in.
    while (owner != null && isOurs(owner) && owners.add(owner)) {
      owner = owner.supertype?.element;
    }
  }

  return owners.expand((owner) => owner.fields).where((field) => !field.isStatic).toSet();
}

Iterable<_Base> _collectBases(List<LibSrcUnit> units) => _under(units, 'lib/src/models/').expand(
  (unit) => unit.ast.declarations
      .whereType<ClassDeclaration>()
      .map((declaration) => (declaration: declaration, name: declaration.namePart.typeName.lexeme))
      .where(
        (candidate) => candidate.name.startsWith('_Platform') && candidate.name.endsWith('Data'),
      )
      .map(
        (candidate) => _Base(
          name: candidate.name,
          widgetName: candidate.name.replaceFirst('_', '').replaceFirst(RegExp(r'Data$'), ''),
          fields: instanceFieldNames(candidate.declaration),
          location: unit.locate(candidate.declaration),
        ),
      ),
);

Map<String, _Widget> _collectWidgetClasses(List<LibSrcUnit> units) => Map.fromEntries(
  _under(units, 'lib/src/widgets/').expand(
    (unit) => unit.ast.declarations.whereType<ClassDeclaration>().map(
      (declaration) => MapEntry(
        declaration.namePart.typeName.lexeme,
        _Widget(
          location: unit.locate(declaration),
          fieldNames: instanceFieldNames(declaration),
          halves: [
            for (final MapEntry(key: look, value: names) in _halfNames.entries)
              _half(declaration, look, names),
          ],
        ),
      ),
    ),
  ),
);

Iterable<LibSrcUnit> _under(List<LibSrcUnit> units, String folder) =>
    units.where((unit) => unit.path.startsWith(folder));

/// [node]'s half for [look], the first of [names] it declares, and what that merges.
_Half _half(ClassDeclaration node, String look, Set<String> names) {
  final method = node.body.members
      .whereType<MethodDeclaration>()
      .where((member) => names.contains(member.name.lexeme))
      .firstOrNull;
  final visitor = _MergeVisitor(look);
  method?.body.accept(visitor);

  return _Half(name: method?.name.lexeme ?? names.first, look: look, merged: visitor.merged);
}

class _FieldReadVisitor() extends RecursiveAstVisitor<void> {
  final Set<FieldElement> read = {};

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    // A doc comment's `[Record.field]` resolves too, but reads nothing.
    if (node.element case GetterElement(variable: final FieldElement field)
        when node.thisOrAncestorOfType<Comment>() == null) {
      read.add(field.baseElement);
    }
    super.visitSimpleIdentifier(node);
  }
}

class _MergeVisitor(final String _accessorPrefix) extends RecursiveAstVisitor<void> {
  final Set<String> merged = {};

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final left = node.leftOperand;
    final right = node.rightOperand;
    if (node.operator.lexeme == '??' &&
        right is SimpleIdentifier &&
        left is PrefixedIdentifier &&
        left.prefix.name.toLowerCase().startsWith(_accessorPrefix) &&
        left.identifier.name == right.name) {
      merged.add(right.name);
    }
    super.visitBinaryExpression(node);
  }
}

class _Base({
  required final String name,
  required final String widgetName,
  required final Set<String> fields,
  required final String location,
});

class _Widget({
  required final String location,
  required final Set<String> fieldNames,
  required final List<_Half> halves,
});

/// The method a look is built in, and the fields it merges as `<look>….field ?? field`.
class _Half({
  required final String name,
  required final String look,
  required final Set<String> merged,
});
