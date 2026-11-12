import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSwitch;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Switch;

import '/src/models/interaction/platform_switch_data.dart';
import '/src/models/platform_widget_base.dart';

/// [Switch] on Material, [CupertinoSwitch] on Cupertino.
///
/// Per-platform tuning lives in [materialSwitchData] / [cupertinoSwitchData]. See `APPENDIX.md#field-classification`,
/// and `APPENDIX.md#cross-platform-field-mappings` where a field's name here doesn't match the one underneath.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_switch.dart#platform_switch}
class const PlatformSwitch({
  /// Forwards to [Switch.value] on Material and [CupertinoSwitch.value] on Cupertino.
  required final bool value,

  /// Stays required and non-null even for a disabled switch. That's [isEnabled]'s job, not a null callback's.
  /// See `APPENDIX.md#callback-nullability`.
  required final ValueChanged<bool> onChanged,

  /// The way to disable a switch, passing the underlying widget a `null` callback for its standard disabled
  /// look.
  final bool isEnabled = true,

  /// {@macro cupertino_ui.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior = .start,

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode,

  /// {@macro cupertino_ui.inkwell.onFocusChange}
  ///
  /// On Cupertino, forwards to [CupertinoSwitch.onFocusChange].
  final ValueChanged<bool>? onFocusChange,

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus = false,

  /// Cupertino calls this [CupertinoSwitch.thumbColor], which despite the plain name only covers the
  /// switched-on thumb. See `APPENDIX.md#cross-platform-field-mappings`.
  final Color? activeThumbColor,

  /// Forwards to [Switch.activeTrackColor] on Material and [CupertinoSwitch.activeTrackColor] on Cupertino.
  final Color? activeTrackColor,

  /// Forwards to [Switch.inactiveThumbColor] on Material and [CupertinoSwitch.inactiveThumbColor] on
  /// Cupertino.
  final Color? inactiveThumbColor,

  /// Forwards to [Switch.inactiveTrackColor] on Material and [CupertinoSwitch.inactiveTrackColor] on
  /// Cupertino.
  final Color? inactiveTrackColor,

  /// Forwards to [Switch.focusColor] on Material and [CupertinoSwitch.focusColor] on Cupertino.
  final Color? focusColor,

  /// {@macro cupertino_ui.switch.activeThumbImage}
  final ImageProvider? activeThumbImage,

  /// {@macro cupertino_ui.switch.onActiveThumbImageError}
  final ImageErrorListener? onActiveThumbImageError,

  /// {@macro cupertino_ui.switch.inactiveThumbImage}
  final ImageProvider? inactiveThumbImage,

  /// {@macro cupertino_ui.switch.onInactiveThumbImageError}
  final ImageErrorListener? onInactiveThumbImageError,

  /// Forwards to [Switch.trackOutlineColor] on Material and [CupertinoSwitch.trackOutlineColor] on Cupertino.
  final WidgetStateProperty<Color?>? trackOutlineColor,

  /// Forwards to [Switch.trackOutlineWidth] on Material and [CupertinoSwitch.trackOutlineWidth] on Cupertino.
  final WidgetStateProperty<double?>? trackOutlineWidth,

  /// Forwards to [Switch.thumbIcon] on Material and [CupertinoSwitch.thumbIcon] on Cupertino.
  final WidgetStateProperty<Icon?>? thumbIcon,

  /// Cupertino takes the property as-is. Material wants one [MouseCursor] and gets a resolved copy.
  /// See `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<MouseCursor>? mouseCursor,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialSwitchData materialSwitchData = const MaterialSwitchData(),

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoSwitchData cupertinoSwitchData = const CupertinoSwitchData(),
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive switch. Disable it with [isEnabled] rather than a null callback.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) => Switch(
    key: widgetKey,
    value: value,
    onChanged: !isEnabled ? null : onChanged,
    activeThumbColor: materialSwitchData.activeThumbColor ?? activeThumbColor,
    activeTrackColor: materialSwitchData.activeTrackColor ?? activeTrackColor,
    inactiveThumbColor: materialSwitchData.inactiveThumbColor ?? inactiveThumbColor,
    inactiveTrackColor: materialSwitchData.inactiveTrackColor ?? inactiveTrackColor,
    focusColor: materialSwitchData.focusColor ?? focusColor,
    activeThumbImage: materialSwitchData.activeThumbImage ?? activeThumbImage,
    onActiveThumbImageError: materialSwitchData.onActiveThumbImageError ?? onActiveThumbImageError,
    inactiveThumbImage: materialSwitchData.inactiveThumbImage ?? inactiveThumbImage,
    onInactiveThumbImageError:
        materialSwitchData.onInactiveThumbImageError ?? onInactiveThumbImageError,
    trackOutlineColor: materialSwitchData.trackOutlineColor ?? trackOutlineColor,
    trackOutlineWidth: materialSwitchData.trackOutlineWidth ?? trackOutlineWidth,
    thumbIcon: materialSwitchData.thumbIcon ?? thumbIcon,
    mouseCursor: (materialSwitchData.mouseCursor ?? mouseCursor)?.resolve({
      .selected,
      .hovered,
      .focused,
      .disabled,
    }),
    dragStartBehavior: dragStartBehavior,
    focusNode: focusNode,
    onFocusChange: onFocusChange,
    autofocus: autofocus,
    thumbColor: materialSwitchData.thumbColor,
    trackColor: materialSwitchData.trackColor,
    overlayColor: materialSwitchData.overlayColor,
    materialTapTargetSize: materialSwitchData.materialTapTargetSize,
    hoverColor: materialSwitchData.hoverColor,
    splashRadius: materialSwitchData.splashRadius,
    padding: materialSwitchData.padding,
  );

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) => CupertinoSwitch(
    key: widgetKey,
    value: value,
    onChanged: !isEnabled ? null : onChanged,
    thumbColor: cupertinoSwitchData.activeThumbColor ?? activeThumbColor,
    activeTrackColor: cupertinoSwitchData.activeTrackColor ?? activeTrackColor,
    inactiveThumbColor: cupertinoSwitchData.inactiveThumbColor ?? inactiveThumbColor,
    inactiveTrackColor: cupertinoSwitchData.inactiveTrackColor ?? inactiveTrackColor,
    focusColor: cupertinoSwitchData.focusColor ?? focusColor,
    activeThumbImage: cupertinoSwitchData.activeThumbImage ?? activeThumbImage,
    onActiveThumbImageError: cupertinoSwitchData.onActiveThumbImageError ?? onActiveThumbImageError,
    inactiveThumbImage: cupertinoSwitchData.inactiveThumbImage ?? inactiveThumbImage,
    onInactiveThumbImageError:
        cupertinoSwitchData.onInactiveThumbImageError ?? onInactiveThumbImageError,
    trackOutlineColor: cupertinoSwitchData.trackOutlineColor ?? trackOutlineColor,
    trackOutlineWidth: cupertinoSwitchData.trackOutlineWidth ?? trackOutlineWidth,
    thumbIcon: cupertinoSwitchData.thumbIcon ?? thumbIcon,
    mouseCursor: cupertinoSwitchData.mouseCursor ?? mouseCursor,
    dragStartBehavior: dragStartBehavior,
    focusNode: focusNode,
    onFocusChange: onFocusChange,
    autofocus: autofocus,
    applyTheme: cupertinoSwitchData.applyTheme,
    onLabelColor: cupertinoSwitchData.onLabelColor,
    offLabelColor: cupertinoSwitchData.offLabelColor,
  );
}
