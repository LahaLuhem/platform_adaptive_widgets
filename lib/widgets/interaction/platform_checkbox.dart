import 'package:flutter/cupertino.dart' show CupertinoCheckbox;
import 'package:flutter/material.dart' show Checkbox;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_checkbox_data.dart';
import '/models/platform_widget_base.dart';

class PlatformCheckbox extends PlatformWidgetBase {
  final PlatformCheckboxData? platformCheckboxData;
  final MaterialCheckboxData? materialCheckboxData;
  final CupertinoCheckboxData? cupertinoCheckboxData;

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
