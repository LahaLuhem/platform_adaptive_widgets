import 'package:flutter/cupertino.dart' show CupertinoSlider;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Slider;

import '/src/models/interaction/platform_slider_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive slider that renders Material [Slider] on Android
/// and [CupertinoSlider] on iOS.
///
/// All functional inputs (value, callbacks, state-gating, range/divisions)
/// and shared visual defaults live as flat constructor parameters.
/// Per-platform visual tuning is opt-in via [materialSliderData] and
/// [cupertinoSliderData]. See `APPENDIX.md#field-classification` for the
/// classification rule and `APPENDIX.md#cross-platform-field-mappings` for
/// fields whose underlying parameter type diverges from the package's
/// unified type (notably [thumbColor]).
///
/// Example:
/// ```dart
/// PlatformSlider(
///   value: _value,
///   onChanged: (v) => setState(() => _value = v),
/// )
/// ```
class PlatformSlider extends PlatformWidgetKeyedBase {
  /// Current value of the slider.
  final double value;

  /// Callback fired when the user changes the slider value.
  ///
  /// Required and non-null. To disable the slider, set [isEnabled] to
  /// `false` — do **not** pass `null` here. See
  /// `APPENDIX.md#callback-nullability`.
  final ValueChanged<double> onChanged;

  /// Whether the slider is enabled and responds to input.
  ///
  /// When `false`, the underlying platform widget receives `null` for its
  /// `onChanged` callback (the platform-native "disabled" state). The
  /// package's [onChanged] field stays non-null regardless.
  final bool isEnabled;

  /// Optional observation callback fired when the user starts dragging.
  ///
  /// Nullable per the optional-callback rule in
  /// `APPENDIX.md#callback-nullability`.
  final ValueChanged<double>? onChangeStart;

  /// Optional observation callback fired when the user stops dragging.
  ///
  /// Nullable per the optional-callback rule in
  /// `APPENDIX.md#callback-nullability`.
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value of the slider. Defaults to `0.0`.
  final double min;

  /// Maximum value of the slider. Defaults to `1.0`.
  final double max;

  /// Number of discrete divisions on the slider.
  final int? divisions;

  /// Colour of the active portion of the slider track.
  ///
  /// Shared visual — overridable per platform via [materialSliderData] /
  /// [cupertinoSliderData].
  final Color? activeColor;

  /// Colour of the slider thumb.
  ///
  /// Maps to [Slider.thumbColor] on Android (typed `Color?`, theme-falls
  /// through when `null`) and to [CupertinoSlider.thumbColor] on iOS (typed
  /// non-null `Color`, defaulting to `CupertinoColors.white`). The Cupertino
  /// branch substitutes [kDefaultCupertinoSliderThumbColor] when `null`. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Color? thumbColor;

  /// Material-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Material branch; Material-only fields
  /// (`secondaryTrackValue`, `label`, `inactiveColor`, etc.) are read only
  /// from here.
  final MaterialSliderData? materialSliderData;

  /// Cupertino-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Cupertino branch. [CupertinoSlider] has no
  /// Cupertino-only fields beyond the shared-visual surface, so today this
  /// record carries only [activeColor] / [thumbColor]; it exists for API
  /// symmetry and to forward-compat with future Cupertino-only additions.
  final CupertinoSliderData? cupertinoSliderData;

  /// Creates a platform-adaptive slider.
  const PlatformSlider({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.thumbColor,
    this.materialSliderData,
    this.cupertinoSliderData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Slider(
    key: widgetKey,
    value: value,
    onChanged: isEnabled ? onChanged : null,
    onChangeStart: onChangeStart,
    onChangeEnd: onChangeEnd,
    min: min,
    max: max,
    divisions: divisions,
    activeColor: materialSliderData?.activeColor ?? activeColor,
    thumbColor: materialSliderData?.thumbColor ?? thumbColor,
    secondaryTrackValue: materialSliderData?.secondaryTrackValue,
    label: materialSliderData?.label,
    inactiveColor: materialSliderData?.inactiveColor,
    secondaryActiveColor: materialSliderData?.secondaryActiveColor,
    overlayColor: materialSliderData?.overlayColor,
    mouseCursor: materialSliderData?.mouseCursor,
    semanticFormatterCallback: materialSliderData?.semanticFormatterCallback,
    focusNode: materialSliderData?.focusNode,
    autofocus: materialSliderData?.autofocus ?? kDefaultSliderAutofocus,
    allowedInteraction: materialSliderData?.allowedInteraction,
    padding: materialSliderData?.padding,
    showValueIndicator: materialSliderData?.showValueIndicator,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSlider(
    key: widgetKey,
    value: value,
    onChanged: isEnabled ? onChanged : null,
    onChangeStart: onChangeStart,
    onChangeEnd: onChangeEnd,
    min: min,
    max: max,
    divisions: divisions,
    activeColor: cupertinoSliderData?.activeColor ?? activeColor,
    thumbColor: cupertinoSliderData?.thumbColor ?? thumbColor ?? kDefaultCupertinoSliderThumbColor,
  );
}
