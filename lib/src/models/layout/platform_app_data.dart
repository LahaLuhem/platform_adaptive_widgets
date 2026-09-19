// The ~26 fields shared by MaterialApp and CupertinoApp are functional
// (identity, routing, localization, callbacks), per APPENDIX#field-classification
// they live flat on the PlatformApp widget, single source of truth. Only the
// platform-divergent theme surface lives here: ThemeData and CupertinoThemeData
// are disjoint types, so theme is platform-only, not shared-visual.
// ignore_for_file: prefer-match-file-name

/// @docImport '/src/widgets/layout/platform_app.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ScaffoldMessengerState, ThemeData, ThemeMode, kThemeAnimationDuration;

/// Default value for `showPerformanceOverlay` on [PlatformApp] / [PlatformApp.router].
const kDefaultShowPerformanceOverlay = false;

/// Default value for `checkerboardRasterCacheImages` on [PlatformApp] / [PlatformApp.router].
const kDefaultCheckerboardRasterCacheImages = false;

/// Default value for `checkerboardOffscreenLayers` on [PlatformApp] / [PlatformApp.router].
const kDefaultCheckerboardOffscreenLayers = false;

/// Default value for `showSemanticsDebugger` on [PlatformApp] / [PlatformApp.router].
const kDefaultShowSemanticsDebugger = false;

/// Default value for `debugShowCheckedModeBanner` on [PlatformApp] / [PlatformApp.router].
const kDefaultDebugShowCheckedModeBanner = true;

/// Default value for `supportedLocales` on [PlatformApp] / [PlatformApp.router].
const kDefaultSupportedLocales = [Locale('en', 'US')];

/// Default value for [MaterialAppData.themeAnimationDuration].
const kMaterialDefaultThemeAnimationDuration = kThemeAnimationDuration;

/// Default value for [MaterialAppData.themeAnimationCurve].
const kMaterialDefaultThemeAnimationCurve = Curves.linear;

/// Default value for [MaterialAppData.debugShowMaterialGrid].
const kDebugShowMaterialGrid = false;

/// Material-side settings for [PlatformApp] and [PlatformApp.router]. The app surface proper (`title`,
/// `home`, `routes`, `locale`, `builder` and the rest) stays flat on the widget.
///
/// Thin, because almost nothing about an app is platform-specific. What's left is the theme, where [ThemeData]
/// and [CupertinoThemeData] share no ground at all, plus [scaffoldMessengerKey], which iOS has no use
/// for.
final class const MaterialAppData({
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,

  /// Used in light mode, and in dark mode too when [darkTheme] is left out.
  final ThemeData? theme,

  final ThemeData? darkTheme,

  final ThemeData? highContrastTheme,

  final ThemeData? highContrastDarkTheme,

  /// Light, dark, or follow the system.
  final ThemeMode? themeMode,

  /// How long a theme change takes to cross-fade.
  final Duration themeAnimationDuration = kMaterialDefaultThemeAnimationDuration,

  final Curve themeAnimationCurve = kMaterialDefaultThemeAnimationCurve,

  /// Paints the Material baseline grid over the app, for lining things up during development.
  final bool debugShowMaterialGrid = kDebugShowMaterialGrid,

  final AnimationStyle? themeAnimationStyle,
}) {
  /// Creates Material-side settings for [PlatformApp].
  this;
}

/// Cupertino-side settings for [PlatformApp] and [PlatformApp.router]. Just the theme, since the app
/// surface proper stays flat on the widget.
final class const CupertinoAppData({final CupertinoThemeData? theme}) {
  /// Creates Cupertino-side settings for [PlatformApp].
  this;
}
