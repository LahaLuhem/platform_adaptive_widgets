import 'package:flutter/cupertino.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/material.dart' show ButtonSegment, SegmentedButton;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_segment_button_data.dart';
import '/models/platform_widget_base.dart';

/// A platform-adaptive segmented button that renders Material SegmentedButton on Android
/// and CupertinoSlidingSegmentedControl on iOS.
///
/// This widget automatically selects the appropriate segmented button implementation based on the target platform:
/// - On Android: renders Material Design SegmentedButton
/// - On iOS: renders CupertinoSlidingSegmentedControl
///
/// The segmented button can be configured with platform-specific data through [materialSegmentButtonData]
/// and [cupertinoSegmentButtonData], or with common properties.
///
/// Note: On Android, only supports single selection due to use in CupertinoSlidingSegmentedControl.
///
/// Example:
/// ```dart
/// PlatformSegmentButton<String>(
///   choices: ['Day', 'Week', 'Month'],
///   selectedChoice: _selectedView,
///   onSelectionChanged: (choice) => setState(() => _selectedView = choice),
///   segmentBuilder: (choice) => Text(choice),
/// )
/// ```
class PlatformSegmentButton<T extends Object> extends PlatformWidgetKeyedBase {
  /// The list of choices to display as segments.
  final Iterable<T>? choices;

  /// Builder function for creating the widget representation of each segment.
  final Widget Function(T choice)? segmentBuilder;

  /// Callback when the selected segment changes.
  final ValueChanged<T?>? onSelectionChanged;

  /// Material-specific segmented button data.
  final MaterialSegmentButtonData<T>? materialSegmentButtonData;

  /// Cupertino-specific segmented button data.
  final CupertinoSegmentButtonData<T>? cupertinoSegmentButtonData;

  /// The currently selected choice.
  final T? _selectedChoice;

  /// Creates a platform-adaptive segmented button.
  ///
  /// The segmented button will render as a Material SegmentedButton on Android and a CupertinoSlidingSegmentedControl on iOS.
  /// Android: Only supports single selection due to use in CupertinoSlidingSegmentedControl.
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
