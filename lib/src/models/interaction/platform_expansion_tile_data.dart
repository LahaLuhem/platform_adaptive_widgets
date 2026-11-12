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

/// Default value for [MaterialExpansionTileData.showTrailingIcon]. Matches upstream.
const kDefaultExpansionTileShowTrailingIcon = true;

/// Default value for [MaterialExpansionTileData.enableFeedback]. Matches upstream.
const kDefaultExpansionTileEnableFeedback = true;

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

  /// Forwards to [ExpansionTile.leading].
  final Widget? leading,

  /// Forwards to [ExpansionTile.subtitle].
  final Widget? subtitle,

  /// Usually the expand/collapse chevron.
  final Widget? trailing,

  /// Forwards to [ExpansionTile.showTrailingIcon].
  final bool showTrailingIcon = kDefaultExpansionTileShowTrailingIcon,

  /// Forwards to [ExpansionTile.initiallyExpanded].
  final bool initiallyExpanded = kDefaultExpansionTileInitiallyExpanded,

  /// Keeps the children in the tree while collapsed, so they hold their state.
  final bool maintainState = kDefaultExpansionTileMaintainState,

  /// Around the header, where [childrenPadding] wraps the expanded part.
  final EdgeInsetsGeometry? tilePadding,

  /// Forwards to [ExpansionTile.expandedCrossAxisAlignment].
  final CrossAxisAlignment? expandedCrossAxisAlignment,

  /// Forwards to [ExpansionTile.expandedAlignment].
  final AlignmentGeometry? expandedAlignment,

  /// Forwards to [ExpansionTile.childrenPadding].
  final EdgeInsetsGeometry? childrenPadding,

  /// Forwards to [ExpansionTile.backgroundColor].
  final Color? backgroundColor,

  /// Forwards to [ExpansionTile.collapsedBackgroundColor].
  final Color? collapsedBackgroundColor,

  /// Forwards to [ExpansionTile.textColor].
  final Color? textColor,

  /// Forwards to [ExpansionTile.collapsedTextColor].
  final Color? collapsedTextColor,

  /// Forwards to [ExpansionTile.iconColor].
  final Color? iconColor,

  /// Forwards to [ExpansionTile.collapsedIconColor].
  final Color? collapsedIconColor,

  /// Forwards to [ExpansionTile.shape].
  final ShapeBorder? shape,

  /// Forwards to [ExpansionTile.collapsedShape].
  final ShapeBorder? collapsedShape,

  /// Forwards to [ExpansionTile.clipBehavior].
  final Clip? clipBehavior,

  /// Which end the expand/collapse control sits at.
  final ListTileControlAffinity? controlAffinity,

  /// Forwards to [ExpansionTile.splashColor].
  final Color? splashColor,

  /// Forwards to [ExpansionTile.visualDensity].
  final VisualDensity? visualDensity,

  /// {@macro material_ui.ListTile.minTileHeight}
  final double? minTileHeight,

  /// Haptic feedback on tap. `null` reads `ListTileTheme`'s.
  final bool? enableFeedback = kDefaultExpansionTileEnableFeedback,

  /// Cupertino has no off switch, so wrap that one in an [IgnorePointer] instead.
  final bool enabled = kDefaultExpansionTileEnabled,

  /// Forwards to [ExpansionTile.expansionAnimationStyle].
  final AnimationStyle? expansionAnimationStyle,

  /// Adds semantic annotations for tap events.
  final bool internalAddSemanticForOnTap = kDefaultExpansionTileInternalAddSemanticForOnTap,

  /// Forwards to [ExpansionTile.statesController].
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
