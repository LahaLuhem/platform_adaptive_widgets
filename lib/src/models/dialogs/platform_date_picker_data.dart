// Per-platform records for showPlatformDatePicker (no shared private base,
// shared show-function args are flat on the function signatures, and the
// Material / Cupertino visual surfaces don't overlap).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_date_picker.dart';
library;

import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoDynamicColor, DatePickerDateOrder, SelectionOverlayBuilder;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show CalendarDelegate, DatePickerEntryMode, DatePickerMode, GregorianCalendarDelegate;

/// Default value for [MaterialDatePickerData.initialEntryMode]. Matches upstream `showDatePicker`'s
/// default.
const kDefaultMaterialDatePickerInitialEntryMode = DatePickerEntryMode.calendar;

/// Default value for [MaterialDatePickerData.initialDatePickerMode]. Matches upstream `showDatePicker`'s
/// default.
const kDefaultMaterialDatePickerInitialDatePickerMode = DatePickerMode.day;

/// Default value for [MaterialDatePickerData.calendarDelegate]. Matches upstream's Gregorian calendar
/// default.
const kDefaultMaterialDatePickerCalendarDelegate = GregorianCalendarDelegate();

/// Barrier colour the iOS popup falls back to when the show function's `barrierColor` is left out. Shared
/// by `showPlatformDatePicker` and `showPlatformTimePicker`, and matching iOS's own translucent black.
const kDefaultCupertinoDatePickerBarrierColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x33000000),
  darkColor: Color(0x7A000000),
);

/// Default value for [CupertinoDatePickerData.semanticsDismissible].
const kDefaultCupertinoDatePickerSemanticsDismissible = false;

/// Default value for [CupertinoDatePickerData.changeReportingBehavior]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerChangeReportingBehavior = ChangeReportingBehavior.onScrollUpdate;

/// Default value for [CupertinoDatePickerData.itemExtent]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerItemExtent = 32.0;

/// Default value for [CupertinoDatePickerData.minimumYear]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerMinimumYear = 1;

/// Default value for [CupertinoDatePickerData.minuteInterval]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerMinuteInterval = 1;

/// Default value for [CupertinoDatePickerData.showDayOfWeek]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerShowDayOfWeek = false;

/// Default value for [CupertinoDatePickerData.showTimeSeparator]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerShowTimeSeparator = false;

/// Default value for [CupertinoDatePickerData.use24hFormat]. Matches upstream `CupertinoDatePicker`'s
/// default.
const kDefaultCupertinoDatePickerUse24hFormat = false;

/// Material-side settings for `showPlatformDatePicker`, passed as `materialDatePickerData`. None of
/// it reaches iOS, whose spinning wheel has no answer for Material's entry modes, error text or keyboard
/// handling.
final class const MaterialDatePickerData({
  /// Which day gets the "today" highlight, separately from which one is selected.
  final DateTime? currentDate,

  /// Calendar grid or typed input.
  final DatePickerEntryMode initialEntryMode = kDefaultMaterialDatePickerInitialEntryMode,

  /// Sits along the top of the picker.
  final String? helpText,

  final String? cancelText,

  final String? confirmText,

  final Locale? locale,

  final String? barrierLabel,

  final TextDirection? textDirection,

  /// Day grid or year list.
  final DatePickerMode initialDatePickerMode = kDefaultMaterialDatePickerInitialDatePickerMode,

  /// Shown when the typed date won't parse.
  final String? errorFormatText,

  /// Shown when the date parses but falls outside the allowed range.
  final String? errorInvalidText,

  final String? fieldHintText,

  final String? fieldLabelText,

  final TextInputType? keyboardType,

  /// Fires when the user flips between calendar and typed input.
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange,

  final Icon? switchToInputEntryModeIcon,

  final Icon? switchToCalendarEntryModeIcon,

  /// Gregorian, Buddhist, and so on.
  final CalendarDelegate<DateTime> calendarDelegate = kDefaultMaterialDatePickerCalendarDelegate,
}) {
  /// Creates Material-side settings for `showPlatformDatePicker`.
  this;
}

/// Cupertino-side settings for the [CupertinoDatePicker] behind both `showPlatformDatePicker` and `showPlatformTimePicker`,
/// passed as `cupertinoDatePickerData` on either.
///
/// One record covers both because iOS draws both from the same widget and only changes its `mode`. So
/// a date-only field like [showDayOfWeek] is still accepted by the time picker, it just does nothing
/// there, and the same goes the other way.
final class const CupertinoDatePickerData({
  /// Usually a Gaussian blur, for the frosted glass look iOS goes in for.
  final ImageFilter? filter,

  final bool? requestFocus,

  /// Offers the dismiss action to screen readers.
  final bool semanticsDismissible = kDefaultCupertinoDatePickerSemanticsDismissible,

  /// Date mode only.
  final SelectableDayPredicate? selectableDayPredicate,

  final Color? backgroundColor,

  /// Whether `onDateTimeChanged` fires mid-scroll or only once the wheel settles.
  final ChangeReportingBehavior changeReportingBehavior =
      kDefaultCupertinoDatePickerChangeReportingBehavior,

  /// Day-month-year and friends. Left out, the locale decides.
  final DatePickerDateOrder? dateOrder,

  /// Row height on the wheel.
  final double itemExtent = kDefaultCupertinoDatePickerItemExtent,

  /// Left out, the years run on without a ceiling.
  final int? maximumYear,

  final int minimumYear = kDefaultCupertinoDatePickerMinimumYear,

  /// Step between selectable minutes, so `15` gives you quarter hours.
  final int minuteInterval = kDefaultCupertinoDatePickerMinuteInterval,

  /// Decorates the band across the middle of the wheel.
  final SelectionOverlayBuilder? selectionOverlayBuilder,

  /// Date mode only.
  final bool showDayOfWeek = kDefaultCupertinoDatePickerShowDayOfWeek,

  /// Time mode only.
  final bool showTimeSeparator = kDefaultCupertinoDatePickerShowTimeSeparator,

  /// Time mode only.
  final bool use24hFormat = kDefaultCupertinoDatePickerUse24hFormat,
}) {
  /// Creates Cupertino-side settings for the iOS date and time picker.
  this;
}
