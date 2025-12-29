import 'package:flutter/cupertino.dart' show CupertinoSwitch;
import 'package:flutter/material.dart' show Switch;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_switch_data.dart';
import '/models/platform_widget_base.dart';

class PlatformSwitch extends PlatformWidgetKeyedBase {
  final PlatformSwitchData? platformSwitchData;
  final MaterialSwitchData? materialSwitchData;
  final CupertinoSwitchData? cupertinoSwitchData;

  const PlatformSwitch({
    this.platformSwitchData,
    this.materialSwitchData,
    this.cupertinoSwitchData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Switch(
    key: materialSwitchData?.widgetKey ?? platformSwitchData!.widgetKey,
    value: materialSwitchData?.value ?? platformSwitchData!.value!,
    onChanged: !(materialSwitchData?.isEnabled ?? platformSwitchData!.isEnabled)
        ? null
        : materialSwitchData?.onChanged ?? platformSwitchData!.onChanged,
    activeThumbColor: materialSwitchData?.activeThumbColor ?? platformSwitchData?.activeThumbColor,
    activeTrackColor: materialSwitchData?.activeTrackColor ?? platformSwitchData?.activeTrackColor,
    inactiveThumbColor:
        materialSwitchData?.inactiveThumbColor ?? platformSwitchData?.inactiveThumbColor,
    inactiveTrackColor:
        materialSwitchData?.inactiveTrackColor ?? platformSwitchData?.inactiveTrackColor,
    activeThumbImage: materialSwitchData?.activeThumbImage ?? platformSwitchData?.activeThumbImage,
    onActiveThumbImageError:
        materialSwitchData?.onActiveThumbImageError ?? platformSwitchData?.onActiveThumbImageError,
    inactiveThumbImage:
        materialSwitchData?.inactiveThumbImage ?? platformSwitchData?.inactiveThumbImage,
    onInactiveThumbImageError:
        materialSwitchData?.onInactiveThumbImageError ??
        platformSwitchData?.onInactiveThumbImageError,
    thumbColor: materialSwitchData?.thumbColor,
    trackColor: materialSwitchData?.trackColor,
    trackOutlineColor:
        materialSwitchData?.trackOutlineColor ?? platformSwitchData?.trackOutlineColor,
    trackOutlineWidth:
        materialSwitchData?.trackOutlineWidth ?? platformSwitchData?.trackOutlineWidth,
    thumbIcon: materialSwitchData?.thumbIcon ?? platformSwitchData?.thumbIcon,
    materialTapTargetSize: materialSwitchData?.materialTapTargetSize,
    dragStartBehavior:
        materialSwitchData?.dragStartBehavior ??
        platformSwitchData?.dragStartBehavior ??
        PlatformSwitchData.kDefaultDragStartBehavior,
    mouseCursor: (materialSwitchData?.mouseCursor ?? platformSwitchData?.mouseCursor)?.resolve({
      .selected,
      .hovered,
      .focused,
      .disabled,
    }),
    focusColor: materialSwitchData?.focusColor ?? platformSwitchData?.focusColor,
    hoverColor: materialSwitchData?.hoverColor,
    overlayColor: materialSwitchData?.overlayColor,
    splashRadius: materialSwitchData?.splashRadius,
    focusNode: materialSwitchData?.focusNode ?? platformSwitchData?.focusNode,
    onFocusChange: materialSwitchData?.onFocusChange ?? platformSwitchData?.onFocusChange,
    autofocus:
        materialSwitchData?.autofocus ??
        platformSwitchData?.autofocus ??
        PlatformSwitchData.kDefaultAutofocus,
    padding: materialSwitchData?.padding,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSwitch(
    key: cupertinoSwitchData?.widgetKey ?? platformSwitchData!.widgetKey,
    value: cupertinoSwitchData?.value ?? platformSwitchData!.value!,
    onChanged: !(cupertinoSwitchData?.isEnabled ?? platformSwitchData!.isEnabled)
        ? null
        : cupertinoSwitchData?.onChanged ?? platformSwitchData!.onChanged,
    activeTrackColor: cupertinoSwitchData?.activeTrackColor ?? platformSwitchData?.activeTrackColor,
    inactiveTrackColor:
        cupertinoSwitchData?.inactiveTrackColor ?? platformSwitchData?.inactiveTrackColor,
    thumbColor: cupertinoSwitchData?.activeThumbColor ?? platformSwitchData?.activeThumbColor,
    inactiveThumbColor:
        cupertinoSwitchData?.inactiveThumbColor ?? platformSwitchData?.inactiveThumbColor,
    applyTheme: cupertinoSwitchData?.applyTheme,
    focusColor: cupertinoSwitchData?.focusColor ?? platformSwitchData?.focusColor,
    onLabelColor: cupertinoSwitchData?.onLabelColor,
    offLabelColor: cupertinoSwitchData?.offLabelColor,
    activeThumbImage: cupertinoSwitchData?.activeThumbImage ?? platformSwitchData?.activeThumbImage,
    onActiveThumbImageError:
        cupertinoSwitchData?.onActiveThumbImageError ?? platformSwitchData?.onActiveThumbImageError,
    inactiveThumbImage:
        cupertinoSwitchData?.inactiveThumbImage ?? platformSwitchData?.inactiveThumbImage,
    onInactiveThumbImageError:
        cupertinoSwitchData?.onInactiveThumbImageError ??
        platformSwitchData?.onInactiveThumbImageError,
    trackOutlineColor:
        cupertinoSwitchData?.trackOutlineColor ?? platformSwitchData?.trackOutlineColor,
    trackOutlineWidth:
        cupertinoSwitchData?.trackOutlineWidth ?? platformSwitchData?.trackOutlineWidth,
    thumbIcon: cupertinoSwitchData?.thumbIcon ?? platformSwitchData?.thumbIcon,
    mouseCursor: cupertinoSwitchData?.mouseCursor ?? platformSwitchData?.mouseCursor,
    focusNode: cupertinoSwitchData?.focusNode ?? platformSwitchData?.focusNode,
    onFocusChange: cupertinoSwitchData?.onFocusChange ?? platformSwitchData?.onFocusChange,
    autofocus:
        cupertinoSwitchData?.autofocus ??
        platformSwitchData?.autofocus ??
        PlatformSwitchData.kDefaultAutofocus,
    dragStartBehavior:
        cupertinoSwitchData?.dragStartBehavior ??
        platformSwitchData?.dragStartBehavior ??
        PlatformSwitchData.kDefaultDragStartBehavior,
  );
}
