// `this._child` would leak the underscore into the public parameter name, so the slot fields are
// assigned in the initializer list instead.
// ignore_for_file: prefer_initializing_formals

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ElevatedButton, FilledButton, IconAlignment, OutlinedButton, TextButton;

import '/src/models/interaction/platform_button_data.dart';
import '/src/models/platform_widget_base.dart';

/// One of Material's buttons on Android and one of Cupertino's on iOS, picked by [materialButtonVariant]
/// and [cupertinoButtonVariant].
///
/// 2 shapes to build one. [PlatformButton.new] takes a free-form `child`. [PlatformButton.icon] takes
/// an icon and a label, which Material renders through each variant's `.icon` factory and Cupertino,
/// having none, renders as a [Row] spaced by [kDefaultButtonIconLabelGap].
///
/// Per-platform tuning lives in [materialButtonData] / [cupertinoButtonData]. See `APPENDIX.md#field-classification`.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_button.dart#platform_button}
///
/// The icon variant:
/// {@example /example/lib/snippets/interaction/platform_button.dart#platform_button_icon}
class PlatformButton extends PlatformWidgetKeyedBase {
  /// Stays required and non-null even for a disabled button. That's [isEnabled]'s job, not a null callback's.
  /// See `APPENDIX.md#callback-nullability`.
  final VoidCallback onPressed;

  /// Optional long-press callback.
  final VoidCallback? onLongPress;

  /// The way to disable a button, passing both branches a `null` callback for their standard disabled
  /// look.
  final bool isEnabled;

  /// Focus node for the button.
  final FocusNode? focusNode;

  /// Whether the button grabs focus when mounted.
  final bool autofocus;

  /// Fires on focus gained and lost.
  final ValueChanged<bool>? onFocusChange;

  /// Which Material button class Android renders.
  final MaterialButtonVariant materialButtonVariant;

  /// Which Cupertino button constructor iOS calls.
  final CupertinoButtonVariant cupertinoButtonVariant;

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialButtonData? materialButtonData;

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoButtonData? cupertinoButtonData;

  // Content slots. `_child` and the `_icon`/`_label`/`_iconAlignment` trio are mutually exclusive,
  // one set or the other, decided by which constructor ran.
  final Widget? _child;
  final Widget? _icon;
  final Widget? _label;
  final IconAlignment? _iconAlignment;

  bool get _hasIconChild => _icon != null;

  /// Creates a button around a free-form [child].
  const new({
    required this.onPressed,
    required Widget child,
    this.onLongPress,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.materialButtonVariant = .elevated,
    this.cupertinoButtonVariant = .normal,
    this.materialButtonData,
    this.cupertinoButtonData,
    super.widgetKey,
    super.key,
  }) : _child = child,
       _icon = null,
       _label = null,
       _iconAlignment = null;

  /// Creates a button holding an icon next to a label, which Material renders through the variant's
  /// `.icon` factory and Cupertino, having none, renders as a [Row]. [iconAlignment] sets the order,
  /// `.start` putting the icon first and `.end` the label.
  const new icon({
    required this.onPressed,
    required Widget icon,
    required Widget label,
    IconAlignment iconAlignment = .start,
    this.onLongPress,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.materialButtonVariant = .elevated,
    this.cupertinoButtonVariant = .normal,
    this.materialButtonData,
    this.cupertinoButtonData,
    super.widgetKey,
    super.key,
  }) : _child = null,
       _icon = icon,
       _label = label,
       _iconAlignment = iconAlignment;

