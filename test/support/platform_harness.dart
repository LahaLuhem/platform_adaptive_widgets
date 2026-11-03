import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Runs a scenario twice, once as Android and once as iOS. The default for every scenario, because
/// a `PlatformXxx` widget renders a different subtree per platform, so a green Material run proves
/// nothing about Cupertino.
const bothPlatforms = TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS});

/// The Android half of [bothPlatforms].
const androidOnly = TargetPlatformVariant({TargetPlatform.android});

/// The iOS half of [bothPlatforms].
const iosOnly = TargetPlatformVariant({TargetPlatform.iOS});

/// Pumps [child] inside a [PlatformApp], which is the smallest ancestor that gives a `PlatformXxx`
/// widget its theme, directionality and media query. Call it again to drive a rebuild.
Future<void> pumpPlatformWidget(WidgetTester tester, Widget child) =>
    tester.pumpWidget(PlatformApp(home: child));

/// Pumps [child] inside a [PlatformScaffold], which most widgets need because the Material branch
/// looks for a Material ancestor. Use [pumpPlatformWidget] instead for a widget that is itself a
/// scaffold.
Future<void> pumpInPlatformScaffold(WidgetTester tester, Widget child) =>
    pumpPlatformWidget(tester, PlatformScaffold(body: child));

/// Pumps frame by frame through [duration], so timers fire and animations run on the way.
Future<void> pumpThrough(WidgetTester tester, Duration duration) async {
  const frame = Duration(milliseconds: 16);
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += frame) {
    await tester.pump(frame);
  }
}

/// Pumps through a second, which every transition here finishes in.
Future<void> pumpTransition(WidgetTester tester) => pumpThrough(tester, const Duration(seconds: 1));

/// Pumps a bare [PlatformApp] and hands back a context beneath it, for guards that sit on a
/// `showPlatformXxx` function rather than on a widget.
Future<BuildContext> pumpForContext(WidgetTester tester) async {
  await pumpPlatformWidget(tester, const SizedBox());

  return tester.element(find.byType(SizedBox));
}
