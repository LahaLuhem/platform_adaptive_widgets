// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_slider.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show SemanticFormatterCallback, ShowValueIndicator, SliderInteraction;

/// Default value for [MaterialSliderData.autofocus].
const kDefaultSliderAutofocus = false;

/// Thumb colour the Cupertino branch falls back to.
///
/// `CupertinoSlider.thumbColor` can't be null and hard-codes this value, without exposing a constant
/// for it, so we keep our own copy.
const kDefaultCupertinoSliderThumbColor = CupertinoColors.white;

/// Shared-visual fields for [PlatformSlider], forwarded into both records via `super.x`. Private, never
/// exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformSliderData({
  /// Colours the filled part of the track, not the thumb.
  final Color? activeColor,

  /// [Slider.thumbColor] on Android falls through to the theme when `null`. [CupertinoSlider.thumbColor]
  /// can't be null, so iOS swaps in [kDefaultCupertinoSliderThumbColor]. See `APPENDIX.md#cross-platform-field-mappings`.
  final Color? thumbColor,
});

/// Material-side settings for [PlatformSlider], passed as `materialSliderData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Cupertino
/// counterpart at all.
final class const MaterialSliderData({
  super.activeColor,
  super.thumbColor,

  /// A second track drawn behind the first, for things like buffered progress.
  final double? secondaryTrackValue,

  /// Shown above the thumb while dragging.
  final String? label,

  /// Colours the unfilled part of the track.
  final Color? inactiveColor,

  final Color? secondaryActiveColor,

  final WidgetStateProperty<Color?>? overlayColor,

  final MouseCursor? mouseCursor,

  /// Rewrites the value screen readers announce.
  final SemanticFormatterCallback? semanticFormatterCallback,

  final FocusNode? focusNode,

  final bool autofocus = kDefaultSliderAutofocus,

  /// Whether the slider takes drags, taps, or both.
  final SliderInteraction? allowedInteraction,

  final EdgeInsetsGeometry? padding,

  /// When the [label] above the thumb shows up. `null` leaves it to the theme.
  final ShowValueIndicator? showValueIndicator,
}) extends _PlatformSliderData {
  /// Creates Material-side settings for [PlatformSlider].
  this;
}

/// Cupertino-side settings for [PlatformSlider], passed as `cupertinoSliderData`.
///
/// Looks empty because [CupertinoSlider] has nothing of its own beyond the shared fields. It's here
/// so you can retune [activeColor] / [thumbColor] on iOS without touching Android.
final class const CupertinoSliderData({super.activeColor, super.thumbColor})
    extends _PlatformSliderData {
  /// Creates Cupertino-side settings for [PlatformSlider].
  this;
}
