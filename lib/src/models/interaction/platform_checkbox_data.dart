// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_checkbox.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialTapTargetSize, VisualDensity;

/// Default value for [MaterialCheckboxData.isError].
const kDefaultCheckboxIsError = false;

/// Shared-visual fields for [PlatformCheckbox], forwarded into both records via `super.x`. Private,
/// never exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformCheckboxData({
  final MouseCursor? mouseCursor,

  /// Colour while ticked.
  final Color? activeColor,

  /// Fills the box behind the tick.
  final WidgetStateProperty<Color?>? fillColor,

  /// Colours the tick itself.
  final Color? checkColor,

  final Color? focusColor,

  final OutlinedBorder? shape,

  /// Outlines the box.
  final BorderSide? side,
});

/// Material-side settings for [PlatformCheckbox], passed as `materialCheckboxData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Cupertino
/// counterpart at all.
final class const MaterialCheckboxData({
  super.mouseCursor,
  super.activeColor,
  super.fillColor,
  super.checkColor,
  super.focusColor,
  super.shape,
  super.side,

  final Color? hoverColor,

  final WidgetStateProperty<Color?>? overlayColor,

  final double? splashRadius,

  /// A preset, where [CupertinoCheckboxData.tapTargetSize] is an explicit [Size]. Close enough to look
  /// like one field, different enough that the widget keeps them apart.
  final MaterialTapTargetSize? materialTapTargetSize,

  final VisualDensity? visualDensity,

  /// Swaps in the error-state container and tick colours. Material 3 only.
  final bool isError = kDefaultCheckboxIsError,
}) extends _PlatformCheckboxData {
  /// Creates Material-side settings for [PlatformCheckbox].
  this;
}

/// Cupertino-side settings for [PlatformCheckbox], passed as `cupertinoCheckboxData`. The inherited
/// shared-visual fields override the widget's flat ones on this branch, and everything declared here
/// has no Material counterpart at all.
final class const CupertinoCheckboxData({
  super.mouseCursor,
  super.activeColor,
  super.fillColor,
  super.checkColor,
  super.focusColor,
  super.shape,
  super.side,

  /// An explicit [Size], where [MaterialCheckboxData.materialTapTargetSize] is a preset.
  final Size? tapTargetSize,
}) extends _PlatformCheckboxData {
  /// Creates Cupertino-side settings for [PlatformCheckbox].
  this;
}
