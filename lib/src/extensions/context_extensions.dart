import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/platform_adaptive_icons.dart';

/// Icon helpers hung off [BuildContext]. The value selectors in `platform_value.dart` are top-level
/// functions instead, since they never needed a context.
// Purely for name-spacing collisions
// ignore: prefer-match-file-name
extension PlatformAdaptiveContextExtensions on BuildContext {
  /// The right icon set for the platform.
  PlatformAdaptiveIcons get platformAdaptiveIcons => PlatformAdaptiveIcons(this);

  /// [material] on Android, [cupertino] on iOS. Inlines its switch, so AOT prunes the losing arm, and
  /// [IconData] drags no platform code along anyway. The receiver goes unused today and is here for
  /// the call-site reads and for icons that may want the theme later.
  IconData platformIcon({required IconData material, required IconData cupertino}) =>
      switch (defaultTargetPlatform) {
        .android => material,
        .iOS => cupertino,
        _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
      };
}
