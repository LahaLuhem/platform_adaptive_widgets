// ignore_for_file: prefer-match-file-name

part of 'platform_date_picker.dart';

/// Shows a time picker. Material's [showTimePicker] on Android, a [CupertinoDatePicker] in a bottom
/// popup on iOS.
///
/// iOS draws this with the same widget as [showPlatformDatePicker] and only changes its `mode`, which
/// is why [cupertinoTimePickerData] is a [CupertinoDatePickerData]. Date-only fields on it, like [CupertinoDatePickerData.showDayOfWeek],
/// are simply ignored here.
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
}) => switch (defaultTargetPlatform) {
  .android => showTimePicker(
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
  .iOS => _showCupertinoModePickerPopup(
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
  _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
};
