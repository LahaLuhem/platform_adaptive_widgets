import 'package:flutter/cupertino.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Interface for platform app bar data that provides builders for both platforms.
///
/// Implementations must provide a [materialBuilder] for Android and a
/// [cupertinoBuilder] for iOS.
abstract class PlatformAppBarData {
  /// Builds a Material [PreferredSizeWidget] for Android.
  PreferredSizeWidget materialBuilder(BuildContext context);

  /// Builds a Cupertino [ObstructingPreferredSizeWidget] for iOS.
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context);
}

/// Default value for `automaticallyImplyLeading` in app bar data classes.
const kAutoImplyLeading = true;

/// Common configuration for platform-adaptive app bars.
abstract final class _PlatformAppBarData {
  /// A key to identify the app bar widget.
  final Key? widgetKey;

  /// A widget to display at the start of the app bar.
  final Widget? leading;

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// A widget to display at the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// Whether to automatically imply a leading widget.
  final bool automaticallyImplyLeading;

  /// Creates a [_PlatformAppBarData].
  const _PlatformAppBarData({
    this.widgetKey,
    this.title,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = kAutoImplyLeading,
    this.bottom,
  });
}

/// Material-specific configuration for a platform app bar.
///
/// Maps to properties of `AppBar` on Android.
final class MaterialAppBarData extends _PlatformAppBarData {
  /// Action widgets displayed in the app bar.
  final List<Widget>? actions;

  /// Widget displayed behind the toolbar and tab bar.
  final Widget? flexibleSpace;

  /// Elevation of the app bar.
  final double? elevation;

  /// Elevation when scrolled under.
  final double? scrolledUnderElevation;

  /// Predicate for scroll notifications.
  final ScrollNotificationPredicate notificationPredicate;

  /// Shadow color of the app bar.
  final Color? shadowColor;

  /// Surface tint color of the app bar.
  final Color? surfaceTintColor;

  /// Shape of the app bar.
  final ShapeBorder? shape;

  /// Foreground color of the app bar.
  final Color? foregroundColor;

  /// Icon theme for the app bar icons.
  final IconThemeData? iconTheme;

  /// Icon theme for the action icons.
  final IconThemeData? actionsIconTheme;

  /// Whether this is the primary app bar (affects status bar area).
  final bool primary;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Whether to exclude header semantics.
  final bool excludeHeaderSemantics;

  /// Spacing around the title.
  final double? titleSpacing;

  /// Opacity of the toolbar.
  final double toolbarOpacity;

  /// Opacity of the bottom widget.
  final double bottomOpacity;

  /// Height of the toolbar.
  final double? toolbarHeight;

  /// Width of the leading widget.
  final double? leadingWidth;

  /// Text style for the toolbar.
  final TextStyle? toolbarTextStyle;

  /// Text style for the title.
  final TextStyle? titleTextStyle;

  /// System UI overlay style.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether to force Material transparency.
  final bool forceMaterialTransparency;

  /// Whether to use default semantics order.
  final bool useDefaultSemanticsOrder;

  /// Clip behavior for the app bar.
  final Clip? clipBehavior;

  /// Padding around the actions.
  final EdgeInsetsGeometry? actionsPadding;

  /// Whether to animate color changes.
  final bool animateColor;

  /// Default value for [notificationPredicate].
  static const kDefaultScrollNotificationPredicate = defaultScrollNotificationPredicate;

  /// Default value for [primary].
  static const kDefaultPrimary = true;

  /// Default value for [centerTitle].
  static const kCenterTitle = false;

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

  /// Creates Material-specific app bar configuration.
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

/// Cupertino-specific configuration for a platform navigation bar.
///
/// Maps to properties of `CupertinoNavigationBar` on iOS.
final class CupertinoNavigationBarData extends _PlatformAppBarData {
  /// Whether to automatically imply the middle widget.
  final bool automaticallyImplyMiddle;

  /// Title of the previous page (shown in the back button).
  final String? previousPageTitle;

  /// Trailing widget in the navigation bar.
  final Widget? trailing;

  /// Border at the bottom of the navigation bar.
  final Border? border;

  /// Whether to automatically adjust background visibility.
  final bool automaticBackgroundVisibility;

  /// Whether to enable background filter blur.
  final bool enableBackgroundFilterBlur;

  /// Brightness of the navigation bar.
  final Brightness? brightness;

  /// Padding around the navigation bar content.
  final EdgeInsetsDirectional? padding;

  /// Whether to enable hero transitions between routes.
  final bool transitionBetweenRoutes;

  /// Hero tag for the navigation bar transition.
  final Object? heroTag;

  /// Default value for [automaticallyImplyMiddle].
  static const kAutomaticallyImplyMiddle = true;

  /// Default value for [automaticBackgroundVisibility].
  static const kAutomaticBackgroundVisibility = true;

  /// Default value for [enableBackgroundFilterBlur].
  static const kEnableBackgroundFilterBlur = true;

  /// Default value for [transitionBetweenRoutes].
  static const kTransitionBetweenRoutes = true;

  /// Creates Cupertino-specific navigation bar configuration.
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
