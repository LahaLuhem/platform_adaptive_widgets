import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSwitch;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Switch;

import '/src/models/interaction/platform_switch_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive switch that renders Material [Switch] on Android
/// and [CupertinoSwitch] on iOS.
///
/// All functional inputs (value, callbacks, state-gating, behavioral tuning)
/// and shared visual defaults live as flat constructor parameters. Per-platform
/// visual tuning is opt-in via [materialSwitchData] and [cupertinoSwitchData].
/// See `APPENDIX.md#field-classification` for the classification rule and
/// `APPENDIX.md#cross-platform-field-mappings` for fields whose underlying
/// parameter name diverges from the package's unified name.
///
/// Example:
/// ```dart
/// PlatformSwitch(
///   value: _isOn,
///   onChanged: (v) => setState(() => _isOn = v),
/// )
/// ```
class PlatformSwitch extends PlatformWidgetKeyedBase {
  /// Current value of the switch.
  final bool value;

  /// Callback fired when the user changes the switch value.
  ///
  /// Required and non-null. To disable the switch, set [isEnabled] to
  /// `false` — do **not** pass `null` here. See
  /// `APPENDIX.md#callback-nullability`.
  final ValueChanged<bool> onChanged;

  /// Whether the switch is enabled and responds to input.
  ///
  /// When `false`, the underlying platform widget receives `null` for its
  /// own `onChanged` parameter, producing the platform's standard
  /// disabled-switch rendering. [onChanged] is still required and non-null
  /// at construction — the disable gate is read here, not encoded by a
  /// null callback.
  final bool isEnabled;

  /// Drag start behavior for the switch.
  final DragStartBehavior dragStartBehavior;

  /// Focus node for the switch.
  final FocusNode? focusNode;

  /// Callback when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Whether the switch should autofocus.
  final bool autofocus;

  /// Color of the thumb when the switch is active.
  ///
  /// Maps to [CupertinoSwitch.thumbColor] on iOS (Cupertino's `thumbColor`
  /// represents the active-state thumb color). See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Color? activeThumbColor;

  /// Color of the track when the switch is active.
  final Color? activeTrackColor;

  /// Color of the thumb when the switch is inactive.
  final Color? inactiveThumbColor;

  /// Color of the track when the switch is inactive.
  final Color? inactiveTrackColor;

  /// Color of the switch when focused.
  final Color? focusColor;

  /// Image displayed on the thumb when the switch is active.
  final ImageProvider? activeThumbImage;

  /// Error listener for the active thumb image. Tightly coupled to
  /// [activeThumbImage] — classified as shared visual rather than functional.
  final ImageErrorListener? onActiveThumbImageError;

  /// Image displayed on the thumb when the switch is inactive.
  final ImageProvider? inactiveThumbImage;

  /// Error listener for the inactive thumb image. Tightly coupled to
  /// [inactiveThumbImage] — classified as shared visual rather than functional.
  final ImageErrorListener? onInactiveThumbImageError;

  /// Track outline color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? trackOutlineColor;

  /// Track outline width as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? trackOutlineWidth;

  /// Thumb icon as a [WidgetStateProperty].
  final WidgetStateProperty<Icon?>? thumbIcon;

  /// Mouse cursor as a [WidgetStateProperty].
  ///
  /// On Android the value is resolved to a single [MouseCursor] before being
  /// passed to [Switch.mouseCursor]. On iOS the value is forwarded to
  /// [CupertinoSwitch.mouseCursor] as-is. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<MouseCursor>? mouseCursor;

  /// Material-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Material branch; Material-only fields (e.g. `thumbColor`
  /// state-property, `splashRadius`) are read only from here.
  final MaterialSwitchData? materialSwitchData;

  /// Cupertino-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Cupertino branch; Cupertino-only fields (e.g.
  /// `applyTheme`, `onLabelColor`) are read only from here.
  final CupertinoSwitchData? cupertinoSwitchData;

  /// Creates a platform-adaptive switch.
  ///
  /// [value] and [onChanged] are required and non-null. Disable the switch
  /// via [isEnabled], not by passing a null callback.
  const PlatformSwitch({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.activeThumbColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.focusColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.mouseCursor,
    this.materialSwitchData,
    this.cupertinoSwitchData,
    super.widgetKey,
    super.key,
  });

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
