import 'package:flutter/cupertino.dart' show CupertinoRadio;
import 'package:flutter/material.dart' show Radio;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_radio_group_data.dart';
import '/models/platform_widget_base.dart';

class PlatformRadioGroup<T> extends PlatformWidgetBase {
  final PlatformRadioGroupData<T> platformRadioGroupData;
  final PlatformRadioData<T>? platformRadioData;
  final MaterialRadioData<T>? materialRadioData;
  final CupertinoRadioData<T>? cupertinoRadioData;

  const PlatformRadioGroup({
    required this.platformRadioGroupData,
    this.platformRadioData,
    this.materialRadioData,
    this.cupertinoRadioData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    final resolvedMaterialRadioData = MaterialRadioData<T>(
      widgetKey: materialRadioData?.widgetKey ?? platformRadioData?.widgetKey,
      mouseCursor: materialRadioData?.mouseCursor ?? platformRadioData?.mouseCursor,
      toggleable:
          materialRadioData?.toggleable ??
          platformRadioData?.toggleable ??
          PlatformRadioData.kDefaultToggleable,
      activeColor: materialRadioData?.activeColor ?? platformRadioData?.activeColor,
      fillColor: materialRadioData?.fillColor,
      focusColor: materialRadioData?.focusColor ?? platformRadioData?.focusColor,
      hoverColor: materialRadioData?.hoverColor,
      overlayColor: materialRadioData?.overlayColor,
      splashRadius: materialRadioData?.splashRadius,
      materialTapTargetSize: materialRadioData?.materialTapTargetSize,
      visualDensity: materialRadioData?.visualDensity,
      focusNode: materialRadioData?.focusNode ?? platformRadioData?.focusNode,
      autofocus:
          materialRadioData?.autofocus ??
          platformRadioData?.autofocus ??
          PlatformRadioData.kDefaultAutofocus,
      enabled:
          materialRadioData?.enabled ??
          platformRadioData?.enabled ??
          PlatformRadioData.kDefaultEnabled,
      groupRegistry: materialRadioData?.groupRegistry ?? platformRadioData?.groupRegistry,
      backgroundColor: materialRadioData?.backgroundColor,
      side: materialRadioData?.side,
      innerRadius: materialRadioData?.innerRadius,
    );

    return RadioGroup(
      groupValue: platformRadioGroupData.groupValue,
      onChanged: platformRadioGroupData.onChanged,
      child: platformRadioGroupData.groupBuilder.call([
        for (final value in platformRadioGroupData.groupValues)
          Radio(
            key: resolvedMaterialRadioData.widgetKey,
            value: value,
            mouseCursor: resolvedMaterialRadioData.mouseCursor,
            toggleable: resolvedMaterialRadioData.toggleable,
            activeColor: resolvedMaterialRadioData.activeColor,
            fillColor: resolvedMaterialRadioData.fillColor,
            focusColor: resolvedMaterialRadioData.focusColor,
            hoverColor: resolvedMaterialRadioData.hoverColor,
            overlayColor: resolvedMaterialRadioData.overlayColor,
            splashRadius: resolvedMaterialRadioData.splashRadius,
            materialTapTargetSize: resolvedMaterialRadioData.materialTapTargetSize,
            visualDensity: resolvedMaterialRadioData.visualDensity,
            focusNode: resolvedMaterialRadioData.focusNode,
            autofocus: resolvedMaterialRadioData.autofocus,
            enabled: resolvedMaterialRadioData.enabled,
            groupRegistry: resolvedMaterialRadioData.groupRegistry,
            backgroundColor: resolvedMaterialRadioData.backgroundColor,
            side: resolvedMaterialRadioData.side,
            innerRadius: resolvedMaterialRadioData.innerRadius,
          ),
      ]),
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedCupertinoRadioData = CupertinoRadioData<T>(
      widgetKey: cupertinoRadioData?.widgetKey ?? platformRadioData?.widgetKey,
      mouseCursor: cupertinoRadioData?.mouseCursor ?? platformRadioData?.mouseCursor,
      toggleable:
          cupertinoRadioData?.toggleable ??
          platformRadioData?.toggleable ??
          PlatformRadioData.kDefaultToggleable,
      activeColor: cupertinoRadioData?.activeColor ?? platformRadioData?.activeColor,
      inactiveColor: cupertinoRadioData?.inactiveColor,
      fillColor: cupertinoRadioData?.fillColor,
      focusColor: cupertinoRadioData?.focusColor ?? platformRadioData?.focusColor,
      focusNode: cupertinoRadioData?.focusNode ?? platformRadioData?.focusNode,
      autofocus:
          cupertinoRadioData?.autofocus ??
          platformRadioData?.autofocus ??
          PlatformRadioData.kDefaultAutofocus,
      useCheckmarkStyle:
          cupertinoRadioData?.useCheckmarkStyle ?? CupertinoRadioData.kDefaultUseCheckmarkStyle,
      enabled:
          cupertinoRadioData?.enabled ??
          platformRadioData?.enabled ??
          PlatformRadioData.kDefaultEnabled,
      groupRegistry: cupertinoRadioData?.groupRegistry ?? platformRadioData?.groupRegistry,
    );

    return RadioGroup(
      groupValue: platformRadioGroupData.groupValue,
      onChanged: platformRadioGroupData.onChanged,
      child: platformRadioGroupData.groupBuilder.call([
        for (final value in platformRadioGroupData.groupValues)
          CupertinoRadio(
            key: resolvedCupertinoRadioData.widgetKey,
            value: value,
            mouseCursor: resolvedCupertinoRadioData.mouseCursor,
            toggleable: resolvedCupertinoRadioData.toggleable,
            activeColor: resolvedCupertinoRadioData.activeColor,
            inactiveColor: resolvedCupertinoRadioData.inactiveColor,
            fillColor: resolvedCupertinoRadioData.fillColor,
            focusColor: resolvedCupertinoRadioData.focusColor,
            focusNode: resolvedCupertinoRadioData.focusNode,
            autofocus: resolvedCupertinoRadioData.autofocus,
            useCheckmarkStyle: resolvedCupertinoRadioData.useCheckmarkStyle,
            enabled: resolvedCupertinoRadioData.enabled,
            groupRegistry: resolvedCupertinoRadioData.groupRegistry,
          ),
      ]),
    );
  }
}
