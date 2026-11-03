import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformSlider] knob over a fixed [min] to [max] range, with the live value beside the label.
class const DoubleKnob({
  required final String label,
  required final double value,
  required final ValueChanged<double> onChanged,
  required final double min,
  required final double max,
  final int? divisions,

  /// Left out, the readout is the value to 1 decimal place. Useful for naming a sentinel value.
  final String Function(double)? valueLabel,
  super.key,
}) extends StatelessWidget {
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
