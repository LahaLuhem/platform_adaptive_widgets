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

/// Internal abstract base holding shared-visual fields for [PlatformCheckbox].
///
/// Inherited by [MaterialCheckboxData] and [CupertinoCheckboxData] so each per-platform record carries
/// the shared-visual surface via `super.x` constructor forwarding. Library-private, never exported
/// from the package. Callers never reference this type directly.
///
/// See `APPENDIX.md#field-classification` for the rule placing shared-visual fields on a private
/// base.
abstract class const _PlatformCheckboxData({
  /// Mouse cursor when hovering over the checkbox.
  final MouseCursor? mouseCursor,

  /// Color of the checkbox when active.
  final Color? activeColor,

  /// Fill color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? fillColor,

  /// Color of the check mark.
  final Color? checkColor,

  /// Color of the checkbox when focused.
  final Color? focusColor,

  /// Shape of the checkbox border.
  final OutlinedBorder? shape,

  /// Border side of the checkbox.
  final BorderSide? side,
});

/// Material-only visual overrides for [PlatformCheckbox].
///
/// Pass this via `PlatformCheckbox.materialCheckboxData` when tuning Material rendering. Inherited
/// shared-visual fields override the widget's flat defaults on the Material branch. The fields declared
/// here have no Cupertino equivalent.
final class const MaterialCheckboxData({
  super.mouseCursor,
  super.activeColor,
  super.fillColor,
  super.checkColor,
  super.focusColor,
  super.shape,
  super.side,

  /// Color when hovering over the checkbox.
  final Color? hoverColor,

  /// Overlay color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor,

  /// Splash radius of the checkbox.
  final double? splashRadius,

  /// Material tap target size.
  ///
  /// Conceptually similar to but distinct from [CupertinoCheckboxData.tapTargetSize]. Material uses
  /// an enum of presets ([MaterialTapTargetSize.shrinkWrap] / `.padded`), Cupertino uses an explicit
  /// [Size]. They are not unified at the widget level.
  final MaterialTapTargetSize? materialTapTargetSize,

  /// Visual density of the checkbox.
  final VisualDensity? visualDensity,

  /// Whether the checkbox is in an error state. Affects rendering.
  final bool isError = kDefaultCheckboxIsError,
}) extends _PlatformCheckboxData {
  /// Creates Material-only visual overrides for [PlatformCheckbox].
  this;
}

/// Cupertino-only visual overrides for [PlatformCheckbox].
///
/// Pass this via `PlatformCheckbox.cupertinoCheckboxData` when tuning Cupertino rendering. Inherited
/// shared-visual fields override the widget's flat defaults on the Cupertino branch. The fields
/// declared here have no Material equivalent.
final class const CupertinoCheckboxData({
  super.mouseCursor,
  super.activeColor,
  super.fillColor,
  super.checkColor,
  super.focusColor,
  super.shape,
  super.side,

  /// Custom tap target size for the checkbox, as an explicit [Size].
  ///
  /// Conceptually similar to but distinct from [MaterialCheckboxData.materialTapTargetSize]. See that
  /// field's dartdoc.
  final Size? tapTargetSize,
}) extends _PlatformCheckboxData {
  /// Creates Cupertino-only visual overrides for [PlatformCheckbox].
  this;
}
