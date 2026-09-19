import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListTile;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTile;

import '/src/models/painting/platform_list_tile_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [ListTile] on Android, [CupertinoListTile] on iOS.
///
/// Per-platform tuning lives in [materialListTileData] / [cupertinoListTileData], and iOS's notched
/// variant is [CupertinoListTileData.isNotched]. See `APPENDIX.md#field-classification`, and `APPENDIX.md#cross-platform-field-mappings`
/// for the fields named differently underneath.
///
/// Example:
/// {@example /example/lib/snippets/painting/platform_list_tile.dart#platform_list_tile}
class const PlatformListTile({
  /// Required, because iOS's is.
  required final Widget title,

  /// Below the title.
  final Widget? subtitle,

  /// Before the title.
  final Widget? leading,

  /// After the title.
  final Widget? trailing,

  /// Optional, since a tile can be there to look at. The `FutureOr<void>` return matches [CupertinoListTile.onTap]
  /// and still fits Material's stricter signature, which just drops the value. See `APPENDIX.md#callback-nullability`.
  // Needed for CupertinoListTile compatibility.
  // ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap,

  /// The way to disable a tile, leaving [onTap] non-null. Material greys the content out, iOS just stops
  /// the tap flicker and long-press feedback, having no disabled look of its own.
  final bool isEnabled = true,

  /// [ListTile.minLeadingWidth] on Android, [CupertinoListTile.leadingSize] on iOS, where it can't be
  /// null and the default depends on the variant.
  final double? leadingWidth,

  /// [ListTile.tileColor] on Android, [CupertinoListTile.backgroundColor] on iOS.
  final Color? color,

  /// [ListTile.contentPadding] on Android, [CupertinoListTile.padding] on iOS.
  final EdgeInsetsGeometry? padding,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialListTileData? materialListTileData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoListTileData? cupertinoListTileData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive list tile.
  this;

  @override
  Widget buildMaterial(BuildContext context) => ListTile(
    key: widgetKey,
    title: title,
    subtitle: subtitle,
    leading: leading,
    trailing: trailing,
    onTap: isEnabled ? onTap : null,
    enabled: isEnabled,
    minLeadingWidth: materialListTileData?.leadingWidth ?? leadingWidth,
    tileColor: materialListTileData?.color ?? color,
    contentPadding: materialListTileData?.padding ?? padding,
    statesController: materialListTileData?.statesController,
    mouseCursor: materialListTileData?.mouseCursor,
    autofocus: materialListTileData?.autofocus ?? kDefaultListTileAutofocus,
    enableFeedback: materialListTileData?.enableFeedback,
    focusColor: materialListTileData?.focusColor,
    focusNode: materialListTileData?.focusNode,
    horizontalTitleGap: materialListTileData?.horizontalTitleGap,
    hoverColor: materialListTileData?.hoverColor,
    iconColor: materialListTileData?.iconColor,
    internalAddSemanticForOnTap:
        materialListTileData?.internalAddSemanticForOnTap ??
        kDefaultListTileInternalAddSemanticForOnTap,
    isThreeLine: materialListTileData?.isThreeLine,
    leadingAndTrailingTextStyle: materialListTileData?.leadingAndTrailingTextStyle,
    minTileHeight: materialListTileData?.minTileHeight,
    minVerticalPadding: materialListTileData?.minVerticalPadding,
    onFocusChange: materialListTileData?.onFocusChange,
    onLongPress: materialListTileData?.onLongPress,
    selected: materialListTileData?.selected ?? kDefaultListTileSelected,
    selectedColor: materialListTileData?.selectedColor,
    selectedTileColor: materialListTileData?.selectedTileColor,
    shape: materialListTileData?.shape,
    splashColor: materialListTileData?.splashColor,
    style: materialListTileData?.style,
    subtitleTextStyle: materialListTileData?.subtitleTextStyle,
    textColor: materialListTileData?.textColor,
    titleAlignment: materialListTileData?.titleAlignment ?? kDefaultListTileTitleAlignment,
    titleTextStyle: materialListTileData?.titleTextStyle,
    visualDensity: materialListTileData?.visualDensity,
  );

  @override
  Widget buildCupertino(BuildContext context) {
    final isNotched = cupertinoListTileData?.isNotched ?? kDefaultCupertinoListTileIsNotched;
    final resolvedLeadingSize =
        cupertinoListTileData?.leadingWidth ??
        leadingWidth ??
        (isNotched
            ? kDefaultCupertinoNotchedListTileLeadingSize
            : kDefaultCupertinoListTileLeadingSize);
    final resolvedLeadingToTitle =
        cupertinoListTileData?.leadingToTitle ??
        (isNotched
            ? kDefaultCupertinoNotchedListTileLeadingToTitle
            : kDefaultCupertinoListTileLeadingToTitle);
    final resolvedOnTap = isEnabled ? onTap : null;
    final resolvedColor = cupertinoListTileData?.color ?? color;
    final resolvedPadding = cupertinoListTileData?.padding ?? padding;

    return isNotched
        ? CupertinoListTile.notched(
            key: widgetKey,
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
            onTap: resolvedOnTap,
            backgroundColor: resolvedColor,
            padding: resolvedPadding,
            leadingSize: resolvedLeadingSize,
            leadingToTitle: resolvedLeadingToTitle,
            additionalInfo: cupertinoListTileData?.additionalInfo,
            backgroundColorActivated: cupertinoListTileData?.backgroundColorActivated,
          )
        : CupertinoListTile(
            key: widgetKey,
            title: title,
            subtitle: subtitle,
            leading: leading,
            trailing: trailing,
            onTap: resolvedOnTap,
            backgroundColor: resolvedColor,
            padding: resolvedPadding,
            leadingSize: resolvedLeadingSize,
            leadingToTitle: resolvedLeadingToTitle,
            additionalInfo: cupertinoListTileData?.additionalInfo,
            backgroundColorActivated: cupertinoListTileData?.backgroundColorActivated,
          );
  }
}
