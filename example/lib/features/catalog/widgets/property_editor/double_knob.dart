import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformSlider] knob over a fixed [min] to [max] range, with the live value beside the label.
class DoubleKnob extends StatelessWidget {
  final String label;

  final double value;

  final ValueChanged<double> onChanged;

  final double min;

  final double max;

  final int? divisions;

  /// Left out, the readout is the value to 1 decimal place. Useful for naming a sentinel value.
  final String Function(double)? valueLabel;

  const DoubleKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    this.valueLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    children: [
      Row(
        spacing: 16,
        children: [
          Expanded(child: Text(label)),
          Text(valueLabel?.call(value) ?? value.toStringAsFixed(1)),
        ],
      ),
      PlatformSlider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
    ],
  );
}
