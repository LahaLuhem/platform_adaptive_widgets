// Only `MaterialTimePickerData` lives here, the Cupertino time picker reuses
// the same `CupertinoDatePicker` widget as the date picker (only the `mode`
// differs), so the Cupertino-side data class lives next door in
// `platform_date_picker_data.dart` and is shared.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimePickerEntryMode;

/// Default value for [MaterialTimePickerData.initialEntryMode]. Matches upstream `showTimePicker`'s
/// default.
const kDefaultMaterialTimePickerInitialEntryMode = TimePickerEntryMode.dial;

/// Default value for [MaterialTimePickerData.emptyInitialInput]. Matches upstream `showTimePicker`'s
/// default.
const kDefaultMaterialTimePickerEmptyInitialInput = false;

/// Material-side settings for `showPlatformTimePicker`, passed as `materialTimePickerData`. None of
/// it reaches Cupertino, which spins a wheel where Material offers a dial or typed input.
///
/// There's no Cupertino twin of this class. That side draws its time picker with the same widget as
/// its date picker, so it shares `CupertinoDatePickerData` next door.
final class const MaterialTimePickerData({
  /// What screen readers call the barrier, passed to [showTimePicker].
  final String? barrierLabel,

  /// Dial or typed input.
  final TimePickerEntryMode initialEntryMode = kDefaultMaterialTimePickerInitialEntryMode,

  /// Label on the cancel button, passed to [showTimePicker].
  final String? cancelText,

  /// Label on the OK button, passed to [showTimePicker].
  final String? confirmText,

  /// Sits along the top of the picker.
  final String? helpText,

  /// Shown when the typed time won't parse.
  final String? errorInvalidText,

  /// Label on the hour field, passed to [showTimePicker].
  final String? hourLabelText,

  /// Label on the minute field, passed to [showTimePicker].
  final String? minuteLabelText,

  /// Fires when the user flips between dial and typed input.
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged,

  /// Forces the portrait or landscape layout, passed to [showTimePicker].
  final Orientation? orientation,

  /// {@macro material_ui.time_picker.switchToInputEntryModeIcon}
  final Icon? switchToInputEntryModeIcon,

  /// {@macro material_ui.time_picker.switchToTimerEntryModeIcon}
  final Icon? switchToTimerEntryModeIcon,

  /// Starts the input fields blank instead of pre-filled with the initial time.
  final bool emptyInitialInput = kDefaultMaterialTimePickerEmptyInitialInput,
}) {
  /// Creates Material-side settings for `showPlatformTimePicker`.
  this;
}
