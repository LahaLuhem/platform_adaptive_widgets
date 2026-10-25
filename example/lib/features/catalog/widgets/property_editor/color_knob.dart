import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// [ColorKnob]'s palette when the caller passes no other: recognisable hues, plus black and white.
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

  final Color? value;

  final ValueChanged<Color> onChanged;

  /// Adds a "none" swatch, which clears the colour so the widget falls back to its own default.
  final VoidCallback? onCleared;

  final List<Color> swatches;

  const ColorKnob({
    required this.label,
    required this.value,
    required this.onChanged,
    this.onCleared,
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
          if (onCleared != null)
            GestureDetector(
              onTap: onCleared,
              child: _Swatch(color: null, isSelected: value == null),
            ),
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
/// visible against the background. No [color] makes it the "none" swatch.
final class _Swatch extends StatelessWidget {
  final Color? color;
  final bool isSelected;

  const _Swatch({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    // The none swatch has no fill, so its ring sits on the page and matches its icon instead.
    final ringColor = switch (color) {
      null => IconTheme.of(context).color ?? const Color(0xFF000000),
      final fill when fill.computeLuminance() > 0.5 => const Color(0xFF000000),
      _ => const Color(0xFFFFFFFF),
    };

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.fromBorderSide(
          isSelected
              ? BorderSide(color: ringColor, width: 2)
              : const BorderSide(color: Color(0x33000000)),
        ),
      ),
      child: color == null
          ? Icon(
              context.platformIcon(material: Icons.block, cupertino: CupertinoIcons.nosign),
              size: 16,
            )
          : null,
    );
  }
}
