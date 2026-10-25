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

typedef _Look = ({double? size, FontWeight? weight, int argb});

// Not the whole style: printing a Cupertino colour after its alert closed throws.
_Look _lookOf(WidgetTester tester, String label) {
  final style = labelStyle(tester, label);

  return (size: style.fontSize, weight: style.fontWeight, argb: argbOf(style));
}

// How the title and the message are drawn in an alert that has both.
Future<({_Look title, _Look message})> _fullAlertLooks(
  WidgetTester tester,
  BuildContext context,
) async {
  unawaited(showPlatformAcknowledge(context: context, title: _title, message: _message));
  await tester.pumpAndSettle();
  final looks = (title: _lookOf(tester, _title), message: _lookOf(tester, _message));
  await tester.tap(find.text(kDefaultPlatformAcknowledgeOkLabel));
  await tester.pumpAndSettle();

  return looks;
}

Future<_Look> _loneTitleLook(WidgetTester tester, BuildContext context) async {
  unawaited(showPlatformAcknowledge(context: context, title: _title));
  await tester.pumpAndSettle();

  return _lookOf(tester, _title);
}

void main() {
  feature('showPlatformAcknowledge', () {
    scenarioWidgets('draws a lone title as the message on Android, which M3 requires', (
      tester,
    ) async {
      final context = await pumpForContext(tester);
      final looks = await _fullAlertLooks(tester, context);

      check(looks.title).not((it) => it.equals(looks.message));
      check(await _loneTitleLook(tester, context)).equals(looks.message);
    }, variant: androidOnly);

    scenarioWidgets('draws a lone title as the title on iOS, which the HIG requires', (
      tester,
    ) async {
      final context = await pumpForContext(tester);
      final looks = await _fullAlertLooks(tester, context);

      check(looks.title).not((it) => it.equals(looks.message));
      check(await _loneTitleLook(tester, context)).equals(looks.title);
    }, variant: iosOnly);

    scenarioWidgets('keeps a lone title as far from the top as from the side on Android', (
      tester,
    ) async {
      final context = await pumpForContext(tester);
      unawaited(showPlatformAcknowledge(context: context, title: _title));
      await tester.pumpAndSettle();

      final insets = messageInsets(tester, _title);
      check(insets.top).equals(insets.side);
    }, variant: androidOnly);

    // M3 tucks the text closer under a headline or an icon than the dialog's own padding.
    scenarioOutlineWidgets<
      ({String? message, MaterialAlertDialogData? data, Finder above, String text})
    >(
      'keeps the text closer under what tops it than to the side on Android',
      examples: {
        'a title': (message: _message, data: null, above: find.text(_title), text: _message),
        'an icon': (
          message: null,
          data: const MaterialAlertDialogData(icon: Icon(_icon)),
          above: find.byIcon(_icon),
          text: _title,
        ),
      },
      outline: (tester, row) async {
        final context = await pumpForContext(tester);
        unawaited(
          showPlatformAcknowledge(
            context: context,
            title: _title,
            message: row.message,
            materialAlertDialogData: row.data,
          ),
        );
        await tester.pumpAndSettle();

        final gapAbove = tester.getRect(find.text(row.text)).top - tester.getRect(row.above).bottom;
        check(gapAbove).isLessThan(messageInsets(tester, row.text).side);
      },
      variant: androidOnly,
    );
  });
}
