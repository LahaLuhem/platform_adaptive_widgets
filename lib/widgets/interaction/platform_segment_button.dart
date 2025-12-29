import 'package:flutter/cupertino.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/material.dart' show ButtonSegment, SegmentedButton;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_segment_button_data.dart';
import '/models/platform_widget_base.dart';

class PlatformSegmentButton<T extends Object> extends PlatformWidgetKeyedBase {
  final Iterable<T>? choices;
  final Widget Function(T choice)? segmentBuilder;
  final ValueChanged<T?>? onSelectionChanged;

  final MaterialSegmentButtonData<T>? materialSegmentButtonData;
  final CupertinoSegmentButtonData<T>? cupertinoSegmentButtonData;

  final T? _selectedChoice;

  /// Android: Only supports single selection due to use in [CupertinoSlidingSegmentedControl]
  const PlatformSegmentButton({
    required this.choices,
    required this.segmentBuilder,
    required T? selectedChoice,
    required this.onSelectionChanged,
    this.materialSegmentButtonData,
    this.cupertinoSegmentButtonData,
    super.widgetKey,
    super.key,
  }) : _selectedChoice = selectedChoice;

  @override
  Widget buildMaterial(BuildContext context) {
    final resolvedOnSelectionChanged =
        materialSegmentButtonData?.onSelectionChanged ?? onSelectionChanged;
    final resolvedSegmentBuilder = materialSegmentButtonData?.segmentBuilder ?? segmentBuilder;

    //TODO(lahaluhem): Add options for ButtonSegment.
    return SegmentedButton<T>(
      key: materialSegmentButtonData?.widgetKey ?? widgetKey,
      emptySelectionAllowed:
          materialSegmentButtonData?.emptySelectionAllowed ??
          MaterialSegmentButtonData.kDefaultEmptySelectionAllowed,
      expandedInsets: materialSegmentButtonData?.expandedInsets,
      style: materialSegmentButtonData?.style,
      showSelectedIcon:
          materialSegmentButtonData?.showSelectedIcon ??
          MaterialSegmentButtonData.kDefaultShowSelectedIcon,
      selectedIcon: materialSegmentButtonData?.selectedIcon,
      direction:
          materialSegmentButtonData?.direction ?? MaterialSegmentButtonData.kDefaultDirection,
      selected: (materialSegmentButtonData?.selectedChoice ?? _selectedChoice) != null
          ? {?materialSegmentButtonData?.selectedChoice, ?_selectedChoice}
          : const {},
      onSelectionChanged: (selectedValues) =>
          resolvedOnSelectionChanged?.call(selectedValues.firstOrNull),
      segments: [
        for (final choice in materialSegmentButtonData?.choices ?? choices!)
          ButtonSegment(value: choice, label: resolvedSegmentBuilder?.call(choice)),
      ],
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedOnSelectionChanged =
        cupertinoSegmentButtonData?.onSelectionChanged ?? onSelectionChanged;
    final resolvedSegmentBuilder = cupertinoSegmentButtonData?.segmentBuilder ?? segmentBuilder;

    return CupertinoSlidingSegmentedControl<T>(
      key: cupertinoSegmentButtonData?.widgetKey ?? widgetKey,
      onValueChanged: resolvedOnSelectionChanged!,
      disabledChildren:
          cupertinoSegmentButtonData?.disabledChildren ??
          CupertinoSegmentButtonData.kDefaultDisabledChildren,
      groupValue: _selectedChoice,
      thumbColor:
          cupertinoSegmentButtonData?.thumbColor ?? CupertinoSegmentButtonData.kDefaultThumbColor,
      padding: cupertinoSegmentButtonData?.padding ?? CupertinoSegmentButtonData.kDefaultPadding,
      backgroundColor:
          cupertinoSegmentButtonData?.backgroundColor ??
          CupertinoSegmentButtonData.kDefaultBackgroundColor,
      proportionalWidth:
          cupertinoSegmentButtonData?.proportionalWidth ??
          CupertinoSegmentButtonData.kDefaultProportionalWidth,
      isMomentary:
          cupertinoSegmentButtonData?.isMomentary ?? CupertinoSegmentButtonData.kDefaultIsMomentary,
      children: {
        for (final choice in cupertinoSegmentButtonData?.choices ?? choices!)
          choice: resolvedSegmentBuilder!.call(choice),
      },
    );
  }
}
