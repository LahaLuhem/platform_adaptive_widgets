/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_time_picker.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDatePickerMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showDatePicker;
import 'package:minted_chronology/minted_chronology.dart' show Date;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';
import '/src/utils/design_language.dart';
import 'cupertino_picker_popup.dart';

/// Shows a date picker. [showDatePicker] on Material, a [CupertinoDatePicker] in a bottom
/// popup on Cupertino.
///
/// The Cupertino wheel reports as it turns and the value comes back once the popup closes. [CupertinoDatePickerData.changeReportingBehavior]
/// decides how often it reports.
///
/// Per-platform tuning lives in [materialDatePickerData] / [cupertinoDatePickerData], the latter shared
/// with [showPlatformTimePicker] since Cupertino draws both with one widget.
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

  return switch (designLanguage) {
    .material => showDatePicker(
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
    .cupertino => showCupertinoPickerPopup(
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
  };
}

// The picker clamps to [firstDate, lastDate], so the null arm is unreachable. Null beats throwing.
Date? _toDate(DateTime? dateTime) =>
    dateTime == null ? null : Date.fromDateTime(dateTime).getOrNull();
