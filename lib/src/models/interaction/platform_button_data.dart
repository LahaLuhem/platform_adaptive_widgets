// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoButtonSize;
import 'package:flutter/material.dart' show ButtonStyle, IconAlignment;
import 'package:flutter/widgets.dart';

/// Default value for whether a widget should autofocus.
const kDefaultAutofocus = false;

/// Abstract base class for platform button data.
///
/// Contains common properties that apply to both Material and Cupertino buttons.
/// This class is used as a base for platform-specific button data classes.
abstract final class _PlatformButtonData {
  /// Optional key for the button widget.
  final Key? widgetKey;

  /// Whether the button is enabled and can be pressed.
  ///
  /// When false, the button will be disabled and [onPressed] will be ignored.
  final bool isEnabled;

  /// Callback that is called when the button is pressed.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Callback that is called when the button is long-pressed.
  ///
  /// If null, the button will not respond to long presses.
  final VoidCallback? onLongPress;

  /// The cursor to display when the mouse hovers over the button.
  final MouseCursor? mouseCursor;

  /// The focus node for the button.
  final FocusNode? focusNode;

  /// Whether the button should automatically focus when it's first displayed.
  final bool autofocus;

  /// The widget to display as the button's label.
  final Widget? child;

  /// Creates platform button data with common properties.
  const _PlatformButtonData({
    this.isEnabled = true,
    this.onPressed,
    this.widgetKey,
    this.onLongPress,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = kDefaultAutofocus,
    this.child,
  });
}

/// Material-specific configuration for a platform button.
///
/// Maps to properties of Material button widgets (e.g., `ElevatedButton`,
/// `TextButton`, `OutlinedButton`) on Android. Use this class to configure
/// platform-specific styling and behavior for Material buttons.
///
/// Example:
/// ```dart
/// MaterialButtonData(
///   style: ElevatedButton.styleFrom(
///     backgroundColor: Colors.blue,
///     foregroundColor: Colors.white,
///   ),
///   onHover: (isHovered) => print('Hovered: $isHovered'),
/// )
/// ```
final class MaterialButtonData extends _PlatformButtonData {
  /// Callback when the hover state changes.
  ///
  /// Called when the mouse enters or leaves the button area.
  final ValueChanged<bool>? onHover;

  /// Callback when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// The button style to apply.
  final ButtonStyle? style;

  /// Clip behavior for the button.
  final Clip? clipBehavior;

  /// Controller for the widget states.
  final WidgetStatesController? statesController;

  /// Whether the button is a semantic button for accessibility.
  final bool? isSemanticButton;

  /// Icon widget for the `.icon` constructor variant.
  final Widget? icon;

  /// Label widget for the `.icon` constructor variant.
  final Widget? label;

  /// Alignment of the icon relative to the label.
  final IconAlignment? iconAlignment;

  /// [child] and ([icon], [label]) are mutually exclusive. They are used to indicate the calling for the different variant of the button.
  /// [child] is used for the normal button-constructors ([useNormalConstructor]).
  /// ([icon], [label]) are used for the `.icon`-constructors ([useNormalConstructor]).
  /// <br>
  /// When [useNormalConstructor] is `true`, [iconAlignment] will be ignored.
  /// When [useIconConstructor] is `true`, [mouseCursor] will be ignored.
  /// [isSemanticButton] seems to be only available for `TextButton`.
  const MaterialButtonData({
    super.isEnabled,
    super.onPressed,
    super.onLongPress,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.child,
    super.widgetKey,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton,
    this.icon,
    this.label,
    this.iconAlignment,
  });

  /// Whether the normal (child-based) constructor should be used.
  bool get useNormalConstructor => child != null;

  /// Whether the icon constructor should be used.
  bool get useIconConstructor => !useNormalConstructor;
}

/// Cupertino-specific configuration for a platform button.
///
/// Maps to properties of `CupertinoButton` on iOS.
final class CupertinoButtonData extends _PlatformButtonData {
  /// The size style of the Cupertino button.
  final CupertinoButtonSize sizeStyle;

  /// Padding around the button content.
  final EdgeInsetsGeometry? padding;

  /// Background color of the button.
  final Color? color;

  /// Foreground (text/icon) color of the button.
  final Color? foregroundColor;

  /// Color of the button when disabled.
  final Color? disabledColor;

  /// Minimum size of the button.
  final Size? minimumSize;

  /// Opacity applied when the button is pressed.
  final double? pressedOpacity;

  /// Border radius of the button.
  final BorderRadius? borderRadius;

  /// Alignment of the button content.
  final AlignmentGeometry? alignment;

  /// Callback when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Color of the button when focused.
  final Color? focusColor;

  /// Default value for [sizeStyle].
  static const kDefaultSizeStyle = CupertinoButtonSize.large;

  /// Default value for [pressedOpacity].
  static const kDefaultPressedOpacity = 0.4;

  /// Default value for [alignment].
  static const kDefaultAlignment = Alignment.center;

  /// Creates Cupertino-specific button configuration.
  const CupertinoButtonData({
    super.isEnabled,
    super.onPressed,
    super.onLongPress,
    super.mouseCursor,
    super.focusNode,
    super.autofocus,
    super.child,
    super.widgetKey,
    this.sizeStyle = kDefaultSizeStyle,
    this.padding,
    this.color,
    this.foregroundColor,
    this.disabledColor,
    this.minimumSize,
    this.pressedOpacity = kDefaultPressedOpacity,
    this.borderRadius,
    this.alignment = kDefaultAlignment,
    this.onFocusChange,
    this.focusColor,
  });
}
