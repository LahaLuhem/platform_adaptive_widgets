import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A labelled enum control for a property editor, backed by a
/// [PlatformSegmentButton] — for small enums (two or more values), where
/// `EnumKnob`'s dropdown can't go (its Cupertino rendering needs ≥3 items).
/// Each option's label is the value's `name`.
class SegmentKnob<T extends Enum> extends StatelessWidget {
  /// The property name shown above the segmented control.
  final String label;

  /// The current value.
  final T value;

  /// The selectable values.
  final List<T> values;

  /// Fired when the user picks a different value.
  final ValueChanged<T> onChanged;

  /// Creates a segmented enum knob.
  const SegmentKnob({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: 4,
    children: [
      Text(label),
      PlatformSegmentButton<T>(
        choices: values,
        selectedChoice: value,
        segmentBuilder: (choice) => Text(choice.name),
        onSelectionChanged: (selected) => onChanged(selected ?? value),
      ),
    ],
  );
}
