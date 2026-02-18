import 'package:flutter/cupertino.dart' show CupertinoApp;
import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';

import '/src/models/layout/platform_app_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive app widget that renders MaterialApp on Android
/// and CupertinoApp on iOS.
///
/// This widget automatically selects the appropriate app implementation based on the target platform:
/// - On Android: renders MaterialApp
/// - On iOS: renders CupertinoApp
///
/// The app can be configured with platform-specific data through [materialAppData]
/// and [cupertinoAppData], or with common properties through [appData].
///
/// Use the named constructor `PlatformApp.router` for apps using Flutter's router API.
///
/// Example:
/// ```dart
/// PlatformApp(
///   appData: AppData(
///     title: 'My App',
///     home: MyHomePage(),
///   ),
/// )
/// ```
class PlatformApp extends PlatformWidgetBase {
  /// Common app data that applies to both platforms.
  ///
  /// These properties will be used unless overridden by platform-specific data.
  final AppData? appData;

  /// Common router app data that applies to both platforms.
  ///
  /// These properties will be used unless overridden by platform-specific router data.
  final PlatformAppRouterData? appRouterData;

  /// Platform-specific data for MaterialApp.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on Android. See [MaterialAppData] for available options.
  final MaterialAppData? materialAppData;

  /// Platform-specific data for MaterialApp.router.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on Android with router. See [MaterialAppRouterData] for available options.
  final MaterialAppRouterData? materialAppRouterData;

  /// Platform-specific data for CupertinoApp.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on iOS. See [CupertinoAppData] for available options.
  final CupertinoAppData? cupertinoAppData;

  /// Platform-specific data for CupertinoApp.router.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on iOS with router. See [CupertinoAppRouterData] for available options.
  final CupertinoAppRouterData? cupertinoAppRouterData;

  /// Creates a platform-adaptive app.
  ///
  /// The app will render as a MaterialApp on Android and a CupertinoApp on iOS.
  /// Use [appData] for common properties, or override with platform-specific data.
  const PlatformApp({this.appData, this.materialAppData, this.cupertinoAppData, super.key})
    : appRouterData = null,
      materialAppRouterData = null,
      cupertinoAppRouterData = null;

  /// Creates a platform-adaptive app using Flutter's router API.
  ///
  /// The app will render as a MaterialApp.router on Android and a CupertinoApp.router on iOS.
  /// Use [appRouterData] for common properties, or override with platform-specific router data.
  const PlatformApp.router({
    this.appRouterData,
    this.materialAppRouterData = const MaterialAppRouterData(),
    this.cupertinoAppRouterData = const CupertinoAppRouterData(),
    super.key,
  }) : appData = null,
       materialAppData = null,
       cupertinoAppData = null;

