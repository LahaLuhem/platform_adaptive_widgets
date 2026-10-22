// Named for the popup, its private shell rides along.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoDatePicker, CupertinoDatePickerMode, showCupertinoModalPopup;
import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';

/// One popup for both pickers, since Cupertino only changes the [CupertinoDatePicker]'s `mode` between
/// them. Callers cut the [DateTime] down to what they asked for.
Future<DateTime?> showCupertinoPickerPopup({
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
