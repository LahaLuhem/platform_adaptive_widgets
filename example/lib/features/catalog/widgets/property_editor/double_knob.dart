import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A labelled double control for a property editor, backed by a
/// [PlatformSlider] over a fixed [min]–[max] range. The current value is shown
/// beside the label — formatted by [valueLabel] when given (e.g. to name a
/// sentinel value), else as a one-decimal number.
class DoubleKnob extends StatelessWidget {
  /// The property name shown beside the value.
  final String label;

  /// The current value.
  final double value;

  /// Fired as the user drags the slider.
  final ValueChanged<double> onChanged;

  /// Lower bound of the slider.
  final double min;

  /// Upper bound of the slider.
  final double max;

  /// Optional discrete divisions across the range.
  final int? divisions;

  /// Optional formatter for the numeric readout. Defaults to the value at one
  /// decimal place.
  final String Function(double)? valueLabel;

  /// Creates a double knob over a fixed range.
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
