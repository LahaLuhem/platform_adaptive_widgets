import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoSlider;
import 'package:flutter/material.dart' show Slider;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_slider_data.dart';
import '/models/platform_widget_base.dart';

/// A platform-adaptive slider that renders Material Slider on Android
/// and CupertinoSlider on iOS.
///
/// This widget automatically selects the appropriate slider implementation based on the target platform:
/// - On Android: renders Material Design Slider
/// - On iOS: renders CupertinoSlider
///
/// The slider can be configured with platform-specific data through [materialSliderData]
/// and [cupertinoSliderData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformSlider(
///   platformSliderData: PlatformSliderData(
///     value: _sliderValue,
///     onChanged: (value) => setState(() => _sliderValue = value),
///   ),
/// )
/// ```
class PlatformSlider extends PlatformWidgetBase {
  /// Cupertino-specific slider data.
  final PlatformSliderData? cupertinoSliderData;

  /// Platform-shared slider data.
  final PlatformSliderData? platformSliderData;

  /// Material-specific slider data.
  final MaterialSliderData? materialSliderData;

  /// Creates a platform-adaptive slider.
  ///
  /// The slider will render as a Material Slider on Android and a CupertinoSlider on iOS.
  const PlatformSlider({
    this.platformSliderData,
    this.materialSliderData,
    this.cupertinoSliderData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Slider(
    key: materialSliderData?.widgetKey ?? platformSliderData?.widgetKey,
    value: materialSliderData?.value ?? platformSliderData!.value!,
    onChanged: !(materialSliderData?.isEnabled ?? platformSliderData!.isEnabled)
        ? null
        : materialSliderData?.onChanged ?? platformSliderData!.onChanged,
    secondaryTrackValue: materialSliderData?.secondaryTrackValue,
    onChangeStart: materialSliderData?.onChangeStart ?? platformSliderData?.onChangeStart,
    onChangeEnd: materialSliderData?.onChangeEnd ?? platformSliderData?.onChangeEnd,
    min: materialSliderData?.min ?? platformSliderData?.min ?? PlatformSliderData.kDefaultMin,
    max: materialSliderData?.max ?? platformSliderData?.max ?? PlatformSliderData.kDefaultMax,
    divisions: materialSliderData?.divisions ?? platformSliderData?.divisions,
    label: materialSliderData?.label,
    activeColor: materialSliderData?.activeColor,
    inactiveColor: materialSliderData?.inactiveColor,
    secondaryActiveColor: materialSliderData?.secondaryActiveColor,
    thumbColor: materialSliderData?.thumbColor,
    overlayColor: materialSliderData?.overlayColor,
    mouseCursor: materialSliderData?.mouseCursor,
    semanticFormatterCallback: materialSliderData?.semanticFormatterCallback,
    focusNode: materialSliderData?.focusNode,
    autofocus: materialSliderData?.autofocus ?? MaterialSliderData.kDefaultAutofocus,
    allowedInteraction: materialSliderData?.allowedInteraction,
    padding: materialSliderData?.padding,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSlider(
    key: cupertinoSliderData?.widgetKey ?? platformSliderData?.widgetKey,
    value: cupertinoSliderData?.value ?? platformSliderData!.value!,
    onChanged: !(cupertinoSliderData?.isEnabled ?? platformSliderData!.isEnabled)
        ? null
        : cupertinoSliderData?.onChanged ?? platformSliderData!.onChanged,
    onChangeStart: cupertinoSliderData?.onChangeStart ?? platformSliderData?.onChangeStart,
    onChangeEnd: cupertinoSliderData?.onChangeEnd ?? platformSliderData?.onChangeEnd,
    min: cupertinoSliderData?.min ?? platformSliderData?.min ?? PlatformSliderData.kDefaultMin,
    max: cupertinoSliderData?.max ?? platformSliderData?.max ?? PlatformSliderData.kDefaultMax,
    divisions: cupertinoSliderData?.divisions ?? platformSliderData?.divisions,
    activeColor: cupertinoSliderData?.activeColor ?? platformSliderData?.activeColor,
    thumbColor:
        cupertinoSliderData?.thumbColor ?? platformSliderData?.thumbColor ?? CupertinoColors.white,
  );
}
