import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformSegmentButton] knob, labelling each option with the value's `name`. Takes 2 values or more.
class const SegmentKnob<T extends Enum>({
  required final String label,
  required final T value,
  required final Set<T> values,
  required final ValueChanged<T> onChanged,
  super.key,
}) extends StatelessWidget {
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
