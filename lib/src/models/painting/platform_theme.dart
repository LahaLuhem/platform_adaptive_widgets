import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTheme;
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Provides access to platform-specific theme colors.
final class PlatformTheme {
  /// The build context to use for retrieving theme data.
  final BuildContext context;

  /// Creates a [PlatformTheme] with the given [context].
  const PlatformTheme.of(this.context);

  /// The background color of the app bar.
  Color get barBackgroundColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).appBarTheme.backgroundColor ?? const Color(0x00000000),
    .iOS => CupertinoTheme.of(context).barBackgroundColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// The primary color of the theme.
  Color get primaryColor => switch (defaultTargetPlatform) {
    .android => Theme.of(context).primaryColor,
    .iOS => CupertinoTheme.of(context).primaryColor,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };

  /// A color that contrasts with the primary color.
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
