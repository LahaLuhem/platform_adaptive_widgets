import 'dart:async';
import 'dart:ui' show SemanticsAction;

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _save = PlatformChoice(value: 1, label: 'Save Draft', actionKind: .normal);
const _delete = PlatformChoice(value: 2, label: 'Delete Draft', actionKind: .delete);
const _keep = PlatformChoice(value: 3, label: 'Keep Editing', actionKind: .normal);
const _discard = PlatformChoice(value: 4, label: 'Discard Changes', actionKind: .discard);
const _choices = {_save, _delete, _keep, _discard};

const _tint = Color(0xFF123456);

Future<int?> _show(
  BuildContext context, {
  Set<PlatformChoice<int>> choices = _choices,
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

bool _isShowing() => find.text(_save.label).evaluate().isNotEmpty;

double _top(WidgetTester tester, String label) => tester.getCenter(find.text(label)).dy;

List<String> _labelsTopDown(WidgetTester tester) =>
    [for (final choice in _choices) choice.label]
      ..sort((a, b) => _top(tester, a).compareTo(_top(tester, b)));

void main() {
  final feature = BddFeature('showPlatformChoices');

  Bdd(feature)
      .scenario('answers with the picked choice')
      .runOutlineWidgets<PlatformChoice<int>>(
        examples: {'something harmless': _save, 'something destructive': _discard},
        outline: (tester, choice) async {
          final context = await pumpForContext(tester);
          final answerFuture = _show(context);
          await pumpTransition(tester);

          await tester.tap(find.text(choice.label));
          await pumpTransition(tester);

          check(_isShowing()).isFalse();
          check(await answerFuture).equals(choice.value);
        },
      );

  Bdd(feature).scenario('answers null when closed from outside').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    final answerFuture = _show(context);
    await pumpTransition(tester);
    check(_isShowing()).isTrue();

    await tester.tapAt(const Offset(4, 4));
    await pumpTransition(tester);

    check(_isShowing()).isFalse();
    check(await answerFuture).isNull();
  });

  Bdd(feature).scenario('answers null when a screen reader closes it').runWidgets((tester) async {
    final semantics = tester.ensureSemantics();
    final context = await pumpForContext(tester);
    final answerFuture = _show(context);
    await pumpTransition(tester);

    tester.semantics.performAction(
      find.semantics.byAction(SemanticsAction.dismiss),
      SemanticsAction.dismiss,
    );
    await pumpTransition(tester);

    check(_isShowing()).isFalse();
    check(await answerFuture).isNull();
    semantics.dispose();
  });

  Bdd(feature).scenario('answers null on Cancel').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    final answerFuture = _show(context);
    await pumpTransition(tester);

    await tester.tap(find.text('Cancel'));
    await pumpTransition(tester);

    check(_isShowing()).isFalse();
    check(await answerFuture).isNull();
  }, variant: iosOnly);

  Bdd(feature).scenario('puts delete and discard choices on top on iOS').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    unawaited(_show(context));
    await pumpTransition(tester);

    check(_labelsTopDown(tester))
        .deepEquals([_delete.label, _discard.label, _save.label, _keep.label]);
  }, variant: iosOnly);

  Bdd(feature).scenario("keeps the caller's order on Android").runWidgets((tester) async {
    final context = await pumpForContext(tester);
    unawaited(_show(context));
    await pumpTransition(tester);

    check(_labelsTopDown(tester)).deepEquals([for (final choice in _choices) choice.label]);
  }, variant: androidOnly);

  // German, so a hard-coded English Cancel can't pass.
  Bdd(feature).scenario("labels Cancel in the app's language").runWidgets((tester) async {
    await tester.pumpWidget(
      const PlatformApp(
        locale: Locale('de'),
        supportedLocales: [Locale('de')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: SizedBox(),
      ),
    );

    final context = tester.element(find.byType(SizedBox));
    unawaited(_show(context));
    await pumpTransition(tester);

    check(find.text(cancelLabel(context)).evaluate()).isNotEmpty();
  }, variant: iosOnly);

  Bdd(feature).scenario('shows no Cancel row on Android').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    unawaited(_show(context));
    await pumpTransition(tester);

    check(_isShowing()).isTrue();
    check(find.text('Cancel').evaluate()).isEmpty();
  }, variant: androidOnly);

  Bdd(feature)
      .scenario('shows what each choice does')
      .runOutlineWidgets<({PlatformActionKind actionKind, bool isRed})>(
        // A discard takes the delete's branch.
        examples: {
          'something harmless stays plain': (actionKind: .normal, isRed: false),
          'a delete turns red': (actionKind: .delete, isRed: true),
        },
        outline: (tester, row) async {
          final context = await pumpForContext(tester);
          unawaited(
            _show(
              context,
              choices: {
                PlatformChoice(value: 1, label: 'Choice', actionKind: row.actionKind),
                _keep,
              },
            ),
          );
          await pumpTransition(tester);

          check(argbOf(labelStyle(tester, 'Choice'))).equals(
            row.isRed ? destructiveArgbOf(context) : argbOf(labelStyle(tester, _keep.label)),
          );
        },
      );

  Bdd(feature).scenario('shows the title and message above the choices').runWidgets((tester) async {
    const title = 'Draft';
    const message = 'Your edits will be lost.';
    final context = await pumpForContext(tester);
    unawaited(_show(context, title: title, message: message));
    await pumpTransition(tester);

    check(_top(tester, title)).isLessThan(_top(tester, message));
    for (final choice in _choices) {
      check(_top(tester, message)).isLessThan(_top(tester, choice.label));
    }
  });

  Bdd(feature).scenario('refuses fewer than 2 choices').runWidgets((tester) async {
    final context = await pumpForContext(tester);

    check(() => _show(context, choices: {_save})).throws<AssertionError>();
  });

  Bdd(feature).scenario('refuses 2 choices with the same value').runWidgets((tester) async {
    final context = await pumpForContext(tester);

    check(
      () => _show(
        context,
        choices: {
          _save,
          PlatformChoice(value: _save.value, label: 'Keep Draft', actionKind: .normal),
        },
      ),
    ).throws<AssertionError>();
  });

  Bdd(feature).scenario('scrolls the choices with scrollController').runWidgets((tester) async {
    final choices = {
      for (var value = 1; value <= 30; value++)
        PlatformChoice(value: value, label: 'Choice $value', actionKind: .normal),
    };
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    final context = await pumpForContext(tester);
    unawaited(_show(context, choices: choices, scrollController: scrollController));
    await pumpTransition(tester);
    check(find.text('Choice 30').hitTestable().evaluate()).isEmpty();

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await pumpTransition(tester);

    check(find.text('Choice 30').hitTestable().evaluate()).isNotEmpty();
  });

  Bdd(feature).scenario('tints the barrier with barrierColor').runWidgets((tester) async {
    final context = await pumpForContext(tester);
    unawaited(_show(context, barrierColor: _tint));
    await pumpTransition(tester);

    check(tester.widget<ModalBarrier>(find.byType(ModalBarrier).last).color).equals(_tint);
  });
}
