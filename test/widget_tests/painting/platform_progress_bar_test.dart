import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _barKey = Key('bar');
const _label = 'Loading inbox';

Future<void> _pump(WidgetTester tester, PlatformProgressBar bar) => pumpPlatformWidget(
  tester,
  Center(
    // Room for the bar, which spans its parent.
    child: SizedBox(
      width: 200,
      child: Center(
        child: RepaintBoundary(key: _barKey, child: bar),
      ),
    ),
  ),
);

String _spokenValue() =>
    find.semantics.byPredicate((node) => node.value.isNotEmpty).evaluate().singleOrNull?.value ??
    '';

void main() {
  feature('PlatformProgressBar', () {
    scenarioWidgets('shows how far along known progress is', (tester) async {
      await _pump(tester, const PlatformProgressBar(value: 0.3));
      final atThird = (await pixelsOf(tester, find.byKey(_barKey))).rgba;
      await _pump(tester, const PlatformProgressBar(value: 0.6));
      final atTwoThirds = (await pixelsOf(tester, find.byKey(_barKey))).rgba;

      check(listEquals(atThird, atTwoThirds)).isFalse();
    });

    scenarioWidgets('draws the bar as thick as asked', (tester) async {
      await _pump(tester, const PlatformProgressBar(value: 0.3, height: 9));

      check(tester.getSize(find.byKey(_barKey)).height).equals(9);
    });

    // Material's bar says it by itself.
    scenarioWidgets('tells screen readers how far along known progress is', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const PlatformProgressBar(value: 0.3));
      final atThird = _spokenValue();
      await _pump(tester, const PlatformProgressBar(value: 0.6));
      final atTwoThirds = _spokenValue();
      semantics.dispose();

      check(atThird).isNotEmpty();
      check(atTwoThirds).not((it) => it.equals(atThird));
    }, variant: iosOnly);

    scenarioWidgets('tells screen readers what is loading', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const PlatformProgressBar(value: 0.3, semanticsLabel: _label));
      final isNamed = find.semantics.byLabel(_label).evaluate().isNotEmpty;
      semantics.dispose();

      check(isNamed).isTrue();
    });

    scenarioOutlineWidgets<double>(
      'refuses progress outside 0 to 1',
      examples: {'above 1': 1.2, 'below 0': -0.1},
      outline: (tester, value) async {
        check(() => PlatformProgressBar(value: value)).throws<AssertionError>();
      },
    );
  });
}
