// `this._child` would leak the underscore into the public parameter name, so the slot fields are
// assigned in the initializer list instead.
// ignore_for_file: prefer_initializing_formals

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoButton, CupertinoColors, CupertinoTheme;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show FilledButton, OutlinedButton, TextButton;

import '/src/models/dialogs/platform_action_kind.dart';
import '/src/models/interaction/platform_button_data.dart';
import '/src/models/interaction/platform_button_emphasis.dart';
import '/src/models/platform_widget_base.dart';

/// One of Material's buttons or one of Cupertino's, at the rank [emphasis] asks for.
///
/// 2 shapes to build one. [PlatformButton.new] takes a free-form `child`. [PlatformButton.icon] takes
/// an icon and a label, which Material renders through each button's icon factory and Cupertino,
/// having none, renders as a [Row] spaced by [kDefaultButtonIconLabelGap].
///
/// Per-platform tuning lives in [materialButtonData] / [cupertinoButtonData]. See `APPENDIX.md#field-classification`.
///
/// Known Flutter gap: in light mode, Cupertino's `medium` and `mediumNeutral` draw lighter than UIKit's
/// tinted and gray buttons ([flutter/flutter#195265](https://github.com/flutter/flutter/issues/195265)).
///
/// Guidelines: [M3 buttons](https://m3.material.io/components/buttons/guidelines),
/// [HIG buttons](https://developer.apple.com/design/human-interface-guidelines/buttons#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_button.dart#platform_button}
///
/// With an icon:
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

  /// How much attention the button asks for, the same on both platforms.
  final PlatformButtonEmphasis emphasis;

  /// What the action does. A delete or a discard draws red where the accent would be on Cupertino, as
  /// SwiftUI draws a destructive button. Material stays plain, as M3 has no destructive style.
  final PlatformActionKind actionKind;

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialButtonData? materialButtonData;

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoButtonData? cupertinoButtonData;

  // Content slots. `_child` and the `_icon`/`_label` pair are mutually exclusive, one set or the
  // other, decided by which constructor ran.
  final Widget? _child;
  final Widget? _icon;
  final Widget? _label;

  bool get _hasIconChild => _icon != null;

  /// Creates a button around a free-form [child].
  const new({
    required this.onPressed,
    required this.emphasis,
    required Widget child,
    this.actionKind = .normal,
    this.onLongPress,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.materialButtonData,
    this.cupertinoButtonData,
    super.widgetKey,
    super.key,
  }) : _child = child,
       _icon = null,
       _label = null;

  /// Creates a button holding an icon before a label, which Material renders through its button's
  /// icon factory and Cupertino, having none, renders as a [Row]. In a right-to-left language the
  /// icon sits right of the label, as both platforms draw it.
  const new icon({
    required this.onPressed,
    required this.emphasis,
    required Widget icon,
    required Widget label,
    this.actionKind = .normal,
    this.onLongPress,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.materialButtonData,
    this.cupertinoButtonData,
    super.widgetKey,
    super.key,
  }) : _child = null,
       _icon = icon,
       _label = label;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    final pressed = isEnabled ? onPressed : null;
    final long = isEnabled ? onLongPress : null;
    final onHover = materialButtonData?.onHover;
    final style = materialButtonData?.style;
    final clipBehavior = materialButtonData?.clipBehavior;
    final statesController = materialButtonData?.statesController;

    return switch ((emphasis, _hasIconChild)) {
      (.high, false) => FilledButton(
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
        // tonal and outlined. Only TextButton narrows it to non-null.
        child: _child,
      ),
      (.high, true) => FilledButton.icon(
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
      ),
      (.medium, false) => FilledButton.tonal(
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
      (.medium, true) => FilledButton.tonalIcon(
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
      ),
      (.mediumNeutral, false) => OutlinedButton(
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
      (.mediumNeutral, true) => OutlinedButton.icon(
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
      ),
      (.low, false) => TextButton(
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
      (.low, true) => TextButton.icon(
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
      ),
    };
  }

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    final pressed = isEnabled ? onPressed : null;
    final long = isEnabled ? onLongPress : null;
    // Cupertino has no icon factory, so the icon and the label share a Row.
    final child = _hasIconChild
        ? Row(mainAxisSize: .min, spacing: kDefaultButtonIconLabelGap, children: [_icon!, _label!])
        : _child!;
    final sizeStyle = cupertinoButtonData?.sizeStyle ?? kDefaultCupertinoButtonSizeStyle;
    final padding = cupertinoButtonData?.padding;
    // cupertino_ui's recipe for iOS's gray button.
    final color =
        cupertinoButtonData?.color ??
        (emphasis == .mediumNeutral ? CupertinoColors.systemGrey : null);
    final foregroundColor = cupertinoButtonData?.foregroundColor;
    // cupertino_ui won't take a null here, so each constructor gets its own default back.
    final disabledColor =
        cupertinoButtonData?.disabledColor ??
        switch (emphasis) {
          .low => CupertinoColors.quaternarySystemFill,
          .high || .medium || .mediumNeutral => CupertinoColors.tertiarySystemFill,
        };
    final minimumSize = cupertinoButtonData?.minimumSize;
    final pressedOpacity =
        cupertinoButtonData?.pressedOpacity ?? kDefaultCupertinoButtonPressedOpacity;
    final borderRadius = cupertinoButtonData?.borderRadius;
    final alignment = cupertinoButtonData?.alignment ?? kDefaultCupertinoButtonAlignment;
    final focusColor = cupertinoButtonData?.focusColor;
    final mouseCursor = cupertinoButtonData?.mouseCursor;

    final button = switch (emphasis) {
      .high => CupertinoButton.filled(
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
        disabledColor: disabledColor,
        minimumSize: minimumSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        focusColor: focusColor,
        child: child,
      ),
      .medium || .mediumNeutral => CupertinoButton.tinted(
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
        disabledColor: disabledColor,
        minimumSize: minimumSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        focusColor: focusColor,
        child: child,
      ),
      .low => CupertinoButton(
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
        disabledColor: disabledColor,
        minimumSize: minimumSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        focusColor: focusColor,
        child: child,
      ),
    };

    return switch (actionKind) {
      .normal => button,
      // A red accent turns exactly the parts that would wear the accent red, at every rank.
      .delete || .discard => CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(primaryColor: CupertinoColors.systemRed),
        child: button,
      ),
    };
  }
}
