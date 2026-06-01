// Per-platform records for PlatformExpansionTile (no shared private base — the
// Material and Cupertino visual surfaces don't overlap; the shared functional fields
// title / child / controller are flat on the widget).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_expansion_tile.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show ExpansionTileTransitionMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTileControlAffinity, VisualDensity;

/// Default value for [MaterialExpansionTileData.showTrailingIcon].
const kDefaultExpansionTileShowTrailingIcon = false;

/// Default value for [MaterialExpansionTileData.initiallyExpanded].
const kDefaultExpansionTileInitiallyExpanded = false;

/// Default value for [MaterialExpansionTileData.maintainState].
const kDefaultExpansionTileMaintainState = false;

/// Default value for [MaterialExpansionTileData.enabled].
const kDefaultExpansionTileEnabled = true;

/// Default value for [MaterialExpansionTileData.internalAddSemanticForOnTap].
const kDefaultExpansionTileInternalAddSemanticForOnTap = false;

/// Default value for [CupertinoExpansionTileData.transitionMode].
const kDefaultCupertinoExpansionTileTransitionMode = ExpansionTileTransitionMode.fade;

/// Material-only configuration for [PlatformExpansionTile].
///
/// Pass this via `PlatformExpansionTile.materialExpansionTileData` when tuning Material
/// rendering. The fields declared here have no Cupertino equivalent.
final class MaterialExpansionTileData {
  /// Callback fired when the expansion state changes. Functional, Material-only —
  /// Cupertino's [CupertinoExpansionTile] surfaces no equivalent callback (use the
  /// shared [ExpansibleController] for programmatic observation).
  final ValueChanged<bool>? onExpansionChanged;

  /// Leading widget before the title.
  final Widget? leading;

  /// Subtitle widget below the title.
  final Widget? subtitle;

  /// Trailing widget (typically an expand/collapse icon).
  final Widget? trailing;

  /// Whether to show the trailing icon. Defaults to
  /// [kDefaultExpansionTileShowTrailingIcon].
  final bool showTrailingIcon;

  /// Whether the tile starts in the expanded state. Defaults to
  /// [kDefaultExpansionTileInitiallyExpanded].
  final bool initiallyExpanded;

  /// Whether the children are kept in the widget tree when collapsed. Defaults to
  /// [kDefaultExpansionTileMaintainState].
  final bool maintainState;

  /// Padding around the tile header.
  final EdgeInsetsGeometry? tilePadding;

  /// Cross-axis alignment of the expanded child. Nullable — when `null`, Material
  /// applies its theme-driven default.
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  /// Alignment of the expanded child. Nullable — when `null`, Material applies its
  /// theme-driven default.
  final AlignmentGeometry? expandedAlignment;

  /// Padding around the expanded child.
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

  /// Whether to enable haptic feedback on tap. Nullable — when `null`, Material applies
  /// its own default (`true`).
  final bool? enableFeedback;

  /// Whether the tile is enabled. Functional, Material-only — Cupertino has no
  /// equivalent disable affordance (wrap with [IgnorePointer] to disable a Cupertino
  /// tile). Defaults to [kDefaultExpansionTileEnabled].
  final bool enabled;

  /// Animation style for the expansion transition.
  final AnimationStyle? expansionAnimationStyle;

  /// Whether to add semantics for the on-tap action internally. Defaults to
  /// [kDefaultExpansionTileInternalAddSemanticForOnTap].
  final bool internalAddSemanticForOnTap;

  /// Controller for the tile's interaction states. Functional, Material-only.
  final WidgetStatesController? statesController;

  /// Creates Material-only configuration for [PlatformExpansionTile].
  const MaterialExpansionTileData({
    this.onExpansionChanged,
    this.leading,
    this.subtitle,
    this.trailing,
    this.showTrailingIcon = kDefaultExpansionTileShowTrailingIcon,
    this.initiallyExpanded = kDefaultExpansionTileInitiallyExpanded,
    this.maintainState = kDefaultExpansionTileMaintainState,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
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
    this.enableFeedback,
    this.enabled = kDefaultExpansionTileEnabled,
    this.expansionAnimationStyle,
    this.internalAddSemanticForOnTap = kDefaultExpansionTileInternalAddSemanticForOnTap,
    this.statesController,
  });
}

/// Cupertino-only configuration for [PlatformExpansionTile].
///
/// Pass this via `PlatformExpansionTile.cupertinoExpansionTileData` when tuning
/// Cupertino rendering. The field declared here has no Material equivalent.
final class CupertinoExpansionTileData {
  /// Transition mode used when expanding or collapsing. Defaults to
  /// [kDefaultCupertinoExpansionTileTransitionMode].
  final ExpansionTileTransitionMode transitionMode;

  /// Creates Cupertino-only configuration for [PlatformExpansionTile].
  const CupertinoExpansionTileData({
    this.transitionMode = kDefaultCupertinoExpansionTileTransitionMode,
  });
}
