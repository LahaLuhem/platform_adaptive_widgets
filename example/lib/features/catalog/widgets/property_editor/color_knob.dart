import 'package:flutter/widgets.dart';

/// Curated default palette for [ColorKnob] — recognisable hues plus black and
/// white. Pass `swatches` to override.
const _defaultSwatches = <Color>[
  Color(0xFF000000), // black
  Color(0xFFF44336), // red
  Color(0xFFFF9800), // orange
  Color(0xFFFFEB3B), // yellow
  Color(0xFF4CAF50), // green
  Color(0xFF2196F3), // blue
  Color(0xFF9C27B0), // purple
  Color(0xFFFFFFFF), // white
];

/// A labelled colour control for a property editor — a tap-to-select grid of
/// curated [swatches]. Deliberately a swatch grid, not a full HSV picker, and
/// pulls in no extra dependency.
class ColorKnob extends StatelessWidget {
  /// The property name shown above the swatches.
  final String label;

  /// The current value.
  final Color value;

  /// Fired when the user taps a swatch.
  final ValueChanged<Color> onChanged;

  /// The selectable palette.
  final List<Color> swatches;

  /// Creates a colour knob.
  const ColorKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    this.swatches = _defaultSwatches,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: 8,
    children: [
      Text(label),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final swatch in swatches)
            GestureDetector(
              onTap: () => onChanged(swatch),
              child: _Swatch(color: swatch, isSelected: swatch == value),
            ),
        ],
      ),
    ],
  );
}

/// A single colour square in [ColorKnob]; ringed in a contrasting colour when
/// selected, faintly outlined otherwise so light swatches stay visible.
final class _Swatch extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _Swatch({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      border: Border.fromBorderSide(
        isSelected
            ? BorderSide(
                color: color.computeLuminance() > 0.5
                    ? const Color(0xFF000000)
                    : const Color(0xFFFFFFFF),
                width: 2,
              )
            : const BorderSide(color: Color(0x33000000)),
      ),
    ),
  );
}
