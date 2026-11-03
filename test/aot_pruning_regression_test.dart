// Regression guard for the AOT-pruning contract documented in
// APPENDIX.md#aot-pruning-rules. 3 static checks over `lib/src/`:
//
//   1. No call to the dispatch helpers, `platform_value.dart`'s public functions, outside that file.
//      These take both Material and Cupertino arms as values/closures. The unused arm stays lexically
//      reachable and defeats AOT pruning.
//
//   2. No internal function, method or constructor (a `_` name, anything inside a `_` declaration,
//      or anything in a file the barrel doesn't export) takes both a `material*`-named and a
//      `cupertino*`-named function-typed parameter. That shape is the deferred-dispatch trap: it
//      constructs both closures at the call site and prevents the AOT compiler from folding the
//      unused arm.
//
//   3. Every read of `designLanguage` is a switch whose cases are each one look. Release builds fold
//      only that shape early, so an `==`, a `_`, an `||` or a `when` keeps the other arm's code in.
//
// Necessary-but-not-sufficient. The empirical guarantee lives in the
// size-regression CI job. See `tool/check_size_regression.dart`.

// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/lib_src.dart';

const _helperHomeBasename = 'platform_value.dart';

final _helperNames = libSrcUnits
    .singleWhere((unit) => unit.basename == _helperHomeBasename)
    .parsed
    .unit
    .declarations
    .whereType<FunctionDeclaration>()
    .map((function) => function.name.lexeme)
    .where((name) => !name.startsWith('_'))
    .toSet();

void main() {
  group('AOT pruning regression guard', () {
    // The helpers' own definitions aren't calls.
    test('no caller of dispatch helpers outside $_helperHomeBasename', () {
      check(
        because:
            'Found no public function in $_helperHomeBasename, so the check below bans nothing.',
        _helperNames,
      ).isNotEmpty();
      final offenders = offendersIn(
        libSrcUnitsExcept({_helperHomeBasename}),
        _HelperCallVisitor.new,
      );
      check(
        because:
            'Files in lib/src/ call the dispatch helpers '
            '($_helperNames). These take both Material and Cupertino '
            'values/closures as parameters, so the unused arm stays lexically '
            'reachable and AOT pruning cannot drop it. Use inline '
            '`switch (designLanguage)` at the call site instead. See '
            'APPENDIX.md#aot-pruning-rules.',
        offenders,
      ).isEmpty();
    });

    test('no internal helper in lib/src takes both material* and cupertino* '
        'function-typed params', () {
      final offenders = offendersIn(
        libSrcUnitsExcept({_helperHomeBasename}),
        (unit) => _DispatchHelperVisitor(unit, isExported: exportedPaths.contains(unit.path)),
      );
      check(
        because:
            'Found internal function(s) that take both a material*-named and '
            'a cupertino*-named function-typed parameter. This shape '
            'constructs both closures at the call site, defeating AOT '
            'pruning. Dispatch at the public entry point with '
            '`switch (designLanguage)` and call single-platform '
            'helpers (e.g. `showMaterialDialogRoute` vs `showCupertinoDialogRoute`) '
            'that each take only one builder. See '
            'APPENDIX.md#aot-pruning-rules.',
        offenders,
      ).isEmpty();
    });

    test('every designLanguage read in lib/src is a switch whose cases are each one look', () {
      final visitors = visitAll(libSrcUnits, _LookReadVisitor.new);
      check(
        because: 'Found no designLanguage read at all, so the check below passes on nothing.',
        visitors.fold(0, (sum, visitor) => sum + visitor.readCount),
      ).isGreaterThan(0);
      check(
        because:
            'Release builds fold `designLanguage` early only in a switch whose cases are each one '
            'look. Anything else keeps the other arm reachable. See APPENDIX.md#aot-pruning-rules.',
        visitors.expand((visitor) => visitor.offenders),
      ).isEmpty();
    });
  });
}

class _HelperCallVisitor(final LibSrcUnit _unit)
    extends RecursiveAstVisitor<void>
    implements OffenderVisitor {
  @override
  final List<String> offenders = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_helperNames.contains(node.methodName.name)) {
      offenders.add('${_unit.locate(node)}: calls ${node.methodName.name}(...)');
    }
    super.visitMethodInvocation(node);
  }
}

class _DispatchHelperVisitor(final LibSrcUnit _unit, {required final bool isExported})
    extends RecursiveAstVisitor<void>
    implements OffenderVisitor {
  @override
  final List<String> offenders = [];

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _check(node, node.name, node.functionExpression.parameters);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _check(node, node.name, node.parameters);
    super.visitMethodDeclaration(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    _check(node, node.name, node.parameters);
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitPrimaryConstructorDeclaration(PrimaryConstructorDeclaration node) {
    _check(node, node.constructorName?.name, node.formalParameters);
    super.visitPrimaryConstructorDeclaration(node);
  }

  /// [ownName] is `null` for an unnamed constructor.
  void _check(AstNode node, Token? ownName, FormalParameterList? params) {
    final owner = node.parent?.thisOrAncestorOfType<CompilationUnitMember>();
    final names = [if (owner != null) ...declaredNames(owner), ?ownName?.lexeme];
    if (params == null || (isExported && !names.any((name) => name.startsWith('_')))) return;

    final functionTypedNames = params.parameters
        .where(_isFunctionTyped)
        .map((param) => (param.name?.lexeme ?? '').toLowerCase())
        .toList(growable: false);
    final hasMaterial = functionTypedNames.any((paramName) => paramName.startsWith('material'));
    final hasCupertino = functionTypedNames.any((paramName) => paramName.startsWith('cupertino'));
    if (hasMaterial && hasCupertino) {
      offenders.add(
        '${_unit.locate(node)}: internal `${names.join('.')}` takes both '
        'material* and cupertino* function-typed params',
      );
    }
  }

  bool _isFunctionTyped(FormalParameter param) {
    if (param.functionTypedSuffix != null) return true;
    final src = param.type?.toSource() ?? '';

    return src.contains('Function') ||
        src.contains('Builder') ||
        src.contains('Callback') ||
        src.contains('Getter');
  }
}

class _LookReadVisitor(final LibSrcUnit _unit) extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];
  var readCount = 0;

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (readsInCode(node, 'designLanguage')) {
      readCount++;
      final foldsEarly = switch (node.parent) {
        SwitchExpression(:final expression, :final cases) when expression == node => cases.every(
          (switchCase) => _isOneLook(switchCase.guardedPattern),
        ),
        SwitchStatement(:final expression, :final members) when expression == node => members.every(
          (member) => member is SwitchPatternCase && _isOneLook(member.guardedPattern),
        ),
        _ => false,
      };
      if (!foldsEarly) {
        offenders.add(
          '${_unit.locate(node)}: reads designLanguage in a shape release builds '
          "can't fold early",
        );
      }
    }
    super.visitSimpleIdentifier(node);
  }

  bool _isOneLook(GuardedPattern guardedPattern) =>
      guardedPattern.whenClause == null && guardedPattern.pattern is ConstantPattern;
}
