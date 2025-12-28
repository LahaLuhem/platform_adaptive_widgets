// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/material.dart' show ButtonStyle;
import 'package:flutter/widgets.dart';

abstract final class _PlatformSegmentButtonData<T extends Object> {
  final Key? widgetKey;
  final Iterable<T>? choices;
  final Widget Function(T choice)? segmentBuilder;
  final ValueChanged<T?>? onSelectionChanged;
  final T? selectedChoice;

  const _PlatformSegmentButtonData({
    this.choices,
    this.segmentBuilder,
    this.selectedChoice,
    this.onSelectionChanged,
    this.widgetKey,
  });
}

final class MaterialSegmentButtonData<T extends Object> extends _PlatformSegmentButtonData<T> {
  final bool emptySelectionAllowed;
  final EdgeInsets? expandedInsets;
  final ButtonStyle? style;
  final bool showSelectedIcon;
  final Widget? selectedIcon;
  final Axis direction;

  static const kDefaultEmptySelectionAllowed = false;
  static const kDefaultShowSelectedIcon = true;
  static const kDefaultDirection = Axis.horizontal;

  const MaterialSegmentButtonData({
    super.choices,
    super.segmentBuilder,
    super.selectedChoice,
    super.onSelectionChanged,
    super.widgetKey,
    this.emptySelectionAllowed = kDefaultEmptySelectionAllowed,
    this.expandedInsets,
    this.style,
    this.showSelectedIcon = kDefaultShowSelectedIcon,
    this.selectedIcon,
    this.direction = kDefaultDirection,
  });
}

final class CupertinoSegmentButtonData<T extends Object> extends _PlatformSegmentButtonData<T> {
  final Set<T> disabledChildren;
  final Color thumbColor;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final bool proportionalWidth;
  final bool isMomentary;

  static const kDefaultDisabledChildren = <Never>{};
  static const kDefaultThumbColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF636366),
  );
  static const kDefaultPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 3);
  static const kDefaultBackgroundColor = CupertinoColors.tertiarySystemFill;
  static const kDefaultProportionalWidth = false;
  static const kDefaultIsMomentary = false;

  const CupertinoSegmentButtonData({
    super.choices,
    super.segmentBuilder,
    super.selectedChoice,
    super.onSelectionChanged,
    super.widgetKey,
    this.disabledChildren = kDefaultDisabledChildren,
    this.thumbColor = kDefaultThumbColor,
    this.padding = kDefaultPadding,
    this.backgroundColor = kDefaultBackgroundColor,
    this.proportionalWidth = kDefaultProportionalWidth,
    this.isMomentary = kDefaultIsMomentary,
  });
}
