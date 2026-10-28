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

const _picked = _Fruit.pear;

class const _Fruits({final List<_Fruit>? picks}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformSingleSelectList<_Fruit>(
    options: _Fruit.values.toSet(),
    selected: _picked,
    label: (fruit) => fruit.name,
    onChanged: (fruit) => picks?.add(fruit),
  );
}

void main() {
  feature('PlatformSingleSelectList', () {
    scenarioWidgets('picks the tapped option, ignoring a tap on the picked one', (tester) async {
      final picks = <_Fruit>[];
      await pumpInPlatformScaffold(tester, _Fruits(picks: picks));

      await tester.tap(find.text(_picked.name));
      await tester.tap(find.text(_Fruit.plum.name));
      await tester.pump();

      check(picks).deepEquals([_Fruit.plum]);
    });

    scenarioWidgets('tells a screen reader which row is picked', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpInPlatformScaffold(tester, const _Fruits());

      final picked = tester.getSemantics(find.text(_picked.name)).getSemanticsData();
      final other = tester.getSemantics(find.text(_Fruit.plum.name)).getSemanticsData();
      semantics.dispose();

      // The row's own title, so the reader says it with the state, not a run of rows.
      check(picked.label).equals(_picked.name);
      check(readsAsPicked(picked)).isTrue();
      check(readsAsPicked(other)).isFalse();
    });
  });
}
