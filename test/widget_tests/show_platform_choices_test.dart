import 'dart:async';

import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _save = PlatformChoice(value: 1, label: 'Save Draft', kind: .normal);
const _delete = PlatformChoice(value: 2, label: 'Delete Draft', kind: .delete);
const _keep = PlatformChoice(value: 3, label: 'Keep Editing', kind: .normal);
const _discard = PlatformChoice(value: 4, label: 'Discard Changes', kind: .discard);
const _choices = [_save, _delete, _keep, _discard];

const _tint = Color(0xFF123456);

Future<int?> _show(
  BuildContext context, {
  List<PlatformChoice<int>> choices = _choices,
  String? title,
  String? message,
  Color? barrierColor,
  ScrollController? scrollController,
}) => showPlatformChoices(
  context: context,
  choices: choices,
  title: title,
  message: message,
  barrierColor: barrierColor,
  scrollController: scrollController,
);

bool _isShowing(WidgetTester tester) => tester.any(find.text(_save.label));

double _top(WidgetTester tester, String label) => tester.getCenter(find.text(label)).dy;

List<String> _labelsTopDown(WidgetTester tester) =>
    [for (final choice in _choices) choice.label]
      ..sort((a, b) => _top(tester, a).compareTo(_top(tester, b)));

void main() {
  feature('showPlatformChoices', () {
    scenarioOutlineWidgets<PlatformChoice<int>>(
      'answers with the picked choice',
      examples: {'something harmless': _save, 'something destructive': _discard},
      outline: (tester, choice) async {
        final context = await pumpForContext(tester);
        final answer = _show(context);
        await tester.pumpAndSettle();

        await tester.tap(find.text(choice.label));
        await tester.pumpAndSettle();

        check(_isShowing(tester)).isFalse();
        check(await answer).equals(choice.value);
      },
    );

    scenarioOutlineWidgets<Future<void> Function(WidgetTester tester)>(
      'answers null when left without a pick',
      examples: {
        'by a tap outside': (tester) => tester.tapAt(const Offset(4, 4)),
        'by Escape': (tester) => tester.sendKeyEvent(LogicalKeyboardKey.escape),
      },
      outline: (tester, leave) async {
        final context = await pumpForContext(tester);
        final answer = _show(context);
        await tester.pumpAndSettle();
        check(_isShowing(tester)).isTrue();

        await leave(tester);
        await tester.pumpAndSettle();

        check(_isShowing(tester)).isFalse();
        check(await answer).isNull();
      },
    );

    scenarioWidgets('answers null on Cancel', (tester) async {
      final context = await pumpForContext(tester);
      final answer = _show(context);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      check(_isShowing(tester)).isFalse();
      check(await answer).isNull();
    }, variant: iosOnly);

    scenarioWidgets('puts delete and discard choices on top on iOS', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      check(_labelsTopDown(tester))
          .deepEquals([_delete.label, _discard.label, _save.label, _keep.label]);
    }, variant: iosOnly);

    scenarioWidgets("keeps the caller's order on Android", (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      check(_labelsTopDown(tester)).deepEquals([for (final choice in _choices) choice.label]);
    }, variant: androidOnly);

    scenarioWidgets('bolds Cancel on iOS', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      check(weightOf(labelStyle(tester, 'Cancel')))
          .isGreaterThan(weightOf(labelStyle(tester, _save.label)));
    }, variant: iosOnly);

    scenarioWidgets("labels Cancel in the app's language", (tester) async {
      await tester.pumpWidget(
        const PlatformApp(
          locale: Locale('de'),
          supportedLocales: [Locale('de')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: SizedBox(),
        ),
      );

      unawaited(_show(tester.element(find.byType(SizedBox))));
      await tester.pumpAndSettle();

      check(tester.any(find.text('Abbrechen'))).isTrue();
    }, variant: iosOnly);

    scenarioWidgets('shows no Cancel row on Android', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      check(_isShowing(tester)).isTrue();
      check(tester.any(find.text('Cancel'))).isFalse();
    }, variant: androidOnly);

    scenarioOutlineWidgets<({PlatformActionKind kind, bool isRed})>(
      'shows what each choice does on iOS',
      examples: {
        'something harmless stays plain': (kind: .normal, isRed: false),
        'a delete turns red': (kind: .delete, isRed: true),
        'a discard turns red': (kind: .discard, isRed: true),
      },
      outline: (tester, row) async {
        final context = await pumpForContext(tester);
        unawaited(
          _show(
            context,
            choices: [
              PlatformChoice(value: 1, label: 'Choice', kind: row.kind),
              _keep,
            ],
          ),
        );
        await tester.pumpAndSettle();

        final choice = labelStyle(tester, 'Choice');
        final cancel = labelStyle(tester, 'Cancel');
        check(argbOf(choice))
            .equals(row.isRed ? CupertinoColors.systemRed.color.toARGB32() : argbOf(cancel));
        // Only Cancel gets the bold look, which the HIG keeps off destructive buttons.
        check(weightOf(choice)).isLessThan(weightOf(cancel));
      },
      variant: iosOnly,
    );

    scenarioWidgets('keeps every choice plain on Material', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context));
      await tester.pumpAndSettle();

      final plain = labelStyle(tester, _save.label);
      for (final label in [_delete.label, _discard.label]) {
        check(argbOf(labelStyle(tester, label))).equals(argbOf(plain));
        check(weightOf(labelStyle(tester, label))).equals(weightOf(plain));
      }
    }, variant: androidOnly);

    scenarioWidgets('shows the title and message above the choices', (tester) async {
      const title = 'Draft';
      const message = 'Your edits will be lost.';
      final context = await pumpForContext(tester);
      unawaited(_show(context, title: title, message: message));
      await tester.pumpAndSettle();

      check(_top(tester, title)).isLessThan(_top(tester, message));
      for (final choice in _choices) {
        check(_top(tester, message)).isLessThan(_top(tester, choice.label));
      }
    });

    scenarioOutlineWidgets<List<PlatformChoice<int>>>(
      'refuses fewer than 2 choices',
      examples: {
        'none': [],
        'one': [_save],
      },
      outline: (tester, choices) async {
        final context = await pumpForContext(tester);

        check(() => _show(context, choices: choices)).throws<AssertionError>();
      },
    );

    scenarioWidgets('scrolls the choices with scrollController', (tester) async {
      final choices = [
        for (var value = 1; value <= 30; value++)
          PlatformChoice(value: value, label: 'Choice $value', kind: .normal),
      ];
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final context = await pumpForContext(tester);
      unawaited(_show(context, choices: choices, scrollController: controller));
      await tester.pumpAndSettle();
      check(tester.any(find.text('Choice 30').hitTestable())).isFalse();

      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pumpAndSettle();

      check(tester.any(find.text('Choice 30').hitTestable())).isTrue();
    });

    scenarioWidgets('tints the barrier with barrierColor', (tester) async {
      final context = await pumpForContext(tester);
      unawaited(_show(context, barrierColor: _tint));
      await tester.pumpAndSettle();

      check(tester.widget<ModalBarrier>(find.byType(ModalBarrier).last).color).equals(_tint);
    });
  });
}
