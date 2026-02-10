import 'package:flutter/cupertino.dart' show CupertinoButton, CupertinoColors;
import 'package:flutter/material.dart'
    show ElevatedButton, FilledButton, OutlinedButton, TextButton;
import 'package:flutter/widgets.dart';

import '../../models/interaction/platform_button_data.dart';
import '../../models/platform_widget_base.dart';

class PlatformButton extends PlatformWidgetKeyedBase {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool? autofocus;

  final Widget? child;

  final MaterialButtonData? materialButtonData;
  final CupertinoButtonData? cupertinoButtonData;

  final MaterialButtonVariant materialButtonVariant;
  final CupertinoButtonVariant cupertinoButtonVariant;

  const PlatformButton({
    this.materialButtonVariant = .elevated,
    this.cupertinoButtonVariant = .normal,
    this.isEnabled = true,
    super.widgetKey,
    super.key,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.materialButtonData,
    this.cupertinoButtonData,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    final resolvedMaterialButtonData = MaterialButtonData(
      widgetKey: materialButtonData?.widgetKey ?? widgetKey,
      onPressed: materialButtonData?.onPressed ?? onPressed!,
      onLongPress: materialButtonData?.onLongPress ?? onLongPress,
      mouseCursor: materialButtonData?.mouseCursor ?? mouseCursor,
      focusNode: materialButtonData?.focusNode ?? focusNode,
      autofocus: materialButtonData?.autofocus ?? autofocus ?? kDefaultAutofocus,
      child: materialButtonData?.child ?? child,
      onHover: materialButtonData?.onHover,
      onFocusChange: materialButtonData?.onFocusChange,
      style: materialButtonData?.style,
      statesController: materialButtonData?.statesController,
      isSemanticButton: materialButtonData?.isSemanticButton,
      icon: materialButtonData?.icon,
      label: materialButtonData?.label,
      iconAlignment: materialButtonData?.iconAlignment,
    );
    assert(
      (resolvedMaterialButtonData.child != null) ^ (resolvedMaterialButtonData.icon != null),
      'child and icon are mutually exclusive: provide either one.',
    );
    assert(
      (resolvedMaterialButtonData.child != null) ^ (resolvedMaterialButtonData.label != null),
      'child and label are mutually exclusive: provide either one.',
    );

    return switch ((materialButtonVariant, resolvedMaterialButtonData.useNormalConstructor)) {
      (.text, true) => TextButton(
        key: resolvedMaterialButtonData.widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        isSemanticButton: resolvedMaterialButtonData.isSemanticButton,
        child: child!,
      ),
      (.text, false) => TextButton.icon(
        key: widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        label: resolvedMaterialButtonData.label!,
        icon: resolvedMaterialButtonData.icon,
        iconAlignment: resolvedMaterialButtonData.iconAlignment,
      ),
      (.elevated, true) => ElevatedButton(
        key: resolvedMaterialButtonData.widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        child: child,
      ),
      (.elevated, false) => ElevatedButton.icon(
        key: widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        label: resolvedMaterialButtonData.label!,
        icon: resolvedMaterialButtonData.icon,
        iconAlignment: resolvedMaterialButtonData.iconAlignment,
      ),
      (.outlined, true) => OutlinedButton(
        key: resolvedMaterialButtonData.widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        child: child,
      ),
      (.outlined, false) => OutlinedButton.icon(
        key: widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        label: resolvedMaterialButtonData.label!,
        icon: resolvedMaterialButtonData.icon,
        iconAlignment: resolvedMaterialButtonData.iconAlignment,
      ),
      //TODO(lahaluhem): Add support for .tonal + .tonalIcon
      (.filled, true) => FilledButton(
        key: resolvedMaterialButtonData.widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        child: child,
      ),
      (.filled, false) => FilledButton.icon(
        key: widgetKey,
        onPressed: !isEnabled ? null : resolvedMaterialButtonData.onPressed,
        onLongPress: !isEnabled ? null : resolvedMaterialButtonData.onLongPress,
        focusNode: resolvedMaterialButtonData.focusNode,
        autofocus: resolvedMaterialButtonData.autofocus,
        onHover: resolvedMaterialButtonData.onHover,
        onFocusChange: resolvedMaterialButtonData.onFocusChange,
        style: resolvedMaterialButtonData.style,
        clipBehavior: resolvedMaterialButtonData.clipBehavior,
        statesController: resolvedMaterialButtonData.statesController,
        label: resolvedMaterialButtonData.label!,
        icon: resolvedMaterialButtonData.icon,
        iconAlignment: resolvedMaterialButtonData.iconAlignment,
      ),
    };
  }

  @override
  Widget buildCupertino(BuildContext context) => switch (cupertinoButtonVariant) {
    .normal => CupertinoButton(
      key: cupertinoButtonData?.widgetKey ?? widgetKey,
      onPressed: !isEnabled ? null : cupertinoButtonData?.onPressed ?? onPressed,
      onLongPress: !isEnabled ? null : cupertinoButtonData?.onLongPress ?? onLongPress,
      mouseCursor: cupertinoButtonData?.mouseCursor ?? mouseCursor,
      focusNode: cupertinoButtonData?.focusNode ?? focusNode,
      autofocus: cupertinoButtonData?.autofocus ?? autofocus ?? kDefaultAutofocus,
      sizeStyle: cupertinoButtonData?.sizeStyle ?? CupertinoButtonData.kDefaultSizeStyle,
      padding: cupertinoButtonData?.padding,
      color: cupertinoButtonData?.color,
      onFocusChange: cupertinoButtonData?.onFocusChange,
      foregroundColor: cupertinoButtonData?.foregroundColor,
      disabledColor: cupertinoButtonData?.disabledColor ?? CupertinoColors.quaternarySystemFill,
      minimumSize: cupertinoButtonData?.minimumSize,
      pressedOpacity: cupertinoButtonData?.pressedOpacity,
      borderRadius: cupertinoButtonData?.borderRadius,
      alignment: cupertinoButtonData?.alignment ?? CupertinoButtonData.kDefaultAlignment,
      focusColor: cupertinoButtonData?.focusColor,
      child: cupertinoButtonData?.child ?? child!,
    ),
    .filled => CupertinoButton.filled(
      key: cupertinoButtonData?.widgetKey ?? widgetKey,
      onPressed: cupertinoButtonData?.onPressed ?? onPressed,
      onLongPress: cupertinoButtonData?.onLongPress ?? onLongPress,
      mouseCursor: cupertinoButtonData?.mouseCursor ?? mouseCursor,
      focusNode: cupertinoButtonData?.focusNode ?? focusNode,
      autofocus: cupertinoButtonData?.autofocus ?? autofocus ?? kDefaultAutofocus,
      sizeStyle: cupertinoButtonData?.sizeStyle ?? CupertinoButtonData.kDefaultSizeStyle,
      padding: cupertinoButtonData?.padding,
      color: cupertinoButtonData?.color,
      onFocusChange: cupertinoButtonData?.onFocusChange,
      foregroundColor: cupertinoButtonData?.foregroundColor,
      disabledColor: cupertinoButtonData?.disabledColor ?? CupertinoColors.tertiarySystemFill,
      minimumSize: cupertinoButtonData?.minimumSize,
      pressedOpacity: cupertinoButtonData?.pressedOpacity,
      borderRadius: cupertinoButtonData?.borderRadius,
      alignment: cupertinoButtonData?.alignment ?? CupertinoButtonData.kDefaultAlignment,
      focusColor: cupertinoButtonData?.focusColor,
      child: cupertinoButtonData?.child ?? child!,
    ),
    .tinted => CupertinoButton.tinted(
      key: cupertinoButtonData?.widgetKey ?? widgetKey,
      onPressed: cupertinoButtonData?.onPressed ?? onPressed,
      onLongPress: cupertinoButtonData?.onLongPress ?? onLongPress,
      mouseCursor: cupertinoButtonData?.mouseCursor ?? mouseCursor,
      focusNode: cupertinoButtonData?.focusNode ?? focusNode,
      autofocus: cupertinoButtonData?.autofocus ?? autofocus ?? kDefaultAutofocus,
      sizeStyle: cupertinoButtonData?.sizeStyle ?? CupertinoButtonData.kDefaultSizeStyle,
      padding: cupertinoButtonData?.padding,
      color: cupertinoButtonData?.color,
      onFocusChange: cupertinoButtonData?.onFocusChange,
      foregroundColor: cupertinoButtonData?.foregroundColor,
      disabledColor: cupertinoButtonData?.disabledColor ?? CupertinoColors.tertiarySystemFill,
      minimumSize: cupertinoButtonData?.minimumSize,
      pressedOpacity: cupertinoButtonData?.pressedOpacity,
      borderRadius: cupertinoButtonData?.borderRadius,
      alignment: cupertinoButtonData?.alignment ?? CupertinoButtonData.kDefaultAlignment,
      focusColor: cupertinoButtonData?.focusColor,
      child: cupertinoButtonData?.child ?? child!,
    ),
  };
}

enum MaterialButtonVariant { text, elevated, outlined, filled }

enum CupertinoButtonVariant { normal, filled, tinted }
