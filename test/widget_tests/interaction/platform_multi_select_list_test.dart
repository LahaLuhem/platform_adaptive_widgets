// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoCheckbox;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _listKey = Key('list');

// Past iOS's section margin, still inside the row.
const _farEndInset = 40.0;

enum _Fruit() {
  apple,
  pear,
  plum,
}

class const _Fruits({
  required final Set<_Fruit> selected,
  final Set<_Fruit>? options,
  final List<Set<_Fruit>>? picks,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: _listKey,
    child: PlatformMultiSelectList<_Fruit>(
      options: options ?? _Fruit.values.toSet(),
      selected: selected,
      label: (fruit) => fruit.name,
      onChanged: (fruits) => picks?.add(fruits),
    ),
  );
}

Future<Set<_Fruit>> _newSetAfterTapping(
  WidgetTester tester,
  _Fruit fruit, {
  required Set<_Fruit> selected,
}) async {
  final picks = <Set<_Fruit>>[];
  await pumpInPlatformScaffold(tester, _Fruits(selected: selected, picks: picks));

  await tester.tap(find.text(fruit.name));
  await tester.pump();

  return picks.single;
}

void main() {
  feature('PlatformMultiSelectList', () {
    scenarioOutlineWidgets<({_Fruit tapped, Set<_Fruit> after})>(
      'adds or drops the tapped option',
      examples: {
        'adds an unpicked one': (tapped: .plum, after: {.pear, .plum}),
        'drops a picked one': (tapped: .pear, after: {}),
      },
      outline: (tester, example) async {
        final after = await _newSetAfterTapping(tester, example.tapped, selected: const {.pear});

        check(after).unorderedEquals(example.after);
      },
    );

    scenarioWidgets("hands back the set in the options' order, not the taps'", (tester) async {
      final after = await _newSetAfterTapping(tester, .apple, selected: const {.plum});

      check(after).deepEquals([_Fruit.apple, _Fruit.plum]);
    });

    scenarioWidgets("takes a tap at a row's far end, away from its label", (tester) async {
      final picks = <Set<_Fruit>>[];
      await pumpInPlatformScaffold(tester, _Fruits(selected: const {.pear}, picks: picks));

      await tester.tapAt(
        Offset(
          tester.getRect(find.byKey(_listKey)).right - _farEndInset,
          tester.getCenter(find.text(_Fruit.plum.name)).dy,
        ),
      );
      await tester.pump();

      check(picks).length.equals(1);
    });

    scenarioWidgets("lists the options top to bottom, in the set's order", (tester) async {
      await pumpInPlatformScaffold(tester, const _Fruits(selected: {.pear}));

      final corners = [for (final fruit in _Fruit.values) tester.getTopLeft(find.text(fruit.name))];
      final tops = [for (final corner in corners) corner.dy];

      check(corners.map((corner) => corner.dx).toSet()).length.equals(1);
      check(tops).deepEquals([...tops]..sort());
    });

    scenarioWidgets('tells a screen reader which rows are picked', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpInPlatformScaffold(tester, const _Fruits(selected: {.apple, .plum}));

      final rows = [
        for (final fruit in _Fruit.values)
          tester.getSemantics(find.text(fruit.name)).getSemanticsData(),
      ];
      semantics.dispose();

      // Each row's own title, not a run of rows.
      check(rows.map((row) => row.label)).deepEquals(_Fruit.values.map((fruit) => fruit.name));
      check(rows.map(readsAsPicked)).deepEquals([true, false, true]);
    });

    scenarioWidgets("flags a selected value that isn't an option", (tester) async {
      await pumpInPlatformScaffold(
        tester,
        _Fruits(selected: const {.pear}, options: _Fruit.values.toSet()..remove(_Fruit.pear)),
      );

      check(tester.takeException()).isA<AssertionError>();
    });

    scenarioWidgets("draws iOS's checkmark rows, not the Mac's controls", (tester) async {
      await pumpInPlatformScaffold(tester, const _Fruits(selected: {.pear}));

      check(find.text(_Fruit.pear.name).evaluate()).isNotEmpty();
      check(find.byType(CupertinoCheckbox).evaluate()).isEmpty();
    }, variant: iosOnly);
  });
}
