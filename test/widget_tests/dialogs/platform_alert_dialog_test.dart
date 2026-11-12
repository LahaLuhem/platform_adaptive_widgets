import 'dart:async';

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_adaptive_widgets/src/widgets/dialogs/platform_destructive_confirm.dart';

import '../../support/support.dart';

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
  await pumpTransition(tester);
  final looks = (title: _lookOf(tester, _title), message: _lookOf(tester, _message));
  await tester.tap(find.text(kDefaultPlatformAcknowledgeOkLabel));
  await pumpTransition(tester);

  return looks;
}

Future<_Look> _loneTitleLook(WidgetTester tester, BuildContext context) async {
  unawaited(showPlatformAcknowledge(context: context, title: _title));
  await pumpTransition(tester);

  return _lookOf(tester, _title);
}

void main() {
  final feature = BddFeature('Platform alert dialog');

  Bdd(feature)
      .scenario('draws a lone title as the message on Android, which M3 requires')
      .runWidgets((tester) async {
        final context = await pumpForContext(tester);
        final looks = await _fullAlertLooks(tester, context);

        check(looks.title).not((it) => it.equals(looks.message));
        check(await _loneTitleLook(tester, context)).equals(looks.message);
      }, variant: androidOnly);

  Bdd(feature)
      .scenario('draws a lone title as the title on iOS, which the HIG requires')
      .runWidgets((tester) async {
        final context = await pumpForContext(tester);
        final looks = await _fullAlertLooks(tester, context);

        check(looks.title).not((it) => it.equals(looks.message));
        check(await _loneTitleLook(tester, context)).equals(looks.title);
      }, variant: iosOnly);

  // Upstream leaves 16 on top, M3 asks for 24.
  Bdd(feature)
      .scenario('keeps an untitled message as far from the top as from the side on Android')
      .runOutlineWidgets<Future<void> Function(BuildContext context)>(
        examples: {
          'in an acknowledgement': (context) =>
              showPlatformAcknowledge(context: context, title: _message),
          'in a destructive confirm': (context) => showPlatformDestructiveConfirm(
            context: context,
            message: _message,
            confirmLabel: 'Delete',
          ),
        },
        outline: (tester, show) async {
          unawaited(show(await pumpForContext(tester)));
          await pumpTransition(tester);

          final insets = messageInsets(tester, _message);
          check(insets.top).equals(insets.side);
        },
        variant: androidOnly,
      );

  // M3 tucks the text closer under a headline or an icon than the dialog's own padding.
  Bdd(feature)
      .scenario('keeps the text closer under what tops it than to the side on Android')
      .runOutlineWidgets<
        ({String? message, MaterialAlertDialogData data, Finder above, String text})
      >(
        examples: {
          'a title': (
            message: _message,
            data: const MaterialAlertDialogData(),
            above: find.text(_title),
            text: _message,
          ),
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
          await pumpTransition(tester);

          final gapAbove =
              tester.getRect(find.text(row.text)).top - tester.getRect(row.above).bottom;
          check(gapAbove).isLessThan(messageInsets(tester, row.text).side);
        },
        variant: androidOnly,
      );
}
