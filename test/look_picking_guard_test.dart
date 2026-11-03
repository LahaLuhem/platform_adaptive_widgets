// Look-picking guard for APPENDIX.md#platform-widget-base-hierarchy: every look is picked through
// `designLanguage`, and no half can be built from outside.

// Named for the guard, not for its visitor classes.
// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/lib_src.dart';

const _designLanguageHomeBasename = 'design_language.dart';

const _platformNames = {'defaultTargetPlatform', 'TargetPlatform'};

final _halfNames = {lookHalves.material, lookHalves.cupertino};

// The analyzer doesn't carry the base's annotations over to overrides.
const _halfLocks = {'protected', 'visibleForOverriding'};

void main() {
  group('Look-picking guard', () {
    test('nothing in lib/src but $_designLanguageHomeBasename reads the platform', () {
      final offenders = offendersIn(
        libSrcUnitsExcept({_designLanguageHomeBasename}),
        _PlatformReadVisitor.new,
      );
      check(
        because: 'Switch on `designLanguage` instead, so every site agrees on the look.',
        offenders,
      ).isEmpty();
    });

    test('every ${_halfNames.join(' / ')} is $_halfLocks', () {
      final visitors = visitAll(libSrcUnits, _HalfLockVisitor.new);
      check(
        because: 'Found no look half at all, so the check below passes on nothing.',
        visitors.fold(0, (sum, visitor) => sum + visitor.halfCount),
      ).isGreaterThan(0);
      check(
        because: 'A half callable from outside skips `designLanguage`.',
        visitors.expand((visitor) => visitor.offenders),
      ).isEmpty();
    });
  });
}

class _PlatformReadVisitor(final LibSrcUnit _unit)
    extends RecursiveAstVisitor<void>
    implements OffenderVisitor {
  @override
  final List<String> offenders = [];

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    // `Theme.of(context).platform` and the like.
    final isPropertyRead = switch (node.parent) {
      PropertyAccess(:final propertyName) => propertyName == node,
      PrefixedIdentifier(:final identifier) => identifier == node,
      _ => false,
    };
    if ((isPropertyRead && readsInCode(node, 'platform')) ||
        _platformNames.any((name) => readsInCode(node, name))) {
      offenders.add('${_unit.locate(node)}: reads ${node.name}');
    }
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitNamedType(NamedType node) {
    if (_platformNames.contains(node.name.lexeme)) {
      offenders.add('${_unit.locate(node)}: names ${node.name.lexeme}');
    }
    super.visitNamedType(node);
  }
}

class _HalfLockVisitor(final LibSrcUnit _unit) extends RecursiveAstVisitor<void> {
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
        offenders.add('${_unit.locate(node)}: $name misses $missing');
      }
    }
    super.visitMethodDeclaration(node);
  }
}
