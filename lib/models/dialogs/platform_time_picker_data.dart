// ignore_for_file: prefer-match-file-name

import 'package:flutter/material.dart' show TimePickerEntryMode;
import 'package:flutter/widgets.dart';

final class _PlatformTimePickerData {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool? barrierDismissible;
  final RouteSettings? routeSettings;
  final bool? useRootNavigator;

  final TransitionBuilder? builder;

  const _PlatformTimePickerData({
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible,
    this.routeSettings,
    this.useRootNavigator,
    this.builder,
  });
}

final class MaterialTimePickerData extends _PlatformTimePickerData {
  final String? barrierLabel;
  final TimePickerEntryMode initialEntryMode;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;
  final String? errorInvalidText;
  final String? hourLabelText;
  final String? minuteLabelText;
  final ValueChanged<TimePickerEntryMode>? onEntryModeChanged;
  final Orientation? orientation;
  final Icon? switchToInputEntryModeIcon;
  final Icon? switchToTimerEntryModeIcon;
  final bool emptyInitialInput;

  static const kDefaultBarrierDismissible = false;
  static const kDefaultInitialEntryMode = TimePickerEntryMode.dial;
  static const kDefaultEmptyInitialInput = false;

  const MaterialTimePickerData({
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible = kDefaultBarrierDismissible,
    super.routeSettings,
    super.useRootNavigator,
    super.builder,
    this.barrierLabel,
    this.initialEntryMode = kDefaultInitialEntryMode,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.onEntryModeChanged,
    this.orientation,
    this.switchToInputEntryModeIcon,
    this.switchToTimerEntryModeIcon,
    this.emptyInitialInput = kDefaultEmptyInitialInput,
  });
}
