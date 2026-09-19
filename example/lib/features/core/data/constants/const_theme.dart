import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart' show Brightness, Color;
import 'package:material_ui/material_ui.dart' show ColorScheme, ThemeData;

/// One seed colour drives a Material 3 light and dark scheme plus a matching Cupertino theme, so the
/// demo looks designed on both platforms and the About tab's toggle has something to switch.
abstract final class ConstTheme {
  /// The brand seed. Everything else is derived from it.
  static const seedColor = Color(0xFF4F46E5);

  static final materialLightThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
  );

  static final materialDarkThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
  );

  /// `null` follows the device, which is what the `system` theme mode passes.
  static CupertinoThemeData cupertinoThemeData(Brightness? brightness) =>
      CupertinoThemeData(brightness: brightness, primaryColor: seedColor);
}
