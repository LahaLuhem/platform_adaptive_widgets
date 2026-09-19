// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_radio.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialTapTargetSize, VisualDensity;

/// Default value for [CupertinoRadioData.useCheckmarkStyle].
const kDefaultCupertinoRadioUseCheckmarkStyle = false;

/// Shared-visual fields for [PlatformRadio], forwarded into both records via `super.x`. Private, never
/// exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformRadioData({
  /// Colour while selected.
  final Color? activeColor,

  final Color? focusColor,

  final MouseCursor? mouseCursor,

  /// [Radio.fillColor] on Android, which takes the [WidgetStateProperty] as-is. iOS resolves it down
  /// to one [Color] first. See `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<Color?>? fillColor,
});

/// Material-side settings for [PlatformRadio], passed as `materialRadioData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Cupertino
/// counterpart at all.
///
/// Not generic, even though the widget is. None of these depend on the radio's value type, so write
/// `MaterialRadioData(visualDensity: .compact)` and leave the type parameter out.
final class const MaterialRadioData({
  super.activeColor,
  super.focusColor,
  super.mouseCursor,
  super.fillColor,

  final Color? hoverColor,

  final WidgetStateProperty<Color?>? overlayColor,

  final double? splashRadius,

  final MaterialTapTargetSize? materialTapTargetSize,

  final VisualDensity? visualDensity,

  /// Fills the radio circle behind the mark.
  final WidgetStateProperty<Color?>? backgroundColor,

  /// Outlines the radio circle.
  final BorderSide? side,

  /// Sizes the filled mark inside the circle.
  final WidgetStateProperty<double?>? innerRadius,
}) extends _PlatformRadioData {
  /// Creates Material-side settings for [PlatformRadio].
  this;
}

/// Cupertino-side settings for [PlatformRadio], passed as `cupertinoRadioData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Material
/// counterpart at all.
///
/// Not generic, even though the widget is. None of these depend on the radio's value type.
final class const CupertinoRadioData({
  super.activeColor,
  super.focusColor,
  super.mouseCursor,
  super.fillColor,

  /// Colour while *not* selected. Material works this out from the theme instead.
  final Color? inactiveColor,

  /// Draws a checkmark when selected instead of filling the inner circle.
  final bool useCheckmarkStyle = kDefaultCupertinoRadioUseCheckmarkStyle,
}) extends _PlatformRadioData {
  /// Creates Cupertino-side settings for [PlatformRadio].
  this;
}
