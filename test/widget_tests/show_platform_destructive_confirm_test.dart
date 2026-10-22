import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/src/widgets/dialogs/platform_destructive_confirm.dart';

import '../support/support.dart';

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

    scenarioOutlineWidgets<Future<void> Function(WidgetTester tester)>(
      'answers no when left another way',
      examples: {
        'by a tap outside': (tester) => tester.tapAt(const Offset(4, 4)),
        'by Escape': (tester) => tester.sendKeyEvent(LogicalKeyboardKey.escape),
        'by Back': (tester) => tester.binding.handlePopRoute(),
      },
      outline: (tester, leave) async {
        final context = await pumpForContext(tester);
        final answerFuture = _show(context);
        await tester.pumpAndSettle();
        check(_isShowing(tester)).isTrue();

        await leave(tester);
        await tester.pumpAndSettle();

        check(_isShowing(tester)).isFalse();
        check(await answerFuture).isFalse();
      },
    );

    scenarioWidgets('shows the message above the confirming button', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      check(_center(tester, _message).dy).isLessThan(_center(tester, _confirm).dy);
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

    scenarioWidgets("asks in M3's plain dialog on Android", (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      // A dialog's buttons share a row, Cancel first. A sheet would stack them.
      check(_center(tester, 'Cancel').dy).equals(_center(tester, _confirm).dy);
      check(_center(tester, 'Cancel').dx).isLessThan(_center(tester, _confirm).dx);
      check(argbOf(labelStyle(tester, _confirm))).equals(argbOf(labelStyle(tester, 'Cancel')));
    }, variant: androidOnly);

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
