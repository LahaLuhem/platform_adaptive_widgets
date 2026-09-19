import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSwitch;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Switch;

import '/src/models/interaction/platform_switch_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [Switch] on Android, [CupertinoSwitch] on iOS.
///
/// Per-platform tuning lives in [materialSwitchData] / [cupertinoSwitchData]. See `APPENDIX.md#field-classification`,
/// and `APPENDIX.md#cross-platform-field-mappings` where a field's name here doesn't match the one underneath.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_switch.dart#platform_switch}
class const PlatformSwitch({
  required final bool value,

  /// Stays required and non-null even for a disabled switch. That's [isEnabled]'s job, not a null callback's.
  /// See `APPENDIX.md#callback-nullability`.
  required final ValueChanged<bool> onChanged,

  /// The way to disable a switch, passing the underlying widget a `null` callback for its standard disabled
  /// look.
  final bool isEnabled = true,

  final DragStartBehavior dragStartBehavior = .start,

  final FocusNode? focusNode,

  final ValueChanged<bool>? onFocusChange,

  final bool autofocus = false,

  /// iOS calls this [CupertinoSwitch.thumbColor], which despite the plain name only covers the switched-on
  /// thumb. See `APPENDIX.md#cross-platform-field-mappings`.
  final Color? activeThumbColor,

  final Color? activeTrackColor,

  final Color? inactiveThumbColor,

  final Color? inactiveTrackColor,

  final Color? focusColor,

  final ImageProvider? activeThumbImage,

  final ImageErrorListener? onActiveThumbImageError,

  final ImageProvider? inactiveThumbImage,

  final ImageErrorListener? onInactiveThumbImageError,

  final WidgetStateProperty<Color?>? trackOutlineColor,

  final WidgetStateProperty<double?>? trackOutlineWidth,

  final WidgetStateProperty<Icon?>? thumbIcon,

  /// iOS takes the property as-is. Android wants one [MouseCursor] and gets a resolved copy. See `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<MouseCursor>? mouseCursor,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialSwitchData? materialSwitchData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoSwitchData? cupertinoSwitchData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive switch. Disable it with [isEnabled] rather than a null callback.
  this;

  @override
  Widget buildMaterial(BuildContext context) => Switch(
    key: widgetKey,
    value: value,
    onChanged: !isEnabled ? null : onChanged,
    activeThumbColor: materialSwitchData?.activeThumbColor ?? activeThumbColor,
    activeTrackColor: materialSwitchData?.activeTrackColor ?? activeTrackColor,
    inactiveThumbColor: materialSwitchData?.inactiveThumbColor ?? inactiveThumbColor,
    inactiveTrackColor: materialSwitchData?.inactiveTrackColor ?? inactiveTrackColor,
    focusColor: materialSwitchData?.focusColor ?? focusColor,
    activeThumbImage: materialSwitchData?.activeThumbImage ?? activeThumbImage,
    onActiveThumbImageError: materialSwitchData?.onActiveThumbImageError ?? onActiveThumbImageError,
    inactiveThumbImage: materialSwitchData?.inactiveThumbImage ?? inactiveThumbImage,
    onInactiveThumbImageError:
        materialSwitchData?.onInactiveThumbImageError ?? onInactiveThumbImageError,
    trackOutlineColor: materialSwitchData?.trackOutlineColor ?? trackOutlineColor,
    trackOutlineWidth: materialSwitchData?.trackOutlineWidth ?? trackOutlineWidth,
    thumbIcon: materialSwitchData?.thumbIcon ?? thumbIcon,
    mouseCursor: (materialSwitchData?.mouseCursor ?? mouseCursor)?.resolve({
      .selected,
      .hovered,
      .focused,
      .disabled,
    }),
    dragStartBehavior: dragStartBehavior,
    focusNode: focusNode,
    onFocusChange: onFocusChange,
    autofocus: autofocus,
    thumbColor: materialSwitchData?.thumbColor,
    trackColor: materialSwitchData?.trackColor,
    overlayColor: materialSwitchData?.overlayColor,
    materialTapTargetSize: materialSwitchData?.materialTapTargetSize,
    hoverColor: materialSwitchData?.hoverColor,
    splashRadius: materialSwitchData?.splashRadius,
    padding: materialSwitchData?.padding,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSwitch(
    key: widgetKey,
    value: value,
    onChanged: !isEnabled ? null : onChanged,
    thumbColor: cupertinoSwitchData?.activeThumbColor ?? activeThumbColor,
    activeTrackColor: cupertinoSwitchData?.activeTrackColor ?? activeTrackColor,
    inactiveThumbColor: cupertinoSwitchData?.inactiveThumbColor ?? inactiveThumbColor,
    inactiveTrackColor: cupertinoSwitchData?.inactiveTrackColor ?? inactiveTrackColor,
    focusColor: cupertinoSwitchData?.focusColor ?? focusColor,
    activeThumbImage: cupertinoSwitchData?.activeThumbImage ?? activeThumbImage,
    onActiveThumbImageError:
        cupertinoSwitchData?.onActiveThumbImageError ?? onActiveThumbImageError,
    inactiveThumbImage: cupertinoSwitchData?.inactiveThumbImage ?? inactiveThumbImage,
    onInactiveThumbImageError:
        cupertinoSwitchData?.onInactiveThumbImageError ?? onInactiveThumbImageError,
    trackOutlineColor: cupertinoSwitchData?.trackOutlineColor ?? trackOutlineColor,
    trackOutlineWidth: cupertinoSwitchData?.trackOutlineWidth ?? trackOutlineWidth,
    thumbIcon: cupertinoSwitchData?.thumbIcon ?? thumbIcon,
    mouseCursor: cupertinoSwitchData?.mouseCursor ?? mouseCursor,
    dragStartBehavior: dragStartBehavior,
    focusNode: focusNode,
    onFocusChange: onFocusChange,
    autofocus: autofocus,
    applyTheme: cupertinoSwitchData?.applyTheme,
    onLabelColor: cupertinoSwitchData?.onLabelColor,
    offLabelColor: cupertinoSwitchData?.offLabelColor,
  );
}
