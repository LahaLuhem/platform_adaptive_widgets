// Per-platform records for showPlatformDatePicker (no shared private base —
// shared show-function args are flat on the function signatures, and the
// Material / Cupertino visual surfaces don't overlap).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/dialogs/platform_date_picker.dart';
library;

import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoDynamicColor, DatePickerDateOrder, SelectionOverlayBuilder;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show CalendarDelegate, DatePickerEntryMode, DatePickerMode, GregorianCalendarDelegate;

/// Default value for [MaterialDatePickerData.initialEntryMode]. Matches
/// upstream `showDatePicker`'s default.
const kDefaultMaterialDatePickerInitialEntryMode = DatePickerEntryMode.calendar;

/// Default value for [MaterialDatePickerData.initialDatePickerMode]. Matches
/// upstream `showDatePicker`'s default.
const kDefaultMaterialDatePickerInitialDatePickerMode = DatePickerMode.day;

/// Default value for [MaterialDatePickerData.calendarDelegate]. Matches
/// upstream's Gregorian calendar default.
const kDefaultMaterialDatePickerCalendarDelegate = GregorianCalendarDelegate();

/// Default barrier colour for the iOS modal popup wrapping
/// [CupertinoDatePicker] in both `showPlatformDatePicker` and
/// `showPlatformTimePicker`. Matches the iOS-standard translucent black. The
/// build site substitutes this when the function-level `barrierColor` arg is
/// `null`.
const kDefaultCupertinoDatePickerBarrierColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x33000000),
  darkColor: Color(0x7A000000),
);

/// Default value for [CupertinoDatePickerData.semanticsDismissible].
const kDefaultCupertinoDatePickerSemanticsDismissible = false;

/// Default value for [CupertinoDatePickerData.changeReportingBehavior]. Matches
/// upstream `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerChangeReportingBehavior = ChangeReportingBehavior.onScrollUpdate;

/// Default value for [CupertinoDatePickerData.itemExtent]. Matches upstream
/// `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerItemExtent = 32.0;

/// Default value for [CupertinoDatePickerData.minimumYear]. Matches upstream
/// `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerMinimumYear = 1;

/// Default value for [CupertinoDatePickerData.minuteInterval]. Matches
/// upstream `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerMinuteInterval = 1;

/// Default value for [CupertinoDatePickerData.showDayOfWeek]. Matches upstream
/// `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerShowDayOfWeek = false;

/// Default value for [CupertinoDatePickerData.showTimeSeparator]. Matches
/// upstream `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerShowTimeSeparator = false;

/// Default value for [CupertinoDatePickerData.use24hFormat]. Matches upstream
/// `CupertinoDatePicker`'s default.
const kDefaultCupertinoDatePickerUse24hFormat = false;

/// Material-only configuration for `showPlatformDatePicker`.
///
/// Pass this via `showPlatformDatePicker`'s `materialDatePickerData` parameter.
/// The fields declared here have no Cupertino equivalent — Material's
/// `showDatePicker` exposes a richer set of entry-mode / locale / error-text /
/// keyboard knobs that don't map to Cupertino's spinning-wheel picker.
final class MaterialDatePickerData {
  /// Date highlighted as "today" in the calendar (independent of the selected
  /// date).
  final DateTime? currentDate;

  /// Initial entry mode (calendar grid vs typed input). Defaults to
  /// [kDefaultMaterialDatePickerInitialEntryMode].
  final DatePickerEntryMode initialEntryMode;

  /// Help text shown at the top of the picker.
  final String? helpText;

  /// Text for the cancel button.
  final String? cancelText;

  /// Text for the confirm button.
  final String? confirmText;

  /// Locale used for date formatting.
  final Locale? locale;

  /// Semantic label for the modal barrier.
  final String? barrierLabel;

  /// Text direction for the picker.
  final TextDirection? textDirection;

  /// Initial calendar mode (day grid vs year selector). Defaults to
  /// [kDefaultMaterialDatePickerInitialDatePickerMode].
  final DatePickerMode initialDatePickerMode;

  /// Error text shown when the typed date can't be parsed.
  final String? errorFormatText;

  /// Error text shown when the date is outside the selectable range.
  final String? errorInvalidText;

  /// Hint text for the typed-input field.
  final String? fieldHintText;

  /// Label text for the typed-input field.
  final String? fieldLabelText;

  /// Keyboard type for the typed-input field.
  final TextInputType? keyboardType;

  /// Callback fired when the user toggles between calendar and input modes.
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange;

  /// Icon used on the "switch to input mode" button.
  final Icon? switchToInputEntryModeIcon;

