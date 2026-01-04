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

final class MaterialDatePickerData extends _PlatformDatePickerData {
  final DateTime? currentDate;
  final DatePickerEntryMode initialEntryMode;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final Locale? locale;
  final String? barrierLabel;
  final TextDirection? textDirection;
  final DatePickerMode initialDatePickerMode;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final TextInputType? keyboardType;
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange;
  final Icon? switchToInputEntryModeIcon;
  final Icon? switchToCalendarEntryModeIcon;
  final CalendarDelegate<DateTime> calendarDelegate;

  static const kDefaultInitialEntryMode = DatePickerEntryMode.calendar;
  static const kDefaultInitialDatePickerMode = DatePickerMode.day;
  static const kDefaultCalendarDelegate = GregorianCalendarDelegate();

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

final class CupertinoDatePickerData extends _PlatformDatePickerData {
  final ImageFilter? filter;
  final bool? requestFocus;
  final bool semanticsDismissible;

  final Color? backgroundColor;
  final ChangeReportingBehavior changeReportingBehavior;
  final DatePickerDateOrder? dateOrder;
  final double itemExtent;
  final int? maximumYear;
  final int minimumYear;
  final int minuteInterval;
  final SelectionOverlayBuilder? selectionOverlayBuilder;
  final bool showDayOfWeek;
  final bool showTimeSeparator;
  final bool use24hFormat;

  static const kDefaultModalBarrierColor = CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x7A000000),
  );
  static const kDefaultSemanticsDismissible = false;
  static const kDefaultChangeReportingBehavior = ChangeReportingBehavior.onScrollUpdate;
  static const kDefaultItemExtent = 32.0;
  static const kDefaultMinimumYear = 1;
  static const kDefaultMinuteInterval = 1;
  static const kDefaultShowDayOfWeek = false;
  static const kDefaultShowTimeSeparator = false;
  static const kDefaultUse24hFormat = false;

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
