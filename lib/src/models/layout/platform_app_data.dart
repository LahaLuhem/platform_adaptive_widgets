// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ScaffoldMessengerState, ThemeData, ThemeMode, kThemeAnimationDuration;

/// Default value for `showPerformanceOverlay in app data classes.
const kDefaultShowPerformanceOverlay = false;

/// Default value for `checkerboardRasterCacheImages in app data classes.
const kDefaultCheckerboardRasterCacheImages = false;

/// Default value for `checkerboardOffscreenLayers in app data classes.
const kDefaultCheckerboardOffscreenLayers = false;

/// Default value for `showSemanticsDebugger in app data classes.
const kDefaultShowSemanticsDebugger = false;

/// Default value for `debugShowCheckedModeBanner in app data classes.
const kDefaultDebugShowCheckedModeBanner = true;

/// Default value for `supportedLocales in app data classes.
const kDefaultSupportedLocales = [Locale('en', 'US')];

/// Default Material theme animation duration.
const kMaterialDefaultThemeAnimationDuration = kThemeAnimationDuration;

/// Default Material theme animation curve.
const kMaterialDefaultThemeAnimationCurve = Curves.linear;

/// Default value for `debugShowMaterialGrid in Material app data.
const kDebugShowMaterialGrid = false;

// Common base for both regular and router apps
abstract final class _PlatformAppData {
  /// A key to identify the top-level widget of the app.
  final Key? widgetKey;

  /// A one-line description of the app for the OS.
  final String? title;

  /// A callback to generate the app's title.
  final GenerateAppTitle? onGenerateTitle;

  /// The primary color to use for the application in the OS interface.
  final Color? color;

  /// The initial locale for the app.
  final Locale? locale;

  /// The delegates for this app's Localizations widget.
  // Signature matching
  // ignore: avoid-dynamic
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// A callback that is used to resolve the locale when the user changes it.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// A callback that is used to resolve the locale when the app is starting.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The list of locales that this app has been localized for.
  final Iterable<Locale>? supportedLocales;

  /// Whether to show the performance overlay.
  final bool? showPerformanceOverlay;

  /// Whether to checkerboard raster cache images.
  final bool? checkerboardRasterCacheImages;

  /// Whether to checkerboard layers rendered to offscreen bitmaps.
  final bool? checkerboardOffscreenLayers;

  /// Whether to show the semantics debugger.
  final bool? showSemanticsDebugger;

  /// Whether to show a "DEBUG" banner.
  final bool? debugShowCheckedModeBanner;

  /// The default map of keyboard shortcuts.
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// The default map of actions.
  final Map<Type, Action<Intent>>? actions;

  /// The restoration scope ID for the app.
  final String? restorationScopeId;

  /// The default scroll behavior for the app.
  final ScrollBehavior? scrollBehavior;

  /// A builder for the app's content.
  final TransitionBuilder? builder;

  /// A callback to listen for navigation notifications.
  final bool Function(NavigationNotification)? onNavigationNotification;

  /// Creates a [_PlatformAppData].
  const _PlatformAppData({
    this.widgetKey,
    this.title,
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales,
    this.showPerformanceOverlay,
    this.checkerboardRasterCacheImages,
    this.checkerboardOffscreenLayers,
    this.showSemanticsDebugger,
    this.debugShowCheckedModeBanner,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.builder,
    this.onNavigationNotification,
  });
}

/// Configuration for a regular (non-router) platform app.
///
/// Contains navigator-based routing properties shared by Material and Cupertino apps.
final class AppData extends _PlatformAppData {
  /// Global key for the navigator state.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Home widget of the app.
  final Widget? home;

  /// Named routes for the app.
  final Map<String, WidgetBuilder>? routes;

  /// Initial route name.
  final String? initialRoute;

  /// Route factory for generating routes.
  final RouteFactory? onGenerateRoute;

  /// Factory for generating initial routes.
  // Signature matching
  // ignore: avoid-dynamic
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;

  /// Route factory for unknown routes.
  final RouteFactory? onUnknownRoute;

  /// List of navigator observers.
  final List<NavigatorObserver>? navigatorObservers;

  /// Default value for [navigatorObservers].
  static const kDefaultNavigationObservers = <NavigatorObserver>[];

  /// Default value for [routes].
  static const kDefaultAppRoutes = <String, WidgetBuilder>{};

  /// Creates regular app configuration.
  const AppData({
    super.widgetKey,
    super.title,
    super.onGenerateTitle,
    super.color,
    super.locale,
    super.localizationsDelegates,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.supportedLocales,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.restorationScopeId,
    super.scrollBehavior,
    super.builder,
    super.onNavigationNotification,
    this.navigatorKey,
    this.home,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers,
  });
}

/// Platform-shared configuration for router-based apps.
///
/// Contains common properties used by both MaterialApp.router and CupertinoApp.router.
/// Use this class when using Flutter's declarative routing API.
final class PlatformAppRouterData extends _PlatformAppData {
  /// Provider for route information from the platform.
  final RouteInformationProvider? routeInformationProvider;

  /// Parser for converting route information to route configuration.
  final RouteInformationParser<Object>? routeInformationParser;

  /// Delegate for building the navigation stack.
  final RouterDelegate<Object>? routerDelegate;

