// The two ctors initialise library-private content-slot fields via the
// initializer list (`_child = child`, etc.). Using `this._child` initializing
// formals would expose the underscore on the public parameter signature, which
// Dart forbids on exported APIs — the param-to-private-field assignment is the
// only way to keep the slot fields private while accepting public params.
// ignore_for_file: prefer_initializing_formals

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ElevatedButton, FilledButton, IconAlignment, OutlinedButton, TextButton;

import '/src/models/interaction/platform_button_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive button that renders one of Material's button variants
/// on Android ([TextButton], [ElevatedButton], [OutlinedButton],
/// [FilledButton], or [FilledButton.tonal] — selected by
/// [materialButtonVariant]) and one of Cupertino's button variants on iOS
/// ([CupertinoButton], [CupertinoButton.filled], or [CupertinoButton.tinted] —
/// selected by [cupertinoButtonVariant]).
///
/// Two constructor shapes:
/// - [PlatformButton.new] — arbitrary `child` slot (text, icon-only, custom
///   widget).
/// - [PlatformButton.icon] — icon + label slots; on Material maps to each
///   variant's `.icon` factory ([TextButton.icon] … [FilledButton.tonalIcon]),
///   on Cupertino the package wraps the icon and label in a [Row] with
///   `spacing: kDefaultButtonIconLabelGap` (Cupertino has no native
///   icon-button factory).
///
/// All shared functional inputs ([onPressed], [onLongPress], [isEnabled],
/// [focusNode], [autofocus], [onFocusChange]) live as flat constructor
/// parameters. Per-platform tuning is opt-in via [materialButtonData] and
/// [cupertinoButtonData]. See `APPENDIX.md#field-classification` for the
/// classification rule.
///
/// Example:
/// ```dart
/// PlatformButton(
///   onPressed: () => Navigator.maybeOf(context)?.pop(),
///   child: const Text('Dismiss'),
/// )
///
/// PlatformButton.icon(
///   onPressed: _onAdd,
///   icon: const Icon(Icons.add),
///   label: const Text('Add'),
///   materialButtonVariant: .filled,
///   cupertinoButtonVariant: .filled,
/// )
/// ```
class PlatformButton extends PlatformWidgetKeyedBase {
  /// Callback fired when the button is pressed.
  ///
  /// Required and non-null per the callback-nullability rule
  /// (`APPENDIX.md#callback-nullability`). To disable the button, set
  /// [isEnabled] to `false` — both branches receive `null` for their
  /// `onPressed` (the platform-native "disabled" state) while this field
  /// stays non-null.
  final VoidCallback onPressed;

  /// Optional long-press callback. Nullable per
  /// `APPENDIX.md#callback-nullability`.
  final VoidCallback? onLongPress;

  /// Whether the button is enabled and responds to input. Defaults to `true`.
  /// When `false`, both branches receive `null` for `onPressed` / `onLongPress`.
  final bool isEnabled;

  /// Focus node for the button.
  final FocusNode? focusNode;

  /// Whether the button should autofocus on mount. Defaults to `false`.
  final bool autofocus;

  /// Callback fired when the focus state changes. Optional.
  final ValueChanged<bool>? onFocusChange;

  /// Selects which Material button class to render on Android. Defaults to
  /// [MaterialButtonVariant.elevated]. See [MaterialButtonVariant] for the
  /// per-variant mapping.
  final MaterialButtonVariant materialButtonVariant;

  /// Selects which Cupertino button constructor to invoke on iOS. Defaults to
  /// [CupertinoButtonVariant.normal]. See [CupertinoButtonVariant] for the
  /// per-variant mapping.
  final CupertinoButtonVariant cupertinoButtonVariant;

  /// Material-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Material branch only.
  final MaterialButtonData? materialButtonData;

  /// Cupertino-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Cupertino branch only.
  final CupertinoButtonData? cupertinoButtonData;

  // ---- Content slots (set by one of two constructors; library-private) ----

  /// Set when constructed via [PlatformButton.new]; `null` when constructed
  /// via [PlatformButton.icon]. Mutually exclusive with [_icon] / [_label] by
  /// construction.
  final Widget? _child;

  /// Set when constructed via [PlatformButton.icon]; `null` otherwise.
  /// Non-null iff [_hasIconChild] is `true`.
  final Widget? _icon;

  /// Set when constructed via [PlatformButton.icon]; `null` otherwise.
  /// Non-null iff [_hasIconChild] is `true`.
  final Widget? _label;

  /// Set when constructed via [PlatformButton.icon]; `null` otherwise.
  /// Non-null iff [_hasIconChild] is `true` (defaults to [IconAlignment.start]
  /// when omitted from the `.icon` constructor).
  final IconAlignment? _iconAlignment;

  /// Whether this widget was constructed via [PlatformButton.icon] — i.e. its
  /// rendered content is an icon + label pair rather than a free-form child.
  /// `true` iff [_icon] is non-null (the three `_icon`/`_label`/`_iconAlignment`
  /// fields are set / null as a unit by the two constructors).
  bool get _hasIconChild => _icon != null;

  /// Creates a text-only / arbitrary-`child` platform-adaptive button.
  const PlatformButton({
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

  /// Creates an icon + label platform-adaptive button.
  ///
  /// On Material, maps to the selected variant's `.icon` factory
  /// ([TextButton.icon] / [ElevatedButton.icon] / [OutlinedButton.icon] /
  /// [FilledButton.icon] / [FilledButton.tonalIcon]).
  ///
  /// On Cupertino, the icon and label are wrapped in a [Row] of
  /// `mainAxisSize: .min` with `spacing: kDefaultButtonIconLabelGap`.
  /// [iconAlignment] controls the order: `.start` renders the icon before
  /// the label; `.end` renders the label before the icon. Cupertino has no
  /// native icon-button factory, so this is the package's bridge.
  const PlatformButton.icon({
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
        // No bang: ElevatedButton's `required super.child` inherits parent's
        // `Widget?` — passing the nullable field directly is what upstream
        // expects. (Same for outlined / filled / tonal below; only TextButton
        // narrows to non-null `Widget` via `required Widget super.child`.)
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
