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

final class MaterialListTileData extends _PlatformListTileData {
  final WidgetStatesController? statesController;
  final MouseCursor? mouseCursor;
  final bool? dense;
  final bool autofocus;
  final bool enabled;
  final bool? enableFeedback;
  final Color? focusColor;
  final FocusNode? focusNode;
  final double? horizontalTitleGap;
  final Color? hoverColor;
  final Color? iconColor;
  final bool internalAddSemanticForOnTap;
  final bool? isThreeLine;
  final TextStyle? leadingAndTrailingTextStyle;
  final double? minTileHeight;
  final double? minVerticalPadding;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onLongPress;
  final bool selected;
  final Color? selectedColor;
  final Color? selectedTileColor;
  final ShapeBorder? shape;
  final Color? splashColor;
  final ListTileStyle? style;
  final TextStyle? subtitleTextStyle;
  final Color? textColor;
  final ListTileTitleAlignment titleAlignment;
  final TextStyle? titleTextStyle;
  final VisualDensity? visualDensity;

  static const kDefaultAutoFocus = false;
  static const kDefaultEnabled = true;
  static const kDefaultInternalAddSemanticForOnTap = false;
  static const kDefaultSelected = false;

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
    this.dense,
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

final class CupertinoListTileData extends _PlatformListTileData {
  final Widget? additionalInfo;
  final Color? backgroundColorActivated;
  final double leadingToTitle;

  final bool isNotched;

  static const kDefaultLeadingSize = 28.0;
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
