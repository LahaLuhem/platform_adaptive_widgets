// Per-platform records for PlatformExpansionTile (no shared private base, the
// Material and Cupertino visual surfaces don't overlap. The shared functional fields
// title / child / controller are flat on the widget).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
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

/// Material-side settings for [PlatformExpansionTile], passed as `materialExpansionTileData`. Everything
/// declared here has no Cupertino counterpart at all.
final class const MaterialExpansionTileData({
  /// [CupertinoExpansionTile] fires nothing like it. Watch the shared [ExpansibleController] instead.
  final ValueChanged<bool>? onExpansionChanged,

  final Widget? leading,

  final Widget? subtitle,

  /// Usually the expand/collapse chevron.
  final Widget? trailing,

  final bool showTrailingIcon = kDefaultExpansionTileShowTrailingIcon,

  final bool initiallyExpanded = kDefaultExpansionTileInitiallyExpanded,

  /// Keeps the children in the tree while collapsed, so they hold their state.
  final bool maintainState = kDefaultExpansionTileMaintainState,

  /// Around the header, where [childrenPadding] wraps the expanded part.
  final EdgeInsetsGeometry? tilePadding,

  final CrossAxisAlignment? expandedCrossAxisAlignment,

  final AlignmentGeometry? expandedAlignment,

  final EdgeInsetsGeometry? childrenPadding,

  final Color? backgroundColor,

  final Color? collapsedBackgroundColor,

  final Color? textColor,

  final Color? collapsedTextColor,

  final Color? iconColor,

  final Color? collapsedIconColor,

  final ShapeBorder? shape,

  final ShapeBorder? collapsedShape,

  final Clip? clipBehavior,

  /// Which end the expand/collapse control sits at.
  final ListTileControlAffinity? controlAffinity,

  final Color? splashColor,

  final VisualDensity? visualDensity,

  final double? minTileHeight,

  /// Haptic feedback on tap. Material's own default is `true`.
  final bool? enableFeedback,

  /// Cupertino has no off switch, so wrap that one in an [IgnorePointer] instead.
  final bool enabled = kDefaultExpansionTileEnabled,

  final AnimationStyle? expansionAnimationStyle,

  /// Adds semantic annotations for tap events.
  final bool internalAddSemanticForOnTap = kDefaultExpansionTileInternalAddSemanticForOnTap,

  final WidgetStatesController? statesController,
}) {
  /// Creates Material-side settings for [PlatformExpansionTile].
  this;
}

/// Cupertino-side settings for [PlatformExpansionTile], passed as `cupertinoExpansionTileData`. The
/// one field here has no Material counterpart.
final class const CupertinoExpansionTileData({
  /// How the tile animates open and shut.
  final ExpansionTileTransitionMode transitionMode = kDefaultCupertinoExpansionTileTransitionMode,
}) {
  /// Creates Cupertino-side settings for [PlatformExpansionTile].
  this;
}
