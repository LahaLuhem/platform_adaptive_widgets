// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDatePicker, showCupertinoModalPopup;
import 'package:flutter/material.dart' show showDatePicker;
import 'package:flutter/widgets.dart';

import '/extensions/context_extensions.dart';
import '/extensions/date_time_extensions.dart';
import '/models/date.dart';
import '/models/dialogs/const_values.dart';
import '/models/dialogs/platform_date_picker_data.dart';

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
  SelectableDayPredicate? selectableDayPredicate,
  TransitionBuilder? builder,
  MaterialDatePickerData? materialDatePickerData,
  CupertinoDatePickerData? cupertinoDatePickerData,
}) {
  final initialDateTime = initialDate?.toDateTime();
  final firstDateTime = firstDate.toDateTime();
  final lastDateTime = lastDate.toDateTime();

  return context.platformLazyValue(
    material: () => showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDateTime,
      lastDate: lastDateTime,
      anchorPoint: materialDatePickerData?.anchorPoint ?? anchorPoint,
      barrierColor: materialDatePickerData?.barrierColor ?? barrierColor,
      barrierDismissible:
          materialDatePickerData?.barrierDismissible ??
          barrierDismissible ??
          kMaterialBarrierDismissible,
      routeSettings: materialDatePickerData?.routeSettings ?? routeSettings,
      useRootNavigator: materialDatePickerData?.useRootNavigator ?? useRootNavigator,
      selectableDayPredicate:
          materialDatePickerData?.selectableDayPredicate ?? selectableDayPredicate,
      builder: materialDatePickerData?.builder ?? builder,
      currentDate: materialDatePickerData?.currentDate,
      initialEntryMode:
          materialDatePickerData?.initialEntryMode ??
          MaterialDatePickerData.kDefaultInitialEntryMode,
      helpText: materialDatePickerData?.helpText,
      cancelText: materialDatePickerData?.cancelText,
      confirmText: materialDatePickerData?.confirmText,
      locale: materialDatePickerData?.locale,
      barrierLabel: materialDatePickerData?.barrierLabel,
      textDirection: materialDatePickerData?.textDirection,
      initialDatePickerMode:
          materialDatePickerData?.initialDatePickerMode ??
          MaterialDatePickerData.kDefaultInitialDatePickerMode,
      errorFormatText: materialDatePickerData?.errorFormatText,
      errorInvalidText: materialDatePickerData?.errorInvalidText,
      fieldHintText: materialDatePickerData?.fieldHintText,
      fieldLabelText: materialDatePickerData?.fieldLabelText,
      keyboardType: materialDatePickerData?.keyboardType,
      onDatePickerModeChange: materialDatePickerData?.onDatePickerModeChange,
      switchToInputEntryModeIcon: materialDatePickerData?.switchToInputEntryModeIcon,
      switchToCalendarEntryModeIcon: materialDatePickerData?.switchToCalendarEntryModeIcon,
      calendarDelegate:
          materialDatePickerData?.calendarDelegate ??
          MaterialDatePickerData.kDefaultCalendarDelegate,
    ).then((dateTime) => dateTime?.toDate()),
    cupertino: () async {
      var selectedDateTime = initialDateTime ?? DateTime.now();
      final resolvedBuilder = cupertinoDatePickerData?.builder ?? builder;

      final pickerWidget = CupertinoDatePicker(
        initialDateTime: initialDateTime,
        minimumDate: firstDateTime,
        maximumDate: lastDateTime,
        selectableDayPredicate: cupertinoDatePickerData?.selectableDayPredicate,
        mode: .date,
        onDateTimeChanged: (dateTime) => selectedDateTime = dateTime,
        backgroundColor: cupertinoDatePickerData?.backgroundColor,
        changeReportingBehavior:
            cupertinoDatePickerData?.changeReportingBehavior ??
            ChangeReportingBehavior.onScrollUpdate,
        dateOrder: cupertinoDatePickerData?.dateOrder,
        itemExtent:
            cupertinoDatePickerData?.itemExtent ?? CupertinoDatePickerData.kDefaultItemExtent,
        maximumYear: cupertinoDatePickerData?.maximumYear,
        minimumYear:
            cupertinoDatePickerData?.minimumYear ?? CupertinoDatePickerData.kDefaultMinimumYear,
        minuteInterval:
            cupertinoDatePickerData?.minuteInterval ??
            CupertinoDatePickerData.kDefaultMinuteInterval,
        selectionOverlayBuilder: cupertinoDatePickerData?.selectionOverlayBuilder,
        showDayOfWeek:
            cupertinoDatePickerData?.showDayOfWeek ?? CupertinoDatePickerData.kDefaultShowDayOfWeek,
        showTimeSeparator:
            cupertinoDatePickerData?.showTimeSeparator ??
            CupertinoDatePickerData.kDefaultShowTimeSeparator,
        use24hFormat:
            cupertinoDatePickerData?.use24hFormat ?? CupertinoDatePickerData.kDefaultUse24hFormat,
      );

      await showCupertinoModalPopup<void>(
        context: context,
        anchorPoint: cupertinoDatePickerData?.anchorPoint ?? anchorPoint,
        barrierColor:
            cupertinoDatePickerData?.barrierColor ??
            barrierColor ??
            CupertinoDatePickerData.kDefaultModalBarrierColor,
        barrierDismissible:
            cupertinoDatePickerData?.barrierDismissible ??
            barrierDismissible ??
            kCupertinoBarrierDismissible,
        routeSettings: cupertinoDatePickerData?.routeSettings ?? routeSettings,
        useRootNavigator: cupertinoDatePickerData?.useRootNavigator ?? useRootNavigator,
        filter: cupertinoDatePickerData?.filter,
        requestFocus: cupertinoDatePickerData?.requestFocus,
        semanticsDismissible:
            cupertinoDatePickerData?.semanticsDismissible ??
            CupertinoDatePickerData.kDefaultSemanticsDismissible,
        builder: (context) =>
            resolvedBuilder?.call(context, pickerWidget) ??
            _CupertinoPickerContainer(pickerWidget: pickerWidget),
      );

      return selectedDateTime.toDate();
    },
  );
}

class _CupertinoPickerContainer extends StatelessWidget {
  final CupertinoDatePicker pickerWidget;

  const _CupertinoPickerContainer({required this.pickerWidget});

  @override
  Widget build(BuildContext context) => Container(
    height: 216,
    padding: const EdgeInsets.only(top: 6),
    // The Bottom margin is provided to align the popup above the system
    // navigation bar.
    margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    // Provide a background color for the popup.
    color: CupertinoColors.systemBackground.resolveFrom(context),
    // Use a SafeArea widget to avoid system overlaps.
    child: SafeArea(top: false, child: pickerWidget),
  );
}
