// Regression guard for the AOT-pruning contract documented in
// APPENDIX.md#aot-pruning-rules. 2 static checks over `lib/src/`:
//
//   1. No call to the closure-arg dispatch helpers (`platformValue`,
//      `platformLazyValue`, `platformValueNullable`, `platformLazyNullable`)
//      outside the file that defines them. These helpers take both Material
//      and Cupertino arms as values/closures. The unused arm stays lexically
//      reachable and defeats AOT pruning.
//
//   2. No private helper takes both a `material*`-named and a `cupertino*`-named
//      function-typed parameter. That shape is the deferred-dispatch trap
//      (`_showBasePlatformDialog`-style) that constructs both closures at the
//      call site and prevents the AOT compiler from folding the unused arm.
//
// Necessary-but-not-sufficient. The empirical guarantee lives in the
// size-regression CI job. See `tool/check_size_regression.dart`.

// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

const _helperHomeBasename = 'platform_value.dart';

const _designLanguageHomeBasename = 'design_language.dart';

const _halfNames = {'buildMaterial', 'buildCupertino'};

// The analyzer doesn't carry the base's annotations over to overrides.
const _halfLocks = {'protected', 'visibleForOverriding'};

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
      final offenders = _unitsExcept({_helperHomeBasename}).expand((unit) {
        final visitor = _HelperCallVisitor(unit.path, unit.parsed.lineInfo);
        unit.parsed.unit.accept(visitor);

        return visitor.offenders;
      });
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

    test('no private helper in lib/src takes both material* and cupertino* '
        'function-typed params', () {
      final offenders = _unitsExcept({_helperHomeBasename}).expand((unit) {
        final visitor = _DispatchHelperVisitor(unit.path, unit.parsed.lineInfo);
        unit.parsed.unit.accept(visitor);

        return visitor.offenders;
      });
      check(
        because:
            'Found private function(s) that take both a material*-named and '
            'a cupertino*-named function-typed parameter. This shape '
            'constructs both closures at the call site, defeating AOT '
            'pruning. Dispatch at the public entry point with '
            '`switch (designLanguage)` and call single-platform '
            'helpers (e.g. `_runMaterialDialog` vs `_runCupertinoDialog`) '
            'that each take only one builder. See '
            'APPENDIX.md#aot-pruning-rules.',
        offenders,
      ).isEmpty();
    });
  });

  group('Look-picking guard', () {
    test('nothing in lib/src but $_designLanguageHomeBasename reads defaultTargetPlatform', () {
      final offenders = _unitsExcept({_designLanguageHomeBasename}).expand((unit) {
        final visitor = _PlatformReadVisitor(unit.path, unit.parsed.lineInfo);
        unit.parsed.unit.accept(visitor);

        return visitor.offenders;
      });
      check(
        because: 'Switch on `designLanguage` instead, so every site agrees on the look.',
        offenders,
      ).isEmpty();
    });

    test('every ${_halfNames.join(' / ')} is $_halfLocks', () {
      final visitors = _libSrcUnits
          .map((unit) {
            final visitor = _HalfLockVisitor(unit.path, unit.parsed.lineInfo);
            unit.parsed.unit.accept(visitor);

            return visitor;
          })
          .toList(growable: false);
      check(visitors.fold(0, (sum, visitor) => sum + visitor.halfCount)).isGreaterThan(0);
      check(
        because: 'A half callable from outside skips `designLanguage`.',
        visitors.expand((visitor) => visitor.offenders),
      ).isEmpty();
    });
  });
}

typedef _Unit = ({String path, String basename, ParseStringResult parsed});

final List<_Unit> _libSrcUnits = [
  for (final file in Directory('lib/src').listSync(recursive: true).whereType<File>())
    if (file.path.endsWith('.dart'))
      (
        path: file.path,
        basename: file.uri.pathSegments.last,
        parsed: parseFile(path: file.absolute.path, featureSet: FeatureSet.latestLanguageVersion()),
      ),
];

Iterable<_Unit> _unitsExcept(Set<String> basenames) =>
    _libSrcUnits.where((unit) => !basenames.contains(unit.basename));

class _HelperCallVisitor(final String _filePath, final LineInfo _lineInfo)
    extends RecursiveAstVisitor<void> {
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

class _DispatchHelperVisitor(final String _filePath, final LineInfo _lineInfo)
    extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;
    if (name.startsWith('_')) {
      _check(name, node.functionExpression.parameters, node.offset);
    }
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.lexeme;
    if (name.startsWith('_')) {
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
        '$_filePath:${loc.lineNumber}: private function `$name` takes both '
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

class _PlatformReadVisitor(final String _filePath, final LineInfo _lineInfo)
    extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    // Doc comments may still name it.
    if (node.name == 'defaultTargetPlatform' && node.thisOrAncestorOfType<Comment>() == null) {
      final loc = _lineInfo.getLocation(node.offset);
      offenders.add('$_filePath:${loc.lineNumber}: reads defaultTargetPlatform');
    }
    super.visitSimpleIdentifier(node);
  }
}

class _HalfLockVisitor(final String _filePath, final LineInfo _lineInfo)
    extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];
  var halfCount = 0;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.lexeme;
    if (_halfNames.contains(name)) {
      halfCount++;
      final missing = _halfLocks.difference(
        node.metadata.map((annotation) => annotation.name.name).toSet(),
      );
      if (missing.isNotEmpty) {
        final loc = _lineInfo.getLocation(node.offset);
        offenders.add('$_filePath:${loc.lineNumber}: $name misses $missing');
      }
    }
    super.visitMethodDeclaration(node);
  }
}
