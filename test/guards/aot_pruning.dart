// Regression guard for the AOT-pruning contract documented in
// APPENDIX.md#aot-pruning-rules. 2 static checks over `lib/src/`:
//
//   1. No call hands arguments to both a `material*`-named and a `cupertino*`-named parameter, the
//      package's per-look records aside: a value selector (`platformValue` and co) or a helper
//      taking both builders. Both arms then exist at the call site, so the unused one stays
//      reachable and defeats AOT pruning.
//
//   2. Every read of `designLanguage` is a switch whose cases are each one look. Release builds fold
//      only that shape early, so an `==`, a `_`, an `||` or a `when` keeps the other arm's code in.
//
// Necessary-but-not-sufficient. The empirical guarantee lives in the
// size-regression CI job. See `tool/check_size_regression.dart`.

// ignore_for_file: prefer-match-file-name

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/lib_src.dart';

const _helperHomeBasename = 'platform_value.dart';

void aotPruningGuard() {
  late final List<LibSrcUnit> units;

  group('AOT pruning regression guard', () {
    setUpAll(() async => units = await analyzedLibSrc);

    // The selectors there pass both arms on by design, at the cost their docs give.
    test('no call in lib/src hands arguments to both looks, records aside', () {
      final visitors = visitAll(units.except({_helperHomeBasename}), _BothLooksCallVisitor.new);
      check(
        because: 'Matched no argument to its parameter, so the check below sees nothing.',
        visitors.fold(0, (sum, visitor) => sum + visitor.matchedCount),
      ).isGreaterThan(0);
      check(
        because:
            "Both arms exist at the call site, so AOT pruning can't drop the look that never draws. "
            'Switch on `designLanguage` there and call a one-look helper instead (like '
            '`showMaterialDialogRoute`). See APPENDIX.md#aot-pruning-rules.',
        visitors.expand((visitor) => visitor.offenders),
      ).isEmpty();
    });

    test('every designLanguage read in lib/src is a switch whose cases are each one look', () {
      final visitors = visitAll(units, _LookReadVisitor.new);
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

class _BothLooksCallVisitor(final LibSrcUnit _unit) extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];
  var matchedCount = 0;

  @override
  void visitArgumentList(ArgumentList node) {
    final parameters = node.arguments
        .map((argument) => argument.correspondingParameter)
        .nonNulls
        .toList(growable: false);
    matchedCount += parameters.length;
    final arms = parameters
        .where((parameter) => !isLookRecord(parameter.type))
        .map((parameter) => parameter.name ?? '');
    final material = arms.where((name) => name.startsWith('material'));
    final cupertino = arms.where((name) => name.startsWith('cupertino'));
    if (material.isNotEmpty && cupertino.isNotEmpty) {
      offenders.add(
        '${_unit.locate(node.parent ?? node)}: passes `${material.first}` and '
        '`${cupertino.first}` to `${parameters.first.enclosingElement?.displayName}`',
      );
    }
    super.visitArgumentList(node);
  }
}

class _LookReadVisitor(final LibSrcUnit _unit) extends RecursiveAstVisitor<void> {
  final List<String> offenders = [];
  var readCount = 0;

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    // A doc comment's `[designLanguage]` resolves to the getter too, but reads nothing.
    if (node.element case final GetterElement getter
        when getter.name == 'designLanguage' &&
            isOurs(getter) &&
            node.thisOrAncestorOfType<Comment>() == null) {
      readCount++;
      final foldsEarly = switch (node.parent) {
        SwitchExpression(:final expression, :final cases) when expression == node => cases.every(
          (switchCase) => lookOf(switchCase.guardedPattern) != null,
        ),
        SwitchStatement(:final expression, :final members) when expression == node => members.every(
          (member) => member is SwitchPatternCase && lookOf(member.guardedPattern) != null,
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
}
