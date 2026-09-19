import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoRadio;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Radio;

import '/src/models/interaction/platform_radio_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [Radio] on Android, [CupertinoRadio] on iOS.
///
/// Does nothing on its own. It needs a [RadioGroup] ancestor, which owns the selected value and the
/// `onChanged` callback, and contributes one option to it. For the usual "radios with labels" layout,
/// [PlatformRadioGroupBuilder] wires both up for you.
///
/// Per-platform tuning lives in [materialRadioData] / [cupertinoRadioData]. See `APPENDIX.md#field-classification`.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_radio.dart#platform_radio}
class const PlatformRadio<T extends Object>({
  /// Selected when the ancestor [RadioGroup]'s `groupValue` matches this.
  required final T value,

  /// Lets a tap on the already-selected radio clear it, handing `null` to the group's `onChanged`.
  final bool toggleable = false,

  /// `true` defers to the ancestor [RadioGroup]'s state, so the underlying widget gets `null`. `false`
  /// force-disables this one radio whatever the group says. See `APPENDIX.md#callback-nullability`.
  final bool isEnabled = true,

  final FocusNode? focusNode,

  final bool autofocus = false,

  /// Colour while selected.
  final Color? activeColor,

  final Color? focusColor,

  final MouseCursor? mouseCursor,

  /// [Radio.fillColor] on Android, which takes the `WidgetStateProperty` as-is. iOS wants a plain `Color?`,
  /// so it gets `.resolve({.selected, if (!isEnabled) .disabled})`, a radio mostly showing its fill
  /// when selected.
  final WidgetStateProperty<Color?>? fillColor,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialRadioData? materialRadioData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoRadioData? cupertinoRadioData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive radio button.
  this;

  @override
  Widget buildMaterial(BuildContext context) => Radio<T>(
    key: widgetKey,
    value: value,
    enabled: isEnabled ? null : false,
    toggleable: toggleable,
    focusNode: focusNode,
    autofocus: autofocus,
    activeColor: materialRadioData?.activeColor ?? activeColor,
    focusColor: materialRadioData?.focusColor ?? focusColor,
    mouseCursor: materialRadioData?.mouseCursor ?? mouseCursor,
    fillColor: materialRadioData?.fillColor ?? fillColor,
    hoverColor: materialRadioData?.hoverColor,
    overlayColor: materialRadioData?.overlayColor,
    splashRadius: materialRadioData?.splashRadius,
    materialTapTargetSize: materialRadioData?.materialTapTargetSize,
    visualDensity: materialRadioData?.visualDensity,
    backgroundColor: materialRadioData?.backgroundColor,
    side: materialRadioData?.side,
    innerRadius: materialRadioData?.innerRadius,
  );

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedFillColor = (cupertinoRadioData?.fillColor ?? fillColor)?.resolve({
      .selected,
      if (!isEnabled) .disabled,
    });

    return CupertinoRadio<T>(
      key: widgetKey,
      value: value,
      enabled: isEnabled ? null : false,
      toggleable: toggleable,
      focusNode: focusNode,
      autofocus: autofocus,
      activeColor: cupertinoRadioData?.activeColor ?? activeColor,
      focusColor: cupertinoRadioData?.focusColor ?? focusColor,
      mouseCursor: cupertinoRadioData?.mouseCursor ?? mouseCursor,
      fillColor: resolvedFillColor,
      inactiveColor: cupertinoRadioData?.inactiveColor,
      useCheckmarkStyle:
          cupertinoRadioData?.useCheckmarkStyle ?? kDefaultCupertinoRadioUseCheckmarkStyle,
    );
  }
}

/// A [RadioGroup] wrapped around a [Wrap] of radios, so you don't hand-roll the usual radio-next-to-a-label
/// layout. Hand it [values] and an [itemBuilder].
///
/// A plain [StatelessWidget] rather than a `PlatformWidgetBase`, because [RadioGroup] and [Wrap] are
/// both platform-agnostic. Branching would hand back the same widget twice.
///
/// Outgrow it (non-radio siblings, scrolling, alignment past what [Wrap] offers) and compose [RadioGroup]
/// + [PlatformRadio] yourself.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_radio.dart#platform_radio_group_builder}
class const PlatformRadioGroupBuilder<T extends Object>({
  /// One [itemBuilder] call per value, in iteration order.
  required final Iterable<T> values,

  /// The selected value, or `null` for nothing selected.
  required final T? groupValue,

  /// Gets the tapped radio's value, or `null` when a toggleable one was cleared.
  required final ValueChanged<T?> onChanged,

  /// Usually a [PlatformRadio] next to a label. Anything works, so long as a [PlatformRadio] carrying
  /// the same `value` sits somewhere in the subtree.
  required final Widget Function(BuildContext context, T value) itemBuilder,

  /// Forwarded to [Wrap.direction].
  final Axis direction = .horizontal,

  /// Forwarded to [Wrap.spacing].
  final double spacing = 16,

  /// Gap between runs, so between rows when horizontal and columns when vertical. Forwarded to [Wrap.runSpacing].
  final double runSpacing = 8,

  /// Goes on the inner [RadioGroup]. The outer widget has [key] for that.
  final Key? widgetKey,
  super.key,
}) extends StatelessWidget {
  /// Creates a group of radios laid out with [Wrap].
  this;

  @override
  Widget build(BuildContext context) => RadioGroup<T>(
    key: widgetKey,
    groupValue: groupValue,
    onChanged: onChanged,
    child: Wrap(
      direction: direction,
      spacing: spacing,
      runSpacing: runSpacing,
      children: [for (final value in values) itemBuilder(context, value)],
    ),
  );
}
