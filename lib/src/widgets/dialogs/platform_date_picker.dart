// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoDatePicker, CupertinoDatePickerMode, showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay, showDatePicker, showTimePicker;

import '/src/extensions/date_time_extensions.dart';
import '/src/extensions/time_of_day_extensions.dart';
import '/src/models/date.dart';
import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';
import '/src/models/dialogs/platform_time_picker_data.dart';

part 'platform_time_picker.dart';

/// Shows a platform-adaptive date picker — Material [showDatePicker] on
/// Android, [CupertinoDatePicker] in date mode wrapped in
/// [showCupertinoModalPopup] on iOS.
///
/// On iOS the picker is rendered inside a bottom-sheet popup; the value is
/// observed continuously and returned when the popup is dismissed. Use
/// [CupertinoDatePickerData.changeReportingBehavior] to tune *when* iOS reports
/// changes.
///
/// Shared show-function args ([anchorPoint], [barrierColor],
/// [barrierDismissible], [routeSettings], [useRootNavigator],
/// [selectableDayPredicate], [builder]) live flat on the function;
/// per-platform tuning is opt-in via [materialDatePickerData] and
/// [cupertinoDatePickerData] (the same Cupertino data class is reused by
/// [showPlatformTimePicker] — see [CupertinoDatePickerData]).
///
/// Example:
/// ```dart
/// final picked = await showPlatformDatePicker(
///   context: context,
///   firstDate: const Date(year: 2020),
///   lastDate: Date.now().add(const Duration(days: 365)),
///   initialDate: Date.now(),
/// );
/// ```
Future<Date?> showPlatformDatePicker({
  required BuildContext context,
  required Date firstDate,
  required Date lastDate,
  Date? initialDate,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  SelectableDayPredicate? selectableDayPredicate,
  TransitionBuilder? builder,
  MaterialDatePickerData? materialDatePickerData,
  CupertinoDatePickerData? cupertinoDatePickerData,
}) {
  final initialDateTime = initialDate?.toDateTime();
  final firstDateTime = firstDate.toDateTime();
  final lastDateTime = lastDate.toDateTime();

  return switch (defaultTargetPlatform) {
    .android => showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDateTime,
      lastDate: lastDateTime,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? kMaterialBarrierDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      selectableDayPredicate: selectableDayPredicate,
      builder: builder,
      currentDate: materialDatePickerData?.currentDate,
      initialEntryMode:
          materialDatePickerData?.initialEntryMode ?? kDefaultMaterialDatePickerInitialEntryMode,
      helpText: materialDatePickerData?.helpText,
      cancelText: materialDatePickerData?.cancelText,
      confirmText: materialDatePickerData?.confirmText,
      locale: materialDatePickerData?.locale,
      barrierLabel: materialDatePickerData?.barrierLabel,
      textDirection: materialDatePickerData?.textDirection,
      initialDatePickerMode:
          materialDatePickerData?.initialDatePickerMode ??
          kDefaultMaterialDatePickerInitialDatePickerMode,
      errorFormatText: materialDatePickerData?.errorFormatText,
      errorInvalidText: materialDatePickerData?.errorInvalidText,
      fieldHintText: materialDatePickerData?.fieldHintText,
      fieldLabelText: materialDatePickerData?.fieldLabelText,
      keyboardType: materialDatePickerData?.keyboardType,
      onDatePickerModeChange: materialDatePickerData?.onDatePickerModeChange,
      switchToInputEntryModeIcon: materialDatePickerData?.switchToInputEntryModeIcon,
      switchToCalendarEntryModeIcon: materialDatePickerData?.switchToCalendarEntryModeIcon,
      calendarDelegate:
          materialDatePickerData?.calendarDelegate ?? kDefaultMaterialDatePickerCalendarDelegate,
    ).then((dateTime) => dateTime?.toDate()),
    .iOS => _showCupertinoModePickerPopup(
      context: context,
      mode: CupertinoDatePickerMode.date,
      initialDateTime: initialDateTime,
      firstDateTime: firstDateTime,
      lastDateTime: lastDateTime,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      builder: builder,
      cupertinoDatePickerData: cupertinoDatePickerData,
    ).then((dateTime) => dateTime?.toDate()),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

/// Shared iOS modal-popup helper — the same [CupertinoDatePicker] +
/// [showCupertinoModalPopup] scaffolding is used by both
/// [showPlatformDatePicker] (mode `.date`) and [showPlatformTimePicker] (mode
/// `.time`). Returns the picker's final [DateTime] value (callers slice it to
/// [Date] or [TimeOfDay] downstream).
///
/// Library-private; reachable from `platform_time_picker.dart` via the
/// `part of` directive.
Future<DateTime?> _showCupertinoModePickerPopup({
  required BuildContext context,
  required CupertinoDatePickerMode mode,
  required DateTime? initialDateTime,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool? barrierDismissible,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
  required TransitionBuilder? builder,
  required CupertinoDatePickerData? cupertinoDatePickerData,
  DateTime? firstDateTime,
  DateTime? lastDateTime,
}) async {
  var selectedDateTime = initialDateTime ?? DateTime.now();

  final pickerWidget = CupertinoDatePicker(
    mode: mode,
    initialDateTime: initialDateTime,
    minimumDate: firstDateTime,
    maximumDate: lastDateTime,
    selectableDayPredicate: cupertinoDatePickerData?.selectableDayPredicate,
    onDateTimeChanged: (dateTime) => selectedDateTime = dateTime,
    backgroundColor: cupertinoDatePickerData?.backgroundColor,
    changeReportingBehavior:
        cupertinoDatePickerData?.changeReportingBehavior ??
        kDefaultCupertinoDatePickerChangeReportingBehavior,
    dateOrder: cupertinoDatePickerData?.dateOrder,
    itemExtent: cupertinoDatePickerData?.itemExtent ?? kDefaultCupertinoDatePickerItemExtent,
    maximumYear: cupertinoDatePickerData?.maximumYear,
    minimumYear: cupertinoDatePickerData?.minimumYear ?? kDefaultCupertinoDatePickerMinimumYear,
    minuteInterval:
        cupertinoDatePickerData?.minuteInterval ?? kDefaultCupertinoDatePickerMinuteInterval,
    selectionOverlayBuilder: cupertinoDatePickerData?.selectionOverlayBuilder,
    showDayOfWeek:
        cupertinoDatePickerData?.showDayOfWeek ?? kDefaultCupertinoDatePickerShowDayOfWeek,
    showTimeSeparator:
        cupertinoDatePickerData?.showTimeSeparator ?? kDefaultCupertinoDatePickerShowTimeSeparator,
    use24hFormat: cupertinoDatePickerData?.use24hFormat ?? kDefaultCupertinoDatePickerUse24hFormat,
  );

  await showCupertinoModalPopup<void>(
    context: context,
    anchorPoint: anchorPoint,
    barrierColor: barrierColor ?? kDefaultCupertinoDatePickerBarrierColor,
    barrierDismissible: barrierDismissible ?? kCupertinoBarrierDismissible,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    filter: cupertinoDatePickerData?.filter,
    requestFocus: requestFocus,
    semanticsDismissible:
        cupertinoDatePickerData?.semanticsDismissible ??
        kDefaultCupertinoDatePickerSemanticsDismissible,
    builder: (context) =>
        builder?.call(context, pickerWidget) ??
        _CupertinoPickerContainer(pickerWidget: pickerWidget),
  );

  return selectedDateTime;
}

/// Standard 216pt-high container used to wrap [CupertinoDatePicker] inside
/// [showCupertinoModalPopup] — provides background, top padding, and safe-area
/// adjustment for the system navigation bar. Shared by both date and time
/// picker iOS paths.
class _CupertinoPickerContainer extends StatelessWidget {
  final CupertinoDatePicker pickerWidget;

  const _CupertinoPickerContainer({required this.pickerWidget});

  @override
  Widget build(BuildContext context) => Container(
    height: 216,
    padding: const EdgeInsets.only(top: 6),
    // Bottom margin aligns the popup above the system navigation bar.
    margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    color: CupertinoColors.systemBackground.resolveFrom(context),
    child: SafeArea(top: false, child: pickerWidget),
  );
}
