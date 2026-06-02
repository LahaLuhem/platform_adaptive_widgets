/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoApp;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp;

import '/src/models/layout/platform_app_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive app — [MaterialApp] on Android, [CupertinoApp] on iOS.
///
/// The two underlying apps share ~26 functional properties (`title`, `home`,
/// `routes`, `locale`, `builder`, navigator config, …). Per the package's
/// field-classification rule those are functional — they live flat on this
/// widget as the single source of truth, never duplicated into a per-platform
/// record. The only per-platform surface is the theme, since Material's
/// [ThemeData] and Cupertino's [CupertinoThemeData] are disjoint types: pass
/// [materialAppData] / [cupertinoAppData] for those.
///
/// Use the default constructor for navigator-based routing (`home`, `routes`,
/// `onGenerateRoute`, …). Use [PlatformApp.router] for Flutter's declarative
/// router API (`routerConfig`, `routerDelegate`, …) — the two constructors
/// expose disjoint routing surfaces, so the type system keeps you from mixing
/// navigator and router config.
///
/// Example:
/// ```dart
/// PlatformApp(
///   title: 'My App',
///   home: const MyHomePage(),
///   materialAppData: MaterialAppData(theme: myLightTheme, darkTheme: myDarkTheme),
///   cupertinoAppData: const CupertinoAppData(theme: myCupertinoTheme),
/// )
/// ```
class PlatformApp extends PlatformWidgetKeyedBase {
  /// A one-line description of the app for the OS.
  final String? title;

  /// A callback to generate the app's title.
  final GenerateAppTitle? onGenerateTitle;

  /// The primary color to use for the application in the OS interface.
  final Color? color;

  /// The initial locale for the app.
  final Locale? locale;

  /// The delegates for this app's `Localizations` widget.
  // Signature matching
  // ignore: avoid-dynamic
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// A callback used to resolve the locale when the device's locale changes.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// A callback used to resolve the locale when the app is starting.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The list of locales this app has been localized for. Defaults to
  /// [kDefaultSupportedLocales].
  final Iterable<Locale> supportedLocales;

  /// Whether to show the performance overlay. Defaults to
  /// [kDefaultShowPerformanceOverlay].
  final bool showPerformanceOverlay;

  /// Whether to checkerboard raster cache images. Defaults to
  /// [kDefaultCheckerboardRasterCacheImages].
  final bool checkerboardRasterCacheImages;

  /// Whether to checkerboard layers rendered to offscreen bitmaps. Defaults to
  /// [kDefaultCheckerboardOffscreenLayers].
  final bool checkerboardOffscreenLayers;

  /// Whether to show the semantics debugger. Defaults to
  /// [kDefaultShowSemanticsDebugger].
  final bool showSemanticsDebugger;

  /// Whether to show the "DEBUG" banner. Defaults to
  /// [kDefaultDebugShowCheckedModeBanner].
  final bool debugShowCheckedModeBanner;

  /// The default map of keyboard shortcuts.
  final Map<LogicalKeySet, Intent>? shortcuts;

  /// The default map of intent actions.
  final Map<Type, Action<Intent>>? actions;

  /// The restoration scope ID for the app.
  final String? restorationScopeId;

  /// The default scroll behavior for the app.
  final ScrollBehavior? scrollBehavior;

  /// A builder inserted above the app's content (e.g. for shared chrome).
  final TransitionBuilder? builder;

  /// A callback to listen for `NavigationNotification`s bubbling up.
  final bool Function(NavigationNotification)? onNavigationNotification;

  /// Global key for the navigator state. Navigator-routing only — `null` on
  /// [PlatformApp.router].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The home widget of the app. Navigator-routing only.
  final Widget? home;

  /// Named routes for the app. Navigator-routing only; defaults to `{}`.
  final Map<String, WidgetBuilder> routes;

  /// The initial route name. Navigator-routing only.
  final String? initialRoute;

  /// Route factory for generating routes. Navigator-routing only.
  final RouteFactory? onGenerateRoute;

  /// Factory for generating the initial route stack. Navigator-routing only.
  // Signature matching
  // ignore: avoid-dynamic
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;

  /// Route factory for unknown routes. Navigator-routing only.
  final RouteFactory? onUnknownRoute;

  /// Navigator observers. Navigator-routing only; defaults to `[]`.
  final List<NavigatorObserver> navigatorObservers;

  /// Provider for route information from the platform. Router-routing only —
  /// `null` on the default constructor.
  final RouteInformationProvider? routeInformationProvider;

  /// Parser converting route information to a route configuration.
  /// Router-routing only.
  final RouteInformationParser<Object>? routeInformationParser;

  /// Delegate building the navigation stack. Router-routing only.
  final RouterDelegate<Object>? routerDelegate;

  /// Configuration object bundling the router pieces. Router-routing only.
  final RouterConfig<Object>? routerConfig;

  /// Dispatcher for back-button presses. Router-routing only.
  final BackButtonDispatcher? backButtonDispatcher;

  /// Material-specific configuration (themes, `scaffoldMessengerKey`).
  final MaterialAppData? materialAppData;

  /// Cupertino-specific configuration (theme).
  final CupertinoAppData? cupertinoAppData;

  /// Discriminates [PlatformApp.router] from the default constructor — selects
  /// `MaterialApp.router` / `CupertinoApp.router` over their navigator forms.
  final bool _useRouter;

  /// Creates a platform-adaptive app using navigator-based routing.
  ///
  /// Renders [MaterialApp] on Android and [CupertinoApp] on iOS.
  const PlatformApp({
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

  /// Creates a platform-adaptive app using Flutter's declarative router API.
  ///
  /// Renders `MaterialApp.router` on Android and `CupertinoApp.router` on iOS.
  const PlatformApp.router({
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