  /// Configuration object for the router.
  final RouterConfig<Object>? routerConfig;

  /// Dispatcher for handling back button presses.
  final BackButtonDispatcher? backButtonDispatcher;

  /// List of observers for navigation events.
  final List<NavigatorObserver>? navigatorObservers;

  /// Creates platform router app configuration.
  const PlatformAppRouterData({
    super.widgetKey,
    super.title,
    super.onGenerateTitle,
    super.color,
    super.locale,
    super.localizationsDelegates,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.supportedLocales,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.restorationScopeId,
    super.scrollBehavior,
    super.builder,
    super.onNavigationNotification,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.navigatorObservers,
  });
}

/// Material-specific configuration for regular (non-router) apps.
///
/// Contains properties specific to MaterialApp for Android platforms.
/// Extends the base AppData with Material-only theme and scaffold configuration.
final class MaterialAppData extends AppData {
  /// Global key for the ScaffoldMessenger.
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

  /// Duration for theme transitions.
  final Duration? themeAnimationDuration;

  /// Animation curve for theme transitions.
  final Curve? themeAnimationCurve;

  /// Whether to show the Material design grid overlay.
  final bool? debugShowMaterialGrid;

  /// Animation style for theme transitions.
  final AnimationStyle? themeAnimationStyle;

  /// Creates Material-specific app configuration.
  ///
  /// Extends the base AppData with Material-only theme and styling properties.
  const MaterialAppData({
    super.widgetKey,
    super.navigatorKey,
    super.home,
    super.routes,
    super.initialRoute,
    super.onGenerateInitialRoutes,
    super.onGenerateRoute,
    super.onUnknownRoute,
    super.navigatorObservers,
    super.builder,
    super.title,
    super.onGenerateTitle,
    super.color,
    super.locale,
    super.localizationsDelegates,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.supportedLocales,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.onNavigationNotification,
    super.restorationScopeId,
    super.scrollBehavior,
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

/// Material-specific configuration for router-based apps.
///
/// Contains properties specific to MaterialApp.router for Android platforms.
/// Extends PlatformAppRouterData with Material-only theme and styling configuration.
final class MaterialAppRouterData extends PlatformAppRouterData {
  /// Global key for the ScaffoldMessenger.
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

  /// Duration for theme transitions.
  final Duration? themeAnimationDuration;

  /// Animation curve for theme transitions.
  final Curve? themeAnimationCurve;

  /// Whether to show the Material design grid overlay.
  final bool? debugShowMaterialGrid;

  /// Animation style for theme transitions.
  final AnimationStyle? themeAnimationStyle;

  /// Creates Material-specific router app configuration.
  ///
  /// Extends PlatformAppRouterData with Material-only theme and styling properties.
  const MaterialAppRouterData({
    super.widgetKey,
    super.title,
    super.onGenerateTitle,
    super.color,
    super.locale,
    super.localizationsDelegates,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.supportedLocales,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.restorationScopeId,
    super.scrollBehavior,
    super.builder,
    super.onNavigationNotification,
    super.routeInformationProvider,
    super.routeInformationParser,
    super.routerDelegate,
    super.routerConfig,
    super.backButtonDispatcher,
    super.navigatorObservers,
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

/// Cupertino-specific configuration for regular (non-router) apps.
///
/// Contains properties specific to CupertinoApp for iOS platforms.
/// Extends the base AppData with Cupertino-only theme configuration.
final class CupertinoAppData extends AppData {
  /// The theme data for the app.
  final CupertinoThemeData? theme;

  /// Creates Cupertino-specific app configuration.
  ///
  /// Extends the base AppData with Cupertino-only theme properties.
  const CupertinoAppData({
    super.widgetKey,
    super.navigatorKey,
    super.home,
    super.routes,
    super.initialRoute,
    super.onGenerateInitialRoutes,
    super.onGenerateRoute,
    super.onUnknownRoute,
    super.navigatorObservers,
    super.builder,
    super.title,
    super.onGenerateTitle,
    super.color,
    super.locale,
    super.localizationsDelegates,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.supportedLocales,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.onNavigationNotification,
    super.restorationScopeId,
    super.scrollBehavior,
    this.theme,
  });
}

/// Cupertino-specific configuration for router-based apps.
///
/// Contains properties specific to CupertinoApp.router for iOS platforms.
/// Extends PlatformAppRouterData with Cupertino-only theme configuration.
final class CupertinoAppRouterData extends PlatformAppRouterData {
  /// The theme data for the app.
  final CupertinoThemeData? theme;

  /// Creates Cupertino-specific router app configuration.
  ///
  /// Extends PlatformAppRouterData with Cupertino-only theme properties.
  const CupertinoAppRouterData({
    super.widgetKey,
    super.title,
    super.onGenerateTitle,
    super.color,
    super.locale,
    super.localizationsDelegates,
    super.localeListResolutionCallback,
    super.localeResolutionCallback,
    super.supportedLocales,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.restorationScopeId,
    super.scrollBehavior,
    super.builder,
    super.onNavigationNotification,
    super.routeInformationProvider,
    super.routeInformationParser,
    super.routerDelegate,
    super.routerConfig,
    super.backButtonDispatcher,
    super.navigatorObservers,
    this.theme,
  });
}
