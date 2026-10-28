// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoRadio;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

// Inside the row on both looks, past the margin iOS leaves around its section.
const _farEndInset = 40.0;

enum _Fruit() {
  apple,
  pear,
  plum,
}

const _picked = _Fruit.pear;

class const _Fruits({final Set<_Fruit>? options, final String? header, final List<_Fruit>? picks})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformSingleSelectList<_Fruit>(
    options: options ?? _Fruit.values.toSet(),
    selected: _picked,
    label: (fruit) => fruit.name,
    onChanged: (fruit) => picks?.add(fruit),
    header: header,
  );
}

Future<void> _pump(WidgetTester tester, _Fruits fruits) => pumpInPlatformScaffold(tester, fruits);

void main() {
  feature('PlatformSingleSelectList', () {
    scenarioOutlineWidgets<Offset Function(WidgetTester tester)>(
      'picks the option whose row is tapped',
      examples: {
        'on its label': (tester) => tester.getCenter(find.text(_Fruit.plum.name)),
        'at its far end': (tester) => Offset(
          tester.getRect(find.byType(PlatformSingleSelectList<_Fruit>)).right - _farEndInset,
          tester.getCenter(find.text(_Fruit.plum.name)).dy,
        ),
      },
      outline: (tester, spot) async {
        final picks = <_Fruit>[];
        await _pump(tester, _Fruits(picks: picks));

        await tester.tapAt(spot(tester));
        await tester.pump();

        check(picks).deepEquals([_Fruit.plum]);
      },
    );

    scenarioWidgets('ignores a tap on the picked row', (tester) async {
      final picks = <_Fruit>[];
      await _pump(tester, _Fruits(picks: picks));

      await tester.tap(find.text(_picked.name));
      // Shows the list was taking taps all along.
      await tester.tap(find.text(_Fruit.plum.name));
      await tester.pump();

      check(picks).deepEquals([_Fruit.plum]);
    });

    scenarioWidgets('tells a screen reader which row is picked', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const _Fruits());

      final picked = tester.getSemantics(find.text(_picked.name)).getSemanticsData();
      final other = tester.getSemantics(find.text(_Fruit.plum.name)).getSemanticsData();
      semantics.dispose();

      // The row's own title, so the reader says it with the state, not a run of rows.
      check(picked.label).equals(_picked.name);
      check(readsAsPicked(picked)).isTrue();
      check(readsAsPicked(other)).isFalse();
    });

    scenarioWidgets("lists the options top to bottom, in the set's order", (tester) async {
      await _pump(tester, const _Fruits());

      final corners = [for (final fruit in _Fruit.values) tester.getTopLeft(find.text(fruit.name))];
      final tops = [for (final corner in corners) corner.dy];

      check(corners.map((corner) => corner.dx).toSet()).length.equals(1);
      check(tops).deepEquals([...tops]..sort());
    });

    scenarioWidgets('makes the header a heading for screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const _Fruits(header: 'Fruit'));

      final header = tester.getSemantics(find.text('Fruit')).getSemanticsData();
      semantics.dispose();

      // Its own node, so the rows aren't read out as part of the heading.
      check(header.label).equals('Fruit');
      check(header.headingLevel).isGreaterThan(0);
    });

    scenarioWidgets("flags a selected value that isn't an option", (tester) async {
      await _pump(tester, _Fruits(options: _Fruit.values.toSet()..remove(_picked)));

      check(tester.takeException()).isA<AssertionError>();
    });

    scenarioWidgets("draws iOS's checkmark rows, not the Mac's radios", (tester) async {
      await _pump(tester, const _Fruits());

      check(find.text(_picked.name).evaluate()).isNotEmpty();
      check(find.byWidgetPredicate((widget) => widget is CupertinoRadio).evaluate()).isEmpty();
    }, variant: iosOnly);
  });
}
