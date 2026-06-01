// Per-platform records for PlatformSegmentButton (no shared private base — the
// Material and Cupertino visual surfaces don't overlap).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_segment_button.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ButtonStyle;

/// Default value for [MaterialSegmentButtonData.emptySelectionAllowed].
const kDefaultSegmentButtonEmptySelectionAllowed = false;

/// Default value for [MaterialSegmentButtonData.showSelectedIcon].
const kDefaultSegmentButtonShowSelectedIcon = true;

/// Default value for [MaterialSegmentButtonData.direction].
const kDefaultSegmentButtonDirection = Axis.horizontal;

/// Default value for [CupertinoSegmentButtonData.disabledChildren].
const kDefaultCupertinoSegmentButtonDisabledChildren = <Never>{};

/// Default thumb colour for the Cupertino branch of [PlatformSegmentButton].
///
/// Mirrors Flutter's private `_kThumbColor` in
/// `package:flutter/src/cupertino/sliding_segmented_control.dart`. Re-validate on
/// Flutter SDK bumps — the upstream constant is private.
const kDefaultCupertinoSegmentButtonThumbColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFFFFFF),
  darkColor: Color(0xFF636366),
);

/// Default padding for the Cupertino branch of [PlatformSegmentButton].
///
/// Mirrors Flutter's private `_kHorizontalItemPadding` in
/// `package:flutter/src/cupertino/sliding_segmented_control.dart`. Re-validate on
/// Flutter SDK bumps — the upstream constant is private.
const kDefaultCupertinoSegmentButtonPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 3);

/// Default value for [CupertinoSegmentButtonData.backgroundColor].
const kDefaultCupertinoSegmentButtonBackgroundColor = CupertinoColors.tertiarySystemFill;

/// Default value for [CupertinoSegmentButtonData.proportionalWidth].
const kDefaultCupertinoSegmentButtonProportionalWidth = false;

/// Default value for [CupertinoSegmentButtonData.isMomentary].
const kDefaultCupertinoSegmentButtonIsMomentary = false;

/// Material-only configuration for [PlatformSegmentButton].
///
/// Pass this via `PlatformSegmentButton.materialSegmentButtonData` when tuning Material
/// rendering. The fields declared here have no Cupertino equivalent.
///
/// Not generic on the segment value type — none of these fields reference `T`. Pass
/// directly: `MaterialSegmentButtonData(direction: .vertical)`, without spelling the
/// type parameter.
///
/// **No multi-select** — see [PlatformSegmentButton]'s class dartdoc for why
/// [SegmentedButton.multiSelectionEnabled] / `Set<T>` selection state are intentionally
/// not surfaced.
final class MaterialSegmentButtonData {
  /// Button style applied to each segment.
  final ButtonStyle? style;

  /// Icon displayed on the selected segment.
  final Widget? selectedIcon;

  /// Insets applied when the segmented button is laid out in an expanded (full-width)
  /// configuration.
  final EdgeInsets? expandedInsets;

  /// Whether tapping the currently-selected segment is allowed to clear the selection.
  /// Functional, Material-only — Cupertino has no equivalent "empty selection"
  /// affordance (use [CupertinoSegmentButtonData.isMomentary] for tap-resets-after).
  /// Defaults to [kDefaultSegmentButtonEmptySelectionAllowed].
  final bool emptySelectionAllowed;

  /// Whether to show a check-mark glyph on the selected segment. Functional,
  /// Material-only. Defaults to [kDefaultSegmentButtonShowSelectedIcon].
  final bool showSelectedIcon;

  /// Layout direction. Material-only — Cupertino's sliding segmented control is always
  /// horizontal. Defaults to [kDefaultSegmentButtonDirection].
  final Axis direction;

  /// Creates Material-only configuration for [PlatformSegmentButton].
  const MaterialSegmentButtonData({
    this.style,
    this.selectedIcon,
    this.expandedInsets,
    this.emptySelectionAllowed = kDefaultSegmentButtonEmptySelectionAllowed,
    this.showSelectedIcon = kDefaultSegmentButtonShowSelectedIcon,
    this.direction = kDefaultSegmentButtonDirection,
  });
}

/// Cupertino-only configuration for [PlatformSegmentButton].
///
/// Pass this via `PlatformSegmentButton.cupertinoSegmentButtonData` when tuning
/// Cupertino rendering. The fields declared here have no Material equivalent.
///
/// Generic on the segment value type because [disabledChildren] is a `Set<T>`. Type
/// inference handles most call sites (`CupertinoSegmentButtonData(thumbColor: …)`
/// infers `T` from the surrounding `PlatformSegmentButton<T>`'s slot).
final class CupertinoSegmentButtonData<T extends Object> {
  /// Subset of segment values that should be disabled (un-tappable). Functional,
  /// Cupertino-only — Material's [SegmentedButton] has no per-segment-disabled list
  /// (per-segment `enabled` lives on [ButtonSegment], which the package doesn't
  /// currently surface). Defaults to [kDefaultCupertinoSegmentButtonDisabledChildren].
  final Set<T> disabledChildren;

  /// Colour of the sliding thumb behind the selected segment. Defaults to
  /// [kDefaultCupertinoSegmentButtonThumbColor].
  final Color thumbColor;

  /// Padding around the segmented control. Defaults to
  /// [kDefaultCupertinoSegmentButtonPadding].
  final EdgeInsetsGeometry padding;

  /// Background colour of the segmented control. Defaults to
  /// [kDefaultCupertinoSegmentButtonBackgroundColor].
  final Color backgroundColor;

  /// Whether segments size proportionally to their content. Functional,
  /// Cupertino-only. Defaults to [kDefaultCupertinoSegmentButtonProportionalWidth].
  final bool proportionalWidth;

  /// Whether the selection resets after each tap (momentary behaviour). Functional,
  /// Cupertino-only. Defaults to [kDefaultCupertinoSegmentButtonIsMomentary].
  final bool isMomentary;

  /// Creates Cupertino-only configuration for [PlatformSegmentButton].
  const CupertinoSegmentButtonData({
    this.disabledChildren = kDefaultCupertinoSegmentButtonDisabledChildren,
    this.thumbColor = kDefaultCupertinoSegmentButtonThumbColor,
    this.padding = kDefaultCupertinoSegmentButtonPadding,
    this.backgroundColor = kDefaultCupertinoSegmentButtonBackgroundColor,
    this.proportionalWidth = kDefaultCupertinoSegmentButtonProportionalWidth,
    this.isMomentary = kDefaultCupertinoSegmentButtonIsMomentary,
  });
}
