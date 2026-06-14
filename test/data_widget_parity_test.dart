// Parity guard for the field-classification contract in
// APPENDIX.md#field-classification. For every canonical widget whose
// shared-visual fields live on a private `_PlatformXxxData` base (inherited by
// `MaterialXxxData` / `CupertinoXxxData` via `super`-forwarding), two static
// checks over `lib/src/` keep the two edges the Dart compiler does NOT check
// honest:
//
//   1. Field-set parity — every field on the `_PlatformXxxData` base also
//      exists as a flat field on the matching `PlatformXxx` widget. Dart
//      compiler-checks `super.x` forwarding (base -> records) and ctor-params
//      -> field-decls, but nothing forces the widget to mirror the base; a base
//      field added without a flat widget twin compiles, yet can never be set at
//      the call site.
//
//   2. Build-method wiring — every base field is merged via
//      `materialXxxData?.field ?? field` in `buildMaterial` AND
//      `cupertinoXxxData?.field ?? field` in `buildCupertino`. A forgotten
//      fallback (or one pointing at the wrong flat field) compiles, type-checks,
//      and silently drops the per-platform override. This is the more dangerous
//      edge and the one the compiler is blindest to.
//
// Bases listed in `_basesWithoutFlatMirror` exist only to DRY a single field
// across the two records and have no flat widget twin by design — see that
// set's comment.

// This guard declares several private visitor / record classes in one file.
// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

/// Private `_PlatformXxxData` bases that intentionally have NO flat mirror on
/// their widget. Their base exists only to share a single field declaration
/// (`backgroundColor`) across the two per-platform records; the widget reads it
/// straight off the record, so there is no widget-flat field to keep in parity.
/// See APPENDIX.md#field-classification (scaffold / app-bar carve-out).
const _basesWithoutFlatMirror = {'_PlatformAppBarData', '_PlatformScaffoldData'};

/// The canonical widgets the guard MUST discover. A floor, not a ceiling: a new
/// canonical widget auto-enrolls in the checks below and need not be added here.
/// This set only guards against discovery silently finding nothing (e.g. after
/// an analyzer AST change or a lib/src/models layout move), which would let the
/// parity checks pass vacuously.
const _knownCanonicalWidgets = {
  'PlatformCheckbox',
  'PlatformRadio',
  'PlatformScrollbar',
  'PlatformSlider',
  'PlatformSwitch',
  'PlatformListTile',
  'PlatformProgressIndicator',
};

void main() {
  final bases = _collectBases().toList(growable: false);
  final widgetsByName = _collectWidgetClasses();

  group('Data/widget parity guard', () {
    test('discovers the known canonical widgets (guards against a no-op guard)', () {
      final discovered = bases.map((base) => base.widgetName).toSet();
      check(
        because:
            'The parity guard discovered fewer `_PlatformXxxData` bases than the '
            'known canonical set. If the analyzer AST API or the lib/src/models '
            'layout changed, base discovery may be silently broken — which would '
            'let the parity checks below pass vacuously. Fix discovery in '
            '`_collectBases`, or update `_knownCanonicalWidgets` if a widget was '
            'intentionally removed.',
        _knownCanonicalWidgets.difference(discovered),
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
                  '${widget.filePath}: `${base.widgetName}` is missing flat '
                  'field `$field` (declared on `${base.name}`)',
            );
      });
      check(
        because:
            'A `_PlatformXxxData` base field has no matching flat field on its '
            '`PlatformXxx` widget. Shared-visual fields must live in BOTH places '
            '(widget default + per-platform override) — the compiler checks '
            'neither direction. Add the flat field to the widget, or, if the '
            'field is genuinely platform-only, move it onto the Material / '
            'Cupertino record instead of the shared base. See '
            'APPENDIX.md#field-classification.',
        offenders,
      ).isEmpty();
    });

    test('every shared-visual field is merged via `data?.field ?? field` in '
        'both build methods', () {
      final offenders = bases.expand((base) {
        final widget = widgetsByName[base.widgetName];
        if (widget == null) return const <String>[]; // reported by the test above

        final branches = {
          'buildMaterial': (merged: widget.materialMerged, accessor: 'materialXxxData'),
          'buildCupertino': (merged: widget.cupertinoMerged, accessor: 'cupertinoXxxData'),
        };

        return branches.entries.expand(
          (branch) => base.fields
              .difference(branch.value.merged)
              .map(
                (field) =>
                    '${widget.filePath}: ${branch.key} does not merge `$field` '
                    'via `${branch.value.accessor}?.$field ?? $field`',
              ),
        );
      });
      check(
        because:
            'A shared-visual base field is not merged with the documented '
            '`materialXxxData?.field ?? field` / `cupertinoXxxData?.field ?? '
            'field` idiom in one or both build methods. A missing fallback '
            'compiles but silently drops the per-platform override (or the flat '
            'default). Wire the field in both `buildMaterial` and '
            '`buildCupertino`. See APPENDIX.md#field-classification.',
        offenders,
      ).isEmpty();
    });
  });
}

