import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoNavigationBar, ObstructingPreferredSizeWidget;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show AppBar;

import '/src/models/layout/platform_app_bar_data.dart';

/// A platform-adaptive app bar that renders Material AppBar on Android
/// and CupertinoNavigationBar on iOS.
///
/// This widget automatically selects the appropriate app bar implementation based on the target platform:
/// - On Android: renders Material Design AppBar
/// - On iOS: renders CupertinoNavigationBar
///
/// The app bar can be configured with platform-specific data through [materialAppBarData]
/// and [cupertinoNavigationBarData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformAppBar(
///   title: Text('My App'),
///   leading: IconButton(
///     icon: Icon(Icons.menu),
///     onPressed: () => Scaffold.of(context).openDrawer(),
///   ),
/// )
/// ```
class PlatformAppBar implements PlatformAppBarData {
  /// Optional key for the app bar widget.
  final Key? widgetKey;

  /// Widget to display before the title.
  ///
  /// Typically used for navigation or menu icons.
  final Widget? leading;

  /// The primary title of the app bar.
  final Widget? title;

  /// Widget to display below the app bar.
  ///
  /// Typically used for tabs or other supplementary content.
  final PreferredSizeWidget? bottom;

  /// Background color of the app bar.
  final Color? backgroundColor;

  /// Whether to automatically imply a leading widget.
  ///
  /// If true, a back button will be automatically added when appropriate.
  final bool automaticallyImplyLeading;

  /// Material-specific app bar data.
  final MaterialAppBarData? materialAppBarData;

  /// Cupertino-specific navigation bar data.
  final CupertinoNavigationBarData? cupertinoNavigationBarData;

  /// Creates a platform-adaptive app bar.
  ///
  /// The app bar will render as a Material AppBar on Android and a CupertinoNavigationBar on iOS.
  const PlatformAppBar({
    this.widgetKey,
    this.materialAppBarData,
    this.cupertinoNavigationBarData,
    this.title,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = kAutoImplyLeading,
    this.bottom,
  });

  @override
  PreferredSizeWidget materialBuilder(BuildContext context) => AppBar(
    key: materialAppBarData?.widgetKey ?? widgetKey,
    leading: materialAppBarData?.leading ?? leading,
    title: materialAppBarData?.title ?? title,
    backgroundColor: materialAppBarData?.backgroundColor ?? backgroundColor,
    automaticallyImplyLeading:
        materialAppBarData?.automaticallyImplyLeading ?? automaticallyImplyLeading,
    bottom: materialAppBarData?.bottom ?? bottom,
    actions: materialAppBarData?.actions,
    flexibleSpace: materialAppBarData?.flexibleSpace,
    elevation: materialAppBarData?.elevation,
    scrolledUnderElevation: materialAppBarData?.scrolledUnderElevation,
    notificationPredicate:
        materialAppBarData?.notificationPredicate ??
        MaterialAppBarData.kDefaultScrollNotificationPredicate,
    shadowColor: materialAppBarData?.shadowColor,
    surfaceTintColor: materialAppBarData?.surfaceTintColor,
    shape: materialAppBarData?.shape,
    foregroundColor: materialAppBarData?.foregroundColor,
    iconTheme: materialAppBarData?.iconTheme,
    actionsIconTheme: materialAppBarData?.actionsIconTheme,
    primary: materialAppBarData?.primary ?? MaterialAppBarData.kDefaultPrimary,
    centerTitle: materialAppBarData?.centerTitle,
    excludeHeaderSemantics:
        materialAppBarData?.excludeHeaderSemantics ?? MaterialAppBarData.kExcludeHeaderSemantics,
    titleSpacing: materialAppBarData?.titleSpacing,
    toolbarOpacity: materialAppBarData?.toolbarOpacity ?? MaterialAppBarData.kToolbarOpacity,
    bottomOpacity: materialAppBarData?.bottomOpacity ?? MaterialAppBarData.kBottomOpacity,
    toolbarHeight: materialAppBarData?.toolbarHeight,
    leadingWidth: materialAppBarData?.leadingWidth,
    toolbarTextStyle: materialAppBarData?.toolbarTextStyle,
    titleTextStyle: materialAppBarData?.titleTextStyle,
    systemOverlayStyle: materialAppBarData?.systemOverlayStyle,
    forceMaterialTransparency:
        materialAppBarData?.forceMaterialTransparency ??
        MaterialAppBarData.kForceMaterialTransparency,
    useDefaultSemanticsOrder:
        materialAppBarData?.useDefaultSemanticsOrder ??
        MaterialAppBarData.kUseDefaultSemanticsOrder,
    clipBehavior: materialAppBarData?.clipBehavior,
    actionsPadding: materialAppBarData?.actionsPadding,
    animateColor: materialAppBarData?.animateColor ?? MaterialAppBarData.kAnimateColor,
  );

