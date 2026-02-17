/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
// ignore_for_file: prefer-match-file-name

library;

import 'dart:async';

import 'package:flutter/material.dart' show ListTileStyle, ListTileTitleAlignment, VisualDensity;
import 'package:flutter/widgets.dart';

abstract final class _PlatformListTileData {
  final Key? widgetKey;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  // Needed for CupertinoListTile
  //ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap;
  final double? leadingWidth;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  /// [color] corresponds to `tileColor` for [ListTile] and `backgroundColor` for [CupertinoListTile].
  /// [leadingWidth] corresponds to `minLeadingWidth` for [ListTile] and `leadingSize` for [CupertinoListTile]. Purely convenience.
  const _PlatformListTileData({
    this.widgetKey,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.leadingWidth,
    this.color,
    this.padding,
  });
}

/// Material-specific configuration for platform list tiles.
///
/// Contains properties specific to Material ListTile for Android platforms.
/// Extends the base platform list tile data with Material-only styling and behavior options.
final class MaterialListTileData extends _PlatformListTileData {
  /// Controller for managing the tile's states.
  final WidgetStatesController? statesController;

  /// The cursor to display when hovering over the tile.
  final MouseCursor? mouseCursor;

  /// Whether the tile should autofocus when possible.
  final bool autofocus;

  /// Whether the tile is enabled and interactive.
  final bool enabled;

  /// Whether to enable haptic feedback on tap.
  final bool? enableFeedback;

  /// Color of the tile when focused.
  final Color? focusColor;

  /// Focus node for the tile.
  final FocusNode? focusNode;

  /// Horizontal gap between title and subtitle.
  final double? horizontalTitleGap;

  /// Color of the tile when hovered.
  final Color? hoverColor;

  /// Color of the leading and trailing icons.
  final Color? iconColor;

  /// Whether to add semantic annotations for tap events.
  final bool? internalAddSemanticForOnTap;

  /// Whether to display the tile with three lines of text.
  final bool? isThreeLine;

  /// Text style for leading and trailing widgets.
  final TextStyle? leadingAndTrailingTextStyle;

  /// Minimum height of the tile.
  final double? minTileHeight;

  /// Minimum vertical padding of the tile.
  final double? minVerticalPadding;

  /// Callback when the tile gains or loses focus.
  final ValueChanged<bool>? onFocusChange;

  /// Callback when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the tile is currently selected.
  final bool selected;

  /// Color of the selected tile.
  final Color? selectedColor;

  /// Background color of the selected tile.
  final Color? selectedTileColor;

  /// Shape border of the tile.
  final ShapeBorder? shape;

  /// Color of the tile's splash effect.
  final Color? splashColor;

  /// Material styling for the tile.
  final ListTileStyle? style;

  /// Text style for the subtitle.
  final TextStyle? subtitleTextStyle;

  /// Text color for the tile content.
  final Color? textColor;

  /// Alignment of the title within the tile.
  final ListTileTitleAlignment titleAlignment;

  /// Text style for the title.
  final TextStyle? titleTextStyle;

  /// Visual density of the tile.
  final VisualDensity? visualDensity;

  /// Default value for autofocus.
  static const kDefaultAutoFocus = false;

  /// Default value for enabled state.
  static const kDefaultEnabled = true;

  /// Default value for semantic annotations on tap.
  static const kDefaultInternalAddSemanticForOnTap = false;

  /// Default value for selected state.
  static const kDefaultSelected = false;

  /// Creates Material-specific list tile configuration.
  ///
  /// Extends the base platform list tile data with Material-only styling properties.
  const MaterialListTileData({
    super.widgetKey,
    super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.onTap,
    super.leadingWidth,
    super.color,
    super.padding,
    this.statesController,
    this.mouseCursor,
    this.autofocus = kDefaultAutoFocus,
    this.enabled = kDefaultEnabled,
    this.enableFeedback,
    this.focusColor,
    this.focusNode,
    this.horizontalTitleGap,
    this.hoverColor,
    this.iconColor,
    this.internalAddSemanticForOnTap = kDefaultInternalAddSemanticForOnTap,
    this.isThreeLine,
    this.leadingAndTrailingTextStyle,
    this.minTileHeight,
    this.minVerticalPadding,
    this.onFocusChange,
    this.onLongPress,
    this.selected = kDefaultSelected,
    this.selectedColor,
    this.selectedTileColor,
    this.shape,
    this.splashColor,
    this.style,
    this.subtitleTextStyle,
    this.textColor,
    this.titleAlignment = ListTileTitleAlignment.threeLine,
    this.titleTextStyle,
    this.visualDensity,
  });
}

/// Cupertino-specific configuration for a platform list tile.
final class CupertinoListTileData extends _PlatformListTileData {
  /// Additional information widget displayed below the title.
  final Widget? additionalInfo;

  /// Background color of the tile when activated.
  final Color? backgroundColorActivated;

  /// Horizontal gap between leading widget and title.
  final double leadingToTitle;

  /// Whether the tile is notched.
  final bool isNotched;

  /// Default value for [leadingToTitle].
  static const kDefaultLeadingSize = 28.0;

  /// Default value for [leadingToTitle].
  static const kDefaultLeadingToTitle = 16.0;

  /// [isNotched] is used signify [CupertinoListTile.notched] behavior.
  const CupertinoListTileData({
    super.widgetKey,
    super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.onTap,
    super.leadingWidth,
    super.color,
    super.padding,
    this.additionalInfo,
    this.backgroundColorActivated,
    this.leadingToTitle = kDefaultLeadingToTitle,
    this.isNotched = false,
  });
}
