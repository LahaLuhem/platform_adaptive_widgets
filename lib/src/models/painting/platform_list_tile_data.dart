// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/painting/platform_list_tile.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ListTileStyle, ListTileTitleAlignment, VisualDensity;

/// Default value for [MaterialListTileData.autofocus].
const kDefaultListTileAutofocus = false;

/// Default value for [MaterialListTileData.internalAddSemanticForOnTap].
const kDefaultListTileInternalAddSemanticForOnTap = false;

/// Default value for [MaterialListTileData.selected].
const kDefaultListTileSelected = false;

/// Default value for [MaterialListTileData.titleAlignment].
const kDefaultListTileTitleAlignment = ListTileTitleAlignment.threeLine;

/// Leading size for the base Cupertino [PlatformListTile], used when `leadingWidth` is `null`.
///
/// Mirrors Flutter's private `_kLeadingSize`. Recheck on SDK bumps, nothing warns us when it moves.
const kDefaultCupertinoListTileLeadingSize = 28.0;

/// Leading-to-title gap for the base Cupertino [PlatformListTile].
///
/// Mirrors Flutter's private `_kLeadingToTitle`. Recheck on SDK bumps.
const kDefaultCupertinoListTileLeadingToTitle = 16.0;

/// Leading size for the notched Cupertino [PlatformListTile] ([CupertinoListTile.notched]).
///
/// Mirrors Flutter's private `_kNotchedLeadingSize`. Recheck on SDK bumps. Notched and base differ here,
/// and an older version of this package used base's numbers for both, quietly breaking the notched look.
const kDefaultCupertinoNotchedListTileLeadingSize = 30.0;

/// Leading-to-title gap for the notched Cupertino [PlatformListTile].
///
/// Mirrors Flutter's private `_kNotchedLeadingToTitle`. Recheck on SDK bumps.
const kDefaultCupertinoNotchedListTileLeadingToTitle = 12.0;

/// Default value for [CupertinoListTileData.isNotched].
const kDefaultCupertinoListTileIsNotched = false;

/// Shared-visual fields for [PlatformListTile], forwarded into both records via `super.x`. Private,
/// never exported. The names diverge across platforms, so see `APPENDIX.md#field-classification` and
/// `APPENDIX.md#cross-platform-field-mappings`.
abstract class const _PlatformListTileData({
  /// [ListTile.minLeadingWidth] on Android, [CupertinoListTile.leadingSize] on iOS, where it can't be
  /// null and the default depends on the variant.
  final double? leadingWidth,

  /// [ListTile.tileColor] on Android, [CupertinoListTile.backgroundColor] on iOS.
  final Color? color,

  /// [ListTile.contentPadding] on Android, [CupertinoListTile.padding] on iOS.
  final EdgeInsetsGeometry? padding,
});

/// Material-side settings for [PlatformListTile], passed as `materialListTileData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Cupertino
/// counterpart at all.
final class const MaterialListTileData({
  super.leadingWidth,
  super.color,
  super.padding,

  final WidgetStatesController? statesController,

  final MouseCursor? mouseCursor,

  final bool autofocus = kDefaultListTileAutofocus,

  /// Haptic feedback on tap.
  final bool? enableFeedback,

  final Color? focusColor,

  final FocusNode? focusNode,

  /// Measured from the leading content's edge. [CupertinoListTileData.leadingToTitle] looks like the
  /// same thing but measures from the leading edge and defaults per variant, so the 2 stay separate.
  /// See `APPENDIX.md#field-classification`.
  final double? horizontalTitleGap,

  final Color? hoverColor,

  /// Colours the leading and trailing icons.
  final Color? iconColor,

  /// Adds semantic annotations for tap events.
  final bool internalAddSemanticForOnTap = kDefaultListTileInternalAddSemanticForOnTap,

  final bool? isThreeLine,

  final TextStyle? leadingAndTrailingTextStyle,

  final double? minTileHeight,

  final double? minVerticalPadding,

  final ValueChanged<bool>? onFocusChange,

  final VoidCallback? onLongPress,

  final bool selected = kDefaultListTileSelected,

  /// Colours the selected tile's text and icons. [selectedTileColor] does its background.
  final Color? selectedColor,

  final Color? selectedTileColor,

  final ShapeBorder? shape,

  /// Colours the ink splash.
  final Color? splashColor,

  /// Material's text styling preset.
  final ListTileStyle? style,

  final TextStyle? subtitleTextStyle,

  final Color? textColor,

  final ListTileTitleAlignment titleAlignment = kDefaultListTileTitleAlignment,

  final TextStyle? titleTextStyle,

  final VisualDensity? visualDensity,
}) extends _PlatformListTileData {
  /// Creates Material-side settings for [PlatformListTile].
  this;
}

/// Cupertino-side settings for [PlatformListTile], passed as `cupertinoListTileData`. The inherited
/// shared-visual fields override the widget's flat ones on this branch, and everything declared here
/// has no Material counterpart at all.
///
/// [isNotched] lives here rather than as a `.notched()` constructor on the widget, since Material renders
/// the same either way and a named constructor would imply the choice means something on both platforms.
final class const CupertinoListTileData({
  super.leadingWidth,
  super.color,
  super.padding,

  /// An extra widget in the trailing area. Material's tile has no such slot.
  final Widget? additionalInfo,

  /// Background colour while a tap is in flight.
  final Color? backgroundColorActivated,

  /// Measured from the leading edge, unlike [MaterialListTileData.horizontalTitleGap]. Leave it `null`
  /// and [isNotched] picks between [kDefaultCupertinoListTileLeadingToTitle] and [kDefaultCupertinoNotchedListTileLeadingToTitle]
  /// at build time.
  final double? leadingToTitle,

  /// Renders [CupertinoListTile.notched] instead of the plain [CupertinoListTile], which mostly changes
  /// the default geometry.
  final bool isNotched = kDefaultCupertinoListTileIsNotched,
}) extends _PlatformListTileData {
  /// Creates Cupertino-side settings for [PlatformListTile].
  this;
}
