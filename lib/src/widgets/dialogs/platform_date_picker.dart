// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDatePicker, showCupertinoModalPopup;
import 'package:flutter/material.dart' show showDatePicker;
import 'package:flutter/widgets.dart';

import '/src/extensions/context_extensions.dart';
import '/src/extensions/date_time_extensions.dart';
import '/src/models/date.dart';
import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';

/// Shows a platform-adaptive date picker that renders Material showDatePicker on Android
/// and CupertinoDatePicker on iOS.
///
/// This function automatically selects the appropriate date picker implementation based on the target platform:
/// - On Android: shows a Material Design date picker
/// - On iOS: shows a Cupertino date picker
///
/// The date picker can be configured with platform-specific data through [materialDatePickerData]
/// and [cupertinoDatePickerData], or with common properties.
///
/// Example:
/// ```dart
/// final selectedDate = await showPlatformDatePicker(
///   context: context,
///   firstDate: Date(2023, 1, 1),
///   lastDate: Date(2023, 12, 31),
///   initialDate: Date.now(),
/// );
/// ```
Future<Date?> showPlatformDatePicker({
  /// The build context for showing the date picker.
  required BuildContext context,

  /// The earliest selectable date.
  required Date firstDate,

  /// The latest selectable date.
  required Date lastDate,

  /// The initially selected date.
  Date? initialDate,

  /// The anchor point for positioning the date picker.
  Offset? anchorPoint,

  /// Color of the modal barrier behind the date picker.
  Color? barrierColor,

  /// Whether tapping the barrier dismisses the date picker.
  bool? barrierDismissible,

  /// Route settings for the date picker route.
  RouteSettings? routeSettings,

  /// Whether to use the root navigator for the date picker route.
  bool useRootNavigator = kDefaultUseRootNavigator,

  /// Predicate for determining which days are selectable.
  SelectableDayPredicate? selectableDayPredicate,

  /// Builder for customizing the date picker appearance.
  TransitionBuilder? builder,

  /// Material-specific date picker data.
  MaterialDatePickerData? materialDatePickerData,

  /// Cupertino-specific date picker data.
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
