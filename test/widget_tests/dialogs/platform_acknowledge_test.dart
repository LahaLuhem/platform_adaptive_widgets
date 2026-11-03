import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _title = 'Saved';
const _okLabel = 'Got it';

void main() {
  feature('showPlatformAcknowledge', () {
    scenarioWidgets('closes on its okLabel button, and only then completes its future', (
      tester,
    ) async {
      var isDone = false;
      final context = await pumpForContext(tester);

      unawaited(
        showPlatformAcknowledge(
          context: context,
          title: _title,
          okLabel: _okLabel,
        ).then((_) => isDone = true),
      );
      await pumpTransition(tester);
      check(isDone).isFalse();

      await tester.tap(find.text(_okLabel));
      await pumpTransition(tester);

      check(find.text(_title).evaluate()).isEmpty();
      check(isDone).isTrue();
    });
  });
}
