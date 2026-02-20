import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialTapTargetSize, VisualDensity;

/// A record pairing a value with its corresponding radio button widget.
typedef ValueAndButton<T extends Object> = ({T value, Widget button});

/// Configuration for a platform radio group.
///
/// Holds the group value, available values, and a builder that receives
/// the list of [ValueAndButton] records to lay out the radio buttons.
final class PlatformRadioGroupData<T extends Object> {
  /// The currently selected value in the group.
  final T groupValue;

  /// All available values in the group.
  final Iterable<T> groupValues;

  /// Builder that receives the radio buttons paired with their values.
  final Widget Function(List<ValueAndButton<T>> valuesAndRadioButtons) groupBuilder;

  /// Callback when the selected value changes.
  final ValueChanged<T?> onChanged;

  /// Creates a platform radio group configuration.
  const PlatformRadioGroupData({
    required this.groupValue,
    required this.groupValues,
    required this.groupBuilder,
    required this.onChanged,
  });
}

/// Platform-shared configuration for an individual radio button.
///
/// Contains common properties used by both Material and Cupertino radios.
final class PlatformRadioData<T> {
  /// Key applied to the underlying platform widget.
  final Key? widgetKey;

  /// Mouse cursor when hovering over the radio.
  final MouseCursor? mouseCursor;

  /// Whether the radio can be toggled off by tapping it again.
  final bool toggleable;

  /// Color of the radio when active.
  final Color? activeColor;

  /// Color of the radio when focused.
  final Color? focusColor;

  /// Focus node for the radio.
  final FocusNode? focusNode;

  /// Whether the radio should autofocus.
  final bool autofocus;

  /// Whether the radio is enabled.
  final bool enabled;

  /// Optional group registry for coordinating radio buttons.
  final RadioGroupRegistry<T>? groupRegistry;

  /// Default value for [toggleable].
  static const kDefaultToggleable = false;

  /// Default value for [autofocus].
  static const kDefaultAutofocus = false;

  /// Default value for [enabled].
  static const kDefaultEnabled = true;

  /// Creates platform radio configuration.
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

/// Material-specific configuration for a radio button.
///
/// Extends [PlatformRadioData] with Material-only properties.
final class MaterialRadioData<T> extends PlatformRadioData<T> {
  /// Fill color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? fillColor;

  /// Color when hovering over the radio.
  final Color? hoverColor;

  /// Overlay color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Splash radius of the radio.
  final double? splashRadius;

  /// Material tap target size.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Visual density of the radio.
  final VisualDensity? visualDensity;

  /// Background color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? backgroundColor;

  /// Border side of the radio.
  final BorderSide? side;

  /// Inner radius as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? innerRadius;

  /// Creates Material-specific radio configuration.
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

/// Cupertino-specific configuration for a radio button.
///
/// Extends [PlatformRadioData] with Cupertino-only properties.
final class CupertinoRadioData<T> extends PlatformRadioData<T> {
  /// Color of the radio when inactive.
  final Color? inactiveColor;

  /// Fill color of the radio.
  final Color? fillColor;

  /// Whether to use a checkmark style instead of a filled circle.
  final bool useCheckmarkStyle;

  /// Default value for [useCheckmarkStyle].
  static const kDefaultUseCheckmarkStyle = false;

  /// Creates Cupertino-specific radio configuration.
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
