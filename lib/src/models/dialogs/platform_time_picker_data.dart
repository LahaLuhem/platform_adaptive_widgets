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
/// it reaches iOS, which spins a wheel where Material offers a dial or typed input.
///
/// There's no Cupertino twin of this class. iOS draws its time picker with the same widget as its date
/// picker, so that side shares `CupertinoDatePickerData` next door.
final class const MaterialTimePickerData({
  final String? barrierLabel,

  /// Dial or typed input.
  final TimePickerEntryMode initialEntryMode = kDefaultMaterialTimePickerInitialEntryMode,

  final String? cancelText,

  final String? confirmText,

  /// Sits along the top of the picker.
  final String? helpText,

  /// Shown when the typed time won't parse.
  final String? errorInvalidText,

  final String? hourLabelText,

  final String? minuteLabelText,

  /// Fires when the user flips between dial and typed input.
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged,

  final Orientation? orientation,

  final Icon? switchToInputEntryModeIcon,

  final Icon? switchToTimerEntryModeIcon,

  /// Starts the input fields blank instead of pre-filled with the initial time.
  final bool emptyInitialInput = kDefaultMaterialTimePickerEmptyInitialInput,
}) {
  /// Creates Material-side settings for `showPlatformTimePicker`.
  this;
}
