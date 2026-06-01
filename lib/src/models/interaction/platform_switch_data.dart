// Multiple data classes in one file; private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_switch.dart';
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialTapTargetSize;

/// Default value for [PlatformSwitch.dragStartBehavior].
const kDefaultSwitchDragStartBehavior = DragStartBehavior.start;

/// Default value for [PlatformSwitch.autofocus].
const kDefaultSwitchAutofocus = false;

/// Internal abstract base holding shared-visual fields for [PlatformSwitch].
///
/// Inherited by [MaterialSwitchData] and [CupertinoSwitchData] so each
/// per-platform record carries the shared-visual surface via `super.x`
/// constructor forwarding. Library-private — never exported from the
/// package; callers never reference this type directly.
///
/// See `APPENDIX.md#field-classification` for the rule placing
/// shared-visual fields on a private base.
abstract class _PlatformSwitchData {
  /// Color of the thumb when the switch is active.
  ///
  /// Maps to [CupertinoSwitch.thumbColor] on iOS (Cupertino's `thumbColor`
  /// represents the active-state thumb color). See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Color? activeThumbColor;

  /// Color of the track when the switch is active.
  final Color? activeTrackColor;

  /// Color of the thumb when the switch is inactive.
  final Color? inactiveThumbColor;

  /// Color of the track when the switch is inactive.
  final Color? inactiveTrackColor;

  /// Color of the switch when focused.
  final Color? focusColor;

  /// Image displayed on the thumb when the switch is active.
  final ImageProvider? activeThumbImage;

  /// Error listener for the active thumb image.
  ///
  /// Tightly coupled to [activeThumbImage]; classified as shared visual
  /// rather than functional per the carve-out in
  /// `APPENDIX.md#field-classification`.
  final ImageErrorListener? onActiveThumbImageError;

  /// Image displayed on the thumb when the switch is inactive.
  final ImageProvider? inactiveThumbImage;

  /// Error listener for the inactive thumb image.
  ///
  /// Tightly coupled to [inactiveThumbImage]; classified as shared visual
  /// rather than functional per the carve-out in
  /// `APPENDIX.md#field-classification`.
  final ImageErrorListener? onInactiveThumbImageError;

  /// Track outline color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? trackOutlineColor;

  /// Track outline width as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? trackOutlineWidth;

  /// Thumb icon as a [WidgetStateProperty].
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Mouse cursor as a [WidgetStateProperty].
  ///
  /// On Android the value is resolved to a single [MouseCursor] via
  /// `.resolve({.selected, .hovered, .focused, .disabled})` before being
  /// passed to [Switch.mouseCursor]. On iOS the value is forwarded to
  /// [CupertinoSwitch.mouseCursor] as-is. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<MouseCursor>? mouseCursor;

  const _PlatformSwitchData({
    this.activeThumbColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.focusColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.mouseCursor,
  });
}

/// Material-only visual overrides for [PlatformSwitch].
///
/// Pass this via `PlatformSwitch.materialSwitchData` when tuning Material
/// rendering. Inherited shared-visual fields override the widget's flat
/// defaults on the Material branch; the fields declared here have no
/// Cupertino equivalent.
final class MaterialSwitchData extends _PlatformSwitchData {
  /// Thumb color as a [WidgetStateProperty]. Distinct from the inherited
  /// `activeThumbColor` — this is the full state-property surface that
  /// Material exposes for the thumb across every widget state.
  final WidgetStateProperty<Color?>? thumbColor;

  /// Track color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? trackColor;

  /// Overlay color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Material tap target size.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Color when hovering over the switch.
  final Color? hoverColor;

  /// Splash radius of the switch.
  final double? splashRadius;

  /// Padding around the switch. No Cupertino equivalent.
  final EdgeInsetsGeometry? padding;

  /// Creates Material-only visual overrides for [PlatformSwitch].
  const MaterialSwitchData({
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
    this.thumbColor,
    this.trackColor,
    this.overlayColor,
    this.materialTapTargetSize,
    this.hoverColor,
    this.splashRadius,
    this.padding,
  });
}

/// Cupertino-only visual overrides for [PlatformSwitch].
///
/// Pass this via `PlatformSwitch.cupertinoSwitchData` when tuning Cupertino
/// rendering. Inherited shared-visual fields override the widget's flat
/// defaults on the Cupertino branch; the fields declared here have no
/// Material equivalent.
final class CupertinoSwitchData extends _PlatformSwitchData {
  /// Whether to apply the Cupertino theme to the switch.
  final bool? applyTheme;

  /// Color of the "on" label.
  final Color? onLabelColor;

  /// Color of the "off" label.
  final Color? offLabelColor;

  /// Creates Cupertino-only visual overrides for [PlatformSwitch].
  const CupertinoSwitchData({
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
    this.applyTheme,
    this.onLabelColor,
    this.offLabelColor,
  });
}
