// The ~26 fields shared by MaterialApp and CupertinoApp are functional
// (identity, routing, localization, callbacks) — per APPENDIX#field-classification
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

/// Default value for `showPerformanceOverlay` on [PlatformApp] /
/// [PlatformApp.router].
const kDefaultShowPerformanceOverlay = false;

/// Default value for `checkerboardRasterCacheImages` on [PlatformApp] /
/// [PlatformApp.router].
const kDefaultCheckerboardRasterCacheImages = false;

/// Default value for `checkerboardOffscreenLayers` on [PlatformApp] /
/// [PlatformApp.router].
const kDefaultCheckerboardOffscreenLayers = false;

/// Default value for `showSemanticsDebugger` on [PlatformApp] /
/// [PlatformApp.router].
const kDefaultShowSemanticsDebugger = false;

/// Default value for `debugShowCheckedModeBanner` on [PlatformApp] /
/// [PlatformApp.router].
const kDefaultDebugShowCheckedModeBanner = true;

/// Default value for `supportedLocales` on [PlatformApp] / [PlatformApp.router].
const kDefaultSupportedLocales = [Locale('en', 'US')];

/// Default Material theme animation duration. Read by [MaterialAppData]'s
/// field default and substituted in [PlatformApp]'s Material build branch.
const kMaterialDefaultThemeAnimationDuration = kThemeAnimationDuration;

/// Default Material theme animation curve. Read by [MaterialAppData]'s field
/// default and substituted in [PlatformApp]'s Material build branch.
const kMaterialDefaultThemeAnimationCurve = Curves.linear;

/// Default value for [MaterialAppData.debugShowMaterialGrid].
const kDebugShowMaterialGrid = false;

/// Material-only configuration for [PlatformApp] / [PlatformApp.router].
///
/// The cross-platform app surface (`title`, `home`, `routes`, `locale`,
/// `builder`, …) is functional and lives flat on the [PlatformApp] widget. This
/// holds only what's Material-specific: the theme surface (Material's
/// [ThemeData], distinct from Cupertino's [CupertinoThemeData]) plus
/// [scaffoldMessengerKey] (no Cupertino equivalent).
final class MaterialAppData {
  /// Global key for the [ScaffoldMessengerState].
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// The theme data for the app in light mode.
  final ThemeData? theme;

  /// The theme data for the app in dark mode.
  final ThemeData? darkTheme;

  /// The theme data for high contrast light mode.
  final ThemeData? highContrastTheme;

  /// The theme data for high contrast dark mode.
  final ThemeData? highContrastDarkTheme;

  /// The theme mode to use (light, dark, or system).
  final ThemeMode? themeMode;

  /// Duration for theme transitions. Defaults to
  /// [kMaterialDefaultThemeAnimationDuration].
  final Duration themeAnimationDuration;

  /// Animation curve for theme transitions. Defaults to
  /// [kMaterialDefaultThemeAnimationCurve].
  final Curve themeAnimationCurve;

  /// Whether to show the Material design grid overlay. Defaults to
  /// [kDebugShowMaterialGrid].
  final bool debugShowMaterialGrid;

  /// Animation style for theme transitions.
  final AnimationStyle? themeAnimationStyle;

  /// Creates Material-only configuration for [PlatformApp].
  const MaterialAppData({
    this.scaffoldMessengerKey,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode,
    this.themeAnimationDuration = kMaterialDefaultThemeAnimationDuration,
    this.themeAnimationCurve = kMaterialDefaultThemeAnimationCurve,
    this.debugShowMaterialGrid = kDebugShowMaterialGrid,
    this.themeAnimationStyle,
  });
}

/// Cupertino-only configuration for [PlatformApp] / [PlatformApp.router].
///
/// Holds only the Cupertino [CupertinoThemeData]; the cross-platform app
/// surface is functional and lives flat on the [PlatformApp] widget.
final class CupertinoAppData {
  /// The theme data for the app.
  final CupertinoThemeData? theme;

  /// Creates Cupertino-only configuration for [PlatformApp].
  const CupertinoAppData({this.theme});
}
