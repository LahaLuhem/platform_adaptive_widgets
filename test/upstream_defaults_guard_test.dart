// Resolving lib/ with material_ui and cupertino_ui takes seconds, more on a CI runner.
@Timeout(Duration(minutes: 1))
library;

import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:checks/checks.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_test/flutter_test.dart';

// Grouped by what's wrong, so a fix takes its group off, sees red, then turns it green.

// Upstream's own default leaves these on, and its `null` turns them off.
const _sendsNullForOff = {
  'platform_app_bar.dart: CupertinoNavigationBar.border',
  'platform_app_bar.dart: CupertinoNavigationBar.large.border',
  'platform_button.dart: TextButton.isSemanticButton',
  'platform_search_bar.dart: SearchBar.contextMenuBuilder',
  'platform_text_field.dart: CupertinoTextField.autofillHints',
  'platform_text_field.dart: CupertinoTextField.contextMenuBuilder',
  'platform_text_field.dart: CupertinoTextField.placeholderStyle',
  'platform_text_field.dart: TextField.autofillHints',
  'platform_text_field.dart: TextField.contextMenuBuilder',
};

// Copies of a default that don't match upstream's own.
const _copiesThatDiffer = {
  'cupertino_picker_popup.dart: showCupertinoModalPopup.barrierDismissible',
  'platform_dialog.dart: Dialog.fullscreen.insetAnimationDuration',
  'platform_expansion_tile.dart: ExpansionTile.showTrailingIcon',
  'platform_list_tile.dart: ListTile.internalAddSemanticForOnTap',
  'sheet_routes.dart: showModalBottomSheet.useRootNavigator',
};

// `null` where upstream has a default of its own.
const _sendsNullForDefault = {
  'platform_app.dart: MaterialApp.router.themeMode',
  'platform_app.dart: MaterialApp.themeMode',
  'platform_app.dart: MaterialApp.title',
  'platform_button.dart: FilledButton.clipBehavior',
  'platform_button.dart: FilledButton.icon.clipBehavior',
  'platform_button.dart: FilledButton.tonal.clipBehavior',
  'platform_button.dart: FilledButton.tonalIcon.clipBehavior',
  'platform_button.dart: TextButton.icon.clipBehavior',
  'platform_expansion_tile.dart: ExpansionTile.enableFeedback',
  'platform_search_bar.dart: CupertinoSearchTextField.keyboardType',
};

const _ownBool = "The package's own non-null bool, which upstream reads the same as its null.";
const _grayButton = "iOS's gray button for `.mediumNeutral`, cupertino_ui's own recipe.";

/// The package's own picks, which stay.
const _ownPicks = {
  'platform_alert_dialog.dart: AlertDialog.actionsOverflowDirection':
      'Up, so a stack puts the confirming action on top as M3 asks.',
  'platform_alert_dialog.dart: AlertDialog.contentPadding':
      "M3's 24 around an untitled message, where upstream leaves 16 "
      '(https://github.com/flutter/flutter/issues/195096).',
  'platform_button.dart: CupertinoButton.color': _grayButton,
  'platform_button.dart: CupertinoButton.filled.color': _grayButton,
  'platform_button.dart: CupertinoButton.tinted.color': _grayButton,
  'platform_scaffold.dart: Scaffold.resizeToAvoidBottomInset': _ownBool,
  'platform_search_bar.dart: CupertinoSearchTextField.enabled': _ownBool,
  'platform_tab_scaffold.dart: Scaffold.resizeToAvoidBottomInset': _ownBool,
  'platform_text_field.dart: TextField.autocorrect': _ownBool,
  'platform_text_field.dart: TextField.enabled': _ownBool,
};

const _upstreamPackages = {'material_ui', 'cupertino_ui'};

void main() {
  final listed = {
    ..._sendsNullForOff,
    ..._copiesThatDiffer,
    ..._sendsNullForDefault,
    ..._ownPicks.keys,
  };
  late final List<_Offender> offenders;
  late final Iterable<String> nullableRecords;

  setUpAll(() async {
    final units = await _resolveLib();
    offenders = _Tracer.of(units).offenders();
    nullableRecords = _nullableRecords(units);
  });

  test('a field left out sends what the plain upstream widget defaults to, or is listed', () {
    check(
      because:
          "Send upstream's own default (APPENDIX.md#left-out-fields), or list the row here with its "
          'reason.',
      offenders
          .where((offender) => !listed.contains(offender.row))
          .map((offender) => offender.description),
    ).isEmpty();
  });

  test('every listed row still differs from upstream', () {
    check(
      because: 'Take a fixed row off the list, or it hides the next drift there.',
      listed.difference(offenders.map((offender) => offender.row).toSet()),
    ).isEmpty();
  });

  test('a record left out is its empty record, never null', () {
    check(
      because:
          'Default the record to its `const` empty one, or a left-out record and a left-out field '
          'send different things (APPENDIX.md#left-out-fields).',
      nullableRecords,
    ).isEmpty();
  });
}

