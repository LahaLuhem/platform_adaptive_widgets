// Multiple data classes in one file; private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_radio.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialTapTargetSize, VisualDensity;

/// Default value for [CupertinoRadioData.useCheckmarkStyle].
const kDefaultCupertinoRadioUseCheckmarkStyle = false;

/// Internal abstract base holding shared-visual fields for [PlatformRadio].
///
/// Inherited by [MaterialRadioData] and [CupertinoRadioData] so each
/// per-platform record carries the shared-visual surface via `super.x`
/// constructor forwarding. Library-private — never exported from the
/// package.
///
/// Not generic on the radio's value type: the shared-visual fields are all
/// independent of `T`, so the data classes stay un-parameterised even
/// though [PlatformRadio] itself is `PlatformRadio<T>`.
///
/// See `APPENDIX.md#field-classification` for the rule placing shared-visual
/// fields on a private base.
abstract class _PlatformRadioData {
  /// Colour applied when the radio is selected.
  final Color? activeColor;

  /// Colour applied when the radio is focused.
  final Color? focusColor;

  /// Cursor displayed when hovering over the radio.
  final MouseCursor? mouseCursor;

  /// Fill colour for the radio's inner mark.
  ///
  /// Maps to [Radio.fillColor] on Android directly (the underlying widget
  /// already accepts a [WidgetStateProperty]) and to
  /// [CupertinoRadio.fillColor] on iOS after resolving to a single
  /// [Color]. See `APPENDIX.md#cross-platform-field-mappings` for the
  /// resolution policy.
  final WidgetStateProperty<Color?>? fillColor;

  const _PlatformRadioData({this.activeColor, this.focusColor, this.mouseCursor, this.fillColor});
}

/// Material-only configuration for [PlatformRadio].
///
/// Pass this via `PlatformRadio.materialRadioData` when tuning Material
/// rendering. Inherited shared-visual fields override the widget's flat
/// defaults on the Material branch; the fields declared here have no
/// Cupertino equivalent.
///
/// Not generic on the radio's value type — these are all visual / interaction
/// fields independent of `T`. Pass directly: `MaterialRadioData(visualDensity:
/// .compact)`, without spelling the type parameter.
final class MaterialRadioData extends _PlatformRadioData {
  /// Colour applied when hovering over the radio.
  final Color? hoverColor;

  /// Overlay colour as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Splash radius of the radio's tap response.
  final double? splashRadius;

  /// Tap target sizing rule.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Visual density of the radio.
  final VisualDensity? visualDensity;

  /// Background colour for the radio circle as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? backgroundColor;

  /// Border side of the radio circle.
  final BorderSide? side;

  /// Inner-radius of the radio circle as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? innerRadius;

  /// Creates Material-only configuration for [PlatformRadio].
  const MaterialRadioData({
    super.activeColor,
    super.focusColor,
    super.mouseCursor,
    super.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.backgroundColor,
    this.side,
    this.innerRadius,
  });
}

/// Cupertino-only configuration for [PlatformRadio].
///
/// Pass this via `PlatformRadio.cupertinoRadioData` when tuning Cupertino
/// rendering. Inherited shared-visual fields override the widget's flat
/// defaults on the Cupertino branch; the fields declared here have no
/// Material equivalent.
///
/// Not generic on the radio's value type — these are all visual fields
/// independent of `T`.
final class CupertinoRadioData extends _PlatformRadioData {
  /// Colour applied when the radio is **not** selected. Cupertino-only —
  /// Material's `Radio` derives the inactive look from theme.
  final Color? inactiveColor;

  /// Whether to render a checkmark glyph instead of a filled inner circle
  /// when selected. Cupertino-only. Defaults to
  /// [kDefaultCupertinoRadioUseCheckmarkStyle].
  final bool useCheckmarkStyle;

  /// Creates Cupertino-only configuration for [PlatformRadio].
  const CupertinoRadioData({
    super.activeColor,
    super.focusColor,
    super.mouseCursor,
    super.fillColor,
    this.inactiveColor,
    this.useCheckmarkStyle = kDefaultCupertinoRadioUseCheckmarkStyle,
  });
}
