// Named after what it tests, not after its helper enum.
// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

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
  PlatformConfirmKind kind = .discard,
  String confirmLabel = _confirm,
}) => showPlatformConfirm(
  context: context,
  title: _title,
  message: 'Your edits will be lost.',
  confirmLabel: confirmLabel,
  kind: kind,
);

bool _isShowing(WidgetTester tester) => tester.any(find.text(_title));

Offset _center(WidgetTester tester, String label) => tester.getCenter(find.text(label).last);

TextStyle _labelStyle(WidgetTester tester, String label) => tester
    .widget<RichText>(find.descendant(of: find.text(label).last, matching: find.byType(RichText)))
    .text
    .style!;

int _argb(TextStyle style) => style.color!.toARGB32();

int _weight(TextStyle style) => (style.fontWeight ?? FontWeight.normal).value;

void main() {
  feature('showPlatformConfirm', () {
    scenarioOutlineWidgets<({String button, bool answer})>(
      'answers whether the person confirmed',
      examples: {
        'when confirmed': (button: _confirm, answer: true),
        'when cancelled': (button: 'Cancel', answer: false),
      },
      outline: (tester, row) async {
        final context = await _pumpPage(tester);
        final answer = _show(context);
        await tester.pumpAndSettle();

        await tester.tap(find.text(row.button).last);
        await tester.pumpAndSettle();

        check(_isShowing(tester)).isFalse();
        check(await answer).equals(row.answer);
      },
    );

    scenarioWidgets('answers no when closed from outside', (tester) async {
      final context = await _pumpPage(tester);
      final answer = _show(context);
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      check(_isShowing(tester)).isFalse();
      check(await answer).isFalse();
    }, variant: androidOnly);

    scenarioWidgets('puts Cancel before the confirming button', (tester) async {
      final context = await _pumpPage(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      check(_center(tester, 'Cancel').dy).equals(_center(tester, _confirm).dy);
      check(_center(tester, 'Cancel').dx).isLessThan(_center(tester, _confirm).dx);
    });

    // Cupertino can't yet: its alert actions have no cancel role for the layout to place.
    scenarioWidgets('puts the confirming button above Cancel when they stack', (tester) async {
      const longConfirm = 'Discard All Unsaved Changes';
      tester.view
        ..physicalSize = const Size(390 * 3, 844 * 3)
        ..devicePixelRatio = 3;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final context = await _pumpPage(tester);

      unawaited(_show(context, confirmLabel: longConfirm));
      await tester.pumpAndSettle();

      check(_center(tester, 'Cancel').dy).isGreaterThan(_center(tester, longConfirm).dy);
    }, variant: androidOnly);

    scenarioWidgets("labels Cancel in the app's language", (tester) async {
      await tester.pumpWidget(
        const PlatformApp(
          locale: Locale('de'),
          supportedLocales: [Locale('de')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: PlatformScaffold(body: _page),
        ),
      );

      unawaited(_show(tester.element(find.byWidget(_page))));
      await tester.pumpAndSettle();

      check(tester.any(find.text(_confirm))).isTrue();
      check(tester.any(find.text('Abbrechen'))).isTrue();
    });

    scenarioOutlineWidgets<PlatformConfirmKind>(
      'keeps the confirming button as plain as Cancel on Material',
      examples: {
        'when it proceeds': .proceed,
        'when it deletes': .delete,
        'when it discards': .discard,
      },
      outline: (tester, kind) async {
        final context = await _pumpPage(tester);
        unawaited(_show(context, kind: kind));
        await tester.pumpAndSettle();

        final confirm = _labelStyle(tester, _confirm);
        final cancel = _labelStyle(tester, 'Cancel');
        check(_argb(confirm)).equals(_argb(cancel));
        check(_weight(confirm)).equals(_weight(cancel));
      },
      variant: androidOnly,
    );

    scenarioOutlineWidgets<({PlatformConfirmKind kind, _Look look})>(
      'shows what confirming does on Cupertino',
      examples: {
        'something harmless leads': (kind: .proceed, look: .primary),
        'a delete the person asked for stays plain': (kind: .delete, look: .plain),
        "a loss they didn't ask for turns red": (kind: .discard, look: .red),
      },
      outline: (tester, row) async {
        final context = await _pumpPage(tester);
        unawaited(_show(context, kind: row.kind));
        await tester.pumpAndSettle();

        final confirm = _labelStyle(tester, _confirm);
        final cancel = _labelStyle(tester, 'Cancel');
        switch (row.look) {
          case .plain:
            check(_argb(confirm)).equals(_argb(cancel));
            check(_weight(confirm)).equals(_weight(cancel));
          case .red:
            check(_argb(confirm)).equals(CupertinoColors.systemRed.color.toARGB32());
            // Never the primary look as well, which the HIG keeps off destructive buttons.
            check(_weight(confirm)).equals(_weight(cancel));
          case .primary:
            check(_weight(confirm)).isGreaterThan(_weight(cancel));
        }
      },
      variant: iosOnly,
    );
  });
}
