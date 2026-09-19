import 'package:flutter/widgets.dart';

/// [ColorKnob]'s palette when none is passed: recognisable hues, plus black and white.
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

/// A tap-to-select grid of [swatches]. A grid rather than a full HSV picker, which would mean another
/// dependency for a demo app.
class ColorKnob extends StatelessWidget {
  final String label;

  final Color value;

  final ValueChanged<Color> onChanged;

  final List<Color> swatches;

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

/// One square in [ColorKnob]. Ringed when selected, faintly outlined otherwise so pale swatches stay
/// visible against the background.
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
