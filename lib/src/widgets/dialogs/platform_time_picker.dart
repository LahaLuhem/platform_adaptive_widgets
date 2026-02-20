// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoDatePicker, showCupertinoModalPopup;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay, showTimePicker;

import '/src/extensions/context_extensions.dart';
import '/src/extensions/time_of_day_extensions.dart';
import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';
import '/src/models/dialogs/platform_time_picker_data.dart';

/// Shows a platform-adaptive time picker that renders Material showTimePicker on Android
/// and CupertinoDatePicker (in time mode) on iOS.
///
/// This function automatically selects the appropriate time picker implementation based on the target platform:
/// - On Android: shows a Material Design time picker
/// - On iOS: shows a Cupertino date picker configured for time selection
///
/// The time picker can be configured with platform-specific data through [materialTimePickerData]
/// and [cupertinoTimePickerData], or with common properties.
///
/// Example:
/// ```dart
/// final selectedTime = await showPlatformTimePicker(
///   context: context,
///   initialTime: TimeOfDay.now(),
/// );
/// ```
Future<TimeOfDay?> showPlatformTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  TransitionBuilder? builder,
  MaterialTimePickerData? materialTimePickerData,
  CupertinoDatePickerData? cupertinoTimePickerData,
}) => context.platformLazyValue(
  material: () => showTimePicker(
    context: context,
    initialTime: initialTime,
    anchorPoint: materialTimePickerData?.anchorPoint ?? anchorPoint,
    orientation: materialTimePickerData?.orientation,
    barrierColor: materialTimePickerData?.barrierColor ?? barrierColor,
    barrierDismissible:
        materialTimePickerData?.barrierDismissible ??
        barrierDismissible ??
        kMaterialBarrierDismissible,
    routeSettings: materialTimePickerData?.routeSettings ?? routeSettings,
    onEntryModeChanged: materialTimePickerData?.onEntryModeChanged,
    useRootNavigator: materialTimePickerData?.useRootNavigator ?? useRootNavigator,
    builder: materialTimePickerData?.builder ?? builder,
    initialEntryMode:
        materialTimePickerData?.initialEntryMode ?? MaterialTimePickerData.kDefaultInitialEntryMode,
    helpText: materialTimePickerData?.helpText,
    cancelText: materialTimePickerData?.cancelText,
    confirmText: materialTimePickerData?.confirmText,
    hourLabelText: materialTimePickerData?.hourLabelText,
    minuteLabelText: materialTimePickerData?.minuteLabelText,
    barrierLabel: materialTimePickerData?.barrierLabel,
    errorInvalidText: materialTimePickerData?.errorInvalidText,
    switchToInputEntryModeIcon: materialTimePickerData?.switchToInputEntryModeIcon,
    switchToTimerEntryModeIcon: materialTimePickerData?.switchToTimerEntryModeIcon,
    emptyInitialInput: materialTimePickerData?.emptyInitialInput ?? false,
  ),
  cupertino: () async {
    var selectedDateTime = initialTime.toDateTime();
    final resolvedBuilder = cupertinoTimePickerData?.builder ?? builder;

    final pickerWidget = CupertinoDatePicker(
      initialDateTime: selectedDateTime,
      selectableDayPredicate: cupertinoTimePickerData?.selectableDayPredicate,
      mode: .time,
      onDateTimeChanged: (dateTime) => selectedDateTime = dateTime,
      backgroundColor: cupertinoTimePickerData?.backgroundColor,
      changeReportingBehavior:
          cupertinoTimePickerData?.changeReportingBehavior ??
          ChangeReportingBehavior.onScrollUpdate,
      dateOrder: cupertinoTimePickerData?.dateOrder,
      itemExtent: cupertinoTimePickerData?.itemExtent ?? CupertinoDatePickerData.kDefaultItemExtent,
      maximumYear: cupertinoTimePickerData?.maximumYear,
      minimumYear:
          cupertinoTimePickerData?.minimumYear ?? CupertinoDatePickerData.kDefaultMinimumYear,
      minuteInterval:
          cupertinoTimePickerData?.minuteInterval ?? CupertinoDatePickerData.kDefaultMinuteInterval,
      selectionOverlayBuilder: cupertinoTimePickerData?.selectionOverlayBuilder,
      showDayOfWeek:
          cupertinoTimePickerData?.showDayOfWeek ?? CupertinoDatePickerData.kDefaultShowDayOfWeek,
      showTimeSeparator:
          cupertinoTimePickerData?.showTimeSeparator ??
          CupertinoDatePickerData.kDefaultShowTimeSeparator,
      use24hFormat:
          cupertinoTimePickerData?.use24hFormat ?? CupertinoDatePickerData.kDefaultUse24hFormat,
    );

    await showCupertinoModalPopup<void>(
      context: context,
      anchorPoint: cupertinoTimePickerData?.anchorPoint ?? anchorPoint,
      barrierColor:
          cupertinoTimePickerData?.barrierColor ??
          barrierColor ??
          CupertinoDatePickerData.kDefaultModalBarrierColor,
      barrierDismissible:
          cupertinoTimePickerData?.barrierDismissible ??
          barrierDismissible ??
          kCupertinoBarrierDismissible,
      routeSettings: cupertinoTimePickerData?.routeSettings ?? routeSettings,
      useRootNavigator: cupertinoTimePickerData?.useRootNavigator ?? useRootNavigator,
      filter: cupertinoTimePickerData?.filter,
      requestFocus: cupertinoTimePickerData?.requestFocus,
      semanticsDismissible:
          cupertinoTimePickerData?.semanticsDismissible ??
          CupertinoDatePickerData.kDefaultSemanticsDismissible,
      builder: (context) =>
          resolvedBuilder?.call(context, pickerWidget) ??
          _CupertinoPickerContainer(pickerWidget: pickerWidget),
    );

    return TimeOfDay.fromDateTime(selectedDateTime);
  },
);

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
