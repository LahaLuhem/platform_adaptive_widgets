// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

enum _Fruit() {
  apple,
  pear,
  plum,
}

class const _Fruits({required final Set<_Fruit> selected, final List<Set<_Fruit>>? picks})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformMultiSelectList<_Fruit>(
    options: _Fruit.values.toSet(),
    selected: selected,
    label: (fruit) => fruit.name,
    onChanged: (fruits) => picks?.add(fruits),
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

    scenarioWidgets('tells a screen reader which rows are picked', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpInPlatformScaffold(tester, const _Fruits(selected: {.apple, .plum}));

      final rows = [
        for (final fruit in _Fruit.values)
          tester.getSemantics(find.text(fruit.name)).getSemanticsData(),
      ];
      semantics.dispose();

      // Each row's own title, so the reader says it with its state, not a run of rows.
      check(rows.map((row) => row.label)).deepEquals(_Fruit.values.map((fruit) => fruit.name));
      check(rows.map(readsAsPicked)).deepEquals([true, false, true]);
    });
  });
}
