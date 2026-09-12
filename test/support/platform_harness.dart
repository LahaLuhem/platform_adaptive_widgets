import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Runs a scenario twice, once as Android and once as iOS. The default for every scenario, because
/// a `PlatformXxx` widget renders a different subtree per platform, so a green Android run proves
/// nothing about iOS.
const bothPlatforms = TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS});

/// For the rare scenario about one branch only, say a Material-only field with no iOS counterpart.
const androidOnly = TargetPlatformVariant({TargetPlatform.android});

/// The iOS half of [bothPlatforms].
const iosOnly = TargetPlatformVariant({TargetPlatform.iOS});

/// Pumps [child] inside a [PlatformApp], which is the smallest ancestor that gives a `PlatformXxx`
/// widget its theme, directionality and media query. Call it again to drive a rebuild.
Future<void> pumpPlatformWidget(WidgetTester tester, Widget child) =>
    tester.pumpWidget(PlatformApp(home: child));
