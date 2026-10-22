/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_date_picker.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDatePickerMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay, showTimePicker;

import '/src/extensions/time_of_day_extensions.dart';
import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_date_picker_data.dart';
import '/src/models/dialogs/platform_time_picker_data.dart';
import '/src/utils/design_language.dart';
import 'cupertino_picker_popup.dart';

/// Shows a time picker. [showTimePicker] on Material, a [CupertinoDatePicker] in a bottom
/// popup on Cupertino.
///
/// Cupertino draws this with the same widget as [showPlatformDatePicker] and only changes its `mode`,
/// which is why [cupertinoTimePickerData] is a [CupertinoDatePickerData]. Date-only fields on it, like
/// [CupertinoDatePickerData.showDayOfWeek], are simply ignored here.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_time_picker.dart#platform_time_picker}
Future<TimeOfDay?> showPlatformTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  TransitionBuilder? builder,
  MaterialTimePickerData? materialTimePickerData,
  CupertinoDatePickerData? cupertinoTimePickerData,
}) => switch (designLanguage) {
  .material => showTimePicker(
    context: context,
    initialTime: initialTime,
    anchorPoint: anchorPoint,
    orientation: materialTimePickerData?.orientation,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible ?? kMaterialBarrierDismissible,
    routeSettings: routeSettings,
    onEntryModeChanged: materialTimePickerData?.onEntryModeChanged,
    useRootNavigator: useRootNavigator,
    builder: builder,
    initialEntryMode:
        materialTimePickerData?.initialEntryMode ?? kDefaultMaterialTimePickerInitialEntryMode,
    helpText: materialTimePickerData?.helpText,
    cancelText: materialTimePickerData?.cancelText,
    confirmText: materialTimePickerData?.confirmText,
    hourLabelText: materialTimePickerData?.hourLabelText,
    minuteLabelText: materialTimePickerData?.minuteLabelText,
    barrierLabel: materialTimePickerData?.barrierLabel,
    errorInvalidText: materialTimePickerData?.errorInvalidText,
    switchToInputEntryModeIcon: materialTimePickerData?.switchToInputEntryModeIcon,
    switchToTimerEntryModeIcon: materialTimePickerData?.switchToTimerEntryModeIcon,
    emptyInitialInput:
        materialTimePickerData?.emptyInitialInput ?? kDefaultMaterialTimePickerEmptyInitialInput,
  ),
  .cupertino => showCupertinoPickerPopup(
    context: context,
    mode: CupertinoDatePickerMode.time,
    initialDateTime: initialTime.toDateTime(),
    anchorPoint: anchorPoint,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    requestFocus: requestFocus,
    builder: builder,
    cupertinoDatePickerData: cupertinoTimePickerData,
  ).then((dateTime) => dateTime == null ? null : TimeOfDay.fromDateTime(dateTime)),
};
