import 'dart:async';

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/src/widgets/dialogs/platform_destructive_confirm.dart';

import '../../support/support.dart';

const _message = 'Its reminders are deleted too.';
const _confirm = 'Delete List';

Future<bool> _show(BuildContext context) =>
    showPlatformDestructiveConfirm(context: context, message: _message, confirmLabel: _confirm);

bool _isShowing() => find.text(_message).evaluate().isNotEmpty;

void main() {
  final feature = BddFeature('showPlatformDestructiveConfirm');

  Bdd(feature)
      .scenario('answers whether the person confirmed')
      .runOutlineWidgets<({String button, bool answer})>(
        examples: {
          'when confirmed': (button: _confirm, answer: true),
          'when cancelled': (button: 'Cancel', answer: false),
        },
        outline: (tester, row) async {
          final context = await pumpForContext(tester);
          final answerFuture = _show(context);
          await pumpTransition(tester);

          await tester.tap(find.text(row.button));
          await pumpTransition(tester);

          check(_isShowing()).isFalse();
          check(await answerFuture).equals(row.answer);
        },
      );

  Bdd(feature).scenario('answers no when closed from outside').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    final answerFuture = _show(context);
    await pumpTransition(tester);
    check(_isShowing()).isTrue();

    await tester.tapAt(const Offset(4, 4));
    await pumpTransition(tester);

    check(_isShowing()).isFalse();
    check(await answerFuture).isFalse();
  });

  Bdd(feature).scenario('marks the confirming button as destructive').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    unawaited(_show(context));
    await pumpTransition(tester);

    check(argbOf(labelStyle(tester, _confirm))).equals(destructiveArgbOf(context));
  });
}
