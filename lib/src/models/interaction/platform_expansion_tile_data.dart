// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show ExpansionTileTransitionMode;
import 'package:flutter/material.dart' show ListTileControlAffinity, VisualDensity;
import 'package:flutter/widgets.dart';

/// Common configuration for platform-adaptive expansion tiles.
abstract final class _PlatformExpansionTileData {
  /// A key to identify the widget.
  final Key? widgetKey;

  /// The primary content of the tile.
  final Widget? title;

  /// The widget to display when the tile is expanded.
  final Widget? child;

  /// A controller to manage the expansion state.
  final ExpansibleController? controller;

  /// Creates a [_PlatformExpansionTileData].
  const _PlatformExpansionTileData({this.widgetKey, this.title, this.child, this.controller});
}

/// Material-specific configuration for a platform expansion tile.
///
/// Maps to properties of `ExpansionTile` on Android.
final class MaterialExpansionTileData extends _PlatformExpansionTileData {
  /// Callback when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Child widgets shown when expanded (mutually exclusive with [child]).
  final List<Widget>? children;

  /// Leading widget before the title.
  final Widget? leading;

  /// Subtitle widget below the title.
  final Widget? subtitle;

  /// Trailing widget (typically an expand/collapse icon).
  final Widget? trailing;

  /// Whether to show the trailing icon.
  final bool showTrailingIcon;

  /// Whether the tile starts in the expanded state.
  final bool initiallyExpanded;

  /// Whether the children are kept in the widget tree when collapsed.
  final bool maintainState;

  /// Padding around the tile header.
  final EdgeInsetsGeometry? tilePadding;

  /// Cross-axis alignment of the expanded children.
  final CrossAxisAlignment expandedCrossAxisAlignment;

  /// Alignment of the expanded children.
  final Alignment expandedAlignment;

  /// Padding around the expanded children.
  final EdgeInsetsGeometry? childrenPadding;

  /// Background color when expanded.
  final Color? backgroundColor;

  /// Background color when collapsed.
  final Color? collapsedBackgroundColor;

  /// Text color when expanded.
  final Color? textColor;

  /// Text color when collapsed.
  final Color? collapsedTextColor;

  /// Icon color when expanded.
  final Color? iconColor;

  /// Icon color when collapsed.
  final Color? collapsedIconColor;

  /// Shape of the tile when expanded.
  final ShapeBorder? shape;

  /// Shape of the tile when collapsed.
  final ShapeBorder? collapsedShape;

  /// Clip behavior for the tile content.
  final Clip? clipBehavior;

  /// Position of the expand/collapse control.
  final ListTileControlAffinity? controlAffinity;

  /// Splash color for the tile.
  final Color? splashColor;

  /// Visual density of the tile.
  final VisualDensity? visualDensity;

  /// Minimum height of the tile.
  final double? minTileHeight;

  /// Whether to enable feedback (e.g., haptic) on tap.
  final bool enableFeedback;

  /// Whether the tile is enabled.
  final bool enabled;

  /// Animation style for the expansion transition.
  final AnimationStyle? expansionAnimationStyle;

  /// Whether to add semantics for the on-tap action internally.
  final bool internalAddSemanticForOnTap;

  /// Default value for [showTrailingIcon].
  static const kDefaultShowTrailingIcon = false;

  /// Default value for [initiallyExpanded].
  static const kDefaultInitiallyExpanded = false;

  /// Default value for [maintainState].
  static const kDefaultMaintainState = false;

  /// Default value for [expandedCrossAxisAlignment].
  static const kDefaultExpandedCrossAxisAlignment = CrossAxisAlignment.center;

  /// Default value for [expandedAlignment].
  static const kDefaultExpandedAlignment = Alignment.centerLeft;

  /// Default value for [enableFeedback].
  static const kDefaultEnableFeedback = true;

  /// Default value for [enabled].
  static const kDefaultEnabled = true;

  /// Default value for [internalAddSemanticForOnTap].
  static const kDefaultInternalAddSemanticForOnTap = false;

  /// Creates Material-specific expansion tile configuration.
  const MaterialExpansionTileData({
    super.widgetKey,
    super.title,
    super.child,
    super.controller,
    this.onExpansionChanged,
    this.children,
    this.leading,
    this.subtitle,
    this.trailing,
    this.showTrailingIcon = kDefaultShowTrailingIcon,
    this.initiallyExpanded = kDefaultInitiallyExpanded,
    this.maintainState = kDefaultMaintainState,
    this.tilePadding,
    this.expandedCrossAxisAlignment = kDefaultExpandedCrossAxisAlignment,
    this.expandedAlignment = kDefaultExpandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controlAffinity,
    this.splashColor,
    this.visualDensity,
    this.minTileHeight,
    this.enableFeedback = kDefaultEnableFeedback,
    this.enabled = kDefaultEnabled,
    this.expansionAnimationStyle,
    this.internalAddSemanticForOnTap = kDefaultInternalAddSemanticForOnTap,
  }) : assert((child != null) ^ (children != null), 'child and children are mutually exclusive.');
}

/// Cupertino-specific configuration for a platform expansion tile.
///
/// Maps to properties of the Cupertino expansion tile on iOS.
final class CupertinoExpansionTileData extends _PlatformExpansionTileData {
  /// The transition mode used when expanding or collapsing.
  final ExpansionTileTransitionMode transitionMode;

  /// Default value for [transitionMode].
  static const kDefaultTransitionMode = ExpansionTileTransitionMode.fade;

  /// Creates Cupertino-specific expansion tile configuration.
  const CupertinoExpansionTileData({
    super.widgetKey,
    super.title,
    super.child,
    super.controller,
    this.transitionMode = kDefaultTransitionMode,
  });
}