  @override
  Widget buildMaterial(BuildContext context) {
    final pressed = isEnabled ? onPressed : null;
    final long = isEnabled ? onLongPress : null;
    final onHover = materialButtonData?.onHover;
    final style = materialButtonData?.style;
    final clipBehavior = materialButtonData?.clipBehavior;
    final statesController = materialButtonData?.statesController;

    return switch ((materialButtonVariant, _hasIconChild)) {
      (.text, false) => TextButton(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        isSemanticButton: materialButtonData?.isSemanticButton,
        child: _child!,
      ),
      (.text, true) => TextButton.icon(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        icon: _icon,
        label: _label!,
        iconAlignment: _iconAlignment,
      ),
      (.elevated, false) => ElevatedButton(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        // No bang, since this one's `required super.child` is still nullable upstream. Same for
        // outlined, filled and tonal. Only TextButton narrows it to non-null.
        child: _child,
      ),
      (.elevated, true) => ElevatedButton.icon(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        icon: _icon,
        label: _label!,
        iconAlignment: _iconAlignment,
      ),
      (.outlined, false) => OutlinedButton(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: _child,
      ),
      (.outlined, true) => OutlinedButton.icon(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        icon: _icon,
        label: _label!,
        iconAlignment: _iconAlignment,
      ),
      (.filled, false) => FilledButton(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: _child,
      ),
      (.filled, true) => FilledButton.icon(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        icon: _icon,
        label: _label!,
        iconAlignment: _iconAlignment,
      ),
      (.tonal, false) => FilledButton.tonal(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: _child,
      ),
      (.tonal, true) => FilledButton.tonalIcon(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        icon: _icon,
        label: _label!,
        iconAlignment: _iconAlignment,
      ),
    };
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final pressed = isEnabled ? onPressed : null;
    final long = isEnabled ? onLongPress : null;
    // For the icon constructor, synthesise the Cupertino child as a Row
    // Cupertino has no native icon-button factory. [iconAlignment] picks element order
    final child = _hasIconChild
        ? Row(
            mainAxisSize: .min,
            spacing: kDefaultButtonIconLabelGap,
            children: _iconAlignment == .start ? [_icon!, _label!] : [_label!, _icon!],
          )
        : _child!;
    final sizeStyle = cupertinoButtonData?.sizeStyle ?? kDefaultCupertinoButtonSizeStyle;
    final padding = cupertinoButtonData?.padding;
    final color = cupertinoButtonData?.color;
    final foregroundColor = cupertinoButtonData?.foregroundColor;
    final disabledColor = cupertinoButtonData?.disabledColor;
    final minimumSize = cupertinoButtonData?.minimumSize;
    final pressedOpacity =
        cupertinoButtonData?.pressedOpacity ?? kDefaultCupertinoButtonPressedOpacity;
    final borderRadius = cupertinoButtonData?.borderRadius;
    final alignment = cupertinoButtonData?.alignment ?? kDefaultCupertinoButtonAlignment;
    final focusColor = cupertinoButtonData?.focusColor;
    final mouseCursor = cupertinoButtonData?.mouseCursor;

    return switch (cupertinoButtonVariant) {
      .normal => CupertinoButton(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        autofocus: autofocus,
        onFocusChange: onFocusChange,
        sizeStyle: sizeStyle,
        padding: padding,
        color: color,
        foregroundColor: foregroundColor,
        disabledColor: disabledColor ?? cupertinoButtonVariant.defaultDisabledColor,
        minimumSize: minimumSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        focusColor: focusColor,
        child: child,
      ),
      .filled => CupertinoButton.filled(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        autofocus: autofocus,
        onFocusChange: onFocusChange,
        sizeStyle: sizeStyle,
        padding: padding,
        color: color,
        foregroundColor: foregroundColor,
        disabledColor: disabledColor ?? cupertinoButtonVariant.defaultDisabledColor,
        minimumSize: minimumSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        focusColor: focusColor,
        child: child,
      ),
      .tinted => CupertinoButton.tinted(
        key: widgetKey,
        onPressed: pressed,
        onLongPress: long,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        autofocus: autofocus,
        onFocusChange: onFocusChange,
        sizeStyle: sizeStyle,
        padding: padding,
        color: color,
        foregroundColor: foregroundColor,
        disabledColor: disabledColor ?? cupertinoButtonVariant.defaultDisabledColor,
        minimumSize: minimumSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        focusColor: focusColor,
        child: child,
      ),
    };
  }
}
