// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoDatePicker, CupertinoDatePickerMode, showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay, showDatePicker, showTimePicker;
import 'package:minted_chronology/minted_chronology.dart' show Date;

import '/src/extensions/time_of_day_extensions.dart';
import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';
import '/src/models/dialogs/platform_time_picker_data.dart';

part 'platform_time_picker.dart';

/// Shows a date picker. Material's [showDatePicker] on Android, a [CupertinoDatePicker] in a bottom
/// popup on iOS.
///
/// The iOS wheel reports as it turns and the value comes back once the popup closes. [CupertinoDatePickerData.changeReportingBehavior]
/// decides how often it reports.
///
/// Per-platform tuning lives in [materialDatePickerData] / [cupertinoDatePickerData], the latter shared
/// with [showPlatformTimePicker] since iOS draws both with one widget.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_date_picker.dart#platform_date_picker}
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
    ).then(_toDate),
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
    ).then(_toDate),
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}

// The picker clamps to [firstDate, lastDate], so the null arm is unreachable. Null beats throwing.
Date? _toDate(DateTime? dateTime) =>
    dateTime == null ? null : Date.fromDateTime(dateTime).getOrNull();

/// One popup for both pickers, since iOS only changes the [CupertinoDatePicker]'s `mode` between them.
/// Callers slice the [DateTime] down to a [Date] or a [TimeOfDay] afterwards.
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

/// The standard 216pt shell around the wheel: background, a little top padding, and room for the system
/// navigation bar.
class const _CupertinoPickerContainer({required final CupertinoDatePicker pickerWidget})
    extends StatelessWidget {
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
