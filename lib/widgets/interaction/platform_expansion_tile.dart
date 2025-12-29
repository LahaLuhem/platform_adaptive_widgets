import 'package:flutter/cupertino.dart' show CupertinoExpansionTile;
import 'package:flutter/material.dart' show ExpansionTile;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_expansion_tile_data.dart';
import '/models/platform_widget_base.dart';

class PlatformExpansionTile extends PlatformWidgetKeyedBase {
  final Widget? title;
  final Widget? child;
  final ExpansibleController? controller;

  final MaterialExpansionTileData? materialExpansionTileData;
  final CupertinoExpansionTileData? cupertinoExpansionTileData;

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
    dense: materialExpansionTileData?.dense,
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
