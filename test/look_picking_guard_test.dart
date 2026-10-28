// Look-picking guard for APPENDIX.md#platform-widget-base-hierarchy: every look is picked through
// `designLanguage`, and no half can be built from outside.

// Named for the guard, not for its visitor classes.
// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/lib_src.dart';

const _designLanguageHomeBasename = 'design_language.dart';

const _halfNames = {'buildMaterial', 'buildCupertino'};

// The analyzer doesn't carry the base's annotations over to overrides.
const _halfLocks = {'protected', 'visibleForOverriding'};

void main() {
  group('Look-picking guard', () {
    test('nothing in lib/src but $_designLanguageHomeBasename reads defaultTargetPlatform', () {
      final offenders = libSrcUnitsExcept({_designLanguageHomeBasename}).expand((unit) {
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
      final visitors = libSrcUnits
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
