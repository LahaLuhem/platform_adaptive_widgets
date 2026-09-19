import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTheme;
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Pulls colours off whichever theme the current platform is running, so you don't reach for [Theme]
/// or [CupertinoTheme] by hand.
final class const PlatformTheme.of(final BuildContext context) {
  /// Creates a [PlatformTheme] with the given [context].
  this;

  /// Falls back to transparent on Android, where the app bar theme may leave it unset.
  Color get barBackgroundColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).appBarTheme.backgroundColor ?? const Color(0x00000000),
    .iOS => CupertinoTheme.of(context).barBackgroundColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// The theme's primary colour.
  Color get primaryColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).primaryColor,
    .iOS => CupertinoTheme.of(context).primaryColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// Reads against [primaryColor].
  Color get primaryContrastingColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).colorScheme.onPrimary,
    .iOS => CupertinoTheme.of(context).primaryContrastingColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// The background color of the scaffold.
  Color get scaffoldBackgroundColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).scaffoldBackgroundColor,
    .iOS => CupertinoTheme.of(context).scaffoldBackgroundColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// The color of the selection handles.
  Color get selectionHandleColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).colorScheme.onSurface,
    .iOS => CupertinoTheme.of(context).selectionHandleColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}
