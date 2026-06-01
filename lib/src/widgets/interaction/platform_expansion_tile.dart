import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoExpansionTile;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ExpansionTile;

import '/src/models/interaction/platform_expansion_tile_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive expansion tile that renders Material [ExpansionTile] on
/// Android and [CupertinoExpansionTile] on iOS.
///
/// All functional inputs (title content, child content, expansion controller) live as
/// flat constructor parameters. Per-platform visual + behavioural tuning is opt-in via
/// [materialExpansionTileData] and [cupertinoExpansionTileData]. See
/// `APPENDIX.md#field-classification`.
///
/// Single-child only — [CupertinoExpansionTile] has no multi-child slot. Callers
/// wanting Material's multi-child layout wrap with `Column` at the call site
/// (`child: Column(children: [...])`). See `APPENDIX.md#cross-platform-field-mappings`
/// for the `child` ↔ `children` mapping.
///
/// No `isEnabled` flag — [CupertinoExpansionTile] has no built-in disabled state.
/// Material's `enabled` lives on [MaterialExpansionTileData]; for Cupertino, wrap with
/// [IgnorePointer] (or [Opacity] for a faded-out look).
///
/// Example:
/// ```dart
/// PlatformExpansionTile(
///   title: const Text('Settings'),
///   child: const Text('Settings content'),
/// )
/// ```
class PlatformExpansionTile extends PlatformWidgetKeyedBase {
  /// Primary content of the tile header.
  ///
  /// Required non-null — both [ExpansionTile.title] and [CupertinoExpansionTile.title]
  /// require non-null upstream.
  final Widget title;

  /// Content shown when the tile is expanded.
  ///
  /// Required non-null — [CupertinoExpansionTile.child] requires it. Material wraps it
  /// as `[child]` for its `children:` slot. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Widget child;

  /// Optional controller for programmatic expand / collapse + state observation.
  /// Same [ExpansibleController] type on both platforms.
  final ExpansibleController? controller;

  /// Material-only visual + functional overrides. Optional.
  final MaterialExpansionTileData? materialExpansionTileData;

  /// Cupertino-only visual + functional overrides. Optional.
  final CupertinoExpansionTileData? cupertinoExpansionTileData;

  /// Creates a platform-adaptive expansion tile.
  const PlatformExpansionTile({
    required this.title,
    required this.child,
    this.controller,
    this.materialExpansionTileData,
    this.cupertinoExpansionTileData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => ExpansionTile(
    key: widgetKey,
    title: title,
    controller: controller,
    onExpansionChanged: materialExpansionTileData?.onExpansionChanged,
    leading: materialExpansionTileData?.leading,
    subtitle: materialExpansionTileData?.subtitle,
    trailing: materialExpansionTileData?.trailing,
    showTrailingIcon:
        materialExpansionTileData?.showTrailingIcon ?? kDefaultExpansionTileShowTrailingIcon,
    initiallyExpanded:
        materialExpansionTileData?.initiallyExpanded ?? kDefaultExpansionTileInitiallyExpanded,
    maintainState: materialExpansionTileData?.maintainState ?? kDefaultExpansionTileMaintainState,
    tilePadding: materialExpansionTileData?.tilePadding,
    expandedCrossAxisAlignment: materialExpansionTileData?.expandedCrossAxisAlignment,
    expandedAlignment: materialExpansionTileData?.expandedAlignment,
    childrenPadding: materialExpansionTileData?.childrenPadding,
    backgroundColor: materialExpansionTileData?.backgroundColor,
    collapsedBackgroundColor: materialExpansionTileData?.collapsedBackgroundColor,
    textColor: materialExpansionTileData?.textColor,
    collapsedTextColor: materialExpansionTileData?.collapsedTextColor,
    iconColor: materialExpansionTileData?.iconColor,
    collapsedIconColor: materialExpansionTileData?.collapsedIconColor,
    shape: materialExpansionTileData?.shape,
    collapsedShape: materialExpansionTileData?.collapsedShape,
    clipBehavior: materialExpansionTileData?.clipBehavior,
    controlAffinity: materialExpansionTileData?.controlAffinity,
    splashColor: materialExpansionTileData?.splashColor,
    visualDensity: materialExpansionTileData?.visualDensity,
    minTileHeight: materialExpansionTileData?.minTileHeight,
    enableFeedback: materialExpansionTileData?.enableFeedback,
    enabled: materialExpansionTileData?.enabled ?? kDefaultExpansionTileEnabled,
    expansionAnimationStyle: materialExpansionTileData?.expansionAnimationStyle,
    internalAddSemanticForOnTap:
        materialExpansionTileData?.internalAddSemanticForOnTap ??
        kDefaultExpansionTileInternalAddSemanticForOnTap,
    statesController: materialExpansionTileData?.statesController,
    children: [child],
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoExpansionTile(
    key: widgetKey,
    title: title,
    controller: controller,
    transitionMode:
        cupertinoExpansionTileData?.transitionMode ?? kDefaultCupertinoExpansionTileTransitionMode,
    child: child,
  );
}
