// Regression guard for the AOT-pruning contract documented in
// APPENDIX.md#aot-pruning-rules. Two static checks over `lib/src/`:
//
//   1. No call to the closure-arg dispatch helpers (`platformValue`,
//      `platformLazyValue`, `platformValueNullable`, `platformLazyNullable`)
//      outside the file that defines them. These helpers take both Material
//      and Cupertino arms as values/closures; the unused arm stays lexically
//      reachable and defeats AOT pruning.
//
//   2. No private helper takes both a `material*`-named and a `cupertino*`-named
//      function-typed parameter. That shape is the deferred-dispatch trap
//      (`_showBasePlatformDialog`-style) that constructs both closures at the
//      call site and prevents the AOT compiler from folding the unused arm.
//
// Necessary-but-not-sufficient. The empirical guarantee lives in the
// size-regression CI job; see `tool/check_size_regression.dart`.

// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:test/test.dart';

const _helperHomeBasename = 'context_extensions.dart';

const _forbiddenHelperNames = {
  'platformValue',
  'platformValueNullable',
  'platformLazyValue',
  'platformLazyNullable',
};

void main() {
  group('AOT pruning regression guard', () {
    test('no caller of dispatch helpers outside $_helperHomeBasename', () {
      final offenders = <String>[];
      for (final file in _dartFilesIn('lib/src')) {
        if (_isHelperHome(file)) continue;
        final parsed = parseFile(
          path: file.absolute.path,
          featureSet: FeatureSet.latestLanguageVersion(),
        );
        final visitor = _HelperCallVisitor(file.path, parsed.lineInfo);
        parsed.unit.accept(visitor);
        offenders.addAll(visitor.offenders);
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Files in lib/src/ call the dispatch helpers '
            '($_forbiddenHelperNames). These take both Material and Cupertino '
            'values/closures as parameters, so the unused arm stays lexically '
            'reachable and AOT pruning cannot drop it. Use inline '
            '`switch (defaultTargetPlatform)` at the call site instead. See '
            'APPENDIX.md#aot-pruning-rules.',
      );
    });

    test('no private helper in lib/src takes both material* and cupertino* '
        'function-typed params', () {
      final offenders = <String>[];
      for (final file in _dartFilesIn('lib/src')) {
        if (_isHelperHome(file)) continue;
        final parsed = parseFile(
          path: file.absolute.path,
          featureSet: FeatureSet.latestLanguageVersion(),
        );
        final visitor = _DispatchHelperVisitor(file.path, parsed.lineInfo);
        parsed.unit.accept(visitor);
        offenders.addAll(visitor.offenders);
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Found private function(s) that take both a material*-named and '
            'a cupertino*-named function-typed parameter. This shape '
            'constructs both closures at the call site, defeating AOT '
            'pruning. Dispatch at the public entry point with '
            '`switch (defaultTargetPlatform)` and call single-platform '
            'helpers (e.g. `_runMaterialDialog` vs `_runCupertinoDialog`) '
            'that each take only one builder. See '
            'APPENDIX.md#aot-pruning-rules.',
      );
    });
  });
}

bool _isHelperHome(File f) {
  final segments = f.uri.pathSegments;
  return segments.isNotEmpty && segments.last == _helperHomeBasename;
}

Iterable<File> _dartFilesIn(String dir) sync* {
  for (final entity in Directory(dir).listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}

class _HelperCallVisitor extends RecursiveAstVisitor<void> {
  _HelperCallVisitor(this.filePath, this.lineInfo);

  final String filePath;
  final LineInfo lineInfo;
  final List<String> offenders = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_forbiddenHelperNames.contains(node.methodName.name)) {
      final loc = lineInfo.getLocation(node.offset);
      offenders.add('$filePath:${loc.lineNumber}: calls ${node.methodName.name}(...)');
    }
    super.visitMethodInvocation(node);
  }
}

class _DispatchHelperVisitor extends RecursiveAstVisitor<void> {
  _DispatchHelperVisitor(this.filePath, this.lineInfo);

  final String filePath;
  final LineInfo lineInfo;
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
    var hasMaterial = false;
    var hasCupertino = false;
    for (final param in params.parameters) {
      final pname = (param.name?.lexeme ?? '').toLowerCase();
      if (!_isFunctionTyped(param)) continue;
      if (pname.startsWith('material')) hasMaterial = true;
      if (pname.startsWith('cupertino')) hasCupertino = true;
    }
    if (hasMaterial && hasCupertino) {
      final loc = lineInfo.getLocation(offset);
      offenders.add(
        '$filePath:${loc.lineNumber}: private function `$name` takes both '
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
