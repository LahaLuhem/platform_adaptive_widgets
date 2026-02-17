import 'package:flutter/cupertino.dart' show CupertinoExpansionTile;
import 'package:flutter/material.dart' show ExpansionTile;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_expansion_tile_data.dart';
import '/models/platform_widget_base.dart';

/// A platform-adaptive expansion tile that renders Material ExpansionTile on Android
/// and CupertinoExpansionTile on iOS.
///
/// This widget automatically selects the appropriate expansion tile implementation based on the target platform:
/// - On Android: renders Material Design ExpansionTile
/// - On iOS: renders CupertinoExpansionTile
///
/// The expansion tile can be configured with platform-specific data through [materialExpansionTileData]
/// and [cupertinoExpansionTileData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformExpansionTile(
///   title: Text('Settings'),
///   child: ListTile(
///     leading: Icon(Icons.settings),
///     title: Text('Advanced Settings'),
///   ),
/// )
/// ```
class PlatformExpansionTile extends PlatformWidgetKeyedBase {
  /// The title widget displayed on the expansion tile.
  final Widget? title;

  /// The child widget that is shown when the tile is expanded.
  final Widget? child;

  /// Controller for managing the expansion state.
  final ExpansibleController? controller;

  /// Material-specific expansion tile data.
  final MaterialExpansionTileData? materialExpansionTileData;

  /// Cupertino-specific expansion tile data.
  final CupertinoExpansionTileData? cupertinoExpansionTileData;

  /// Creates a platform-adaptive expansion tile.
  ///
  /// The expansion tile will render as a Material ExpansionTile on Android and a CupertinoExpansionTile on iOS.
  const PlatformExpansionTile({
    this.title,
    this.child,
    this.controller,
    this.materialExpansionTileData,
    this.cupertinoExpansionTileData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => ExpansionTile(
    key: materialExpansionTileData?.widgetKey ?? widgetKey,
    title: materialExpansionTileData?.title ?? title!,
    controller: materialExpansionTileData?.controller ?? controller,
    onExpansionChanged: materialExpansionTileData?.onExpansionChanged,
    leading: materialExpansionTileData?.leading,
    subtitle: materialExpansionTileData?.subtitle,
    trailing: materialExpansionTileData?.trailing,
    showTrailingIcon:
        materialExpansionTileData?.showTrailingIcon ??
        MaterialExpansionTileData.kDefaultShowTrailingIcon,
    initiallyExpanded:
        materialExpansionTileData?.initiallyExpanded ??
        MaterialExpansionTileData.kDefaultInitiallyExpanded,
    maintainState:
        materialExpansionTileData?.maintainState ?? MaterialExpansionTileData.kDefaultMaintainState,
    tilePadding: materialExpansionTileData?.tilePadding,
    expandedCrossAxisAlignment:
        materialExpansionTileData?.expandedCrossAxisAlignment ??
        MaterialExpansionTileData.kDefaultExpandedCrossAxisAlignment,
    expandedAlignment:
        materialExpansionTileData?.expandedAlignment ??
        MaterialExpansionTileData.kDefaultExpandedAlignment,
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
    enabled: materialExpansionTileData?.enabled ?? MaterialExpansionTileData.kDefaultEnabled,
    expansionAnimationStyle: materialExpansionTileData?.expansionAnimationStyle,
    internalAddSemanticForOnTap:
        materialExpansionTileData?.internalAddSemanticForOnTap ??
        MaterialExpansionTileData.kDefaultInternalAddSemanticForOnTap,
    children: materialExpansionTileData?.children ?? [?child],
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoExpansionTile(
    key: cupertinoExpansionTileData?.widgetKey ?? widgetKey,
    title: cupertinoExpansionTileData?.title ?? title!,
    controller: cupertinoExpansionTileData?.controller ?? controller,
    transitionMode:
        cupertinoExpansionTileData?.transitionMode ??
        CupertinoExpansionTileData.kDefaultTransitionMode,
    child: cupertinoExpansionTileData?.child ?? child!,
  );
}
