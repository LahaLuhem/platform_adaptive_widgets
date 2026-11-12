import 'dart:async';
import 'dart:math' as math;

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoButton,
        CupertinoDynamicColor,
        CupertinoTextThemeData,
        CupertinoThemeData,
        kMinInteractiveDimensionCupertino;
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _page = SizedBox.expand(key: Key('page'));
const _message = 'Deleted';
const _duration = Duration(seconds: 2);
const _family = 'AppFont';

Future<BuildContext> _pumpPage(WidgetTester tester, {CupertinoThemeData? cupertinoTheme}) async {
  await tester.pumpWidget(
    PlatformApp(
      cupertinoAppData: CupertinoAppData(theme: cupertinoTheme),
      home: const PlatformScaffold(body: _page),
    ),
  );

  return tester.element(find.byWidget(_page));
}

void _show(
  BuildContext context, {
  String message = _message,
  VoidCallback? onUndo,
  CupertinoToastData cupertinoToastData = const CupertinoToastData(),
}) => unawaited(
  showPlatformToast(
    context: context,
    message: message,
    duration: _duration,
    action: onUndo == null ? null : PlatformToastAction(label: 'Undo', onPressed: onUndo),
    cupertinoToastData: cupertinoToastData,
  ),
);

bool _isShowing() => find.text(_message).evaluate().isNotEmpty;

double _bannerHeight(WidgetTester tester, String message) => tester
    .getSize(find.ancestor(of: find.text(message), matching: find.byType(BackdropFilter)).first)
    .height;

void main() {
  final feature = BddFeature('showPlatformToast');

  Bdd(feature)
      .scenario('runs its action and closes when the action is tapped')
      .runWidgets((tester) async {
        var isUndone = false;
        final context = await _pumpPage(tester);

        _show(context, onUndo: () => isUndone = true);
        await pumpTransition(tester);
        await tester.tap(find.text('Undo'));
        await pumpTransition(tester);

        check(isUndone).isTrue();
        check(_isShowing()).isFalse();
      });

  // Material's SnackBarAction takes only the first tap by itself.
  Bdd(feature)
      .scenario('runs its action once, however fast it is tapped')
      .runWidgets((tester) async {
        var undoCount = 0;
        final context = await _pumpPage(tester);

        _show(context, onUndo: () => undoCount++);
        await pumpTransition(tester);
        await tester.tap(find.text('Undo'));
        await tester.pump();
        await tester.tap(find.text('Undo'));
        await pumpTransition(tester);

        check(undoCount).equals(1);
      }, variant: iosOnly);

  // Material's SnackBar stays up by itself while it has an action.
  Bdd(feature)
      .scenario('stays up past its duration while it has an action')
      .runWidgets((tester) async {
        final context = await _pumpPage(tester);

        _show(context, onUndo: noop);
        await pumpTransition(tester);
        await tester.pump(_duration * 3);
        await pumpTransition(tester);

        check(_isShowing()).isTrue();
      }, variant: iosOnly);

  // The padding goes inside the action, not above and below it.
  Bdd(feature).scenario('grows to 44pt with an action, and no taller').runWidgets((tester) async {
    final context = await _pumpPage(tester);

    _show(context);
    await pumpTransition(tester);
    final heightAlone = _bannerHeight(tester, _message);
    await pumpThrough(tester, _duration + const Duration(seconds: 1));

    _show(context, onUndo: noop);
    await pumpTransition(tester);

    check(_bannerHeight(tester, _message))
        .equals(math.max(heightAlone, kMinInteractiveDimensionCupertino));
  }, variant: iosOnly);

  Bdd(feature)
      .scenario('takes taps on its action across its full height')
      .runWidgets((tester) async {
        // Long enough to wrap, so the message sets the banner's height rather than the action.
        const message = 'Deleted 3 messages from the conversation with the support team';
        final context = await _pumpPage(tester);

        _show(context, message: message, onUndo: noop);
        await pumpTransition(tester);

        final action = find.ancestor(of: find.text('Undo'), matching: find.byType(CupertinoButton));
        check(tester.getSize(action).height).equals(_bannerHeight(tester, message));
      }, variant: iosOnly);

  // Up just before its duration, gone soon after, so a wrong duration fails either way.
  Bdd(feature).scenario('leaves after its duration without an action').runWidgets((tester) async {
    final context = await _pumpPage(tester);

    _show(context);
    await pumpThrough(tester, _duration - const Duration(milliseconds: 100));
    check(_isShowing()).isTrue();

    await pumpThrough(tester, const Duration(seconds: 1));
    check(_isShowing()).isFalse();
  });

  // Material's SnackBar marks itself a live region.
  Bdd(feature).scenario('is read out by screen readers').runWidgets((tester) async {
    final semantics = tester.ensureSemantics();
    final context = await _pumpPage(tester);

    _show(context);
    await pumpTransition(tester);
    // The read-out happens in the engine, so the flag that triggers it is all a test can see.
    SemanticsNode? node = tester.getSemantics(find.text(_message));
    while (node != null && !node.getSemanticsData().flagsCollection.isLiveRegion) {
      node = node.parent;
    }
    final isReadOut = node != null;
    semantics.dispose();

    check(isReadOut).isTrue();
  }, variant: iosOnly);

  // M3's SnackBar takes the theme's font by itself.
  Bdd(feature).scenario("writes its message in the theme's font").runWidgets((tester) async {
    final context = await _pumpPage(
      tester,
      cupertinoTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: _family)),
      ),
    );

    _show(context);
    await pumpTransition(tester);

    check(labelStyle(tester, _message).fontFamily).equals(_family);
  }, variant: iosOnly);

  Bdd(feature)
      .scenario('keeps its colour when its text style only sets a font')
      .runWidgets((tester) async {
        final context = await _pumpPage(tester);

        _show(
          context,
          cupertinoToastData: const CupertinoToastData(textStyle: TextStyle(fontFamily: _family)),
        );
        await pumpTransition(tester);

        final style = labelStyle(tester, _message);
        final bannerColor = CupertinoDynamicColor.resolve(
          const CupertinoToastData().foregroundColor,
          tester.element(find.text(_message)),
        );
        check(style.fontFamily).equals(_family);
        check(style.color?.toARGB32()).equals(bannerColor.toARGB32());
      }, variant: iosOnly);
}
