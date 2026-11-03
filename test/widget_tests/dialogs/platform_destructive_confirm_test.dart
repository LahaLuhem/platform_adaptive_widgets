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

      check(argbOf(labelStyle(tester, _confirm)))
          .equals(CupertinoColors.systemRed.color.toARGB32());
    }, variant: iosOnly);
  });
}
