import 'package:flutter/cupertino.dart' show CupertinoNavigationBar, ObstructingPreferredSizeWidget;
import 'package:flutter/material.dart' show AppBar;
import 'package:flutter/widgets.dart';

import '/models/scaffolding/platform_app_bar_data.dart';

class PlatformAppBar implements PlatformAppBarData {
  final Key? widgetKey;
  final Widget? leading;
  final Widget? title;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  final MaterialAppBarData? materialAppBarData;
  final CupertinoNavigationBarData? cupertinoNavigationBarData;

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
