// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ButtonStyle;

/// Common configuration for platform-adaptive segmented buttons.
abstract final class _PlatformSegmentButtonData<T extends Object> {
  /// A key to identify the widget.
  final Key? widgetKey;

  /// The choices to display in the segmented button.
  final Iterable<T>? choices;

  /// A builder for the segments.
  final Widget Function(T choice)? segmentBuilder;

  /// A callback for when the selected choice changes.
  final ValueChanged<T?>? onSelectionChanged;

  /// The currently selected choice.
  final T? selectedChoice;

  /// Creates a [_PlatformSegmentButtonData].
  const _PlatformSegmentButtonData({
    this.choices,
    this.segmentBuilder,
    this.selectedChoice,
    this.onSelectionChanged,
    this.widgetKey,
  });
}

/// Material-specific configuration for a segmented button.
///
/// Maps to properties of `SegmentedButton` on Android.
final class MaterialSegmentButtonData<T extends Object> extends _PlatformSegmentButtonData<T> {
  /// Whether an empty selection is allowed.
  final bool emptySelectionAllowed;

  /// Insets applied when the button is expanded.
  final EdgeInsets? expandedInsets;

  /// Button style for the segments.
  final ButtonStyle? style;

  /// Whether to show an icon on the selected segment.
  final bool showSelectedIcon;

  /// Icon displayed on the selected segment.
  final Widget? selectedIcon;

  /// Layout direction of the segments.
  final Axis direction;

  /// Default value for [emptySelectionAllowed].
  static const kDefaultEmptySelectionAllowed = false;

  /// Default value for [showSelectedIcon].
  static const kDefaultShowSelectedIcon = true;

  /// Default value for [direction].
  static const kDefaultDirection = Axis.horizontal;

  /// Creates Material-specific segmented button configuration.
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

/// Cupertino-specific configuration for a segmented control.
///
/// Maps to properties of `CupertinoSlidingSegmentedControl` on iOS.
final class CupertinoSegmentButtonData<T extends Object> extends _PlatformSegmentButtonData<T> {
  /// Set of disabled segment values.
  final Set<T> disabledChildren;

  /// Color of the sliding thumb.
  final Color thumbColor;

  /// Padding around the segmented control.
  final EdgeInsetsGeometry padding;

  /// Background color of the segmented control.
  final Color backgroundColor;

  /// Whether segments have proportional widths.
  final bool proportionalWidth;

  /// Whether the selection is momentary (resets after tap).
  final bool isMomentary;

  /// Default value for [disabledChildren].
  static const kDefaultDisabledChildren = <Never>{};

  /// Default value for [thumbColor].
  static const kDefaultThumbColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF636366),
  );

  /// Default value for [padding].
  static const kDefaultPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 3);

  /// Default value for [backgroundColor].
  static const kDefaultBackgroundColor = CupertinoColors.tertiarySystemFill;

  /// Default value for [proportionalWidth].
  static const kDefaultProportionalWidth = false;

  /// Default value for [isMomentary].
  static const kDefaultIsMomentary = false;

  /// Creates Cupertino-specific segmented button configuration.
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
