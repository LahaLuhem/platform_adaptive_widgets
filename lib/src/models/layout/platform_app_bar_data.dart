/// @docImport '/src/widgets/layout/platform_app_bar.dart';
/// @docImport '/src/widgets/layout/platform_scaffold.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Interface for platform app bar data that provides builders for both platforms.
///
/// Implementations must provide a [materialBuilder] for Android and a [cupertinoBuilder] for iOS.
/// [PlatformAppBar] is the concrete implementation. [PlatformScaffold] accepts any `PlatformAppBarData`
/// via its `appBarData` slot and calls the matching builder at build time.
// A pure interface with no fields needs no constructor, and an empty primary
// one can't carry the dartdoc public_member_api_docs then demands.
// ignore: use_primary_constructors
abstract class PlatformAppBarData {
  /// Builds a Material [PreferredSizeWidget] for Android.
  PreferredSizeWidget materialBuilder(BuildContext context);

  /// Builds a Cupertino [ObstructingPreferredSizeWidget] for iOS.
  ObstructingPreferredSizeWidget cupertinoBuilder(BuildContext context);
}

/// Shared-visual base for the per-platform app-bar records.
///
/// Holds only [backgroundColor], the one app-bar property that exists on both platforms and that a
/// caller may reasonably want to differ per platform (iOS nav bars are often translucent, Android
/// app bars opaque). Everything functional (title, leading, bottom, `automaticallyImplyLeading`,
/// widgetKey) is flat on `PlatformAppBar`, the single source of truth.
///
/// Private, [MaterialAppBarData] and [CupertinoNavigationBarData] inherit [backgroundColor] via
/// `super`-forwarding. Never constructed or exported directly.
abstract final class const _PlatformAppBarData({
  /// The background color of the app bar.
  final Color? backgroundColor,
}) {
  /// Creates a [_PlatformAppBarData].
  this;
}

/// Material-specific configuration for a platform app bar.
///
/// Maps to properties of `AppBar` on Android. Shared content (title, leading, bottom,
/// `automaticallyImplyLeading`, widgetKey) is flat on `PlatformAppBar`.
final class const MaterialAppBarData({
  super.backgroundColor,

  /// Action widgets displayed in the app bar.
  final List<Widget>? actions,

  /// Whether to imply the actions widget when [actions] is null or empty.
  ///
  /// When true (the default), the framework tries to deduce the actions. When false, the actions list
  /// is kept empty. No effect when [actions] is set. Material-only. Cupertino's navigation bar has
  /// no actions list. Defaults to [kAutomaticallyImplyActions].
  final bool automaticallyImplyActions = kAutomaticallyImplyActions,

  /// Widget displayed behind the toolbar and tab bar.
  final Widget? flexibleSpace,

  /// Elevation of the app bar.
  final double? elevation,

  /// Elevation when scrolled under.
  final double? scrolledUnderElevation,

  /// Predicate for scroll notifications.
  final ScrollNotificationPredicate notificationPredicate = kDefaultScrollNotificationPredicate,

  /// Shadow color of the app bar.
  final Color? shadowColor,

  /// Surface tint color of the app bar.
  final Color? surfaceTintColor,

  /// Shape of the app bar.
  final ShapeBorder? shape,

  /// Foreground color of the app bar.
  final Color? foregroundColor,

  /// Icon theme for the app bar icons.
  final IconThemeData? iconTheme,

  /// Icon theme for the action icons.
  final IconThemeData? actionsIconTheme,

  /// Whether this is the primary app bar (affects status bar area).
  final bool primary = kDefaultPrimary,

  /// Whether the title should be centered.
  final bool centerTitle = false,

  /// Whether to exclude header semantics.
  final bool excludeHeaderSemantics = kExcludeHeaderSemantics,

  /// Spacing around the title.
  final double? titleSpacing,

  /// Opacity of the toolbar.
  final double toolbarOpacity = kToolbarOpacity,

  /// Opacity of the bottom widget.
  final double bottomOpacity = kBottomOpacity,

  /// Height of the toolbar.
  final double? toolbarHeight,

  /// Width of the leading widget.
  final double? leadingWidth,

  /// Text style for the toolbar.
  final TextStyle? toolbarTextStyle,

  /// Text style for the title.
  final TextStyle? titleTextStyle,

  /// System UI overlay style.
  final SystemUiOverlayStyle? systemOverlayStyle,

  /// Whether to force Material transparency.
  final bool forceMaterialTransparency = kForceMaterialTransparency,

  /// Whether to use default semantics order.
  final bool useDefaultSemanticsOrder = kUseDefaultSemanticsOrder,

  /// Clip behavior for the app bar.
  final Clip? clipBehavior,

  /// Padding around the actions.
  final EdgeInsetsGeometry? actionsPadding,

  /// Whether to animate color changes.
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

  /// Creates Material-specific app bar configuration.
  this;
}

/// Cupertino-specific configuration for a platform navigation bar.
///
/// Maps to properties of `CupertinoNavigationBar` on iOS. Shared content (title, leading, bottom,
/// `automaticallyImplyLeading`, widgetKey) is flat on `PlatformAppBar`.
final class const CupertinoNavigationBarData({
  super.backgroundColor,

  /// Whether to render the expanded, left-aligned large-title navigation bar (`CupertinoNavigationBar.large`)
  /// instead of the standard centered one.
  ///
  /// iOS-only. Material has no static large-title app bar, so this has no effect on Android. When
  /// true, `PlatformAppBar.title` becomes the `largeTitle` and [automaticallyImplyMiddle] drives the
  /// `.large` ctor's `automaticallyImplyTitle`. Defaults to [kLarge].
  final bool large = kLarge,

  /// Whether to automatically imply the middle widget.
  final bool automaticallyImplyMiddle = kAutomaticallyImplyMiddle,

  /// Title of the previous page (shown in the back button).
  final String? previousPageTitle,

  /// Trailing widget in the navigation bar.
  final Widget? trailing,

  /// Border at the bottom of the navigation bar.
  final Border? border,

  /// Whether to automatically adjust background visibility.
  final bool automaticBackgroundVisibility = kAutomaticBackgroundVisibility,

  /// Whether to enable background filter blur.
  final bool enableBackgroundFilterBlur = kEnableBackgroundFilterBlur,

  /// Brightness of the navigation bar.
  final Brightness? brightness,

  /// Padding around the navigation bar content.
  final EdgeInsetsDirectional? padding,

  /// Whether to enable hero transitions between routes.
  final bool transitionBetweenRoutes = kTransitionBetweenRoutes,

  /// Hero tag for the navigation bar transition.
  ///
  /// Defaults to `null`, which lets `CupertinoNavigationBar` use its built-in default tag. Only set
  /// this when a single route hosts more than one navigation bar, each needs a distinct tag to animate
  /// correctly.
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

  /// Creates Cupertino-specific navigation bar configuration.
  this;
}
