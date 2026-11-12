import 'dart:async';
import 'dart:ui' show Brightness, SemanticsAction;

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoDynamicColor, kCupertinoModalBarrierColor;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _text = 'Sheet';
const _contentKey = Key('content');
const _contentHeight = 200.0;
const _content = SizedBox(key: _contentKey, height: _contentHeight, child: Text(_text));
const _pageKey = Key('page');
const _tint = Color(0xFF123456);

// A full-size page, so a sheet that moves or shrinks it shows.
Future<BuildContext> _pumpPage(WidgetTester tester) async {
  await pumpPlatformWidget(tester, const SizedBox.expand(key: _pageKey));

  return tester.element(find.byKey(_pageKey));
}

Future<void> _show(
  BuildContext context, {
  Widget content = _content,
  Color? barrierColor,
  bool barrierDismissible = true,
}) => showPlatformRawModalBottomSheet<void>(
  context: context,
  builder: (_) => content,
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible,
);

bool _isUp() => find.text(_text).evaluate().isNotEmpty;

Future<void> _dragDown(WidgetTester tester) async {
  await tester.drag(find.text(_text), const Offset(0, 300));
  await pumpTransition(tester);
}

Color? _barrierColor(WidgetTester tester) =>
    tester.widget<ModalBarrier>(find.byType(ModalBarrier).last).color;

void main() {
  final feature = BddFeature('showPlatformRawModalBottomSheet');

  Bdd(feature)
      .scenario('closes on a tap outside only when barrierDismissible allows it')
      .runOutlineWidgets<bool>(
        examples: {'dismissible': true, 'not dismissible': false},
        outline: (tester, barrierDismissible) async {
          unawaited(_show(await _pumpPage(tester), barrierDismissible: barrierDismissible));
          await pumpTransition(tester);
          check(_isUp()).isTrue();

          await tester.tapAt(const Offset(4, 4));
          await pumpTransition(tester);

          check(_isUp()).equals(!barrierDismissible);
        },
      );

  // Material's sheet drags by itself, through enableDrag.
  Bdd(feature)
      .scenario('closes on a drag down, whatever barrierDismissible says')
      .runOutlineWidgets<bool>(
        examples: {'dismissible': true, 'not dismissible': false},
        outline: (tester, barrierDismissible) async {
          unawaited(_show(await _pumpPage(tester), barrierDismissible: barrierDismissible));
          await pumpTransition(tester);
          check(_isUp()).isTrue();

          await _dragDown(tester);

          check(_isUp()).isFalse();
        },
        variant: iosOnly,
      );

  Bdd(feature)
      .scenario("asks the content's PopScope before a drag closes it")
      .runWidgets((tester) async {
        var attempts = 0;
        unawaited(
          _show(
            await _pumpPage(tester),
            content: PopScope<void>(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) attempts++;
              },
              child: _content,
            ),
          ),
        );
        await pumpTransition(tester);

        await _dragDown(tester);

        check(_isUp()).isTrue();
        check(attempts).equals(1);
      }, variant: iosOnly);

  Bdd(feature).scenario('closes when a screen reader dismisses it').runWidgets((tester) async {
    final semantics = tester.ensureSemantics();
    unawaited(_show(await _pumpPage(tester)));
    await pumpTransition(tester);

    tester.semantics.performAction(
      find.semantics.byAction(SemanticsAction.dismiss),
      SemanticsAction.dismiss,
    );
    await pumpTransition(tester);

    check(_isUp()).isFalse();
    semantics.dispose();
  });

  Bdd(feature).scenario('sits at the bottom, as tall as its content').runWidgets((tester) async {
    unawaited(_show(await _pumpPage(tester)));
    await pumpTransition(tester);

    final content = tester.getRect(find.byKey(_contentKey));
    check(content.bottom).equals(tester.getSize(find.byKey(_pageKey)).height);
    check(content.height).equals(_contentHeight);
  }, variant: iosOnly);

  Bdd(feature).scenario('leaves the page behind in place').runWidgets((tester) async {
    final context = await _pumpPage(tester);
    final page = tester.getRect(find.byKey(_pageKey));
    unawaited(_show(context));
    await pumpTransition(tester);

    check(tester.getRect(find.byKey(_pageKey))).equals(page);
  }, variant: iosOnly);

  Bdd(feature).scenario('tints the barrier with barrierColor').runWidgets((tester) async {
    unawaited(_show(await _pumpPage(tester), barrierColor: _tint));
    await pumpTransition(tester);

    check(_barrierColor(tester)).equals(_tint);
  });

  Bdd(feature).scenario('dims with the dark barrier in dark mode').runWidgets((tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final context = await _pumpPage(tester);
    final dark = CupertinoDynamicColor.resolve(kCupertinoModalBarrierColor, context).toARGB32();
    check(
      because: 'dark mode took',
      dark,
    ).not((it) => it.equals(kCupertinoModalBarrierColor.toARGB32()));
    unawaited(_show(context));
    await pumpTransition(tester);

    check(_barrierColor(tester)?.toARGB32()).equals(dark);
  }, variant: iosOnly);
}
