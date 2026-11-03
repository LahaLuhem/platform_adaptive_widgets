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

import 'support/lib_src.dart';

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

/// Each `DesignLanguage` look's upstream package.
const _upstreamPackages = {'material': 'material_ui', 'cupertino': 'cupertino_ui'};

void main() {
  final listed = _ownPicks.keys.toSet();
  late final List<_Offender> offenders;
  late final List<_RecordParameter> recordParameters;

  setUpAll(() async {
    final units = await _resolveLib();
    offenders = _Tracer.of(units).offenders();
    recordParameters = _recordParameters(units);
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
      because: 'Found no parameter that takes a record, so the check below passes on nothing.',
      recordParameters,
    ).isNotEmpty();
    check(
      because:
          'Default the record to its `const` empty one, or a left-out record and a left-out field '
          'send different things (APPENDIX.md#left-out-fields).',
      recordParameters
          .where((parameter) => !_isEmptyWhenLeftOut(parameter))
          .map((parameter) => '${parameter.location}: ${parameter.node.name?.lexeme}'),
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

typedef _RecordParameter = ({String location, FormalParameter node, InterfaceType type});

/// Every parameter that takes one of the package's records.
List<_RecordParameter> _recordParameters(List<ResolvedUnitResult> units) => units
    .expand(
      (unit) => _nodesUnder(unit.unit).whereType<FormalParameter>().map(
        (node) => switch (node.declaredFragment?.element.type) {
          final InterfaceType type
              when _isOurs(type.element) &&
                  (type.element.name ?? '').startsWith(RegExp('Material|Cupertino')) &&
                  (type.element.name ?? '').endsWith('Data') =>
            (
              location: pathLine(
                unit.path,
                unit.lineInfo,
                node.firstTokenAfterCommentAndMetadata.offset,
              ),
              node: node,
              type: type,
            ),
          _ => null,
        },
      ),
    )
    .nonNulls
    .toList(growable: false);

/// Whether [parameter] is never null, and is its record's empty one when left out.
bool _isEmptyWhenLeftOut(_RecordParameter parameter) =>
    parameter.type.nullabilitySuffix == NullabilitySuffix.none &&
    switch (parameter.node.defaultClause?.value) {
      null => parameter.node.isRequired,
      InstanceCreationExpression(:final constructorName, :final argumentList) =>
        constructorName.type.element == parameter.type.element &&
            constructorName.name == null &&
            argumentList.arguments.isEmpty,
      _ => false,
    };

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
  final Map<ExecutableElement, Expression> _bodies,
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
      Map.fromEntries(
        nodes
            .whereType<FunctionDeclaration>()
            .map(
              (node) => switch ((node.declaredFragment?.element, node.functionExpression.body)) {
                (final element?, ExpressionFunctionBody(:final expression)) => MapEntry(
                  element.baseElement,
                  expression,
                ),
                _ => null,
              },
            )
            .nonNulls,
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
          final location = pathLine(call.unit.path, call.unit.lineInfo, argument.offset);

          return _trace(expression)
              // A `designLanguage` arm only runs where its look draws.
              .where((value) => value is! _InLook || value.package == _packageOf(call.callee))
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
                      '$location: $target sends $value, upstream defaults to '
                      '${_Value.of(upstream)}',
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
    if (value == null) return const [];
    final body = _bodies[value.toFunctionValue()?.baseElement];

    return body == null ? [_Value.of(value)] : _handOver(body, value);
  }

  /// A package function standing in for upstream's sends what its [body] calls, per look where it
  /// switches on `designLanguage`. Any other body sends the function itself, which matches nothing.
  Iterable<_Value> _handOver(Expression body, DartObject handOver) => switch (body) {
    FunctionExpressionInvocation(:final function) => _trace(function),
    SwitchExpression(:final cases) => cases.expand((arm) {
      final package = switch (arm.guardedPattern.pattern) {
        ConstantPattern(expression: DotShorthandPropertyAccess(:final propertyName)) =>
          _upstreamPackages[propertyName.name],
        _ => null,
      };

      return package == null
          ? [_Value.of(handOver)]
          : _handOver(arm.expression, handOver).map((value) => _InLook(value, package));
    }),
    _ => [_Value.of(handOver)],
  };

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
  factory of(DartObject? object) =>
      object == null || object.isNull ? const _Null() : _Constant(object);

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

  /// Names a method with its class, since upstream's builders share a name.
  @override
  String toString() => switch (_object.toFunctionValue()) {
    MethodElement(:final enclosingElement?, :final name) => '${enclosingElement.name}.$name',
    final function? => '${function.name}',
    null => '$_object',
  };
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

/// A value sent only where [package] draws, from its look's `designLanguage` arm.
final class const _InLook(final _Value _value, final String package) extends _Value {
  @override
  bool get isNull => _value.isNull;

  @override
  bool matches(DartObject? upstream) => _value.matches(upstream);

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

bool _isUpstream(Element element) => _upstreamPackages.containsValue(_packageOf(element));

String _nameOf(ExecutableElement callee) => switch (callee) {
  ConstructorElement(:final enclosingElement, :final name) when name != 'new' =>
    '${enclosingElement.name}.$name',
  ConstructorElement(:final enclosingElement) => '${enclosingElement.name}',
  _ => callee.displayName,
};