  @override
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context) =>
      cupertinoNavigationBarData?.heroTag == null
      // Default is a private implementation.
      // ignore: prefer-define-hero-tag
      ? CupertinoNavigationBar(
          key: cupertinoNavigationBarData?.widgetKey ?? widgetKey,
          leading: cupertinoNavigationBarData?.leading ?? leading,
          middle: cupertinoNavigationBarData?.title ?? title,
          backgroundColor: cupertinoNavigationBarData?.backgroundColor ?? backgroundColor,
          automaticallyImplyLeading:
              cupertinoNavigationBarData?.automaticallyImplyLeading ?? automaticallyImplyLeading,
          bottom: cupertinoNavigationBarData?.bottom ?? bottom,
          automaticallyImplyMiddle:
              cupertinoNavigationBarData?.automaticallyImplyMiddle ??
              CupertinoNavigationBarData.kAutomaticallyImplyMiddle,
          previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
          trailing: cupertinoNavigationBarData?.trailing,
          border: cupertinoNavigationBarData?.border,
          automaticBackgroundVisibility:
              cupertinoNavigationBarData?.automaticBackgroundVisibility ??
              CupertinoNavigationBarData.kAutomaticBackgroundVisibility,
          enableBackgroundFilterBlur:
              cupertinoNavigationBarData?.enableBackgroundFilterBlur ??
              CupertinoNavigationBarData.kEnableBackgroundFilterBlur,
          brightness: cupertinoNavigationBarData?.brightness,
          padding: cupertinoNavigationBarData?.padding,
          transitionBetweenRoutes:
              cupertinoNavigationBarData?.transitionBetweenRoutes ??
              CupertinoNavigationBarData.kTransitionBetweenRoutes,
        )
      : CupertinoNavigationBar(
          key: cupertinoNavigationBarData?.widgetKey ?? widgetKey,
          leading: cupertinoNavigationBarData?.leading ?? leading,
          middle: cupertinoNavigationBarData?.title ?? title,
          backgroundColor: cupertinoNavigationBarData?.backgroundColor ?? backgroundColor,
          automaticallyImplyLeading:
              cupertinoNavigationBarData?.automaticallyImplyLeading ?? automaticallyImplyLeading,
          bottom: cupertinoNavigationBarData?.bottom ?? bottom,
          automaticallyImplyMiddle:
              cupertinoNavigationBarData?.automaticallyImplyMiddle ??
              CupertinoNavigationBarData.kAutomaticallyImplyMiddle,
          previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
          trailing: cupertinoNavigationBarData?.trailing,
          border: cupertinoNavigationBarData?.border,
          automaticBackgroundVisibility:
              cupertinoNavigationBarData?.automaticBackgroundVisibility ??
              CupertinoNavigationBarData.kAutomaticBackgroundVisibility,
          enableBackgroundFilterBlur:
              cupertinoNavigationBarData?.enableBackgroundFilterBlur ??
              CupertinoNavigationBarData.kEnableBackgroundFilterBlur,
          brightness: cupertinoNavigationBarData?.brightness,
          padding: cupertinoNavigationBarData?.padding,
          transitionBetweenRoutes:
              cupertinoNavigationBarData?.transitionBetweenRoutes ??
              CupertinoNavigationBarData.kTransitionBetweenRoutes,
          heroTag: cupertinoNavigationBarData!.heroTag!,
        );
}
