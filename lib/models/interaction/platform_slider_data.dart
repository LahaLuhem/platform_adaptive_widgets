import 'package:flutter/material.dart' show SemanticFormatterCallback, SliderInteraction;
import 'package:flutter/widgets.dart';

final class PlatformSliderData {
  final Key? widgetKey;
  final double value;
  final bool isEnabled;
  final ValueChanged<double> onChanged;

  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? thumbColor;

  static const kDefaultMin = 0.0;
  static const kDefaultMax = 1.0;

  const PlatformSliderData({
    required this.value,
    required this.onChanged,
    this.widgetKey,
    this.isEnabled = true,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = kDefaultMin,
    this.max = kDefaultMax,
    this.divisions,
    this.activeColor,
    this.thumbColor,
  });
}

final class MaterialSliderData extends PlatformSliderData {
  final double? secondaryTrackValue;
  final String? label;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final WidgetStateProperty<Color>? overlayColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;
  final SliderInteraction? allowedInteraction;
  final EdgeInsetsGeometry? padding;

  static const kDefaultAutofocus = false;

  const MaterialSliderData({
    required super.value,
    required super.onChanged,
    super.widgetKey,
    super.isEnabled,
    super.onChangeStart,
    super.onChangeEnd,
    super.min,
    super.max,
    super.divisions,
    super.activeColor,
    super.thumbColor,
    this.secondaryTrackValue,
    this.label,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.allowedInteraction,
    this.padding,
  });
}
