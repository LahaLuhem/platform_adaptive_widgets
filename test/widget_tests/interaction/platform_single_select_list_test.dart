// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoRadio;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_adaptive_widgets/src/widgets/interaction/internal/cupertino_checkmark_row.dart';

import '../../support/support.dart';

const _listKey = Key('list');

// Clear of the label, inside the row.
const _farEndInset = 40.0;

enum _Fruit() {
  apple,
  pear,
  plum,
}

const _picked = _Fruit.pear;

class const _Fruits({final Set<_Fruit>? options, final List<_Fruit>? picks})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: _listKey,
    child: PlatformSingleSelectList<_Fruit>(
      options: options ?? _Fruit.values.toSet(),
      selected: _picked,
      label: (fruit) => fruit.name,
      onChanged: (fruit) => picks?.add(fruit),
    ),
  );
}

void main() {
  final feature = BddFeature('PlatformSingleSelectList');

  Bdd(feature).scenario('puts widgetKey on the list it builds').runWidgets((tester) async {
    const widgetKey = Key('inner');
    await pumpInPlatformScaffold(
      tester,
      PlatformSingleSelectList<_Fruit>(
        options: _Fruit.values.toSet(),
        selected: _picked,
        label: (fruit) => fruit.name,
        onChanged: (_) => noop(),
        widgetKey: widgetKey,
      ),
    );

    check(
      find
          .descendant(
            of: find.byType(PlatformSingleSelectList<_Fruit>),
            matching: find.byKey(widgetKey),
          )
          .evaluate(),
    ).length.equals(1);
  });

  Bdd(feature).scenario('picks the tapped option').runWidgets((tester) async {
    final picks = <_Fruit>[];
    await pumpInPlatformScaffold(tester, _Fruits(picks: picks));

    await tester.tap(find.text(_Fruit.plum.name));
    await tester.pump();

    check(picks).deepEquals([_Fruit.plum]);
  });

  // Material's radio ignores it by itself.
  Bdd(feature).scenario('ignores a tap on the picked option').runWidgets((tester) async {
    final picks = <_Fruit>[];
    await pumpInPlatformScaffold(tester, _Fruits(picks: picks));

    await tester.tap(find.text(_picked.name));
    await tester.pump();

    check(picks).isEmpty();
  }, variant: iosOnly);

  // iOS's row has its own test.
  Bdd(feature)
      .scenario("takes a tap at a row's far end, away from its label")
      .runWidgets((tester) async {
        final picks = <_Fruit>[];
        await pumpInPlatformScaffold(tester, _Fruits(picks: picks));

        await tester.tapAt(
          Offset(
            tester.getRect(find.byKey(_listKey)).right - _farEndInset,
            tester.getCenter(find.text(_Fruit.plum.name)).dy,
          ),
        );
        await tester.pump();

        check(picks).length.equals(1);
      }, variant: androidOnly);

  Bdd(feature)
      .scenario("lists the options top to bottom, in the set's order")
      .runWidgets((tester) async {
        // Neither the enum's order nor the alphabet's, so a sort shows.
        const options = {_Fruit.plum, _Fruit.apple, _Fruit.pear};
        await pumpInPlatformScaffold(tester, const _Fruits(options: options));

        final corners = [for (final fruit in options) tester.getTopLeft(find.text(fruit.name))];
        final tops = [for (final corner in corners) corner.dy];

        check(corners.map((corner) => corner.dx).toSet()).length.equals(1);
        check(tops).deepEquals([...tops]..sort());
      });

  Bdd(feature).scenario('tells a screen reader which row is picked').runWidgets((tester) async {
    final semantics = tester.ensureSemantics();
    await pumpInPlatformScaffold(tester, const _Fruits());

    final picked = tester.getSemantics(find.text(_picked.name)).getSemanticsData();
    final other = tester.getSemantics(find.text(_Fruit.plum.name)).getSemanticsData();
    semantics.dispose();

    check(readsAsPicked(picked)).isTrue();
    check(readsAsPicked(other)).isFalse();
  });

  Bdd(feature).scenario("flags a selected value that isn't an option").runWidgets((tester) async {
    await pumpInPlatformScaffold(tester, _Fruits(options: _Fruit.values.toSet()..remove(_picked)));

    check(tester.takeException()).isA<AssertionError>();
  });

  Bdd(feature)
      .scenario("draws iOS's checkmark rows, not the Mac's controls")
      .runWidgets((tester) async {
        await pumpInPlatformScaffold(tester, const _Fruits());

        check(find.byType(CupertinoCheckmarkRow).evaluate()).length.equals(_Fruit.values.length);
        check(find.byWidgetPredicate((widget) => widget is CupertinoRadio).evaluate()).isEmpty();
      }, variant: iosOnly);
}
