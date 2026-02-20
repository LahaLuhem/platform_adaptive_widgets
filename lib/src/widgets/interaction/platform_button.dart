import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton, CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ElevatedButton, FilledButton, OutlinedButton, TextButton;

import '/src/models/interaction/platform_button_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive button that renders Material Design buttons on Android
/// and Cupertino buttons on iOS.
///
/// This widget automatically selects the appropriate button type based on the target platform:
/// - On Android: renders Material buttons (TextButton, ElevatedButton, OutlinedButton, FilledButton)
/// - On iOS: renders Cupertino buttons (CupertinoButton, CupertinoButton.filled, CupertinoButton.tinted)
///
/// The button can be configured with platform-specific data through [materialButtonData]
/// and [cupertinoButtonData], or with common properties that work across platforms.
///
/// Example:
/// ```dart
/// PlatformButton(
///   onPressed: () => print('Button pressed'),
///   child: Text('Adaptive Button'),
///   materialButtonVariant: MaterialButtonVariant.elevated,
///   cupertinoButtonVariant: CupertinoButtonVariant.filled,
/// )
/// ```
class PlatformButton extends PlatformWidgetKeyedBase {
  /// Whether the button is enabled and can be pressed.
  ///
  /// When false, the button will be disabled and [onPressed] will be ignored.
  /// Defaults to true.
  final bool isEnabled;

  /// Callback that is called when the button is pressed.
  /// The button is disabled when [isEnabled] is false, even if [onPressed] is provided.
  final VoidCallback? onPressed;

  /// Callback that is called when the button is long-pressed.
  /// The button is disabled when [isEnabled] is false, even if [onLongPress] is provided.
  final VoidCallback? onLongPress;

  /// The cursor to display when the mouse hovers over the button.
  ///
  /// If null, the platform's default cursor will be used.
  final MouseCursor? mouseCursor;

  /// The focus node for the button.
  ///
  /// If null, a default focus node will be created.
  final FocusNode? focusNode;

  /// Whether the button should automatically focus when it's first displayed.
  ///
  /// If null, defaults to platform-specific behavior.
  final bool? autofocus;

  /// The widget to display as the button's label.
  ///
  /// This can be a Text widget, Icon, or any other widget. For Material buttons,
  /// this is mutually exclusive with providing an icon through [materialButtonData].
  final Widget? child;

  /// Platform-specific data for Material Design buttons.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on Android. See [MaterialButtonData] for available options.
  final MaterialButtonData? materialButtonData;

  /// Platform-specific data for Cupertino buttons.
  ///
  /// If provided, these properties will override the common properties when
  /// rendering on iOS. See [CupertinoButtonData] for available options.
  final CupertinoButtonData? cupertinoButtonData;

  /// The type of Material Design button to render on Android.
  ///
  /// Defaults to [MaterialButtonVariant.elevated].
  /// Each variant renders a different Material button type:
  /// - [MaterialButtonVariant.text]: TextButton
  /// - [MaterialButtonVariant.elevated]: ElevatedButton
  /// - [MaterialButtonVariant.outlined]: OutlinedButton
  /// - [MaterialButtonVariant.filled]: FilledButton
  final MaterialButtonVariant materialButtonVariant;

  /// The type of Cupertino button to render on iOS.
  ///
  /// Defaults to [CupertinoButtonVariant.normal].
  /// Each variant renders a different Cupertino button type:
  /// - [CupertinoButtonVariant.normal]: CupertinoButton
  /// - [CupertinoButtonVariant.filled]: CupertinoButton.filled
  /// - [CupertinoButtonVariant.tinted]: CupertinoButton.tinted
  final CupertinoButtonVariant cupertinoButtonVariant;

  /// Creates a platform-adaptive button.
  ///
  /// The button will render as a Material button on Android and a Cupertino button on iOS.
  /// Use [materialButtonVariant] and [cupertinoButtonVariant] to specify the button style
  /// for each platform.
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
        child: resolvedMaterialButtonData.child!,
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
        child: resolvedMaterialButtonData.child,
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
        child: resolvedMaterialButtonData.child,
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
        child: resolvedMaterialButtonData.child,
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

/// Material Design button variants available for [PlatformButton].
///
/// Each variant corresponds to a different Material Design button type:
/// - [text]: Renders as TextButton
/// - [elevated]: Renders as ElevatedButton (default)
/// - [outlined]: Renders as OutlinedButton
/// - [filled]: Renders as FilledButton
enum MaterialButtonVariant {
  /// Renders as a TextButton with no background.
  text,

  /// Renders as an ElevatedButton with elevation and fill.
  elevated,

  /// Renders as an OutlinedButton with a border.
  outlined,

  /// Renders as a FilledButton with a solid background.
  filled,
}

/// Cupertino button variants available for [PlatformButton].
///
/// Each variant corresponds to a different Cupertino button style:
/// - [normal]: Renders as CupertinoButton (default)
/// - [filled]: Renders as CupertinoButton.filled with a solid background
/// - [tinted]: Renders as CupertinoButton.tinted with a subtle background
enum CupertinoButtonVariant {
  /// Renders as a standard CupertinoButton with no background.
  normal,

  /// Renders as a CupertinoButton.filled with a solid background color.
  filled,

  /// Renders as a CupertinoButton.tinted with a subtle background tint.
  tinted,
}
