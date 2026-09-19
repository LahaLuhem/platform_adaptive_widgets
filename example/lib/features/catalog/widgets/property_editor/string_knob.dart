import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A [PlatformTextField] knob. Seeds from [value] once then owns the controller, so later changes to
/// [value] don't reach it. Nothing else edits this string.
class StringKnob extends StatefulWidget {
  final String label;

  final String value;

  final ValueChanged<String> onChanged;

  const StringKnob({required this.label, required this.value, required this.onChanged, super.key});

  @override
  State<StringKnob> createState() => _StringKnobState();
}

class _StringKnobState extends State<StringKnob> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: 4,
    children: [
      Text(widget.label),
      PlatformTextField(controller: _controller, onChanged: widget.onChanged),
    ],
  );
}