/// lib/, resolved.
Future<List<ResolvedUnitResult>> _resolveLib() async {
  final collection = AnalysisContextCollection(
    includedPaths: [Directory('lib').absolute.path],
    // `flutter test` runs on flutter_tester, which the analyzer can't take for a Dart SDK.
    sdkPath: '${Platform.environment['FLUTTER_ROOT']}/bin/cache/dart-sdk',
  );

  return (await collection.contexts
          .expand(
            (context) => context.contextRoot
                .analyzedFiles()
                .where((path) => path.endsWith('.dart'))
                .map(context.currentSession.getResolvedUnit),
          )
          .wait)
      .whereType<ResolvedUnitResult>()
      .toList(growable: false);
}

/// Every parameter that takes one of the package's records but lets it be null.
Iterable<String> _nullableRecords(List<ResolvedUnitResult> units) => units.expand(
  (unit) => _nodesUnder(unit.unit)
      .whereType<FormalParameter>()
      .where(
        (node) => switch (node.declaredFragment?.element.type) {
          InterfaceType(:final element, nullabilitySuffix: NullabilitySuffix.question) =>
            _isOurs(element) &&
                (element.name ?? '').startsWith(RegExp('Material|Cupertino')) &&
                (element.name ?? '').endsWith('Data'),
          _ => false,
        },
      )
      .map(
        (node) =>
            '${unit.uri}:${unit.lineInfo.getLocation(node.offset).lineNumber}: ${node.name?.lexeme}',
      ),
);

/// A value that isn't upstream's default: its `'<file>: <call>.<parameter>'` row, and what and where.
typedef _Offender = ({String row, String description});

typedef _Call = ({ResolvedUnitResult unit, ArgumentList node, ExecutableElement callee});

