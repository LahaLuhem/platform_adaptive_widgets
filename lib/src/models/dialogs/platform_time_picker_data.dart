// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimePickerEntryMode;

import 'const_values.dart';

/// Common configuration for platform-adaptive time pickers.
final class _PlatformTimePickerData {
  /// The anchor point for the dialog positioning.
  final Offset? anchorPoint;

  /// Color of the modal barrier behind the dialog.
  final Color? barrierColor;

  /// Whether tapping the barrier dismisses the dialog.
  final bool? barrierDismissible;

  /// Route settings for the dialog route.
  final RouteSettings? routeSettings;

  /// Whether to use the root navigator for the dialog route.
  final bool? useRootNavigator;

  /// A builder for the dialog's content.
  final TransitionBuilder? builder;

  /// Creates a [_PlatformTimePickerData].
  const _PlatformTimePickerData({
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible,
    this.routeSettings,
    this.useRootNavigator,
    this.builder,
  });
}

/// Material-specific configuration for the platform time picker.
///
/// Maps to parameters of `showTimePicker` on Android.
final class MaterialTimePickerData extends _PlatformTimePickerData {
  /// Semantic label for the barrier.
  final String? barrierLabel;

  /// The initial entry mode of the time picker (dial or input).
  final TimePickerEntryMode initialEntryMode;

  /// Text for the cancel button.
  final String? cancelText;

  /// Text for the confirm button.
  final String? confirmText;

  /// Help text displayed at the top of the picker.
  final String? helpText;

  /// Error text shown when the time is invalid.
  final String? errorInvalidText;

  /// Label text for the hour input field.
  final String? hourLabelText;

  /// Label text for the minute input field.
  final String? minuteLabelText;

  /// Callback when the entry mode changes.
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged;

  /// Preferred orientation of the time picker dialog.
  final Orientation? orientation;

  /// Icon for switching to input entry mode.
  final Icon? switchToInputEntryModeIcon;

  /// Icon for switching to timer (dial) entry mode.
  final Icon? switchToTimerEntryModeIcon;

  /// Whether the input fields should start empty.
  final bool emptyInitialInput;

  /// Default value for [initialEntryMode].
  static const kDefaultInitialEntryMode = TimePickerEntryMode.dial;

  /// Default value for [emptyInitialInput].
  static const kDefaultEmptyInitialInput = false;

  /// Creates Material-specific time picker configuration.
  const MaterialTimePickerData({
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible = kMaterialBarrierDismissible,
    super.routeSettings,
    super.useRootNavigator,
    super.builder,
    this.barrierLabel,
    this.initialEntryMode = kDefaultInitialEntryMode,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.onEntryModeChanged,
    this.orientation,
    this.switchToInputEntryModeIcon,
    this.switchToTimerEntryModeIcon,
    this.emptyInitialInput = kDefaultEmptyInitialInput,
  });
}
