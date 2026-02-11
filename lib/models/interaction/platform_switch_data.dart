/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show MaterialTapTargetSize;
import 'package:flutter/widgets.dart';

/// Platform-shared configuration for a switch widget.
///
/// Contains common properties used by both [Switch] and [CupertinoSwitch].
final class PlatformSwitchData {
  /// Key applied to the underlying platform widget.
  final Key? widgetKey;

  /// Whether the switch is enabled.
  final bool isEnabled;

  /// Current value of the switch.
  final bool? value;

  /// Callback when the switch value changes.
  final ValueChanged<bool>? onChanged;

  /// Color of the thumb when the switch is active.
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
  final ImageErrorListener? onActiveThumbImageError;

  /// Image displayed on the thumb when the switch is inactive.
  final ImageProvider? inactiveThumbImage;

  /// Error listener for the inactive thumb image.
  final ImageErrorListener? onInactiveThumbImageError;

  /// Track outline color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? trackOutlineColor;

  /// Track outline width as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? trackOutlineWidth;

  /// Thumb icon as a [WidgetStateProperty].
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Drag start behavior for the switch.
  final DragStartBehavior dragStartBehavior;

  /// Mouse cursor as a [WidgetStateProperty].
  final WidgetStateProperty<MouseCursor>? mouseCursor;

  /// Focus node for the switch.
  final FocusNode? focusNode;

  /// Callback when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Whether the switch should autofocus.
  final bool autofocus;

  /// Default value for [dragStartBehavior].
  static const kDefaultDragStartBehavior = DragStartBehavior.start;

  /// Default value for [autofocus].
  static const kDefaultAutofocus = false;

  /// [isEnabled] is a convenience property for setting [onChanged] == null automatically.
  /// [activeThumbColor] is used for `thumbColor` property of [CupertinoSwitch].
  /// [mouseCursor] is not proxied through a [WidgetStateProperty] for [Switch]. It is defined by matching the same template/behaviour.
  const PlatformSwitchData({
    this.value,
    this.onChanged,
    this.isEnabled = true,
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
    this.dragStartBehavior = kDefaultDragStartBehavior,
    this.mouseCursor,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = kDefaultAutofocus,
    this.widgetKey,
  });
}

/// Material-specific configuration for a switch widget.
///
/// Extends [PlatformSwitchData] with Material-only properties.
final class MaterialSwitchData extends PlatformSwitchData {
  /// Thumb color as a [WidgetStateProperty].
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

  /// Padding around the switch.
  final EdgeInsetsGeometry? padding;

  /// [isEnabled] is a convenience property for setting [onChanged] == null automatically.
  /// [mouseCursor] is not proxied through a [WidgetStateProperty] for [Switch]. It is defined by matching the same template/behaviour.
  const MaterialSwitchData({
    super.value,
    super.onChanged,
    super.widgetKey,
    super.isEnabled,
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
    super.dragStartBehavior,
    super.mouseCursor,
    super.focusNode,
    super.onFocusChange,
    super.autofocus,
    this.thumbColor,
    this.trackColor,
    this.overlayColor,
    this.materialTapTargetSize,
    this.hoverColor,
    this.splashRadius,
    this.padding,
  });
}

/// Cupertino-specific configuration for a switch widget.
///
/// Extends [PlatformSwitchData] with Cupertino-only properties.
final class CupertinoSwitchData extends PlatformSwitchData {
  /// Whether to apply the Cupertino theme to the switch.
  final bool? applyTheme;

  /// Color of the "on" label.
  final Color? onLabelColor;

  /// Color of the "off" label.
  final Color? offLabelColor;

  /// [isEnabled] is a convenience property for setting [onChanged] == null automatically.
  /// [activeThumbColor] is synonymous with `thumbColor` property of [CupertinoSwitch].
  const CupertinoSwitchData({
    super.value,
    super.onChanged,
    super.widgetKey,
    super.isEnabled,
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
    super.dragStartBehavior,
    super.mouseCursor,
    super.focusNode,
    super.onFocusChange,
    super.autofocus,
    this.applyTheme,
    this.onLabelColor,
    this.offLabelColor,
  });
}
