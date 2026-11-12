// Named after what it tests, not after its helper enum.
// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _page = SizedBox.expand(key: Key('page'));
const _title = 'Discard changes?';
const _confirm = 'Discard';

enum _Look() {
  plain,
  red,
  primary,
}

Future<BuildContext> _pumpPage(WidgetTester tester) async {
  await pumpInPlatformScaffold(tester, _page);

  return tester.element(find.byWidget(_page));
}

Future<bool> _show(
  BuildContext context, {
  PlatformActionKind actionKind = .discard,
  String confirmLabel = _confirm,
}) => showPlatformConfirm(
  context: context,
  title: _title,
  message: 'Your edits will be lost.',
  confirmLabel: confirmLabel,
  actionKind: actionKind,
);

bool _isShowing() => find.text(_title).evaluate().isNotEmpty;

Offset _center(WidgetTester tester, String label) => tester.getCenter(find.text(label).last);

void main() {
  final feature = BddFeature('showPlatformConfirm');

  Bdd(feature)
      .scenario('answers whether the person confirmed')
      .runOutlineWidgets<({String button, bool answer})>(
        examples: {
          'when confirmed': (button: _confirm, answer: true),
          'when cancelled': (button: 'Cancel', answer: false),
        },
        outline: (tester, row) async {
          final context = await _pumpPage(tester);
          final answerFuture = _show(context);
          await pumpTransition(tester);

          await tester.tap(find.text(row.button).last);
          await pumpTransition(tester);

          check(_isShowing()).isFalse();
          check(await answerFuture).equals(row.answer);
        },
      );

  Bdd(feature).scenario('answers no when closed from outside').runWidgets((tester) async {
    final context = await _pumpPage(tester);
    final answerFuture = _show(context);
    await pumpTransition(tester);

    await tester.tapAt(const Offset(4, 4));
    await pumpTransition(tester);

    check(_isShowing()).isFalse();
    check(await answerFuture).isFalse();
  }, variant: androidOnly);

  Bdd(feature).scenario('puts Cancel before the confirming button').runWidgets((tester) async {
    final context = await _pumpPage(tester);
    unawaited(_show(context));
    await pumpTransition(tester);

    check(_center(tester, 'Cancel').dy).equals(_center(tester, _confirm).dy);
    check(_center(tester, 'Cancel').dx).isLessThan(_center(tester, _confirm).dx);
  });

  // Cupertino can't yet: its alert actions have no cancel role for the layout to place.
  Bdd(feature)
      .scenario('puts the confirming button above Cancel when they stack')
      .runWidgets((tester) async {
        const longConfirm = 'Discard All Unsaved Changes';
        tester.view
          ..physicalSize = const Size(390 * 3, 844 * 3)
          ..devicePixelRatio = 3;
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final context = await _pumpPage(tester);

        unawaited(_show(context, confirmLabel: longConfirm));
        await pumpTransition(tester);

        check(_center(tester, 'Cancel').dy).isGreaterThan(_center(tester, longConfirm).dy);
      }, variant: androidOnly);

  // German, so a hard-coded English Cancel can't pass.
  Bdd(feature).scenario("labels Cancel in the app's language").runWidgets((tester) async {
    await tester.pumpWidget(
      const PlatformApp(
        locale: Locale('de'),
        supportedLocales: [Locale('de')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: PlatformScaffold(body: _page),
      ),
    );

    final context = tester.element(find.byWidget(_page));
    unawaited(_show(context));
    await pumpTransition(tester);

    check(find.text(cancelLabel(context)).evaluate()).isNotEmpty();
  });

  Bdd(feature)
      .scenario('shows what confirming does on Material')
      .runOutlineWidgets<({PlatformActionKind actionKind, bool isRed})>(
        // Unlike Cupertino's alert, a delete the person asked for turns red too.
        examples: {
          'something harmless stays as plain as Cancel': (actionKind: .normal, isRed: false),
          'a delete turns red': (actionKind: .delete, isRed: true),
          'a discard turns red': (actionKind: .discard, isRed: true),
        },
        outline: (tester, row) async {
          final context = await _pumpPage(tester);
          unawaited(_show(context, actionKind: row.actionKind));
          await pumpTransition(tester);

          final confirmTextStyle = labelStyle(tester, _confirm);
          final cancelTextStyle = labelStyle(tester, 'Cancel');
          check(argbOf(confirmTextStyle))
              .equals(row.isRed ? destructiveArgbOf(context) : argbOf(cancelTextStyle));
          // M3 has no default action to bold.
          check(weightOf(confirmTextStyle)).equals(weightOf(cancelTextStyle));
        },
        variant: androidOnly,
      );

  Bdd(feature)
      .scenario('shows what confirming does on Cupertino')
      .runOutlineWidgets<({PlatformActionKind actionKind, _Look look})>(
        examples: {
          'something harmless leads': (actionKind: .normal, look: .primary),
          'a delete the person asked for stays plain': (actionKind: .delete, look: .plain),
          "a loss they didn't ask for turns red": (actionKind: .discard, look: .red),
        },
        outline: (tester, row) async {
          final context = await _pumpPage(tester);
          unawaited(_show(context, actionKind: row.actionKind));
          await pumpTransition(tester);

          final confirmTextStyle = labelStyle(tester, _confirm);
          final cancelTextStyle = labelStyle(tester, 'Cancel');
          switch (row.look) {
            case .plain:
              check(argbOf(confirmTextStyle)).equals(argbOf(cancelTextStyle));
              check(weightOf(confirmTextStyle)).equals(weightOf(cancelTextStyle));
            case .red:
              check(argbOf(confirmTextStyle)).equals(CupertinoColors.systemRed.color.toARGB32());
              // Never the primary look as well, which the HIG keeps off destructive buttons.
              check(weightOf(confirmTextStyle)).equals(weightOf(cancelTextStyle));
            case .primary:
              check(weightOf(confirmTextStyle)).isGreaterThan(weightOf(cancelTextStyle));
          }
        },
        variant: iosOnly,
      );
}
