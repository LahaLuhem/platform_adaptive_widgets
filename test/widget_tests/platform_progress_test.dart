// Named after what it tests, not after its helper widget.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _indicatorKey = Key('indicator');
const _label = 'Loading inbox';

// Today the value only goes in through the Material record.
class const _Indicator({final double? value, final String? label}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformProgressIndicator(
    semanticsLabel: label,
    materialProgressIndicatorData: MaterialProgressIndicatorData(value: value),
  );
}

Future<void> _pump(WidgetTester tester, Widget indicator) => pumpPlatformWidget(
  tester,
  Center(
    // Room for a bar, which spans its parent, as well as a ring, which sizes itself.
    child: SizedBox(
      width: 200,
      child: Center(
        child: RepaintBoundary(key: _indicatorKey, child: indicator),
      ),
    ),
  ),
);

Future<Uint8List> _pixels(WidgetTester tester) async {
  final image = (await tester.runAsync(
    () => captureImage(tester.element(find.byKey(_indicatorKey))),
  ))!;
  final bytes = (await tester.runAsync(image.toByteData))!.buffer.asUint8List();
  image.dispose();

  return bytes;
}

String _spokenValue() =>
    find.semantics.byPredicate((node) => node.value.isNotEmpty).evaluate().singleOrNull?.value ??
    '';

void main() {
  feature('Progress indicators', () {
    scenarioWidgets('show how far along known progress is', (tester) async {
      await _pump(tester, const _Indicator(value: 0.3));
      final atThird = await _pixels(tester);
      // No time passes between the 2 frames, so a spinner can't make them differ by turning.
      await _pump(tester, const _Indicator(value: 0.6));
      final atTwoThirds = await _pixels(tester);

      check(listEquals(atThird, atTwoThirds)).isFalse();
    });

    scenarioWidgets('tell screen readers how far along known progress is', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, const _Indicator(value: 0.3));
      final atThird = _spokenValue();
      await _pump(tester, const _Indicator(value: 0.6));
      final atTwoThirds = _spokenValue();
      semantics.dispose();

      check(atThird).isNotEmpty();
      check(atTwoThirds).not((it) => it.equals(atThird));
    });

    scenarioOutlineWidgets<double?>(
      'tell screen readers what is loading',
      examples: {'without a value': null, 'with a value': 0.3},
      outline: (tester, value) async {
        final semantics = tester.ensureSemantics();
        await _pump(tester, _Indicator(value: value, label: _label));
        final isNamed = find.semantics.byLabel(_label).evaluate().isNotEmpty;
        semantics.dispose();

        check(isNamed).isTrue();
      },
    );

    scenarioOutlineWidgets<double>(
      'refuse progress outside 0 to 1',
      examples: {'above 1': 1.2, 'below 0': -0.1},
      outline: (tester, value) async {
        await _pump(tester, _Indicator(value: value));

        check(tester.takeException()).isA<AssertionError>();
      },
    );
  });
}
