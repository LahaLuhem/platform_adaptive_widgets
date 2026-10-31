// Regression guard for the AOT-pruning contract documented in
// APPENDIX.md#aot-pruning-rules. 3 static checks over `lib/src/`:
//
//   1. No call to the closure-arg dispatch helpers (`platformValue`,
//      `platformLazyValue`, `platformValueNullable`, `platformLazyNullable`)
//      outside the file that defines them. These helpers take both Material
//      and Cupertino arms as values/closures. The unused arm stays lexically
//      reachable and defeats AOT pruning.
//
//   2. No internal helper (a `_` name, or anything in a file the barrel doesn't
//      export) takes both a `material*`-named and a `cupertino*`-named
//      function-typed parameter. That shape is the deferred-dispatch trap
//      (`_showBasePlatformDialog`-style) that constructs both closures at the
//      call site and prevents the AOT compiler from folding the unused arm.
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
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/lib_src.dart';

const _helperHomeBasename = 'platform_value.dart';

const _forbiddenHelperNames = {
  'platformValue',
  'platformValueNullable',
  'platformLazyValue',
  'platformLazyNullable',
};

void main() {
  group('AOT pruning regression guard', () {
    // The helpers' own definitions aren't calls.
    test('no caller of dispatch helpers outside $_helperHomeBasename', () {
      final offenders = offendersIn(
        libSrcUnitsExcept({_helperHomeBasename}),
        (unit) => _HelperCallVisitor(unit.path, unit.parsed.lineInfo),
      );
      check(
        because:
            'Files in lib/src/ call the dispatch helpers '
            '($_forbiddenHelperNames). These take both Material and Cupertino '
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
        (unit) => _DispatchHelperVisitor(
          unit.path,
          unit.parsed.lineInfo,
          isExported: exportedPaths.contains(unit.path),
        ),
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
      final visitors = libSrcUnits
          .map((unit) {
            final visitor = _LookReadVisitor(unit.path, unit.parsed.lineInfo);
            unit.parsed.unit.accept(visitor);

            return visitor;
          })
          .toList(growable: false);
      check(visitors.fold(0, (sum, visitor) => sum + visitor.readCount)).isGreaterThan(0);
      check(
        because:
            'Release builds fold `designLanguage` early only in a switch whose cases are each one '
            'look. Anything else keeps the other arm reachable. See APPENDIX.md#aot-pruning-rules.',
        visitors.expand((visitor) => visitor.offenders),
      ).isEmpty();
    });
  });
}

class _HelperCallVisitor(final String _filePath, final LineInfo _lineInfo)
    extends RecursiveAstVisitor<void>
    implements OffenderVisitor {
  @override
  final List<String> offenders = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_forbiddenHelperNames.contains(node.methodName.name)) {
      final loc = _lineInfo.getLocation(node.offset);
      offenders.add('$_filePath:${loc.lineNumber}: calls ${node.methodName.name}(...)');
    }
    super.visitMethodInvocation(node);
  }
}

class _DispatchHelperVisitor(
  final String _filePath,
  final LineInfo _lineInfo, {
  required final bool isExported,
}) extends RecursiveAstVisitor<void> implements OffenderVisitor {
  @override
  final List<String> offenders = [];

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;
    if (!isExported || name.startsWith('_')) {
      _check(name, node.functionExpression.parameters, node.offset);
    }
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.lexeme;
    if (!isExported || name.startsWith('_')) {
      _check(name, node.parameters, node.offset);
    }
    super.visitMethodDeclaration(node);
  }

  void _check(String name, FormalParameterList? params, int offset) {
    if (params == null) return;

    final functionTypedNames = params.parameters
        .where(_isFunctionTyped)
        .map((param) => (param.name?.lexeme ?? '').toLowerCase())
        .toList(growable: false);
    final hasMaterial = functionTypedNames.any((paramName) => paramName.startsWith('material'));
    final hasCupertino = functionTypedNames.any((paramName) => paramName.startsWith('cupertino'));
    if (hasMaterial && hasCupertino) {
      final loc = _lineInfo.getLocation(offset);
      offenders.add(
        '$_filePath:${loc.lineNumber}: internal function `$name` takes both '
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

class _LookReadVisitor(final String _filePath, final LineInfo _lineInfo)
    extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];
  var readCount = 0;

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    // Doc comments may still name it.
    if (node.name == 'designLanguage' && node.thisOrAncestorOfType<Comment>() == null) {
      readCount++;
      final foldsEarly = switch (node.parent) {
        SwitchExpression(:final expression, :final cases) when expression == node => cases.every(
          (switchCase) => _isOneLook(switchCase.guardedPattern),
        ),
        SwitchStatement(:final expression, :final members) when expression == node =>
          members.whereType<SwitchPatternCase>().every(
            (member) => _isOneLook(member.guardedPattern),
          ),
        _ => false,
      };
      if (!foldsEarly) {
        final location = _lineInfo.getLocation(node.offset);
        offenders.add(
          '$_filePath:${location.lineNumber}: reads designLanguage in a shape release builds '
          "can't fold early",
        );
      }
    }
    super.visitSimpleIdentifier(node);
  }

  bool _isOneLook(GuardedPattern guardedPattern) =>
      guardedPattern.whenClause == null && guardedPattern.pattern is ConstantPattern;
}
