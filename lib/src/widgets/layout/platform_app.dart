/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoApp;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp;

import '/src/models/layout/platform_app_data.dart';
import '/src/models/platform_widget_base.dart';

/// [MaterialApp] on Android, [CupertinoApp] on iOS.
///
/// Almost everything an app takes is the same on both platforms, so it all sits flat here. The theme
/// is the exception, [ThemeData] and [CupertinoThemeData] having nothing in common, and lives on [materialAppData]
/// / [cupertinoAppData].
///
/// The default constructor is for navigator routing, [PlatformApp.router] for the declarative router
/// API. They expose different fields on purpose, so the type system stops you mixing the 2.
///
/// Example:
/// {@example /example/lib/snippets/layout/platform_app.dart#platform_app}
class PlatformApp extends PlatformWidgetKeyedBase {
  /// A one-liner for the OS to show in the task switcher.
  final String? title;

  /// Builds [title] instead, when it needs localising.
  final GenerateAppTitle? onGenerateTitle;

  /// What the OS tints the app with, in the task switcher and the like.
  final Color? color;

  /// Overrides the device's own locale.
  final Locale? locale;

  /// Where the app's translations come from.
  // Signature matching
  // ignore: avoid-dynamic
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Picks a locale from the device's ordered preference list.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Picks a locale from just the top preference.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Which locales the app actually has translations for.
  final Iterable<Locale> supportedLocales;

  /// Debugging overlay, off by default.
  final bool showPerformanceOverlay;

  /// Debugging overlay, off by default.
  final bool checkerboardRasterCacheImages;

  /// Debugging overlay, off by default.
  final bool checkerboardOffscreenLayers;

  /// Debugging overlay, off by default.
  final bool showSemanticsDebugger;

  /// The "DEBUG" ribbon in the corner, on by default in debug builds.
  final bool debugShowCheckedModeBanner;

  /// App-wide key bindings.
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// What those bindings actually do.
  final Map<Type, Action<Intent>>? actions;

  /// Turns on state restoration for the whole app.
  final String? restorationScopeId;

  /// App-wide scroll physics and overscroll look.
  final ScrollBehavior? scrollBehavior;

  /// Wraps every route, for chrome that outlives navigation.
  final TransitionBuilder? builder;

  /// Hears `NavigationNotification`s on their way up.
  final bool Function(NavigationNotification)? onNavigationNotification;

  /// Navigator routing only, `null` on [PlatformApp.router].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The first screen. Navigator routing only.
  final Widget? home;

  /// Navigator routing only.
  final Map<String, WidgetBuilder> routes;

  /// Navigator routing only.
  final String? initialRoute;

  /// Builds routes [routes] doesn't name. Navigator routing only.
  final RouteFactory? onGenerateRoute;

  /// Builds the whole starting stack rather than one route. Navigator routing only.
  // Signature matching
  // ignore: avoid-dynamic
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;

  /// Last resort when nothing else matches. Navigator routing only.
  final RouteFactory? onUnknownRoute;

  /// Navigator routing only.
  final List<NavigatorObserver> navigatorObservers;

  /// Router routing only, `null` on the default constructor.
  final RouteInformationProvider? routeInformationProvider;

  /// Turns a URL into your own route configuration. Router routing only.
  final RouteInformationParser<Object>? routeInformationParser;

  /// Turns that configuration back into a stack of pages. Router routing only.
  final RouterDelegate<Object>? routerDelegate;

  /// Bundles the other router pieces into one. Router routing only.
  final RouterConfig<Object>? routerConfig;

  /// Router routing only.
  final BackButtonDispatcher? backButtonDispatcher;

  /// Material-branch overrides: themes, and the scaffold messenger key.
  final MaterialAppData? materialAppData;

  /// Cupertino-branch overrides: the theme.
  final CupertinoAppData? cupertinoAppData;

  /// Which of the 2 constructors ran, and so which upstream app gets built.
  final bool _useRouter;

