/// @docImport '/src/widgets/layout/platform_app_bar.dart';
/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Anything that can build an app bar for either platform. [PlatformAppBar] is the one that ships, and
/// [PlatformScaffold] takes any of these in its `appBarData` slot and calls the right builder.
// A pure interface with no fields needs no constructor, and an empty primary
// one can't carry the dartdoc public_member_api_docs then demands.
// ignore: use_primary_constructors
abstract class PlatformAppBarData {
  /// Builds the Android bar.
  PreferredSizeWidget materialBuilder(BuildContext context);

  /// Builds the iOS bar.
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context);
}

/// Shared-visual base for the 2 app-bar records, holding the one property worth varying per platform.
/// iOS nav bars lean translucent and Android app bars opaque, so a single colour rarely suits both.
///
/// Everything else (title, leading, bottom, `automaticallyImplyLeading`, widgetKey) stays flat on `PlatformAppBar`.
/// Private, never exported.
abstract final class const _PlatformAppBarData({final Color? backgroundColor});

/// Material-side settings for a platform app bar, mapping onto `AppBar`. The content itself stays flat
/// on `PlatformAppBar`.
final class const MaterialAppBarData({
  super.backgroundColor,

  final List<Widget>? actions,

  /// Lets the framework guess at actions while [actions] is empty. Set [actions] and this stops mattering.
  /// iOS has no actions list at all.
  final bool automaticallyImplyActions = kAutomaticallyImplyActions,

  /// Sits behind the toolbar and tab bar.
  final Widget? flexibleSpace,

  final double? elevation,

  /// Takes over once content scrolls beneath the bar.
  final double? scrolledUnderElevation,

  /// Decides which scroll notifications count towards [scrolledUnderElevation].
  final ScrollNotificationPredicate notificationPredicate = kDefaultScrollNotificationPredicate,

  final Color? shadowColor,

  final Color? surfaceTintColor,

  final ShapeBorder? shape,

  /// Colours the title and icons.
  final Color? foregroundColor,

  final IconThemeData? iconTheme,

  final IconThemeData? actionsIconTheme,

  /// Leaves room for the status bar.
  final bool primary = kDefaultPrimary,

  final bool centerTitle = false,

  final bool excludeHeaderSemantics = kExcludeHeaderSemantics,

  final double? titleSpacing,

  final double toolbarOpacity = kToolbarOpacity,

  final double bottomOpacity = kBottomOpacity,

  final double? toolbarHeight,

  final double? leadingWidth,

  final TextStyle? toolbarTextStyle,

  final TextStyle? titleTextStyle,

  /// Status bar icon and text colours while this bar is up.
  final SystemUiOverlayStyle? systemOverlayStyle,

  final bool forceMaterialTransparency = kForceMaterialTransparency,

  final bool useDefaultSemanticsOrder = kUseDefaultSemanticsOrder,

  final Clip? clipBehavior,

  final EdgeInsetsGeometry? actionsPadding,

  /// Tweens [backgroundColor] changes instead of cutting straight to the new one.
  final bool animateColor = kAnimateColor,
}) extends _PlatformAppBarData {
  /// Default value for [notificationPredicate].
  static const kDefaultScrollNotificationPredicate = defaultScrollNotificationPredicate;

  /// Default value for [automaticallyImplyActions].
  static const kAutomaticallyImplyActions = true;

  /// Default value for [primary].
  static const kDefaultPrimary = true;

  /// Default value for [excludeHeaderSemantics].
  static const kExcludeHeaderSemantics = false;

  /// Default value for [toolbarOpacity].
  static const kToolbarOpacity = 1.0;

  /// Default value for [bottomOpacity].
  static const kBottomOpacity = 1.0;

  /// Default value for [forceMaterialTransparency].
  static const kForceMaterialTransparency = false;

  /// Default value for [useDefaultSemanticsOrder].
  static const kUseDefaultSemanticsOrder = true;

  /// Default value for [animateColor].
  static const kAnimateColor = false;

  /// Creates Material-side app bar settings.
  this;
}

/// Cupertino-side settings for a platform nav bar, mapping onto `CupertinoNavigationBar`. The content
/// itself stays flat on `PlatformAppBar`.
final class const CupertinoNavigationBarData({
  super.backgroundColor,

  /// Swaps the centred bar for iOS's tall left-aligned one. Android has no such thing and ignores it.
  /// Turn it on and `PlatformAppBar.title` becomes the large title, with [automaticallyImplyMiddle]
  /// driving the small one that appears on scroll.
  final bool large = kLarge,

  final bool automaticallyImplyMiddle = kAutomaticallyImplyMiddle,

  /// What the back button reads, instead of the previous route's title.
  final String? previousPageTitle,

  final Widget? trailing,

  /// Hairline along the bottom edge.
  final Border? border,

  final bool automaticBackgroundVisibility = kAutomaticBackgroundVisibility,

  /// The frosted glass behind the bar.
  final bool enableBackgroundFilterBlur = kEnableBackgroundFilterBlur,

  final Brightness? brightness,

  final EdgeInsetsDirectional? padding,

  /// Animates the bar between routes rather than cutting.
  final bool transitionBetweenRoutes = kTransitionBetweenRoutes,

  /// Only worth setting when one route puts up 2 nav bars, since they then need different tags to animate
  /// properly. Left out, Cupertino picks its own.
  final Object? heroTag,
}) extends _PlatformAppBarData {
  /// Default value for [large].
  static const kLarge = false;

  /// Default value for [automaticallyImplyMiddle].
  static const kAutomaticallyImplyMiddle = true;

  /// Default value for [automaticBackgroundVisibility].
  static const kAutomaticBackgroundVisibility = true;

  /// Default value for [enableBackgroundFilterBlur].
  static const kEnableBackgroundFilterBlur = true;

  /// Default value for [transitionBetweenRoutes].
  static const kTransitionBetweenRoutes = true;

  /// Creates Cupertino-side nav bar settings.
  this;
}
