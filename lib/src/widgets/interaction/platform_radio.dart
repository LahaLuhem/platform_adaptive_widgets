/// @docImport 'package:flutter/foundation.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoRadio;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Radio;

import '/src/models/interaction/platform_radio_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive radio button that renders Material [Radio] on Android and
/// [CupertinoRadio] on iOS.
///
/// **Leaf widget** — must be a descendant of an ancestor [RadioGroup] (from
/// `package:flutter/widgets.dart`) which holds the group's selected value and
/// `onChanged` callback. This widget contributes one selectable option.
///
/// For the common pattern of "a layout of radios paired with labels", use
/// [PlatformRadioGroupBuilder] — a convenience widget that bundles the [RadioGroup] +
/// a `Wrap` layout + per-item rendering.
///
/// All functional inputs (value, state-gating, focus) and shared visual defaults live
/// as flat constructor parameters. Per-platform visual tuning is opt-in via
/// [materialRadioData] and [cupertinoRadioData]. See
/// `APPENDIX.md#field-classification` for the classification rule and
/// `APPENDIX.md#cross-platform-field-mappings` for [fillColor]'s type-divergence
/// handling.
///
/// Example:
/// ```dart
/// RadioGroup<AxisDirection>(
///   groupValue: selected,
///   onChanged: (v) => setState(() => selected = v),
///   child: Row(children: [
///     for (final dir in AxisDirection.values)
///       Row(mainAxisSize: .min, children: [
///         PlatformRadio(value: dir),
///         Text(dir.name),
///       ]),
///   ]),
/// )
/// ```
class PlatformRadio<T extends Object> extends PlatformWidgetKeyedBase {
  /// The value this radio button represents within its ancestor `RadioGroup<T>`. The
  /// radio is selected when the ancestor's `groupValue` equals [value].
  final T value;

  /// Whether tapping a selected radio deselects it (returning `null` to the ancestor's
  /// `onChanged`). Defaults to `false`.
  final bool toggleable;

  /// Whether this radio is enabled and responds to taps.
  ///
  /// - `true` (default): defers to the ancestor `RadioGroup`'s state — the underlying
  ///   [Radio.enabled] / [CupertinoRadio.enabled] receives `null`.
  /// - `false`: force-disables this specific radio (underlying widget receives
  ///   `enabled: false`), regardless of the group's state.
  ///
  /// See `APPENDIX.md#callback-nullability`.
  final bool isEnabled;

  /// Optional focus node for the radio. Same on both platforms.
  final FocusNode? focusNode;

  /// Whether the radio should autofocus when mounted. Defaults to `false`.
  final bool autofocus;

  /// Colour applied when the radio is selected.
  ///
  /// Shared visual — overridable per platform via [materialRadioData] /
  /// [cupertinoRadioData].
  final Color? activeColor;

  /// Colour applied when the radio is focused. Shared visual.
  final Color? focusColor;

  /// Cursor displayed when hovering over the radio. Shared visual.
  final MouseCursor? mouseCursor;

  /// Fill colour for the radio's inner mark.
  ///
  /// Maps to [Radio.fillColor] on Android directly (richer
  /// `WidgetStateProperty<Color?>?` passes through) and to [CupertinoRadio.fillColor]
  /// on iOS after resolving to a single `Color?` via
  /// `.resolve({.selected, if (!isEnabled) .disabled})` — radios primarily show fill
  /// when selected; disabled state forwarded based on [isEnabled]. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final WidgetStateProperty<Color?>? fillColor;

  /// Material-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual defaults on
  /// the Material branch; Material-only fields (`hoverColor`, `overlayColor`,
  /// `splashRadius`, `materialTapTargetSize`, `visualDensity`, `backgroundColor`,
  /// `side`, `innerRadius`) are read only from here.
  final MaterialRadioData? materialRadioData;

