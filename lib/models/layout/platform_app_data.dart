// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart'
    show ScaffoldMessengerState, ThemeData, ThemeMode, kThemeAnimationDuration;
import 'package:flutter/widgets.dart';

const kDefaultShowPerformanceOverlay = false;
const kDefaultCheckerboardRasterCacheImages = false;
const kDefaultCheckerboardOffscreenLayers = false;
const kDefaultShowSemanticsDebugger = false;
const kDefaultDebugShowCheckedModeBanner = true;

const kDefaultSupportedLocales = [Locale('en', 'US')];

const kMaterialDefaultThemeAnimationDuration = kThemeAnimationDuration;
const kMaterialDefaultThemeAnimationCurve = Curves.linear;
const kDebugShowMaterialGrid = false;

// Common base for both regular and router apps
abstract final class _PlatformAppData {
  final Key? widgetKey;
  final String? title;
  final GenerateAppTitle? onGenerateTitle;
  final Color? color;
  final Locale? locale;
  // Signature matching
  // ignore: avoid-dynamic
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final TransitionBuilder? builder;
  final bool Function(NavigationNotification)? onNavigationNotification;

  const _PlatformAppData({
    this.widgetKey,
    this.title,
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = kDefaultSupportedLocales,
    this.showPerformanceOverlay = kDefaultShowPerformanceOverlay,
    this.checkerboardRasterCacheImages = kDefaultCheckerboardRasterCacheImages,
    this.checkerboardOffscreenLayers = kDefaultCheckerboardOffscreenLayers,
    this.showSemanticsDebugger = kDefaultShowSemanticsDebugger,
    this.debugShowCheckedModeBanner = kDefaultDebugShowCheckedModeBanner,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.builder,
    this.onNavigationNotification,
  });
}

// For regular (non-router) apps
final class AppData extends _PlatformAppData {
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  // Signature matching
  // ignore: avoid-dynamic
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;

  static const kDefaultNavigationObservers = <NavigatorObserver>[];
  static const kDefaultAppRoutes = <String, WidgetBuilder>{};

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
    this.routes = kDefaultAppRoutes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = kDefaultNavigationObservers,
  });
}

// For router-based apps
final class PlatformAppRouterData extends _PlatformAppData {
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final RouterConfig<Object>? routerConfig;
  final BackButtonDispatcher? backButtonDispatcher;
  final List<NavigatorObserver>? navigatorObservers;

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

// Regular Material App (non-router)
final class MaterialAppData extends AppData {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode? themeMode;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final bool debugShowMaterialGrid;
  final AnimationStyle? themeAnimationStyle;

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

// Router-based Material App
final class MaterialAppRouterData extends PlatformAppRouterData {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode? themeMode;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final bool debugShowMaterialGrid;
  final AnimationStyle? themeAnimationStyle;

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

// Regular Cupertino App (non-router)
final class CupertinoAppData extends AppData {
  final CupertinoThemeData? theme;

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

// Router-based Cupertino App
final class CupertinoAppRouterData extends PlatformAppRouterData {
  final CupertinoThemeData? theme;

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
