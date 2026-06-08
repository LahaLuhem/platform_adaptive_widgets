import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/platform_adaptive_icons.dart';

/// Platform-adaptive **icon** helpers on [BuildContext].
///
/// Value selection (`platformValue`, `platformValueNullable`,
/// `platformLazyValue`, `platformLazyNullable`) lives in top-level functions in
/// `platform_value.dart` — those never needed a [BuildContext], so they are not
/// extension methods.
// Purely for name-spacing collisions
// ignore: prefer-match-file-name
extension PlatformAdaptiveContextExtensions on BuildContext {
  /// Render either a Material or Cupertino icon based on the platform
  PlatformAdaptiveIcons get platformAdaptiveIcons => PlatformAdaptiveIcons(this);

  /// Returns the platform-appropriate [IconData] — [material] on Android,
  /// [cupertino] on iOS.
  ///
  /// Dispatches with an inline `switch (defaultTargetPlatform)`, which
  /// const-folds and prunes the unused arm at AOT. [IconData] carries no
  /// platform-specific code, so there is no size cost and the [BuildContext]
  /// receiver is currently unused — kept for `context.platformIcon(...)`
  /// call-site ergonomics and forward-compatibility with theme-aware icons.
  IconData platformIcon({required IconData material, required IconData cupertino}) =>
      switch (defaultTargetPlatform) {
        .android => material,
        .iOS => cupertino,
        _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
      };
}
