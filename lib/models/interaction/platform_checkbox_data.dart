import 'package:flutter/material.dart' show MaterialTapTargetSize, VisualDensity;
import 'package:flutter/widgets.dart';

/// Platform-shared configuration for a checkbox widget.
///
/// Contains common properties used by both Material and Cupertino checkboxes.
final class PlatformCheckboxData {
  /// Key applied to the underlying platform widget.
  final Key? widgetKey;

  /// Current value of the checkbox.
  final bool? value;

  /// Whether the checkbox supports three states (true, false, null).
  final bool tristate;

  /// Whether the checkbox is enabled.
  final bool isEnabled;

  /// Callback when the checkbox value changes.
  final ValueChanged<bool?>? onChanged;

  /// Mouse cursor when hovering over the checkbox.
  final MouseCursor? mouseCursor;

  /// Color of the checkbox when active.
  final Color? activeColor;

  /// Fill color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? fillColor;

  /// Color of the check mark.
  final Color? checkColor;

  /// Color of the checkbox when focused.
  final Color? focusColor;

  /// Focus node for the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox should autofocus.
  final bool autofocus;

  /// Shape of the checkbox border.
  final OutlinedBorder? shape;

  /// Border side of the checkbox.
  final BorderSide? side;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Default value for [autofocus].
  static const kDefaultAutofocus = false;

  /// Creates platform checkbox configuration.
  const PlatformCheckboxData({
    this.onChanged,
    this.value,
    this.tristate = false,
    this.isEnabled = true,
    this.widgetKey,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.shape,
    this.side,
    this.semanticLabel,
  });
}

/// Material-specific configuration for a checkbox widget.
///
/// Extends [PlatformCheckboxData] with Material-only properties.
final class MaterialCheckboxData extends PlatformCheckboxData {
  /// Color when hovering over the checkbox.
  final Color? hoverColor;

  /// Overlay color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Splash radius of the checkbox.
  final double? splashRadius;

  /// Material tap target size.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Visual density of the checkbox.
  final VisualDensity? visualDensity;

  /// Whether the checkbox is in an error state.
  final bool isError;

  /// Default value for [isError].
  static const kDefaultIsError = false;

  /// Creates Material-specific checkbox configuration.
  const MaterialCheckboxData({
    super.onChanged,
    super.value,
    super.tristate,
    super.isEnabled,
    super.widgetKey,
    super.mouseCursor,
    super.activeColor,
    super.fillColor,
    super.checkColor,
    super.focusColor,
    super.focusNode,
    super.autofocus,
    super.shape,
    super.side,
    super.semanticLabel,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.isError = kDefaultIsError,
  });
}

/// Cupertino-specific configuration for a checkbox widget.
///
/// Extends [PlatformCheckboxData] with Cupertino-only properties.
final class CupertinoCheckboxData extends PlatformCheckboxData {
  /// Custom tap target size for the checkbox.
  final Size? tapTargetSize;

  /// Creates Cupertino-specific checkbox configuration.
  const CupertinoCheckboxData({
    super.onChanged,
    super.value,
    super.tristate,
    super.isEnabled,
    super.widgetKey,
    super.mouseCursor,
    super.activeColor,
    super.fillColor,
    super.checkColor,
    super.focusColor,
    super.focusNode,
    super.autofocus,
    super.shape,
    super.side,
    super.semanticLabel,
    this.tapTargetSize,
  });
}
