import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListTile;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTile;

import '/src/models/painting/platform_list_tile_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive list tile that renders Material [ListTile] on Android
/// and [CupertinoListTile] on iOS.
///
/// All functional inputs (content slots, callbacks, state-gating) and
/// shared visual defaults live as flat constructor parameters. Per-platform
/// visual + functional tuning is opt-in via [materialListTileData] and
/// [cupertinoListTileData]. See `APPENDIX.md#field-classification` for the
/// classification rule and `APPENDIX.md#cross-platform-field-mappings` for
/// fields whose underlying parameter name or type diverges from the
/// package's unified surface ([title], [leadingWidth], [color], [padding]).
///
/// To render the Cupertino notched variant ([CupertinoListTile.notched]),
/// set [CupertinoListTileData.isNotched] to `true`. Material renders
/// identically regardless.
///
/// Example:
/// ```dart
/// PlatformListTile(
///   title: const Text('Settings'),
///   leading: const Icon(Icons.settings),
///   onTap: () => print('Tapped settings'),
/// )
/// ```
class PlatformListTile extends PlatformWidgetKeyedBase {
  /// Primary title of the tile.
  ///
  /// Required non-null — Cupertino's [CupertinoListTile.title] is a
  /// required `Widget`. See `APPENDIX.md#cross-platform-field-mappings`.
  final Widget title;

  /// Optional subtitle displayed below the title.
  final Widget? subtitle;

  /// Optional widget displayed before the title.
  final Widget? leading;

  /// Optional widget displayed after the title.
  final Widget? trailing;

  /// Optional callback fired when the tile is tapped.
  ///
  /// Nullable per the optional-callback rule in
  /// `APPENDIX.md#callback-nullability` — list tiles can be display-only.
  /// The broader `FutureOr<void>` return type matches Cupertino's
  /// [CupertinoListTile.onTap]; it is assignable to Material's stricter
  /// `void Function()?` (return values discard).
  // Needed for CupertinoListTile compatibility.
  // ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap;

  /// Whether the tile is enabled and responds to taps.
  ///
  /// When `false`:
  /// - Material: the tile receives `enabled: false` AND `onTap: null` —
  ///   the disabled-state visuals (greyed text + icon) apply.
  /// - Cupertino: the tile receives `onTap: null`, suppressing the
  ///   short-tap flicker and long-press activation feedback that
  ///   [CupertinoListTile] applies when `onTap` is set.
  ///
  /// The package's [onTap] field stays non-null regardless. See
  /// `APPENDIX.md#callback-nullability`.
  final bool isEnabled;

  /// Width of the leading widget slot.
  ///
  /// Maps to [ListTile.minLeadingWidth] on Android and to
  /// [CupertinoListTile.leadingSize] on iOS (Cupertino is non-null with
  /// per-variant defaults — see [kDefaultCupertinoListTileLeadingSize] /
  /// [kDefaultCupertinoNotchedListTileLeadingSize]). Shared visual —
  /// overridable per platform via [materialListTileData] /
  /// [cupertinoListTileData]. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final double? leadingWidth;

  /// Background colour of the tile.
  ///
  /// Maps to [ListTile.tileColor] on Android and to
  /// [CupertinoListTile.backgroundColor] on iOS. Shared visual. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Color? color;

  /// Padding around the tile content.
  ///
  /// Maps to [ListTile.contentPadding] on Android and to
  /// [CupertinoListTile.padding] on iOS. Shared visual. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final EdgeInsetsGeometry? padding;

  /// Material-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Material branch; Material-only fields (focus, hover,
  /// selection state, text styles, splash, long-press, etc.) are read only
  /// from here.
  final MaterialListTileData? materialListTileData;

  /// Cupertino-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Cupertino branch; Cupertino-only fields
  /// (`additionalInfo`, `backgroundColorActivated`, `leadingToTitle`,
  /// `isNotched`) are read only from here.
  final CupertinoListTileData? cupertinoListTileData;

  /// Creates a platform-adaptive list tile.
  const PlatformListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isEnabled = true,
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
