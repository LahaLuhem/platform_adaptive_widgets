import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoListTile;
import 'package:flutter/material.dart' show ListTile;
import 'package:flutter/widgets.dart';

import '/models/painting/platform_list_tile_data.dart';
import '/models/platform_widget_base.dart';

/// A platform-adaptive list tile that renders Material ListTile on Android
/// and CupertinoListTile on iOS.
///
/// This widget automatically selects the appropriate list tile implementation based on the target platform:
/// - On Android: renders Material Design ListTile
/// - On iOS: renders CupertinoListTile
///
/// The list tile can be configured with platform-specific data through [materialListTileData]
/// and [cupertinoListTileData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformListTile(
///   title: Text('Settings'),
///   leading: Icon(Icons.settings),
///   onTap: () => print('Tapped settings'),
/// )
/// ```
class PlatformListTile extends PlatformWidgetKeyedBase {
  /// The primary title of the list tile.
  final Widget? title;

  /// The subtitle of the list tile.
  final Widget? subtitle;

  /// The widget to display before the title.
  final Widget? leading;

  /// The widget to display after the title.
  final Widget? trailing;

  /// Callback when the list tile is tapped.
  ///
  // Needed for CupertinoListTile compatibility.
  //ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap;

  /// Width of the leading widget.
  ///
  /// Corresponds to `minLeadingWidth` for [ListTile] and `leadingSize` for [CupertinoListTile].
  final double? leadingWidth;

  /// Background color of the list tile.
  ///
  /// Corresponds to `tileColor` for [ListTile] and `backgroundColor` for [CupertinoListTile].
  final Color? color;

  /// Padding around the list tile content.
  final EdgeInsetsGeometry? padding;

  /// Material-specific list tile data.
  final MaterialListTileData? materialListTileData;

  /// Cupertino-specific list tile data.
  final CupertinoListTileData? cupertinoListTileData;

  /// [leadingWidth] corresponds to `minLeadingWidth` for [ListTile] and `leadingSize` for [CupertinoListTile]. Purely convenience.
  /// [color] corresponds to `tileColor` for [ListTile] and `backgroundColor` for [CupertinoListTile].
  const PlatformListTile({
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.leadingWidth,
    this.color,
    this.padding,
    this.materialListTileData,
    this.cupertinoListTileData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => ListTile(
    key: materialListTileData?.widgetKey ?? widgetKey,
    title: materialListTileData?.title ?? title,
    subtitle: materialListTileData?.subtitle ?? subtitle,
    leading: materialListTileData?.leading ?? leading,
    trailing: materialListTileData?.trailing ?? trailing,
    onTap: materialListTileData?.onTap ?? onTap,
    minLeadingWidth: materialListTileData?.leadingWidth ?? leadingWidth,
    tileColor: materialListTileData?.color ?? color,
    contentPadding: materialListTileData?.padding ?? padding,
    statesController: materialListTileData?.statesController,
    mouseCursor: materialListTileData?.mouseCursor,
    autofocus: materialListTileData?.autofocus ?? MaterialListTileData.kDefaultAutoFocus,
    enabled: materialListTileData?.enabled ?? MaterialListTileData.kDefaultEnabled,
    enableFeedback: materialListTileData?.enableFeedback,
    focusColor: materialListTileData?.focusColor,
    focusNode: materialListTileData?.focusNode,
    horizontalTitleGap: materialListTileData?.horizontalTitleGap,
    hoverColor: materialListTileData?.hoverColor,
    iconColor: materialListTileData?.iconColor,
    internalAddSemanticForOnTap:
        materialListTileData?.internalAddSemanticForOnTap ??
        MaterialListTileData.kDefaultInternalAddSemanticForOnTap,
    isThreeLine: materialListTileData?.isThreeLine,
    leadingAndTrailingTextStyle: materialListTileData?.leadingAndTrailingTextStyle,
    minTileHeight: materialListTileData?.minTileHeight,
    minVerticalPadding: materialListTileData?.minVerticalPadding,
    onFocusChange: materialListTileData?.onFocusChange,
    onLongPress: materialListTileData?.onLongPress,
    selected: materialListTileData?.selected ?? MaterialListTileData.kDefaultSelected,
    selectedColor: materialListTileData?.selectedColor,
    selectedTileColor: materialListTileData?.selectedTileColor,
    shape: materialListTileData?.shape,
    splashColor: materialListTileData?.splashColor,
    style: materialListTileData?.style,
    subtitleTextStyle: materialListTileData?.subtitleTextStyle,
    textColor: materialListTileData?.textColor,
    titleAlignment: materialListTileData?.titleAlignment,
    titleTextStyle: materialListTileData?.titleTextStyle,
    visualDensity: materialListTileData?.visualDensity,
  );

  @override
  Widget buildCupertino(BuildContext context) => (cupertinoListTileData?.isNotched ?? false)
      ? CupertinoListTile.notched(
          key: cupertinoListTileData?.widgetKey ?? widgetKey,
          title: cupertinoListTileData?.title ?? title!,
          subtitle: cupertinoListTileData?.subtitle ?? subtitle,
          leading: cupertinoListTileData?.leading ?? leading,
          trailing: cupertinoListTileData?.trailing ?? trailing,
          onTap: cupertinoListTileData?.onTap ?? onTap,
          leadingSize:
              cupertinoListTileData?.leadingWidth ??
              leadingWidth ??
              CupertinoListTileData.kDefaultLeadingSize,
          backgroundColor: cupertinoListTileData?.color ?? color,
          padding: cupertinoListTileData?.padding ?? padding,
          additionalInfo: cupertinoListTileData?.additionalInfo,
          backgroundColorActivated: cupertinoListTileData?.backgroundColorActivated,
          leadingToTitle:
              cupertinoListTileData?.leadingToTitle ?? CupertinoListTileData.kDefaultLeadingToTitle,
        )
      : CupertinoListTile(
          key: cupertinoListTileData?.widgetKey ?? widgetKey,
          title: cupertinoListTileData?.title ?? title!,
          subtitle: cupertinoListTileData?.subtitle ?? subtitle,
          leading: cupertinoListTileData?.leading ?? leading,
          trailing: cupertinoListTileData?.trailing ?? trailing,
          onTap: cupertinoListTileData?.onTap ?? onTap,
          leadingSize:
              cupertinoListTileData?.leadingWidth ??
              leadingWidth ??
              CupertinoListTileData.kDefaultLeadingSize,
          backgroundColor: cupertinoListTileData?.color ?? color,
          padding: cupertinoListTileData?.padding ?? padding,
          additionalInfo: cupertinoListTileData?.additionalInfo,
          backgroundColorActivated: cupertinoListTileData?.backgroundColorActivated,
          leadingToTitle:
              cupertinoListTileData?.leadingToTitle ?? CupertinoListTileData.kDefaultLeadingToTitle,
        );
}
