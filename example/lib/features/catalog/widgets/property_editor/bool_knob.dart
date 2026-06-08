import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A labelled boolean control for a property editor, backed by a
/// [PlatformSwitch] so the knob itself renders platform-adaptively.
class BoolKnob extends StatelessWidget {
  /// The property name shown beside the switch.
  final String label;

  /// The current value.
  final bool value;

  /// Fired when the user toggles the switch.
  final ValueChanged<bool> onChanged;

  /// Creates a boolean knob.
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
