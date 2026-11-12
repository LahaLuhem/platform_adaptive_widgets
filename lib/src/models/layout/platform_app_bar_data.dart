/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/layout/platform_app_bar.dart';
/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Anything that can build an app bar for either platform. [PlatformAppBar] is the one that ships, and
/// [PlatformScaffold] takes any of these in its `appBarData` slot and calls the right builder.
abstract class PlatformAppBarData {
  /// Builds the Material bar.
  PreferredSizeWidget materialBuilder(BuildContext context);

  /// Builds the Cupertino bar.
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context);
}

/// Shared-visual base for the 2 app-bar records, holding the one property worth varying per platform.
/// Cupertino nav bars lean translucent and Material app bars opaque, so a single colour rarely suits
/// both.
///
/// Everything else (title, actions, bottom, `automaticallyImplyLeading`, widgetKey) stays flat on `PlatformAppBar`.
/// Private, never exported.
abstract final class const _PlatformAppBarData({final Color? backgroundColor});

/// Material-side settings for a platform app bar, mapping onto `AppBar`. The content itself stays flat
/// on `PlatformAppBar`.
final class const MaterialAppBarData({
  super.backgroundColor,

  /// Replaces the button the bar adds itself (back, close or the drawer's), for a widget only Material
  /// puts there.
  final Widget? leading,

  /// Replaces [PlatformAppBar.actions] and its `primaryAction` on Material, for a widget an action can't
  /// describe.
  final List<Widget>? actions,

  /// Lets the framework add the end drawer's button while the bar has no actions.
  final bool automaticallyImplyActions = kAutomaticallyImplyActions,

  /// Sits behind the toolbar and tab bar.
  final Widget? flexibleSpace,

  /// Forwards to [AppBar.elevation].
  final double? elevation,

  /// Takes over once content scrolls beneath the bar.
  final double? scrolledUnderElevation,

  /// Decides which scroll notifications count towards [scrolledUnderElevation].
  final ScrollNotificationPredicate notificationPredicate = kDefaultScrollNotificationPredicate,

  /// Forwards to [AppBar.shadowColor].
  final Color? shadowColor,

  /// Forwards to [AppBar.surfaceTintColor].
  final Color? surfaceTintColor,

  /// Forwards to [AppBar.shape].
  final ShapeBorder? shape,

  /// Colours the title and icons.
  final Color? foregroundColor,

  /// Forwards to [AppBar.iconTheme].
  final IconThemeData? iconTheme,

  /// Forwards to [AppBar.actionsIconTheme].
  final IconThemeData? actionsIconTheme,

  /// Leaves room for the status bar.
  final bool primary = kDefaultPrimary,

  /// Left out, upstream reads `AppBarTheme`, then the platform.
  final bool? centerTitle,

  /// {@macro material_ui.appbar.excludeHeaderSemantics}
  final bool excludeHeaderSemantics = kExcludeHeaderSemantics,

  /// Forwards to [AppBar.titleSpacing].
  final double? titleSpacing,

  /// {@macro material_ui.appbar.toolbarOpacity}
  final double toolbarOpacity = kToolbarOpacity,

  /// {@macro material_ui.appbar.bottomOpacity}
  final double bottomOpacity = kBottomOpacity,

  /// {@macro material_ui.appbar.toolbarHeight}
  final double? toolbarHeight,

  /// {@macro material_ui.appbar.leadingWidth}
  final double? leadingWidth,

  /// Forwards to [AppBar.toolbarTextStyle].
  final TextStyle? toolbarTextStyle,

  /// Forwards to [AppBar.titleTextStyle].
  final TextStyle? titleTextStyle,

  /// Status bar icon and text colours while this bar is up.
  final SystemUiOverlayStyle? systemOverlayStyle,

  /// {@macro material_ui.appbar.forceMaterialTransparency}
  final bool forceMaterialTransparency = kForceMaterialTransparency,

  /// {@macro material_ui.appbar.useDefaultSemanticsOrder}
  final bool useDefaultSemanticsOrder = kUseDefaultSemanticsOrder,

  /// {@macro cupertino_ui.Material.clipBehavior}
  final Clip? clipBehavior,

  /// {@macro material_ui.appbar.actionsPadding}
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

  /// Swaps the centred bar for Cupertino's tall left-aligned one. Material has no such thing and ignores
  /// it. Turn it on and `PlatformAppBar.title` becomes the large title, with [automaticallyImplyMiddle]
  /// driving the small one that appears on scroll.
  final bool large = false,

  /// Forwards to [CupertinoNavigationBar.automaticallyImplyMiddle].
  final bool automaticallyImplyMiddle = kAutomaticallyImplyMiddle,

  /// What the back button reads, instead of the previous route's title.
  final String? previousPageTitle,

  /// Replaces the button the bar adds itself (back, or a full-screen dialog's Cancel), for a widget only
  /// Cupertino puts there.
  final Widget? leading,

  /// Replaces [PlatformAppBar.actions] and its `primaryAction` on Cupertino, for a widget an action
  /// can't describe.
  final Widget? trailing,

  /// Hairline along the bottom edge. `null` drops it.
  final Border? border = kBorder,

  /// {@macro cupertino_ui.CupertinoNavigationBar.automaticBackgroundVisibility}
  final bool automaticBackgroundVisibility = kAutomaticBackgroundVisibility,

  /// The frosted glass behind the bar.
  final bool enableBackgroundFilterBlur = kEnableBackgroundFilterBlur,

  /// {@macro cupertino_ui.CupertinoNavigationBar.brightness}
  final Brightness? brightness,

  /// {@macro cupertino_ui.CupertinoNavigationBar.padding}
  final EdgeInsetsDirectional? padding,

  /// Animates the bar between routes rather than cutting.
  final bool transitionBetweenRoutes = kTransitionBetweenRoutes,

  /// Only worth setting when one route puts up 2 nav bars, since they then need different tags to animate
  /// properly. Left out, Cupertino picks its own.
  final Object? heroTag,
}) extends _PlatformAppBarData {
  /// Default value for [automaticallyImplyMiddle].
  static const kAutomaticallyImplyMiddle = true;

  /// Default value for [border].
  static const kBorder = Border(bottom: BorderSide(color: Color(0x4D000000), width: 0));

  /// Default value for [automaticBackgroundVisibility].
  static const kAutomaticBackgroundVisibility = true;

  /// Default value for [enableBackgroundFilterBlur].
  static const kEnableBackgroundFilterBlur = true;

  /// Default value for [transitionBetweenRoutes].
  static const kTransitionBetweenRoutes = true;

  /// Creates Cupertino-side nav bar settings.
  this;
}
