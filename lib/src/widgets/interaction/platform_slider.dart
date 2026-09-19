import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlider;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Slider;

import '/src/models/interaction/platform_slider_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [Slider] on Android, [CupertinoSlider] on iOS.
///
/// Per-platform tuning lives in [materialSliderData] / [cupertinoSliderData]. See `APPENDIX.md#field-classification`,
/// and `APPENDIX.md#cross-platform-field-mappings` where the type underneath diverges, [thumbColor]
/// most of all.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_slider.dart#platform_slider}
class const PlatformSlider({
  required final double value,

  /// Stays required and non-null even for a disabled slider. That's [isEnabled]'s job, not a null callback's.
  /// See `APPENDIX.md#callback-nullability`.
  required final ValueChanged<double> onChanged,

  /// The way to disable a slider, passing the underlying widget a `null` callback for its standard disabled
  /// look.
  final bool isEnabled = true,

  /// Fires once as the drag begins, where [onChanged] fires all the way through it.
  final ValueChanged<double>? onChangeStart,

  /// Fires once as the drag ends.
  final ValueChanged<double>? onChangeEnd,

  final double min = 0.0,

  final double max = 1.0,

  /// Snaps the slider to this many steps instead of sliding freely.
  final int? divisions,

  /// Colours the filled part of the track, not the thumb.
  final Color? activeColor,

  /// [Slider.thumbColor] on Android falls through to the theme when `null`. [CupertinoSlider.thumbColor]
  /// can't be null, so iOS swaps in [kDefaultCupertinoSliderThumbColor]. See `APPENDIX.md#cross-platform-field-mappings`.
  final Color? thumbColor,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialSliderData? materialSliderData,

  /// Cupertino-branch overrides. Thin, since [CupertinoSlider] has nothing of its own beyond the shared
  /// fields, but here so you can retune those on iOS alone.
  final CupertinoSliderData? cupertinoSliderData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive slider. Disable it with [isEnabled] rather than a null callback.
  this;

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
