// ignore_for_file: prefer-match-file-name

part of 'platform_date_picker.dart';

/// Shows a platform-adaptive time picker — Material [showTimePicker] on
/// Android, [CupertinoDatePicker] in time mode wrapped in
/// [showCupertinoModalPopup] on iOS.
///
/// The Cupertino side reuses the same widget + modal-popup scaffolding as
/// [showPlatformDatePicker] (only the `mode` differs) — so [cupertinoTimePickerData]
/// is the same [CupertinoDatePickerData] type as the date picker uses.
/// Mode-irrelevant fields ([CupertinoDatePickerData.showDayOfWeek] in time
/// mode, etc.) are silently ignored.
///
/// Example:
/// ```dart
/// final picked = await showPlatformTimePicker(
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
