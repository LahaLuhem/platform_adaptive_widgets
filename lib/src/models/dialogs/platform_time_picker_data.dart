// Only `MaterialTimePickerData` lives here — the Cupertino time picker reuses
// the same `CupertinoDatePicker` widget as the date picker (only the `mode`
// differs), so the Cupertino-side data class lives next door in
// `platform_date_picker_data.dart` and is shared.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimePickerEntryMode;

/// Default value for [MaterialTimePickerData.initialEntryMode]. Matches
/// upstream `showTimePicker`'s default.
const kDefaultMaterialTimePickerInitialEntryMode = TimePickerEntryMode.dial;

/// Default value for [MaterialTimePickerData.emptyInitialInput]. Matches
/// upstream `showTimePicker`'s default.
const kDefaultMaterialTimePickerEmptyInitialInput = false;

/// Material-only configuration for `showPlatformTimePicker`.
///
/// Pass this via `showPlatformTimePicker`'s `materialTimePickerData` parameter.
/// The fields declared here have no Cupertino equivalent — Material's
/// `showTimePicker` has a richer dial-or-input UX while iOS uses a spinning
/// wheel. The Cupertino side reuses `CupertinoDatePickerData` (next door in
/// `platform_date_picker_data.dart`) — the same picker widget renders both
/// date and time on iOS, distinguished only by `mode`.
final class MaterialTimePickerData {
  /// Semantic label for the modal barrier.
  final String? barrierLabel;

  /// Initial entry mode (dial vs typed input). Defaults to
  /// [kDefaultMaterialTimePickerInitialEntryMode].
  final TimePickerEntryMode initialEntryMode;

  /// Text for the cancel button.
  final String? cancelText;

  /// Text for the confirm button.
  final String? confirmText;

  /// Help text shown at the top of the picker.
  final String? helpText;

  /// Error text shown when the typed time can't be parsed.
  final String? errorInvalidText;

  /// Label text for the hour input field.
  final String? hourLabelText;

  /// Label text for the minute input field.
  final String? minuteLabelText;

  /// Callback fired when the user toggles between dial and input modes.
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged;

  /// Preferred orientation of the picker dialog.
  final Orientation? orientation;

  /// Icon used on the "switch to input mode" button.
  final Icon? switchToInputEntryModeIcon;

  /// Icon used on the "switch to timer (dial) mode" button.
  final Icon? switchToTimerEntryModeIcon;

  /// Whether the input fields should start empty (vs. pre-filled with the
  /// initial time). Defaults to [kDefaultMaterialTimePickerEmptyInitialInput].
  final bool emptyInitialInput;

  /// Creates Material-only configuration for `showPlatformTimePicker`.
  const MaterialTimePickerData({
    this.barrierLabel,
    this.initialEntryMode = kDefaultMaterialTimePickerInitialEntryMode,
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
    this.emptyInitialInput = kDefaultMaterialTimePickerEmptyInitialInput,
  });
}
