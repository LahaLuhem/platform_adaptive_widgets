import 'package:flutter/cupertino.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class PlatformAppBarData {
  PreferredSizeWidget materialBuilder(BuildContext context);
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context);
}

const kAutoImplyLeading = true;

abstract class _BaseData {
  final Key? widgetKey;

  final Widget? leading;
  final Widget? title;
  final PreferredSizeWidget? bottom;

  final Color? backgroundColor;
  final bool automaticallyImplyLeading;

  const _BaseData({
    this.widgetKey,
    this.title,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = kAutoImplyLeading,
    this.bottom,
  });
}

class MaterialAppBarData extends _BaseData {
  final List<Widget>? actions;
  final Widget? flexibleSpace;

  final double? elevation;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;

  final bool primary;
  final bool centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;

  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final bool useDefaultSemanticsOrder;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? actionsPadding;
  final bool animateColor;

  static const kDefaultScrollNotificationPredicate = defaultScrollNotificationPredicate;
  static const kDefaultPrimary = true;
  static const kCenterTitle = false;
  static const kExcludeHeaderSemantics = false;
  static const kToolbarOpacity = 1.0;
  static const kBottomOpacity = 1.0;
  static const kForceMaterialTransparency = false;
  static const kUseDefaultSemanticsOrder = true;
  static const kAnimateColor = false;

  const MaterialAppBarData({
    super.title,
    super.backgroundColor,
    super.leading,
    super.widgetKey,
    super.automaticallyImplyLeading,
    super.bottom,
    this.actions,
    this.flexibleSpace,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = kDefaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = kDefaultPrimary,
    this.centerTitle = kCenterTitle,
    this.excludeHeaderSemantics = kExcludeHeaderSemantics,
    this.titleSpacing,
    this.toolbarOpacity = kToolbarOpacity,
    this.bottomOpacity = kBottomOpacity,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = kForceMaterialTransparency,
    this.useDefaultSemanticsOrder = kUseDefaultSemanticsOrder,
    this.clipBehavior,
    this.actionsPadding,
    this.animateColor = kAnimateColor,
  });
}

class CupertinoNavigationBarData extends _BaseData {
  final bool automaticallyImplyMiddle;
  final String? previousPageTitle;
  final Widget? trailing;
  final Border? border;
  final bool automaticBackgroundVisibility;
  final bool enableBackgroundFilterBlur;
  final Brightness? brightness;
  final EdgeInsetsDirectional? padding;
  final bool transitionBetweenRoutes;

  final Object? heroTag;

  static const kAutomaticallyImplyMiddle = true;
  static const kAutomaticBackgroundVisibility = true;
  static const kEnableBackgroundFilterBlur = true;
  static const kTransitionBetweenRoutes = true;

  const CupertinoNavigationBarData({
    super.title,
    super.backgroundColor,
    super.leading,
    super.widgetKey,
    super.automaticallyImplyLeading,
    super.bottom,
    this.automaticallyImplyMiddle = kAutomaticallyImplyMiddle,
    this.previousPageTitle,
    this.trailing,
    this.border,
    this.automaticBackgroundVisibility = kAutomaticBackgroundVisibility,
    this.enableBackgroundFilterBlur = kEnableBackgroundFilterBlur,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = kTransitionBetweenRoutes,
  }) : heroTag = null;

  /// To override the default hero tag, use [heroTag]. Should only be overridden if there are multiple navigation bars per route.
  const CupertinoNavigationBarData.heroTagOverride({
    super.title,
    super.backgroundColor,
    super.leading,
    super.widgetKey,
    super.automaticallyImplyLeading,
    super.bottom,
    this.automaticallyImplyMiddle = kAutomaticallyImplyMiddle,
    this.previousPageTitle,
    this.trailing,
    this.border,
    this.automaticBackgroundVisibility = kAutomaticBackgroundVisibility,
    this.enableBackgroundFilterBlur = kEnableBackgroundFilterBlur,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = kTransitionBetweenRoutes,
    this.heroTag,
  });
}
