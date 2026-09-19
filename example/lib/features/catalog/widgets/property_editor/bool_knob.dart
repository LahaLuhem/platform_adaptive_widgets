import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformSwitch] knob.
class BoolKnob extends StatelessWidget {
  final String label;

  final bool value;

  final ValueChanged<bool> onChanged;

  const BoolKnob({required this.label, required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => Row(
    spacing: 16,
    children: [
      Expanded(child: Text(label)),
      PlatformSwitch(value: value, onChanged: onChanged),
    ],
  );
}
