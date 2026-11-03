// Look-picking guard for APPENDIX.md#platform-widget-base-hierarchy: every look is picked through
// `designLanguage`, and no half can be built from outside.

// Named for the guard, not for its visitor classes.
// ignore_for_file: prefer-match-file-name

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/lib_src.dart';

const _designLanguageHomeBasename = 'design_language.dart';

final _halfNames = {lookHalves.material, lookHalves.cupertino};

// The analyzer doesn't carry the base's annotations over to overrides.
const _halfLocks = {'protected', 'visibleForOverriding'};

void lookPickingGuard() {
  late final List<LibSrcUnit> units;

  group('Look-picking guard', () {
    setUpAll(() async => units = await analyzedLibSrc);

    test('nothing in lib/src but $_designLanguageHomeBasename reads the platform', () {
      final home = units.singleWhere((unit) => unit.basename == _designLanguageHomeBasename);
      check(
        because:
            'Found no TargetPlatform even in $_designLanguageHomeBasename, so the check below '
            "can't see types.",
        offendersIn([home], _PlatformVisitor.new),
      ).isNotEmpty();
      check(
        because: 'Switch on `designLanguage` instead, so every site agrees on the look.',
        offendersIn(units.except({_designLanguageHomeBasename}), _PlatformVisitor.new),
      ).isEmpty();
    });

    test('every ${_halfNames.join(' / ')} is $_halfLocks', () {
      final visitors = visitAll(units, _HalfLockVisitor.new);
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

/// Anything typed `TargetPlatform`, so the platform read under whatever name.
class _PlatformVisitor(final LibSrcUnit _unit)
    extends GeneralizingAstVisitor<void>
    implements OffenderVisitor {
  @override
  final List<String> offenders = [];

  @override
  void visitExpression(Expression node) {
    if (node.staticType case InterfaceType(:final element)
        when element.name == 'TargetPlatform' &&
            element.library.uri.pathSegments.firstOrNull == 'flutter') {
      // Its own parts are the same read, so one line for the whole.
      offenders.add('${_unit.locate(node)}: `${node.toSource()}` is a TargetPlatform');
    } else {
      super.visitExpression(node);
    }
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
