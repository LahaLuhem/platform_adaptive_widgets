import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/src/widgets/dialogs/platform_destructive_confirm.dart';

import '../../support/support.dart';

const _message = 'Its reminders are deleted too.';
const _confirm = 'Delete List';

Future<bool> _show(BuildContext context) =>
    showPlatformDestructiveConfirm(context: context, message: _message, confirmLabel: _confirm);

bool _isShowing(WidgetTester tester) => tester.any(find.text(_message));

Offset _center(WidgetTester tester, String label) => tester.getCenter(find.text(label));

void main() {
  feature('showPlatformDestructiveConfirm', () {
    scenarioOutlineWidgets<({String button, bool answer})>(
      'answers whether the person confirmed',
      examples: {
        'when confirmed': (button: _confirm, answer: true),
        'when cancelled': (button: 'Cancel', answer: false),
      },
      outline: (tester, row) async {
        final context = await pumpForContext(tester);
        final answerFuture = _show(context);
        await tester.pumpAndSettle();

        await tester.tap(find.text(row.button));
        await tester.pumpAndSettle();

        check(_isShowing(tester)).isFalse();
        check(await answerFuture).equals(row.answer);
      },
    );

    scenarioWidgets('answers no when closed from outside', (tester) async {
      final context = await pumpForContext(tester);
      final answerFuture = _show(context);
      await tester.pumpAndSettle();
      check(_isShowing(tester)).isTrue();

      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      check(_isShowing(tester)).isFalse();
      check(await answerFuture).isFalse();
    });

    scenarioWidgets('marks the confirming button as destructive on iOS', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      final confirmTextStyle = labelStyle(tester, _confirm);
      check(argbOf(confirmTextStyle)).equals(CupertinoColors.systemRed.color.toARGB32());
      // Cancel below it, bold as iOS draws its own.
      check(_center(tester, 'Cancel').dy).isGreaterThan(_center(tester, _confirm).dy);
      check(weightOf(labelStyle(tester, 'Cancel'))).isGreaterThan(weightOf(confirmTextStyle));
    }, variant: iosOnly);

    scenarioWidgets('keeps its untitled message as far from the top as from the side on Android', (
      tester,
    ) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      final insets = messageInsets(tester, _message);
      check(insets.top).equals(insets.side);
    }, variant: androidOnly);
  });
}
