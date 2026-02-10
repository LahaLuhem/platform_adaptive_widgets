// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoButtonSize;
import 'package:flutter/material.dart' show ButtonStyle, IconAlignment;
import 'package:flutter/widgets.dart';

const kDefaultAutofocus = false;

abstract final class _PlatformButtonData {
  final Key? widgetKey;
  final bool isEnabled;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;

  final Widget? child;

  const _PlatformButtonData({
    this.isEnabled = true,
    this.onPressed,
    this.widgetKey,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.child,
  });
}

final class MaterialButtonData extends _PlatformButtonData {
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;

  final bool? isSemanticButton;
  final Widget? icon;
  final Widget? label;
  final IconAlignment? iconAlignment;

  /// [child] and ([icon], [label]) are mutually exclusive. They are used to indicate the calling for the different variant of the button.
  /// [child] is used for the normal button-constructors ([useNormalConstructor]).
  /// ([icon], [label]) are used for the `.icon`-constructors ([useNormalConstructor]).
  /// <br>
  /// When [useNormalConstructor] is `true`, [iconAlignment] will be ignored.
  /// When [useIconConstructor] is `true`, [mouseCursor] will be ignored.
  /// [isSemanticButton] seems to be only available for `TextButton`.
  const MaterialButtonData({
    super.isEnabled,
    super.onPressed,
    super.onLongPress,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.child,
    super.widgetKey,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton,
    this.icon,
    this.label,
    this.iconAlignment,
  });

  bool get useNormalConstructor => child != null;

  bool get useIconConstructor => !useNormalConstructor;
}

final class CupertinoButtonData extends _PlatformButtonData {
  final CupertinoButtonSize sizeStyle;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? foregroundColor;
  final Color? disabledColor;
  final Size? minimumSize;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  final AlignmentGeometry alignment;
  final ValueChanged<bool>? onFocusChange;
  final Color? focusColor;

  static const kDefaultSizeStyle = CupertinoButtonSize.large;
  static const kDefaultPressedOpacity = 0.4;
  static const kDefaultAlignment = Alignment.center;

  const CupertinoButtonData({
    super.isEnabled,
    super.onPressed,
    super.onLongPress,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.child,
    super.widgetKey,
    this.sizeStyle = kDefaultSizeStyle,
    this.padding,
    this.color,
    this.foregroundColor,
    this.disabledColor,
    this.minimumSize,
    this.pressedOpacity = kDefaultPressedOpacity,
    this.borderRadius,
    this.alignment = kDefaultAlignment,
    this.onFocusChange,
    this.focusColor,
  });
}
