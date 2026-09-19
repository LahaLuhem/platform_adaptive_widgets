// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_switch.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialTapTargetSize;

/// Shared-visual fields for [PlatformSwitch], forwarded into both records via `super.x`. Private, never
/// exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformSwitchData({
  /// iOS calls this [CupertinoSwitch.thumbColor], which despite the plain name only covers the switched-on
  /// thumb. See `APPENDIX.md#cross-platform-field-mappings`.
  final Color? activeThumbColor,

  final Color? activeTrackColor,

  final Color? inactiveThumbColor,

  final Color? inactiveTrackColor,

  final Color? focusColor,

  final ImageProvider? activeThumbImage,

  final ImageErrorListener? onActiveThumbImageError,

  final ImageProvider? inactiveThumbImage,

  final ImageErrorListener? onInactiveThumbImageError,

  final WidgetStateProperty<Color?>? trackOutlineColor,

  final WidgetStateProperty<double?>? trackOutlineWidth,

  final WidgetStateProperty<Icon?>? thumbIcon,

  /// iOS takes the property as-is. Android wants one [MouseCursor], so it gets `.resolve({.selected, .hovered, .focused, .disabled})`
  /// first. See `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<MouseCursor>? mouseCursor,
});

/// Material-side settings for [PlatformSwitch], passed as `materialSwitchData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Cupertino
/// counterpart at all.
final class const MaterialSwitchData({
  super.activeThumbColor,
  super.activeTrackColor,
  super.inactiveThumbColor,
  super.inactiveTrackColor,
  super.focusColor,
  super.activeThumbImage,
  super.onActiveThumbImageError,
  super.inactiveThumbImage,
  super.onInactiveThumbImageError,
  super.trackOutlineColor,
  super.trackOutlineWidth,
  super.thumbIcon,
  super.mouseCursor,

  /// The thumb across every state, where the inherited `activeThumbColor` only covers the on state.
  final WidgetStateProperty<Color?>? thumbColor,

  final WidgetStateProperty<Color?>? trackColor,

  final WidgetStateProperty<Color?>? overlayColor,

  final MaterialTapTargetSize? materialTapTargetSize,

  final Color? hoverColor,

  final double? splashRadius,

  final EdgeInsetsGeometry? padding,
}) extends _PlatformSwitchData {
  /// Creates Material-side settings for [PlatformSwitch].
  this;
}

/// Cupertino-side settings for [PlatformSwitch], passed as `cupertinoSwitchData`. The inherited shared-visual
/// fields override the widget's flat ones on this branch, and everything declared here has no Material
/// counterpart at all.
final class const CupertinoSwitchData({
  super.activeThumbColor,
  super.activeTrackColor,
  super.inactiveThumbColor,
  super.inactiveTrackColor,
  super.focusColor,
  super.activeThumbImage,
  super.onActiveThumbImageError,
  super.inactiveThumbImage,
  super.onInactiveThumbImageError,
  super.trackOutlineColor,
  super.trackOutlineWidth,
  super.thumbIcon,
  super.mouseCursor,

  /// Takes colours from the ambient [CupertinoTheme] rather than the switch's own defaults.
  final bool? applyTheme,

  /// Colours the "on" accessibility label, which iOS only draws when the on/off labels setting is on.
  final Color? onLabelColor,

  final Color? offLabelColor,
}) extends _PlatformSwitchData {
  /// Creates Cupertino-side settings for [PlatformSwitch].
  this;
}