  @override
  MaterialApp buildMaterial(BuildContext context) => materialAppRouterData != null
      ? .router(
          key: materialAppRouterData?.widgetKey ?? appRouterData?.widgetKey,
          routeInformationProvider:
              materialAppRouterData?.routeInformationProvider ??
              appRouterData?.routeInformationProvider,
          routeInformationParser:
              materialAppRouterData?.routeInformationParser ??
              appRouterData?.routeInformationParser,
          routerDelegate: materialAppRouterData?.routerDelegate ?? appRouterData?.routerDelegate,
          routerConfig: materialAppRouterData?.routerConfig ?? appRouterData?.routerConfig,
          backButtonDispatcher:
              materialAppRouterData?.backButtonDispatcher ?? appRouterData?.backButtonDispatcher,
          onNavigationNotification:
              materialAppRouterData?.onNavigationNotification ??
              appRouterData?.onNavigationNotification,
          builder: materialAppRouterData?.builder ?? appRouterData?.builder,
          title: materialAppRouterData?.title ?? appRouterData?.title,
          onGenerateTitle: materialAppRouterData?.onGenerateTitle ?? appRouterData?.onGenerateTitle,
          color: materialAppRouterData?.color ?? appRouterData?.color,
          locale: materialAppRouterData?.locale ?? appRouterData?.locale,
          localizationsDelegates:
              materialAppRouterData?.localizationsDelegates ??
              appRouterData?.localizationsDelegates,
          localeListResolutionCallback:
              materialAppRouterData?.localeListResolutionCallback ??
              appRouterData?.localeListResolutionCallback,
          localeResolutionCallback:
              materialAppRouterData?.localeResolutionCallback ??
              appRouterData?.localeResolutionCallback,
          supportedLocales:
              materialAppRouterData?.supportedLocales ??
              appRouterData?.supportedLocales ??
              kDefaultSupportedLocales,
          showPerformanceOverlay:
              materialAppRouterData?.showPerformanceOverlay ??
              appRouterData?.showPerformanceOverlay ??
              kDefaultShowPerformanceOverlay,
          checkerboardRasterCacheImages:
              materialAppRouterData?.checkerboardRasterCacheImages ??
              appRouterData?.checkerboardRasterCacheImages ??
              kDefaultCheckerboardRasterCacheImages,
          checkerboardOffscreenLayers:
              materialAppRouterData?.checkerboardOffscreenLayers ??
              appRouterData?.checkerboardOffscreenLayers ??
              kDefaultCheckerboardOffscreenLayers,
          showSemanticsDebugger:
              materialAppRouterData?.showSemanticsDebugger ??
              appRouterData?.showSemanticsDebugger ??
              kDefaultShowSemanticsDebugger,
          debugShowCheckedModeBanner:
              materialAppRouterData?.debugShowCheckedModeBanner ??
              appRouterData?.debugShowCheckedModeBanner ??
              kDefaultDebugShowCheckedModeBanner,
          shortcuts: materialAppRouterData?.shortcuts ?? appRouterData?.shortcuts,
          actions: materialAppRouterData?.actions ?? appRouterData?.actions,
          restorationScopeId:
              materialAppRouterData?.restorationScopeId ?? appRouterData?.restorationScopeId,
          scrollBehavior: materialAppRouterData?.scrollBehavior ?? appRouterData?.scrollBehavior,
          scaffoldMessengerKey: materialAppRouterData?.scaffoldMessengerKey,
          theme: materialAppRouterData?.theme,
          darkTheme: materialAppRouterData?.darkTheme,
          highContrastTheme: materialAppRouterData?.highContrastTheme,
          highContrastDarkTheme: materialAppRouterData?.highContrastDarkTheme,
          themeMode: materialAppRouterData?.themeMode,
          themeAnimationDuration:
              materialAppRouterData?.themeAnimationDuration ??
              kMaterialDefaultThemeAnimationDuration,
          themeAnimationCurve:
              materialAppRouterData?.themeAnimationCurve ?? kMaterialDefaultThemeAnimationCurve,
          debugShowMaterialGrid:
              materialAppRouterData?.debugShowMaterialGrid ?? kDebugShowMaterialGrid,
          themeAnimationStyle: materialAppRouterData?.themeAnimationStyle,
        )
      : MaterialApp(
          key: materialAppData?.widgetKey ?? appData?.widgetKey,
          navigatorKey: materialAppData?.navigatorKey ?? appData?.navigatorKey,
          home: materialAppData?.home ?? appData?.home,
          routes: materialAppData?.routes ?? appData?.routes ?? AppData.kDefaultAppRoutes,
          initialRoute: materialAppData?.initialRoute ?? appData?.initialRoute,
          onGenerateRoute: materialAppData?.onGenerateRoute ?? appData?.onGenerateRoute,
          onGenerateInitialRoutes:
              materialAppData?.onGenerateInitialRoutes ?? appData?.onGenerateInitialRoutes,
          onUnknownRoute: materialAppData?.onUnknownRoute ?? appData?.onUnknownRoute,
          navigatorObservers:
              materialAppData?.navigatorObservers ??
              appData?.navigatorObservers ??
              AppData.kDefaultNavigationObservers,
          onNavigationNotification:
              materialAppData?.onNavigationNotification ?? appData?.onNavigationNotification,
          builder: materialAppData?.builder ?? appData?.builder,
          title: materialAppData?.title ?? appData?.title,
          onGenerateTitle: materialAppData?.onGenerateTitle ?? appData?.onGenerateTitle,
          color: materialAppData?.color ?? appData?.color,
          locale: materialAppData?.locale ?? appData?.locale,
          localizationsDelegates:
              materialAppData?.localizationsDelegates ?? appData?.localizationsDelegates,
          localeListResolutionCallback:
              materialAppData?.localeListResolutionCallback ??
              appData?.localeListResolutionCallback,
          localeResolutionCallback:
              materialAppData?.localeResolutionCallback ?? appData?.localeResolutionCallback,
          supportedLocales:
              materialAppData?.supportedLocales ??
              appData?.supportedLocales ??
              kDefaultSupportedLocales,
          showPerformanceOverlay:
              materialAppData?.showPerformanceOverlay ??
              appData?.showPerformanceOverlay ??
              kDefaultShowPerformanceOverlay,
          checkerboardRasterCacheImages:
              materialAppData?.checkerboardRasterCacheImages ??
              appData?.checkerboardRasterCacheImages ??
              kDefaultCheckerboardRasterCacheImages,
          checkerboardOffscreenLayers:
              materialAppData?.checkerboardOffscreenLayers ??
              appData?.checkerboardOffscreenLayers ??
              kDefaultCheckerboardOffscreenLayers,
          showSemanticsDebugger:
              materialAppData?.showSemanticsDebugger ??
              appData?.showSemanticsDebugger ??
              kDefaultShowSemanticsDebugger,
          debugShowCheckedModeBanner:
              materialAppData?.debugShowCheckedModeBanner ??
              appData?.debugShowCheckedModeBanner ??
              kDefaultDebugShowCheckedModeBanner,
          shortcuts: materialAppData?.shortcuts ?? appData?.shortcuts,
          actions: materialAppData?.actions ?? appData?.actions,
          restorationScopeId: materialAppData?.restorationScopeId ?? appData?.restorationScopeId,
          scrollBehavior: materialAppData?.scrollBehavior ?? appData?.scrollBehavior,
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
  CupertinoApp buildCupertino(BuildContext context) => cupertinoAppRouterData != null
      ? .router(
          key: cupertinoAppRouterData?.widgetKey ?? appRouterData?.widgetKey,
          routeInformationProvider:
              cupertinoAppRouterData?.routeInformationProvider ??
              appRouterData?.routeInformationProvider,
          routeInformationParser:
              cupertinoAppRouterData?.routeInformationParser ??
              appRouterData?.routeInformationParser,
          routerDelegate: cupertinoAppRouterData?.routerDelegate ?? appRouterData?.routerDelegate,
          routerConfig: cupertinoAppRouterData?.routerConfig ?? appRouterData?.routerConfig,
          backButtonDispatcher:
              cupertinoAppRouterData?.backButtonDispatcher ?? appRouterData?.backButtonDispatcher,
          onNavigationNotification:
              cupertinoAppRouterData?.onNavigationNotification ??
              appRouterData?.onNavigationNotification,
          builder: cupertinoAppRouterData?.builder ?? appRouterData?.builder,
          title: cupertinoAppRouterData?.title ?? appRouterData?.title,
          onGenerateTitle:
              cupertinoAppRouterData?.onGenerateTitle ?? appRouterData?.onGenerateTitle,
          color: cupertinoAppRouterData?.color ?? appRouterData?.color,
          locale: cupertinoAppRouterData?.locale ?? appRouterData?.locale,
          localizationsDelegates:
              cupertinoAppRouterData?.localizationsDelegates ??
              appRouterData?.localizationsDelegates,
          localeListResolutionCallback:
              cupertinoAppRouterData?.localeListResolutionCallback ??
              appRouterData?.localeListResolutionCallback,
          localeResolutionCallback:
              cupertinoAppRouterData?.localeResolutionCallback ??
              appRouterData?.localeResolutionCallback,
          supportedLocales:
              cupertinoAppRouterData?.supportedLocales ??
              appRouterData?.supportedLocales ??
              kDefaultSupportedLocales,
          showPerformanceOverlay:
              cupertinoAppRouterData?.showPerformanceOverlay ??
              appRouterData?.showPerformanceOverlay ??
              kDefaultShowPerformanceOverlay,
          checkerboardRasterCacheImages:
              cupertinoAppRouterData?.checkerboardRasterCacheImages ??
              appRouterData?.checkerboardRasterCacheImages ??
              kDefaultCheckerboardRasterCacheImages,
          checkerboardOffscreenLayers:
              cupertinoAppRouterData?.checkerboardOffscreenLayers ??
              appRouterData?.checkerboardOffscreenLayers ??
              kDefaultCheckerboardOffscreenLayers,
          showSemanticsDebugger:
              cupertinoAppRouterData?.showSemanticsDebugger ??
              appRouterData?.showSemanticsDebugger ??
              kDefaultShowSemanticsDebugger,
          debugShowCheckedModeBanner:
              cupertinoAppRouterData?.debugShowCheckedModeBanner ??
              appRouterData?.debugShowCheckedModeBanner ??
              kDefaultDebugShowCheckedModeBanner,
          shortcuts: cupertinoAppRouterData?.shortcuts ?? appRouterData?.shortcuts,
          actions: cupertinoAppRouterData?.actions ?? appRouterData?.actions,
          restorationScopeId:
              cupertinoAppRouterData?.restorationScopeId ?? appRouterData?.restorationScopeId,
          scrollBehavior: cupertinoAppRouterData?.scrollBehavior ?? appRouterData?.scrollBehavior,
          theme: cupertinoAppRouterData?.theme ?? cupertinoAppData?.theme,
        )
      : CupertinoApp(
          key: cupertinoAppData?.widgetKey ?? appData?.widgetKey,
          navigatorKey: cupertinoAppData?.navigatorKey ?? appData?.navigatorKey,
          home: cupertinoAppData?.home ?? appData?.home,
          routes: cupertinoAppData?.routes ?? appData?.routes ?? AppData.kDefaultAppRoutes,
          initialRoute: cupertinoAppData?.initialRoute ?? appData?.initialRoute,
          onGenerateRoute: cupertinoAppData?.onGenerateRoute ?? appData?.onGenerateRoute,
          onGenerateInitialRoutes:
              cupertinoAppData?.onGenerateInitialRoutes ?? appData?.onGenerateInitialRoutes,
          onUnknownRoute: cupertinoAppData?.onUnknownRoute ?? appData?.onUnknownRoute,
          navigatorObservers:
              cupertinoAppData?.navigatorObservers ??
              appData?.navigatorObservers ??
              AppData.kDefaultNavigationObservers,
          onNavigationNotification:
              cupertinoAppData?.onNavigationNotification ?? appData?.onNavigationNotification,
          builder: cupertinoAppData?.builder ?? appData?.builder,
          title: cupertinoAppData?.title ?? appData?.title,
          onGenerateTitle: cupertinoAppData?.onGenerateTitle ?? appData?.onGenerateTitle,
          color: cupertinoAppData?.color ?? appData?.color,
          locale: cupertinoAppData?.locale ?? appData?.locale,
          localizationsDelegates:
              cupertinoAppData?.localizationsDelegates ?? appData?.localizationsDelegates,
          localeListResolutionCallback:
              cupertinoAppData?.localeListResolutionCallback ??
              appData?.localeListResolutionCallback,
          localeResolutionCallback:
              cupertinoAppData?.localeResolutionCallback ?? appData?.localeResolutionCallback,
          supportedLocales:
              cupertinoAppData?.supportedLocales ??
              appData?.supportedLocales ??
              kDefaultSupportedLocales,
          showPerformanceOverlay:
              cupertinoAppData?.showPerformanceOverlay ??
              appData?.showPerformanceOverlay ??
              kDefaultShowPerformanceOverlay,
          checkerboardRasterCacheImages:
              cupertinoAppData?.checkerboardRasterCacheImages ??
              appData?.checkerboardRasterCacheImages ??
              kDefaultCheckerboardRasterCacheImages,
          checkerboardOffscreenLayers:
              cupertinoAppData?.checkerboardOffscreenLayers ??
              appData?.checkerboardOffscreenLayers ??
              kDefaultCheckerboardOffscreenLayers,
          showSemanticsDebugger:
              cupertinoAppData?.showSemanticsDebugger ??
              appData?.showSemanticsDebugger ??
              kDefaultShowSemanticsDebugger,
          debugShowCheckedModeBanner:
              cupertinoAppData?.debugShowCheckedModeBanner ??
              appData?.debugShowCheckedModeBanner ??
              kDefaultDebugShowCheckedModeBanner,
          shortcuts: cupertinoAppData?.shortcuts ?? appData?.shortcuts,
          actions: cupertinoAppData?.actions ?? appData?.actions,
          restorationScopeId: cupertinoAppData?.restorationScopeId ?? appData?.restorationScopeId,
          scrollBehavior: cupertinoAppData?.scrollBehavior ?? appData?.scrollBehavior,
          theme: cupertinoAppData?.theme,
        );
}