/// Traces each argument to an optional material_ui or cupertino_ui parameter back to what a left-out
/// field becomes. A value it can't trace, or one the package builds itself, isn't compared.
// A test file is named for what it checks, not for its helpers.
// ignore: prefer-match-file-name
final class _Tracer(
  final Set<Element> _exported,
  final List<_Call> _calls,
  final Map<ExecutableElement, List<_Call>> _sites,
  final Map<LocalVariableElement, Expression> _locals,
  final Map<ConstructorElement, List<ConstructorFieldInitializer>> _initializers,
) {
  factory of(List<ResolvedUnitResult> units) {
    final barrel = units.singleWhere(
      (unit) => unit.uri.path == 'platform_adaptive_widgets/platform_adaptive_widgets.dart',
    );
    final calls = units
        .expand(
          (unit) => _nodesUnder(unit.unit).whereType<ArgumentList>().map((node) {
            final callee = node.arguments
                .map((argument) => argument.correspondingParameter?.baseElement.enclosingElement)
                .whereType<ExecutableElement>()
                .firstOrNull
                ?.baseElement;

            return callee == null ? null : (unit: unit, node: node, callee: callee);
          }),
        )
        .nonNulls
        .toList(growable: false);
    final nodes = units.expand((unit) => _nodesUnder(unit.unit)).toList(growable: false);

    return _Tracer(
      barrel.libraryElement.exportNamespace.definedNames2.values.toSet(),
      calls,
      calls.groupListsBy((call) => call.callee),
      Map.fromEntries(
        nodes
            .whereType<VariableDeclaration>()
            .map(
              (node) => switch ((node.declaredFragment?.element, node.initializer)) {
                // A `var` can change after it's set, so only a final local's start value is what it
                // sends.
                (final LocalVariableElement element, final initializer?) when element.isFinal =>
                  MapEntry(element, initializer),
                _ => null,
              },
            )
            .nonNulls,
      ),
      Map.fromEntries(
        nodes.whereType<ConstructorDeclaration>().map((node) {
          final element = node.declaredFragment?.element;

          return element == null
              ? null
              : MapEntry(
                  element.baseElement,
                  node.initializers.whereType<ConstructorFieldInitializer>().toList(
                    growable: false,
                  ),
                );
        }).nonNulls,
      ),
    );
  }

  final _tracing = <FormalParameterElement>{};

  /// Every value a left-out field sends where upstream defaults to something else.
  List<_Offender> offenders() => _calls
      .where(
        (call) => switch (call.callee) {
          // `theme.copyWith(…)` and the like have no left-out field to mirror.
          MethodElement(isStatic: false) => false,
          final callee => _isUpstream(callee),
        },
      )
      .expand(
        (call) => call.node.arguments.expand((argument) {
          final parameter = argument.correspondingParameter?.baseElement;
          if (parameter == null || parameter.isRequired) return const <_Offender>[];
          final upstream = parameter.computeConstantValue();
          final expression = argument.argumentExpression;
          final target = '${_nameOf(call.callee)}.${parameter.name}';
          final line = call.unit.lineInfo.getLocation(argument.offset).lineNumber;

          return _trace(expression)
              // A branch where the type already rules null out, like a `heroTag` promoted after a
              // check.
              .where(
                (value) =>
                    !value.isNull ||
                    expression.staticType?.nullabilitySuffix != NullabilitySuffix.none,
              )
              .where((value) => !value.matches(upstream))
              .map(
                (value) => (
                  row: '${call.unit.uri.pathSegments.last}: $target',
                  description:
                      '${call.unit.uri}:$line: $target sends $value, upstream defaults to '
                      '${upstream ?? 'null'}',
                ),
              );
        }),
      )
      .toList(growable: false);

  /// [fillIn] is set on the right of a `??`, where any constant or literal is what "left out" becomes.
  /// Anywhere else only a `kDefault…` copy is: other values there are the package's own picks.
  Iterable<_Value> _trace(
    Expression expression, {
    bool fillIn = false,
  }) => switch (expression.unParenthesized) {
    NullLiteral() => [if (fillIn) const _Null()],
    BooleanLiteral(:final value) => [if (fillIn) _Literal(value)],
    IntegerLiteral(:final value?) => [if (fillIn) _Literal(value)],
    DoubleLiteral(:final value) => [if (fillIn) _Literal(value)],
    SimpleStringLiteral(:final value) => [if (fillIn) _Literal(value)],
    BinaryExpression(:final operator, :final leftOperand, :final rightOperand)
        when operator.type == TokenType.QUESTION_QUESTION =>
      _ifNull(leftOperand, rightOperand, fillIn: fillIn),
    ConditionalExpression(:final thenExpression, :final elseExpression) => _trace(
      thenExpression,
      fillIn: fillIn,
    ).followedBy(_trace(elseExpression, fillIn: fillIn)),
    PostfixExpression(:final operand, :final operator) when operator.type == TokenType.BANG =>
      _trace(operand, fillIn: fillIn).where((value) => !value.isNull),
    SimpleIdentifier(:final element) => _ofElement(element, null, fillIn: fillIn),
    DotShorthandPropertyAccess(:final propertyName) => _ofElement(
      propertyName.element,
      null,
      fillIn: fillIn,
    ),
    PrefixedIdentifier(:final prefix, :final identifier) => _ofElement(
      identifier.element,
      prefix.staticType,
      fillIn: fillIn,
    ),
    // A read off a plain upstream widget, like `const CupertinoTextField().cursorRadius`, is that
    // constructor's own default.
    PropertyAccess(
      target: InstanceCreationExpression(constructorName: ConstructorName(:final element?)),
      :final propertyName,
    )
        when _isUpstream(element) =>
      element.formalParameters
          .where((formal) => formal.name == propertyName.name)
          .expand(_defaultOf),
    PropertyAccess(:final target?, :final propertyName, :final isNullAware) => [
      // `record?.field` sends null while the record itself is left out.
      if (isNullAware && _trace(target, fillIn: fillIn).any((value) => value.isNull)) const _Null(),
      ..._ofElement(propertyName.element, target.staticType, fillIn: fillIn),
    ],
    _ => const [],
  };

  Iterable<_Value> _ifNull(Expression left, Expression right, {required bool fillIn}) {
    final values = _trace(left, fillIn: fillIn).toList(growable: false);

    return values.any((value) => value.isNull)
        ? values.where((value) => !value.isNull).followedBy(_trace(right, fillIn: true))
        : values;
  }

  Iterable<_Value> _ofElement(Element? element, DartType? ownerType, {required bool fillIn}) {
    final variable = element is GetterElement ? element.variable : element;
    switch (variable) {
      case VariableElement(isConst: true):
        final value = variable.computeConstantValue();
        final isCopy = variable.name?.startsWith('kDefault') ?? false;

        return value != null && (fillIn || isCopy) ? [_Value.of(value)] : const [];
      case FieldElement():
        return _ofField(variable, ownerType);
      case FormalParameterElement():
        return _ofParameter(variable);
      case LocalVariableElement():
        final initializer = _locals[variable.baseElement];

        return initializer == null ? const [] : _trace(initializer, fillIn: fillIn);
    }

    return const [];
  }

  /// A field gets what its constructors set it to, read off the record's type for `record.field`.
  Iterable<_Value> _ofField(FieldElement field, DartType? ownerType) {
    final owner = ownerType is InterfaceType ? ownerType.element : field.enclosingElement;
    if (owner is! InterfaceElement || !_isOurs(owner)) return const [];

    return owner.constructors.expand((constructor) {
      final formal = constructor.formalParameters
          .where((formal) => formal.name == field.name)
          .firstOrNull;

      return formal != null
          ? _ofParameter(formal)
          : (_initializers[constructor.baseElement] ?? const <ConstructorFieldInitializer>[])
                .where((initializer) => initializer.fieldName.name == field.name)
                .expand((initializer) => _trace(initializer.expression));
    });
  }

  /// A parameter gets its default when a caller of the public API leaves it out, and whatever the
  /// package's own call sites pass it.
  Iterable<_Value> _ofParameter(FormalParameterElement parameter) {
    final formal = parameter.baseElement;
    final executable = formal.enclosingElement;
    if (executable is! ExecutableElement || !_isOurs(executable) || !_tracing.add(formal)) {
      return const [];
    }
    // Built in full before [_tracing] lets go, or a parameter that reaches itself recurses forever.
    final sent = [
      if (_isPublic(executable) && !formal.isRequired) ..._defaultOf(formal),
      ...(_sites[executable.baseElement] ?? const <_Call>[]).expand((site) {
        final argument = site.node.arguments
            .where((argument) => argument.correspondingParameter?.baseElement == formal)
            .firstOrNull;

        return argument == null ? _defaultOf(formal) : _trace(argument.argumentExpression);
      }),
    ];
    _tracing.remove(formal);

    return sent;
  }

  Iterable<_Value> _defaultOf(FormalParameterElement formal) {
    if (!formal.hasDefaultValue) return const [_Null()];
    final value = formal.computeConstantValue();

    return value == null ? const [] : [_Value.of(value)];
  }

  bool _isPublic(ExecutableElement executable) {
    final owner = executable.enclosingElement;

    return owner is InterfaceElement
        ? _exported.contains(owner) && !executable.isPrivate
        : _exported.contains(executable);
  }
}

