import 'package:flutter/material.dart' show SemanticFormatterCallback, SliderInteraction;
import 'package:flutter/widgets.dart';

/// Platform-shared configuration for a slider widget.
///
/// Contains common properties used by both Material and Cupertino sliders.
final class PlatformSliderData {
  /// Key applied to the underlying platform widget.
  final Key? widgetKey;

  /// Current value of the slider.
  final double? value;

  /// Whether the slider is enabled.
  final bool isEnabled;

  /// Callback when the slider value changes.
  final ValueChanged<double>? onChanged;

  /// Callback when the user starts dragging the slider.
  final ValueChanged<double>? onChangeStart;

  /// Callback when the user stops dragging the slider.
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value of the slider.
  final double min;

  /// Maximum value of the slider.
  final double max;

  /// Number of discrete divisions on the slider.
  final int? divisions;

  /// Color of the active portion of the slider track.
  final Color? activeColor;

  /// Color of the slider thumb.
  final Color? thumbColor;

  /// Default value for [min].
  static const kDefaultMin = 0.0;

  /// Default value for [max].
  static const kDefaultMax = 1.0;

  /// Creates platform slider configuration.
  const PlatformSliderData({
    this.value,
    this.onChanged,
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

/// Material-specific configuration for a slider widget.
///
/// Extends [PlatformSliderData] with Material-only properties.
final class MaterialSliderData extends PlatformSliderData {
  /// Value for the secondary track (e.g., buffered progress).
  final double? secondaryTrackValue;

  /// Label displayed above the thumb.
  final String? label;

  /// Color of the inactive portion of the slider track.
  final Color? inactiveColor;

  /// Color of the secondary active track.
  final Color? secondaryActiveColor;

  /// Overlay color as a [WidgetStateProperty].
  final WidgetStateProperty<Color>? overlayColor;

  /// Mouse cursor when hovering over the slider.
  final MouseCursor? mouseCursor;

  /// Callback for formatting the semantic value.
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// Focus node for the slider.
  final FocusNode? focusNode;

  /// Whether the slider should autofocus.
  final bool autofocus;

  /// Allowed interaction type for the slider.
  final SliderInteraction? allowedInteraction;

  /// Padding around the slider.
  final EdgeInsetsGeometry? padding;

  /// Default value for [autofocus].
  static const kDefaultAutofocus = false;

  /// Creates Material-specific slider configuration.
  const MaterialSliderData({
    super.value,
    super.onChanged,
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
