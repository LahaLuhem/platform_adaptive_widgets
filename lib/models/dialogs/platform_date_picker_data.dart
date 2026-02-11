// ignore_for_file: prefer-match-file-name

import 'dart:ui';

import 'package:flutter/cupertino.dart'
    show CupertinoDynamicColor, DatePickerDateOrder, SelectionOverlayBuilder;
import 'package:flutter/material.dart'
    show CalendarDelegate, DatePickerEntryMode, DatePickerMode, GregorianCalendarDelegate;
import 'package:flutter/widgets.dart';

import 'const_values.dart';

final class _PlatformDatePickerData {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool? barrierDismissible;
  final RouteSettings? routeSettings;
  final bool? useRootNavigator;

  final SelectableDayPredicate? selectableDayPredicate;
  final TransitionBuilder? builder;

  const _PlatformDatePickerData({
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible,
    this.routeSettings,
    this.useRootNavigator,
    this.selectableDayPredicate,
    this.builder,
  });
}

/// Material-specific configuration for the platform date picker.
///
/// Maps to parameters of `showDatePicker` on Android.
final class MaterialDatePickerData extends _PlatformDatePickerData {
  /// The date to highlight as the current date.
  final DateTime? currentDate;

  /// The initial entry mode of the date picker (calendar or input).
  final DatePickerEntryMode initialEntryMode;

  /// Help text displayed at the top of the picker.
  final String? helpText;

  /// Text for the cancel button.
  final String? cancelText;

  /// Text for the confirm button.
  final String? confirmText;

  /// Locale used for formatting dates.
  final Locale? locale;

  /// Semantic label for the barrier.
  final String? barrierLabel;

  /// Text direction for the picker.
  final TextDirection? textDirection;

  /// The initial display mode of the calendar (day or year).
  final DatePickerMode initialDatePickerMode;

  /// Error text shown when the date format is invalid.
  final String? errorFormatText;

  /// Error text shown when the date is not selectable.
  final String? errorInvalidText;

  /// Hint text for the date input field.
  final String? fieldHintText;

  /// Label text for the date input field.
  final String? fieldLabelText;

  /// Keyboard type for the date input field.
  final TextInputType? keyboardType;

  /// Callback when the date picker entry mode changes.
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange;

  /// Icon for switching to input entry mode.
  final Icon? switchToInputEntryModeIcon;

  /// Icon for switching to calendar entry mode.
  final Icon? switchToCalendarEntryModeIcon;

  /// The calendar delegate used for date calculations.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Default value for [initialEntryMode].
  static const kDefaultInitialEntryMode = DatePickerEntryMode.calendar;

  /// Default value for [initialDatePickerMode].
  static const kDefaultInitialDatePickerMode = DatePickerMode.day;

  /// Default value for [calendarDelegate].
  static const kDefaultCalendarDelegate = GregorianCalendarDelegate();

  /// Creates Material-specific date picker configuration.
  const MaterialDatePickerData({
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible = kMaterialBarrierDismissible,
    super.routeSettings,
    super.useRootNavigator,
    super.selectableDayPredicate,
    super.builder,
    this.currentDate,
    this.initialEntryMode = kDefaultInitialEntryMode,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.locale,
    this.barrierLabel,
    this.textDirection,
    this.initialDatePickerMode = kDefaultInitialDatePickerMode,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.onDatePickerModeChange,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
    this.calendarDelegate = kDefaultCalendarDelegate,
  });
}

/// Cupertino-specific configuration for the platform date picker.
///
/// Maps to properties of `CupertinoDatePicker` shown in a modal popup on iOS.
final class CupertinoDatePickerData extends _PlatformDatePickerData {
  /// Image filter applied to the background behind the modal.
  final ImageFilter? filter;

  /// Whether the modal should request focus when shown.
  final bool? requestFocus;

  /// Whether the modal can be dismissed via semantics.
  final bool semanticsDismissible;

  /// Background color of the date picker.
  final Color? backgroundColor;

  /// When changes are reported to the callback.
  final ChangeReportingBehavior changeReportingBehavior;

  /// Order of the date columns (e.g., day-month-year).
  final DatePickerDateOrder? dateOrder;

  /// Height of each item in the picker wheel.
  final double itemExtent;

  /// Maximum selectable year.
  final int? maximumYear;

  /// Minimum selectable year.
  final int minimumYear;

  /// Interval between selectable minutes.
  final int minuteInterval;

  /// Builder for the selection overlay on the picker wheel.
  final SelectionOverlayBuilder? selectionOverlayBuilder;

  /// Whether to show the day of the week.
  final bool showDayOfWeek;

  /// Whether to show the time separator.
  final bool showTimeSeparator;

  /// Whether to use 24-hour format.
  final bool use24hFormat;

  /// Default modal barrier color.
  static const kDefaultModalBarrierColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x7A000000),
  );

  /// Default value for [semanticsDismissible].
  static const kDefaultSemanticsDismissible = false;

  /// Default value for [changeReportingBehavior].
  static const kDefaultChangeReportingBehavior = ChangeReportingBehavior.onScrollUpdate;

  /// Default value for [itemExtent].
  static const kDefaultItemExtent = 32.0;

  /// Default value for [minimumYear].
  static const kDefaultMinimumYear = 1;

  /// Default value for [minuteInterval].
  static const kDefaultMinuteInterval = 1;

  /// Default value for [showDayOfWeek].
  static const kDefaultShowDayOfWeek = false;

  /// Default value for [showTimeSeparator].
  static const kDefaultShowTimeSeparator = false;

  /// Default value for [use24hFormat].
  static const kDefaultUse24hFormat = false;

  /// Creates Cupertino-specific date picker configuration.
  const CupertinoDatePickerData({
    super.anchorPoint,
    super.barrierColor = kDefaultModalBarrierColor,
    super.barrierDismissible,
    super.routeSettings,
    super.useRootNavigator,
    super.selectableDayPredicate,
    super.builder,
    this.filter,
    this.requestFocus,
    this.semanticsDismissible = kDefaultSemanticsDismissible,
    this.backgroundColor,
    this.changeReportingBehavior = kDefaultChangeReportingBehavior,
    this.dateOrder,
    this.itemExtent = kDefaultItemExtent,
    this.maximumYear,
    this.minimumYear = kDefaultMinimumYear,
    this.minuteInterval = kDefaultMinuteInterval,
    this.selectionOverlayBuilder,
    this.showDayOfWeek = kDefaultShowDayOfWeek,
    this.showTimeSeparator = kDefaultShowTimeSeparator,
    this.use24hFormat = kDefaultUse24hFormat,
  });
}
