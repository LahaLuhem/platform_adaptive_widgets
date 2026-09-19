import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoExpansionTile;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ExpansionTile;

import '/src/models/interaction/platform_expansion_tile_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [ExpansionTile] on Android, [CupertinoExpansionTile] on iOS.
///
/// One child, not a list of them, because [CupertinoExpansionTile] takes exactly one. Wrap it in a `Column`
/// yourself for Material's multi-child look. Per-platform tuning lives in [materialExpansionTileData]
/// / [cupertinoExpansionTileData]. See `APPENDIX.md#field-classification`.
///
/// No `isEnabled` here either, since iOS has no disabled state for this. Material's `enabled` sits on
/// [MaterialExpansionTileData], and on iOS an [IgnorePointer] does the job, with an [Opacity] if you
/// want it to look the part too.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_expansion_tile.dart#platform_expansion_tile}
class const PlatformExpansionTile({
  /// The always-visible header.
  required final Widget title,

  /// What the tile reveals when it opens.
  required final Widget child,

  /// Expand and collapse from code, and watch the state. Same type on both platforms.
  final ExpansibleController? controller,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialExpansionTileData? materialExpansionTileData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoExpansionTileData? cupertinoExpansionTileData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive expansion tile.
  this;

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
