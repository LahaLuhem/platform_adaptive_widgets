import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformSegmentButton] knob, labelling each option with the value's `name`. Takes 2 values or
/// more, so it covers the small enums `EnumKnob` can't.
class SegmentKnob<T extends Enum> extends StatelessWidget {
  final String label;

  final T value;

  final List<T> values;

  final ValueChanged<T> onChanged;

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