  /// Creates an app on navigator routing.
  const new({
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
    this.navigatorKey,
    this.home,
    this.routes = const {},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const [],
    this.materialAppData,
    this.cupertinoAppData,
    super.widgetKey,
    super.key,
  }) : _useRouter = false,
       routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       routerConfig = null,
       backButtonDispatcher = null;

  /// Creates an app on the declarative router API.
  const new router({
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
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.materialAppData,
    this.cupertinoAppData,
    super.widgetKey,
    super.key,
  }) : _useRouter = true,
       navigatorKey = null,
       home = null,
       routes = const {},
       initialRoute = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = const [];

  @override
  MaterialApp buildMaterial(BuildContext context) => _useRouter
      ? .router(
          key: widgetKey,
          routeInformationProvider: routeInformationProvider,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          routerConfig: routerConfig,
          backButtonDispatcher: backButtonDispatcher,
          onNavigationNotification: onNavigationNotification,
          builder: builder,
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          actions: actions,
          restorationScopeId: restorationScopeId,
          scrollBehavior: scrollBehavior,
          scaffoldMessengerKey: materialAppData?.scaffoldMessengerKey,
          theme: materialAppData?.theme,
          darkTheme: materialAppData?.darkTheme,
          highContrastTheme: materialAppData?.highContrastTheme,
          highContrastDarkTheme: materialAppData?.highContrastDarkTheme,
          themeMode: materialAppData?.themeMode,
          themeAnimationDuration:
              materialAppData?.themeAnimationDuration ?? kMaterialDefaultThemeAnimationDuration,
          themeAnimationCurve:
              materialAppData?.themeAnimationCurve ?? kMaterialDefaultThemeAnimationCurve,
          debugShowMaterialGrid: materialAppData?.debugShowMaterialGrid ?? kDebugShowMaterialGrid,
          themeAnimationStyle: materialAppData?.themeAnimationStyle,
        )
      : MaterialApp(
          key: widgetKey,
          navigatorKey: navigatorKey,
          home: home,
          routes: routes,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onGenerateInitialRoutes: onGenerateInitialRoutes,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers: navigatorObservers,
          onNavigationNotification: onNavigationNotification,
          builder: builder,
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          actions: actions,
          restorationScopeId: restorationScopeId,
          scrollBehavior: scrollBehavior,
          scaffoldMessengerKey: materialAppData?.scaffoldMessengerKey,
          theme: materialAppData?.theme,
          darkTheme: materialAppData?.darkTheme,
          highContrastTheme: materialAppData?.highContrastTheme,
          highContrastDarkTheme: materialAppData?.highContrastDarkTheme,
          themeMode: materialAppData?.themeMode,
          themeAnimationDuration:
              materialAppData?.themeAnimationDuration ?? kMaterialDefaultThemeAnimationDuration,
          themeAnimationCurve:
              materialAppData?.themeAnimationCurve ?? kMaterialDefaultThemeAnimationCurve,
          debugShowMaterialGrid: materialAppData?.debugShowMaterialGrid ?? kDebugShowMaterialGrid,
          themeAnimationStyle: materialAppData?.themeAnimationStyle,
        );

  @override
  CupertinoApp buildCupertino(BuildContext context) => _useRouter
      ? .router(
          key: widgetKey,
          routeInformationProvider: routeInformationProvider,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          routerConfig: routerConfig,
          backButtonDispatcher: backButtonDispatcher,
          onNavigationNotification: onNavigationNotification,
          builder: builder,
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          actions: actions,
          restorationScopeId: restorationScopeId,
          scrollBehavior: scrollBehavior,
          theme: cupertinoAppData?.theme,
        )
      : CupertinoApp(
          key: widgetKey,
          navigatorKey: navigatorKey,
          home: home,
          routes: routes,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onGenerateInitialRoutes: onGenerateInitialRoutes,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers: navigatorObservers,
          onNavigationNotification: onNavigationNotification,
          builder: builder,
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          showSemanticsDebugger: showSemanticsDebugger,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          shortcuts: shortcuts,
          actions: actions,
          restorationScopeId: restorationScopeId,
          scrollBehavior: scrollBehavior,
          theme: cupertinoAppData?.theme,
        );
}
