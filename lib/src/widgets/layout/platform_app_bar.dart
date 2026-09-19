/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoNavigationBar, ObstructingPreferredSizeWidget;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show AppBar;

import '/src/models/layout/platform_app_bar_data.dart';

/// Material `AppBar` on Android, `CupertinoNavigationBar` on iOS.
///
/// Per-platform tuning lives in [materialAppBarData] / [cupertinoNavigationBarData], which can also
/// override [backgroundColor] on one side alone. Worth doing, since iOS nav bars tend to be translucent
/// where Android's are opaque.
///
/// The odd one out in this package: it `implements` [PlatformAppBarData] instead of extending `PlatformWidgetBase`,
/// because a scaffold's bar slot wants a `PreferredSizeWidget` and a plain `StatelessWidget` isn't one.
/// So there's no `build` here, just the 2 builders [PlatformScaffold] picks between.
///
/// Example:
/// {@example /example/lib/snippets/layout/platform_app_bar.dart#platform_app_bar}
class const PlatformAppBar({
  /// Goes on the bar itself, since this isn't a widget with a [Key] of its own.
  final Key? widgetKey,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialAppBarData? materialAppBarData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoNavigationBarData? cupertinoNavigationBarData,

  final Widget? title,

  final Color? backgroundColor,

  /// Before the title, usually a navigation or menu icon.
  final Widget? leading,

  /// Puts a back button in [leading]'s place when there's somewhere to go back to.
  final bool automaticallyImplyLeading = true,

  /// Under the bar, usually tabs.
  final PreferredSizeWidget? bottom,
}) implements PlatformAppBarData {
  /// Creates a platform-adaptive app bar.
  this;

  @override
  PreferredSizeWidget materialBuilder(BuildContext context) => AppBar(
    key: widgetKey,
    leading: leading,
    title: title,
    backgroundColor: materialAppBarData?.backgroundColor ?? backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    bottom: bottom,
    actions: materialAppBarData?.actions,
    automaticallyImplyActions:
        materialAppBarData?.automaticallyImplyActions ??
        MaterialAppBarData.kAutomaticallyImplyActions,
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
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context) {
    // Resolved once, since every branch below passes the same set.
    final resolvedBackgroundColor = cupertinoNavigationBarData?.backgroundColor ?? backgroundColor;
    final automaticallyImplyMiddle =
        cupertinoNavigationBarData?.automaticallyImplyMiddle ??
        CupertinoNavigationBarData.kAutomaticallyImplyMiddle;
    final automaticBackgroundVisibility =
        cupertinoNavigationBarData?.automaticBackgroundVisibility ??
        CupertinoNavigationBarData.kAutomaticBackgroundVisibility;
    final enableBackgroundFilterBlur =
        cupertinoNavigationBarData?.enableBackgroundFilterBlur ??
        CupertinoNavigationBarData.kEnableBackgroundFilterBlur;
    final transitionBetweenRoutes =
        cupertinoNavigationBarData?.transitionBetweenRoutes ??
        CupertinoNavigationBarData.kTransitionBetweenRoutes;
    // Promoted to non-null inside the branches below, so no force-unwrap is needed there.
    final heroTag = cupertinoNavigationBarData?.heroTag;

    if (cupertinoNavigationBarData?.large ?? CupertinoNavigationBarData.kLarge) {
      return heroTag == null
          // CupertinoNavigationBar's own default tag is private, so the param is omitted rather than
          // filled with a copy of it.
          // ignore: prefer-define-hero-tag
          ? CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
              trailing: cupertinoNavigationBarData?.trailing,
              border: cupertinoNavigationBarData?.border,
              backgroundColor: resolvedBackgroundColor,
              automaticBackgroundVisibility: automaticBackgroundVisibility,
              enableBackgroundFilterBlur: enableBackgroundFilterBlur,
              brightness: cupertinoNavigationBarData?.brightness,
              padding: cupertinoNavigationBarData?.padding,
              transitionBetweenRoutes: transitionBetweenRoutes,
              bottom: bottom,
            )
          : CupertinoNavigationBar.large(
              key: widgetKey,
              largeTitle: title,
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              automaticallyImplyTitle: automaticallyImplyMiddle,
              previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
              trailing: cupertinoNavigationBarData?.trailing,
              border: cupertinoNavigationBarData?.border,
              backgroundColor: resolvedBackgroundColor,
              automaticBackgroundVisibility: automaticBackgroundVisibility,
              enableBackgroundFilterBlur: enableBackgroundFilterBlur,
              brightness: cupertinoNavigationBarData?.brightness,
              padding: cupertinoNavigationBarData?.padding,
              transitionBetweenRoutes: transitionBetweenRoutes,
              bottom: bottom,
              heroTag: heroTag,
            );
    }

    return heroTag == null
        // Covered in the next declaration
        // ignore: prefer-define-hero-tag
        ? CupertinoNavigationBar(
            key: widgetKey,
            leading: leading,
            middle: title,
            backgroundColor: resolvedBackgroundColor,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom,
            automaticallyImplyMiddle: automaticallyImplyMiddle,
            previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
            trailing: cupertinoNavigationBarData?.trailing,
            border: cupertinoNavigationBarData?.border,
            automaticBackgroundVisibility: automaticBackgroundVisibility,
            enableBackgroundFilterBlur: enableBackgroundFilterBlur,
            brightness: cupertinoNavigationBarData?.brightness,
            padding: cupertinoNavigationBarData?.padding,
            transitionBetweenRoutes: transitionBetweenRoutes,
          )
        : CupertinoNavigationBar(
            key: widgetKey,
            leading: leading,
            middle: title,
            backgroundColor: resolvedBackgroundColor,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom,
            automaticallyImplyMiddle: automaticallyImplyMiddle,
            previousPageTitle: cupertinoNavigationBarData?.previousPageTitle,
            trailing: cupertinoNavigationBarData?.trailing,
            border: cupertinoNavigationBarData?.border,
            automaticBackgroundVisibility: automaticBackgroundVisibility,
            enableBackgroundFilterBlur: enableBackgroundFilterBlur,
            brightness: cupertinoNavigationBarData?.brightness,
            padding: cupertinoNavigationBarData?.padding,
            transitionBetweenRoutes: transitionBetweenRoutes,
            heroTag: heroTag,
          );
  }
}