Iterable<File> _dartFilesIn(String dir) => Directory(
  dir,
).listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart'));

Iterable<_Base> _collectBases() => _dartFilesIn('lib/src/models').expand((file) {
  final parsed = parseFile(
    path: file.absolute.path,
    featureSet: FeatureSet.latestLanguageVersion(),
  );

  return parsed.unit.declarations
      .whereType<ClassDeclaration>()
      .map((declaration) => (declaration: declaration, name: declaration.namePart.typeName.lexeme))
      .where(
        (candidate) =>
            candidate.name.startsWith('_Platform') &&
            candidate.name.endsWith('Data') &&
            !_basesWithoutFlatMirror.contains(candidate.name),
      )
      .map(
        (candidate) => _Base(
          name: candidate.name,
          widgetName: candidate.name.replaceFirst('_', '').replaceFirst(RegExp(r'Data$'), ''),
          fields: _instanceFieldNames(candidate.declaration),
          location:
              '${file.path}:${parsed.lineInfo.getLocation(candidate.declaration.offset).lineNumber}',
        ),
      );
});

Map<String, _Widget> _collectWidgetClasses() => Map.fromEntries(
  _dartFilesIn('lib/src/widgets').expand((file) {
    final parsed = parseFile(
      path: file.absolute.path,
      featureSet: FeatureSet.latestLanguageVersion(),
    );

    return parsed.unit.declarations.whereType<ClassDeclaration>().map(
      (declaration) => MapEntry(
        declaration.namePart.typeName.lexeme,
        _Widget(
          filePath: file.path,
          fieldNames: _instanceFieldNames(declaration),
          materialMerged: _mergedFields(declaration, 'buildMaterial', 'material'),
          cupertinoMerged: _mergedFields(declaration, 'buildCupertino', 'cupertino'),
        ),
      ),
    );
  }),
);

Set<String> _instanceFieldNames(ClassDeclaration node) => node.body.members
    .whereType<FieldDeclaration>()
    .where((member) => !member.isStatic)
    .expand((member) => member.fields.variables)
    .map((variable) => variable.name.lexeme)
    .toSet();

/// Field names merged via `<accessorPrefix>...?.field ?? field` inside the
/// [methodName] method of [node].
Set<String> _mergedFields(ClassDeclaration node, String methodName, String accessorPrefix) {
  final visitor = _MergeVisitor(accessorPrefix);
  final methods = node.body.members.whereType<MethodDeclaration>().where(
    (member) => member.name.lexeme == methodName,
  );
  for (final method in methods) {
    method.body.accept(visitor);
  }

  return visitor.merged;
}

class _MergeVisitor extends RecursiveAstVisitor<void> {
  _MergeVisitor(this._accessorPrefix);

  final String _accessorPrefix;
  final Set<String> merged = {};

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final left = node.leftOperand;
    final right = node.rightOperand;
    if (node.operator.lexeme == '??' && right is SimpleIdentifier && left is PropertyAccess) {
      final target = left.target;
      if (target is SimpleIdentifier &&
          target.name.toLowerCase().startsWith(_accessorPrefix) &&
          left.propertyName.name == right.name) {
        merged.add(right.name);
      }
    }
    super.visitBinaryExpression(node);
  }
}

class _Base {
  _Base({
    required this.name,
    required this.widgetName,
    required this.fields,
    required this.location,
  });

  final String name;
  final String widgetName;
  final Set<String> fields;
  final String location;
}

class _Widget {
  _Widget({
    required this.filePath,
    required this.fieldNames,
    required this.materialMerged,
    required this.cupertinoMerged,
  });

  final String filePath;
  final Set<String> fieldNames;
  final Set<String> materialMerged;
  final Set<String> cupertinoMerged;
}
