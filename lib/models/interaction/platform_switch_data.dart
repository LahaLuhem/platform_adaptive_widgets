/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show MaterialTapTargetSize;
import 'package:flutter/widgets.dart';

final class PlatformSwitchData {
  final Key? widgetKey;
  final bool isEnabled;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  final Color? activeThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final Color? focusColor;

  final ImageProvider? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageProvider? inactiveThumbImage;
  final ImageErrorListener? onInactiveThumbImageError;

  final WidgetStateProperty<Color?>? trackOutlineColor;
  final WidgetStateProperty<double?>? trackOutlineWidth;
  final WidgetStateProperty<Icon?>? thumbIcon;

  final DragStartBehavior dragStartBehavior;
  final WidgetStateProperty<MouseCursor>? mouseCursor;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;

  static const kDefaultDragStartBehavior = DragStartBehavior.start;
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

final class MaterialSwitchData extends PlatformSwitchData {
  final WidgetStateProperty<Color?>? thumbColor;
  final WidgetStateProperty<Color?>? trackColor;
  final WidgetStateProperty<Color?>? overlayColor;

  final MaterialTapTargetSize? materialTapTargetSize;
  final Color? hoverColor;
  final double? splashRadius;
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

final class CupertinoSwitchData extends PlatformSwitchData {
  final bool? applyTheme;
  final Color? onLabelColor;
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