  /// Icon used on the "switch to calendar mode" button.
  final Icon? switchToCalendarEntryModeIcon;

  /// Calendar delegate (Gregorian, Buddhist, etc.). Defaults to
  /// [kDefaultMaterialDatePickerCalendarDelegate].
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Creates Material-only configuration for `showPlatformDatePicker`.
  const MaterialDatePickerData({
    this.currentDate,
    this.initialEntryMode = kDefaultMaterialDatePickerInitialEntryMode,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.locale,
    this.barrierLabel,
    this.textDirection,
    this.initialDatePickerMode = kDefaultMaterialDatePickerInitialDatePickerMode,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.onDatePickerModeChange,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
    this.calendarDelegate = kDefaultMaterialDatePickerCalendarDelegate,
  });
}

/// Cupertino-only configuration for the [CupertinoDatePicker]-backed branch
/// of both `showPlatformDatePicker` and `showPlatformTimePicker`.
///
/// Reused across both pickers because iOS uses the *same widget*
/// ([CupertinoDatePicker]) for date and time selection — only the `mode`
/// passed to the picker differs (date vs time). Pass this via
/// `cupertinoDatePickerData` on either show function.
///
/// Fields that are mode-irrelevant (e.g. [showDayOfWeek] on the time picker)
/// are still accepted but have no visible effect for that mode — Cupertino's
/// picker silently ignores them.
final class CupertinoDatePickerData {
  /// Image filter applied to the modal background (typically a Gaussian blur
  /// for iOS's frosted-glass effect).
  final ImageFilter? filter;

  /// Whether the modal should request focus when shown.
  final bool? requestFocus;

  /// Whether the modal is dismissible via accessibility tooling.
  /// Defaults to [kDefaultCupertinoDatePickerSemanticsDismissible].
  final bool semanticsDismissible;

  /// Predicate for restricting which days are selectable. Date-mode only;
  /// time-mode picker ignores.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Background colour of the picker.
  final Color? backgroundColor;

  /// When `onDateTimeChanged` fires (on scroll start, on scroll end, etc.).
  /// Defaults to [kDefaultCupertinoDatePickerChangeReportingBehavior].
  final ChangeReportingBehavior changeReportingBehavior;

  /// Order of the date columns (e.g. day-month-year). When `null`, derived
  /// from the locale.
  final DatePickerDateOrder? dateOrder;

  /// Height of each item in the picker wheel. Defaults to
  /// [kDefaultCupertinoDatePickerItemExtent].
  final double itemExtent;

  /// Maximum selectable year. When `null`, no upper bound.
  final int? maximumYear;

  /// Minimum selectable year. Defaults to
  /// [kDefaultCupertinoDatePickerMinimumYear].
  final int minimumYear;

  /// Interval between selectable minutes. Defaults to
  /// [kDefaultCupertinoDatePickerMinuteInterval].
  final int minuteInterval;

  /// Builder for the selection-overlay decoration on the picker wheel.
  final SelectionOverlayBuilder? selectionOverlayBuilder;

  /// Whether to show the day-of-week column. Date-mode only. Defaults to
  /// [kDefaultCupertinoDatePickerShowDayOfWeek].
  final bool showDayOfWeek;

  /// Whether to show the time-separator glyph. Time-mode only. Defaults to
  /// [kDefaultCupertinoDatePickerShowTimeSeparator].
  final bool showTimeSeparator;

  /// Whether to use 24-hour time format. Time-mode only. Defaults to
  /// [kDefaultCupertinoDatePickerUse24hFormat].
  final bool use24hFormat;

  /// Creates Cupertino-only configuration for the iOS date/time picker.
  const CupertinoDatePickerData({
    this.filter,
    this.requestFocus,
    this.semanticsDismissible = kDefaultCupertinoDatePickerSemanticsDismissible,
    this.selectableDayPredicate,
    this.backgroundColor,
    this.changeReportingBehavior = kDefaultCupertinoDatePickerChangeReportingBehavior,
    this.dateOrder,
    this.itemExtent = kDefaultCupertinoDatePickerItemExtent,
    this.maximumYear,
    this.minimumYear = kDefaultCupertinoDatePickerMinimumYear,
    this.minuteInterval = kDefaultCupertinoDatePickerMinuteInterval,
    this.selectionOverlayBuilder,
    this.showDayOfWeek = kDefaultCupertinoDatePickerShowDayOfWeek,
    this.showTimeSeparator = kDefaultCupertinoDatePickerShowTimeSeparator,
    this.use24hFormat = kDefaultCupertinoDatePickerUse24hFormat,
  });
}
