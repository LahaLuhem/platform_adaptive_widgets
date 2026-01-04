import 'package:flutter/material.dart' show MaterialTapTargetSize, VisualDensity;
import 'package:flutter/widgets.dart';

typedef ValueAndButton<T extends Object> = ({T value, Widget button});

final class PlatformRadioGroupData<T extends Object> {
  final T groupValue;
  final Iterable<T> groupValues;
  final Widget Function(List<ValueAndButton<T>> valuesAndRadioButtons) groupBuilder;
  final ValueChanged<T?> onChanged;

  const PlatformRadioGroupData({
    required this.groupValue,
    required this.groupValues,
    required this.groupBuilder,
    required this.onChanged,
  });
}

final class PlatformRadioData<T> {
  final Key? widgetKey;
  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final RadioGroupRegistry<T>? groupRegistry;

  static const kDefaultToggleable = false;
  static const kDefaultAutofocus = false;
  static const kDefaultEnabled = true;

  const PlatformRadioData({
    this.widgetKey,
    this.mouseCursor,
    this.toggleable = kDefaultToggleable,
    this.activeColor,
    this.focusColor,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.enabled = kDefaultEnabled,
    this.groupRegistry,
  });
}

final class MaterialRadioData<T> extends PlatformRadioData<T> {
  final WidgetStateProperty<Color?>? fillColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final WidgetStateProperty<Color?>? backgroundColor;
  final BorderSide? side;
  final WidgetStateProperty<double?>? innerRadius;

  const MaterialRadioData({
    super.widgetKey,
    super.mouseCursor,
    super.toggleable,
    super.activeColor,
    super.focusColor,
    super.focusNode,
    super.autofocus,
    super.enabled,
    super.groupRegistry,
    this.fillColor,
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

final class CupertinoRadioData<T> extends PlatformRadioData<T> {
  final Color? inactiveColor;
  final Color? fillColor;
  final bool useCheckmarkStyle;

  static const kDefaultUseCheckmarkStyle = false;

  const CupertinoRadioData({
    super.widgetKey,
    super.mouseCursor,
    super.toggleable,
    super.activeColor,
    super.focusColor,
    super.focusNode,
    super.autofocus,
    super.enabled,
    super.groupRegistry,
    this.inactiveColor,
    this.fillColor,
    this.useCheckmarkStyle = kDefaultUseCheckmarkStyle,
  });
}