/// [node] and every node under it.
Iterable<AstNode> _nodesUnder(AstNode node) sync* {
  yield node;
  yield* node.childEntities.whereType<AstNode>().expand(_nodesUnder);
}

/// What a left-out field can send: `null`, a constant, or a literal filled in after `??`.
sealed class const _Value() {
  factory of(DartObject object) => object.isNull ? const _Null() : _Constant(object);

  bool get isNull => this is _Null;

  /// Whether this is upstream's own default, [upstream], which is null when it has none.
  bool matches(DartObject? upstream);
}

final class const _Null() extends _Value {
  @override
  bool matches(DartObject? upstream) => upstream == null || upstream.isNull;

  @override
  String toString() => 'null';
}

final class const _Constant(final DartObject _object) extends _Value {
  @override
  bool matches(DartObject? upstream) =>
      upstream != null && (_object == upstream || _sameInsets(_object, upstream));

  @override
  String toString() => '$_object';
}

final class const _Literal(final Object _value) extends _Value {
  @override
  bool matches(DartObject? upstream) =>
      upstream != null &&
      [
        upstream.toBoolValue(),
        upstream.toIntValue(),
        upstream.toDoubleValue(),
        upstream.toStringValue(),
      ].contains(_value);

  @override
  String toString() => '$_value';
}

/// DCM wants a copy of upstream's `EdgeInsetsDirectional` written as plain `EdgeInsets` (CODESTYLE.md,
/// `prefer-correct-edge-insets-constructor`). The 2 read the same when start and end match.
bool _sameInsets(DartObject ours, DartObject upstream) {
  double? side(DartObject insets, String name) => insets.getField(name)?.toDoubleValue();

  return ours.type?.element?.name == 'EdgeInsets' &&
      upstream.type?.element?.name == 'EdgeInsetsDirectional' &&
      {
            side(ours, 'left'),
            side(ours, 'right'),
            side(upstream, 'start'),
            side(upstream, 'end'),
          }.length ==
          1 &&
      side(ours, 'top') == side(upstream, 'top') &&
      side(ours, 'bottom') == side(upstream, 'bottom');
}

String? _packageOf(Element element) => element.library?.uri.pathSegments.firstOrNull;

bool _isOurs(Element element) => _packageOf(element) == 'platform_adaptive_widgets';

bool _isUpstream(Element element) => _upstreamPackages.contains(_packageOf(element));

String _nameOf(ExecutableElement callee) => switch (callee) {
  ConstructorElement(:final enclosingElement, :final name) when name != 'new' =>
    '${enclosingElement.name}.$name',
  ConstructorElement(:final enclosingElement) => '${enclosingElement.name}',
  _ => callee.displayName,
};
