import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformSwitch] knob.
class const BoolKnob({
  required final String label,
  required final bool value,
  required final ValueChanged<bool> onChanged,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    spacing: 16,
    children: [
      Expanded(child: Text(label)),
      PlatformSwitch(value: value, onChanged: onChanged),
    ],
  );
}