  /// Cupertino-only visual overrides. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual defaults on
  /// the Cupertino branch; Cupertino-only fields (`inactiveColor`, `useCheckmarkStyle`)
  /// are read only from here.
  final CupertinoRadioData? cupertinoRadioData;

  /// Creates a platform-adaptive radio button.
  const PlatformRadio({
    required this.value,
    this.toggleable = false,
    this.isEnabled = true,
    this.focusNode,
    this.autofocus = false,
    this.activeColor,
    this.focusColor,
    this.mouseCursor,
    this.fillColor,
    this.materialRadioData,
    this.cupertinoRadioData,
    super.widgetKey,
    super.key,
  });

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

/// Convenience widget that bundles a [RadioGroup] + a [Wrap] layout + per-item
/// rendering for the common radio-group pattern.
///
/// Collapses the boilerplate of "wrap a [RadioGroup] around a layout of [PlatformRadio]-
/// plus-label rows" into a single widget. The caller supplies [values] and an
/// [itemBuilder]; this widget owns group state (delegated to the underlying
/// [RadioGroup]) and lays the items out with [Wrap] — which degrades to row/column
/// behaviour when items fit and wraps to the next run on narrow screens.
///
/// Intentionally extends [StatelessWidget] rather than `PlatformWidgetBase`: the
/// underlying [RadioGroup] is itself platform-agnostic (`package:flutter/widgets.dart`),
/// so branching on [defaultTargetPlatform] would only return the same widget on both
/// branches — misleading.
///
/// When this widget's layout knobs aren't enough (mixing radios with non-radio
/// siblings, scrollable layouts, alignment beyond [Wrap]'s surface), fall back to
/// composing [RadioGroup] + [PlatformRadio] directly.
///
/// Example:
/// ```dart
/// PlatformRadioGroupBuilder<AxisDirection>(
///   values: AxisDirection.values,
///   groupValue: directionality,
///   onChanged: viewModel.onDirectionalityChanged,
///   itemBuilder: (_, dir) => Row(
///     mainAxisSize: .min,
///     children: [PlatformRadio(value: dir), Text(dir.name)],
///   ),
/// )
/// ```
class PlatformRadioGroupBuilder<T extends Object> extends StatelessWidget {
  /// Values to render as radio options. One [itemBuilder] call per value, in iteration
  /// order.
  final Iterable<T> values;

  /// Currently-selected value within the group. `null` means no selection. Forwarded
  /// to the underlying [RadioGroup] as `groupValue`.
  final T? groupValue;

  /// Called when a descendant [PlatformRadio] is tapped. Receives the tapped radio's
  /// value, or `null` if a toggleable radio was deselected. Forwarded to the
  /// underlying [RadioGroup].
  final ValueChanged<T?> onChanged;

  /// Builds the widget for one value — typically a [PlatformRadio] paired with a
  /// label, but any composition that includes a [PlatformRadio] (with the same
  /// `value`) somewhere in its subtree works.
  final Widget Function(BuildContext context, T value) itemBuilder;

  /// Primary axis along which the items lay out. Defaults to [Axis.horizontal].
  /// Forwarded to [Wrap.direction].
  final Axis direction;

  /// Spacing between items along [direction]. Defaults to `16.0`. Forwarded to
  /// [Wrap.spacing].
  final double spacing;

  /// Spacing between runs (rows when [direction] is horizontal, columns when
  /// vertical). Defaults to `8.0`. Forwarded to [Wrap.runSpacing].
  final double runSpacing;

  /// Optional key applied to the inner [RadioGroup] (distinct from the outer
  /// widget's [key]).
  final Key? widgetKey;

  /// Creates a [PlatformRadio]-aware group + layout convenience widget.
  const PlatformRadioGroupBuilder({
    required this.values,
    required this.groupValue,
    required this.onChanged,
    required this.itemBuilder,
    this.direction = .horizontal,
    this.spacing = 16,
    this.runSpacing = 8,
    this.widgetKey,
    super.key,
  });

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
