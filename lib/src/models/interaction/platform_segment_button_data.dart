// Per-platform records for PlatformSegmentButton (no shared private base, the
// Material and Cupertino visual surfaces don't overlap).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
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

/// Thumb colour for the Cupertino branch of [PlatformSegmentButton].
///
/// Mirrors Flutter's private `_kThumbColor`. Recheck on SDK bumps, nothing warns us when it moves.
const kDefaultCupertinoSegmentButtonThumbColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFFFFFF),
  darkColor: Color(0xFF636366),
);

/// Padding for the Cupertino branch of [PlatformSegmentButton].
///
/// Mirrors Flutter's private `_kHorizontalItemPadding`. Recheck on SDK bumps.
const kDefaultCupertinoSegmentButtonPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 3);

/// Default value for [CupertinoSegmentButtonData.backgroundColor].
const kDefaultCupertinoSegmentButtonBackgroundColor = CupertinoColors.tertiarySystemFill;

/// Default value for [CupertinoSegmentButtonData.proportionalWidth].
const kDefaultCupertinoSegmentButtonProportionalWidth = false;

/// Default value for [CupertinoSegmentButtonData.isMomentary].
const kDefaultCupertinoSegmentButtonIsMomentary = false;

/// Material-side settings for [PlatformSegmentButton], passed as `materialSegmentButtonData`. Everything
/// declared here has no Cupertino counterpart at all.
///
/// Not generic, even though the widget is. None of these depend on the segment value type, so write
/// `MaterialSegmentButtonData(direction: .vertical)` and leave the type parameter out. Multi-select
/// is deliberately missing, and [PlatformSegmentButton]'s own dartdoc says why.
final class const MaterialSegmentButtonData({
  /// Applied to every segment.
  final ButtonStyle? style,

  /// Shown on the selected segment.
  final Widget? selectedIcon,

  /// Only read when the button lays out full-width.
  final EdgeInsets? expandedInsets,

  /// Lets a tap on the selected segment clear the selection. Cupertino has nothing like it, though [CupertinoSegmentButtonData.isMomentary]
  /// covers the tap-then-reset case.
  final bool emptySelectionAllowed = kDefaultSegmentButtonEmptySelectionAllowed,

  /// Draws a tick on the selected segment.
  final bool showSelectedIcon = kDefaultSegmentButtonShowSelectedIcon,

  /// Cupertino's sliding control is always horizontal, so this is Material's alone.
  final Axis direction = kDefaultSegmentButtonDirection,
}) {
  /// Creates Material-side settings for [PlatformSegmentButton].
  this;
}

/// Cupertino-side settings for [PlatformSegmentButton], passed as `cupertinoSegmentButtonData`. Everything
/// declared here has no Material counterpart at all.
///
/// Generic only because [disabledChildren] is a `Set<T>`. Most call sites infer `T` from the surrounding
/// `PlatformSegmentButton<T>` and never spell it.
final class const CupertinoSegmentButtonData<T extends Object>({
  /// Which segments can't be tapped. Material has no per-segment switch, since upstream puts `enabled`
  /// on [ButtonSegment] and this package doesn't surface that yet.
  final Set<T> disabledChildren = kDefaultCupertinoSegmentButtonDisabledChildren,

  /// The sliding thumb behind the selected segment.
  final Color thumbColor = kDefaultCupertinoSegmentButtonThumbColor,

  final EdgeInsetsGeometry padding = kDefaultCupertinoSegmentButtonPadding,

  final Color backgroundColor = kDefaultCupertinoSegmentButtonBackgroundColor,

  /// Sizes each segment to its own content instead of splitting the width evenly.
  final bool proportionalWidth = kDefaultCupertinoSegmentButtonProportionalWidth,

  /// Clears the selection again right after each tap.
  final bool isMomentary = kDefaultCupertinoSegmentButtonIsMomentary,
}) {
  /// Creates Cupertino-side settings for [PlatformSegmentButton].
  this;
}
