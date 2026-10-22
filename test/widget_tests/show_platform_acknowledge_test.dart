import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _title = 'Saved';
const _message = 'Saved to your library.';
const _icon = Icons.check_circle;

void main() {
  feature('showPlatformAcknowledge', () {
    scenarioWidgets('keeps an untitled message as far from the top as from the side on Android', (
      tester,
    ) async {
      final context = await pumpForContext(tester);
      unawaited(showPlatformAcknowledge(context: context, message: _message));
      await tester.pumpAndSettle();

      final insets = messageInsets(tester, _message);
      check(insets.top).equals(insets.side);
    }, variant: androidOnly);

    // M3 tucks the message closer under a headline or an icon than the dialog's own padding.
    scenarioOutlineWidgets<({String? title, MaterialAlertDialogData? data, Finder above})>(
      'keeps the message closer under what tops it than to the side on Android',
      examples: {
        'a title': (title: _title, data: null, above: find.text(_title)),
        'an icon': (
          title: null,
          data: const MaterialAlertDialogData(icon: Icon(_icon)),
          above: find.byIcon(_icon),
        ),
      },
      outline: (tester, row) async {
        final context = await pumpForContext(tester);
        unawaited(
          showPlatformAcknowledge(
            context: context,
            title: row.title,
            message: _message,
            materialAlertDialogData: row.data,
          ),
        );
        await tester.pumpAndSettle();

        final gapAbove = tester.getRect(find.text(_message)).top - tester.getRect(row.above).bottom;
        check(gapAbove).isLessThan(messageInsets(tester, _message).side);
      },
      variant: androidOnly,
    );
  });
}
