import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _content = 'Sheet';
const _tint = Color(0xFF123456);

Future<void> _show(BuildContext context, {Color? barrierColor, bool barrierDismissible = true}) =>
    showPlatformRawModalBottomSheet<void>(
      context: context,
      builder: (_) => const Text(_content),
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
    );

void main() {
  feature('showPlatformRawModalBottomSheet', () {
    scenarioOutlineWidgets<bool>(
      'closes on a tap outside only when barrierDismissible allows it',
      examples: {'dismissible': true, 'not dismissible': false},
      outline: (tester, barrierDismissible) async {
        final context = await pumpForContext(tester);
        unawaited(_show(context, barrierDismissible: barrierDismissible));
        await tester.pumpAndSettle();
        check(tester.any(find.text(_content))).isTrue();

        await tester.tapAt(const Offset(4, 4));
        await tester.pumpAndSettle();

        check(tester.any(find.text(_content))).equals(!barrierDismissible);
      },
    );

    scenarioWidgets('tints the barrier with barrierColor', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context, barrierColor: _tint));
      await tester.pumpAndSettle();

      check(tester.widget<ModalBarrier>(find.byType(ModalBarrier).last).color).equals(_tint);
    });
  });
}
