import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoCheckbox;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Checkbox;

import '/src/models/interaction/platform_checkbox_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive checkbox that renders Material Design checkboxes on Android
/// and Cupertino checkboxes on iOS.
///
/// This widget automatically selects the appropriate checkbox implementation based on the target platform:
/// - On Android: renders Material Design Checkbox
/// - On iOS: renders CupertinoCheckbox
///
/// The checkbox can be configured with platform-specific data through [materialCheckboxData]
/// and [cupertinoCheckboxData], or with common properties through [platformCheckboxData].
///
/// Example:
/// ```dart
/// PlatformCheckbox(
///   platformCheckboxData: PlatformCheckboxData(
///     value: true,
///     onChanged: (bool? value) => print('Checkbox changed: $value'),
///   ),
/// )
/// ```
class PlatformCheckbox extends PlatformWidgetBase {
  /// Common checkbox data that applies to both platforms.
  ///
  /// These properties will be used unless overridden by platform-specific data.
  final PlatformCheckboxData? platformCheckboxData;

  /// Platform-specific data for Material Design checkboxes.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on Android. See [MaterialCheckboxData] for available options.
  final MaterialCheckboxData? materialCheckboxData;

  /// Platform-specific data for Cupertino checkboxes.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on iOS. See [CupertinoCheckboxData] for available options.
  final CupertinoCheckboxData? cupertinoCheckboxData;

  /// Creates a platform-adaptive checkbox.
  ///
  /// The checkbox will render as a Material checkbox on Android and a Cupertino checkbox on iOS.
  /// Use [platformCheckboxData] for common properties, or override with platform-specific data.
  const PlatformCheckbox({
    this.platformCheckboxData,
    this.materialCheckboxData,
    this.cupertinoCheckboxData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Checkbox(
    key: materialCheckboxData?.widgetKey ?? platformCheckboxData?.widgetKey,
    value: materialCheckboxData?.value ?? platformCheckboxData?.value,
    tristate: materialCheckboxData?.tristate ?? platformCheckboxData?.tristate ?? false,
    onChanged: !(materialCheckboxData?.isEnabled ?? platformCheckboxData!.isEnabled)
        ? null
        : materialCheckboxData?.onChanged ?? platformCheckboxData!.onChanged,
    mouseCursor: materialCheckboxData?.mouseCursor ?? platformCheckboxData?.mouseCursor,
    activeColor: materialCheckboxData?.activeColor ?? platformCheckboxData?.activeColor,
    fillColor: materialCheckboxData?.fillColor ?? platformCheckboxData?.fillColor,
    checkColor: materialCheckboxData?.checkColor ?? platformCheckboxData?.checkColor,
    focusColor: materialCheckboxData?.focusColor ?? platformCheckboxData?.focusColor,
    hoverColor: materialCheckboxData?.hoverColor,
    overlayColor: materialCheckboxData?.overlayColor,
    splashRadius: materialCheckboxData?.splashRadius,
    materialTapTargetSize: materialCheckboxData?.materialTapTargetSize,
    visualDensity: materialCheckboxData?.visualDensity,
    focusNode: materialCheckboxData?.focusNode ?? platformCheckboxData?.focusNode,
    autofocus:
        materialCheckboxData?.autofocus ??
        platformCheckboxData?.autofocus ??
        PlatformCheckboxData.kDefaultAutofocus,
    shape: materialCheckboxData?.shape ?? platformCheckboxData?.shape,
    side: materialCheckboxData?.side ?? platformCheckboxData?.side,
    isError: materialCheckboxData?.isError ?? MaterialCheckboxData.kDefaultIsError,
    semanticLabel: materialCheckboxData?.semanticLabel ?? platformCheckboxData?.semanticLabel,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoCheckbox(
    key: cupertinoCheckboxData?.widgetKey ?? platformCheckboxData?.widgetKey,
    value: cupertinoCheckboxData?.value ?? platformCheckboxData?.value,
    tristate: cupertinoCheckboxData?.tristate ?? platformCheckboxData?.tristate ?? false,
    onChanged: !(cupertinoCheckboxData?.isEnabled ?? platformCheckboxData!.isEnabled)
        ? null
        : cupertinoCheckboxData?.onChanged ?? platformCheckboxData!.onChanged,
    mouseCursor: cupertinoCheckboxData?.mouseCursor ?? platformCheckboxData?.mouseCursor,
    activeColor: cupertinoCheckboxData?.activeColor ?? platformCheckboxData?.activeColor,
    fillColor: cupertinoCheckboxData?.fillColor ?? platformCheckboxData?.fillColor,
    checkColor: cupertinoCheckboxData?.checkColor ?? platformCheckboxData?.checkColor,
    focusColor: cupertinoCheckboxData?.focusColor ?? platformCheckboxData?.focusColor,
    focusNode: cupertinoCheckboxData?.focusNode ?? platformCheckboxData?.focusNode,
    autofocus:
        cupertinoCheckboxData?.autofocus ??
        platformCheckboxData?.autofocus ??
        PlatformCheckboxData.kDefaultAutofocus,
    side: cupertinoCheckboxData?.side ?? platformCheckboxData?.side,
    shape: cupertinoCheckboxData?.shape ?? platformCheckboxData?.shape,
    tapTargetSize: cupertinoCheckboxData?.tapTargetSize,
    semanticLabel: cupertinoCheckboxData?.semanticLabel ?? platformCheckboxData?.semanticLabel,
  );
}
