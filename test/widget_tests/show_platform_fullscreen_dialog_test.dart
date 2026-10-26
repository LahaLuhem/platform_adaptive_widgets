import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _bar = PlatformAppBar(title: Text('New event'));
const _body = SizedBox.expand(key: Key('body'));
const _statusBarHeight = 24.0;
const _save = 'Save';
const _saved = 'saved';

Future<String?> _open(BuildContext context) => showPlatformFullscreenDialog<String>(
  context: context,
  appBarBuilder: (_) => _bar,
  builder: (_) => _body,
);

Future<int> _seeThroughPixels(WidgetTester tester) async {
  final image = (await tester.runAsync(
    () => captureImage(tester.element(find.byType(PlatformApp))),
  ))!;
  final bytes = (await tester.runAsync(image.toByteData))!.buffer.asUint8List();
  image.dispose();

  var seeThrough = 0;
  // Raw RGBA, so alpha is every 4th byte.
  for (var alpha = 3; alpha < bytes.length; alpha += 4) {
    if (bytes[alpha] < 0xFF) seeThrough++;
  }

  return seeThrough;
}

void main() {
  feature('showPlatformFullscreenDialog', () {
    scenarioWidgets('covers the whole screen, status bar included', (tester) async {
      tester.view.padding = FakeViewPadding(top: _statusBarHeight * tester.view.devicePixelRatio);
      addTearDown(tester.view.reset);
      final context = await pumpForContext(tester);
      // The bare app paints nothing, so any spot the dialog misses stays see-through.
      check(await _seeThroughPixels(tester)).isGreaterThan(0);

      unawaited(_open(context));
      await tester.pumpAndSettle();

      check(await _seeThroughPixels(tester)).equals(0);
    });

    scenarioWidgets('slides up from the bottom', (tester) async {
      final context = await pumpForContext(tester);

      unawaited(_open(context));
      await tester.pump();
      // A pushed page spends its first frame offstage.
      final route = ModalRoute.of(tester.element(find.byWidget(_body, skipOffstage: false)))!;
      await tester.pump(route.transitionDuration ~/ 2);
      final midway = tester.getRect(find.byWidget(_body));
      await tester.pumpAndSettle();
      final settled = tester.getRect(find.byWidget(_body));

      // Straight up. An alert's zoom or a push from the side would move it sideways too.
      check(midway.left).equals(settled.left);
      check(midway.top).isGreaterThan(settled.top);
    }, variant: iosOnly);

    scenarioWidgets('opens as a full-screen dialog, so its bar shows close, not back', (
      tester,
    ) async {
      final context = await pumpForContext(tester);

      unawaited(_open(context));
      await tester.pumpAndSettle();

      // The flag both bars read, not the button, since what each bar draws is Flutter's call.
      check(ModalRoute.of(tester.element(find.byWidget(_body)))!.fullscreenDialog).isTrue();
    });

    scenarioOutlineWidgets<bool>(
      'closes with the value of a Save in its bar',
      examples: {'opened from the root navigator': false, 'opened from a nested one': true},
      outline: (tester, isNested) async {
        // go_router's tab branches are nested navigators, while the dialog goes on the root one.
        await pumpPlatformWidget(
          tester,
          isNested
              ? Navigator(
                  onGenerateRoute: (_) =>
                      PageRouteBuilder<void>(pageBuilder: (_, _, _) => const SizedBox()),
                )
              : const SizedBox(),
        );
        final result = showPlatformFullscreenDialog<String>(
          context: tester.element(find.byType(SizedBox).last),
          appBarBuilder: (context) => PlatformAppBar(
            primaryAction: PlatformBarAction(
              label: _save,
              onPressed: () => Navigator.maybeOf(context)?.pop(_saved),
            ),
          ),
          builder: (_) => _body,
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(_save));
        await tester.pumpAndSettle();

        // Closed first, or the result never comes.
        check(find.byWidget(_body).evaluate()).isEmpty();
        check(await result).equals(_saved);
      },
    );
  });
}
