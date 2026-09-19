/// @docImport '/src/widgets/interaction/platform_radio.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ButtonSegment, SegmentedButton;

import '/src/models/interaction/platform_segment_button_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [SegmentedButton] on Android, [CupertinoSlidingSegmentedControl] on iOS.
///
/// Per-platform tuning lives in [materialSegmentButtonData] / [cupertinoSegmentButtonData]. See `APPENDIX.md#field-classification`.
///
/// One selection at a time, deliberately. Material can do multi-select, iOS can't, and shipping that
/// would mean the same widget behaving differently on the 2 platforms, which is the opposite of what
/// this package is for. Hence [onSelectionChanged] taking a single `T?`, with Material's `Set<T>` collapsed
/// on the way through. If you need multi-select everywhere, something else fits better: chips, a list
/// of checkboxes, or [PlatformRadioGroupBuilder] with toggle semantics.
///
/// No `isEnabled` either, since neither underlying widget has a disabled state. Wrap it in an [IgnorePointer],
/// with an [Opacity] if you want it to look the part too.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_segment_button.dart#platform_segment_button}
class const PlatformSegmentButton<T extends Object>({
  /// One [segmentBuilder] call per choice, in iteration order. Needs at least 2, which iOS asserts.
  required final Iterable<T> choices,

  /// Usually a [Text] or an [Icon].
  required final Widget Function(T choice) segmentBuilder,

  /// `null` for nothing selected, which on Material needs [MaterialSegmentButtonData.emptySelectionAllowed]
  /// or [SegmentedButton] trips an assert.
  required final T? selectedChoice,

  /// Stays required and non-null, since iOS won't construct without it. It can still hand you `null`
  /// when a Material tap clears the selection. See `APPENDIX.md#callback-nullability`.
  required final ValueChanged<T?> onSelectionChanged,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialSegmentButtonData? materialSegmentButtonData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoSegmentButtonData<T>? cupertinoSegmentButtonData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive segmented button.
  this;

  @override
  Widget buildMaterial(BuildContext context) => SegmentedButton<T>(
    key: widgetKey,
    segments: [
      for (final choice in choices) ButtonSegment(value: choice, label: segmentBuilder(choice)),
    ],
    selected: {?selectedChoice},
    onSelectionChanged: (set) => onSelectionChanged(set.firstOrNull),
    emptySelectionAllowed:
        materialSegmentButtonData?.emptySelectionAllowed ??
        kDefaultSegmentButtonEmptySelectionAllowed,
    expandedInsets: materialSegmentButtonData?.expandedInsets,
    style: materialSegmentButtonData?.style,
    showSelectedIcon:
        materialSegmentButtonData?.showSelectedIcon ?? kDefaultSegmentButtonShowSelectedIcon,
    selectedIcon: materialSegmentButtonData?.selectedIcon,
    direction: materialSegmentButtonData?.direction ?? kDefaultSegmentButtonDirection,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSlidingSegmentedControl<T>(
    key: widgetKey,
    children: {for (final choice in choices) choice: segmentBuilder(choice)},
    groupValue: selectedChoice,
    onValueChanged: onSelectionChanged,
    disabledChildren:
        cupertinoSegmentButtonData?.disabledChildren ??
        kDefaultCupertinoSegmentButtonDisabledChildren,
    thumbColor: cupertinoSegmentButtonData?.thumbColor ?? kDefaultCupertinoSegmentButtonThumbColor,
    padding: cupertinoSegmentButtonData?.padding ?? kDefaultCupertinoSegmentButtonPadding,
    backgroundColor:
        cupertinoSegmentButtonData?.backgroundColor ??
        kDefaultCupertinoSegmentButtonBackgroundColor,
    proportionalWidth:
        cupertinoSegmentButtonData?.proportionalWidth ??
        kDefaultCupertinoSegmentButtonProportionalWidth,
    isMomentary:
        cupertinoSegmentButtonData?.isMomentary ?? kDefaultCupertinoSegmentButtonIsMomentary,
  );
}
