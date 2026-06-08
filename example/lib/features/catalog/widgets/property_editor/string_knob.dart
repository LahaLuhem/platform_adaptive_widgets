import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A labelled string control for a property editor, backed by a
/// [PlatformTextField]. It seeds its field from the initial [value] and reports
/// edits via [onChanged]; it owns the editing controller because it is the sole
/// editor of the value, so it ignores later [value] changes (no external sync).
class StringKnob extends StatefulWidget {
  /// The property name shown above the field.
  final String label;

  /// The initial value used to seed the field.
  final String value;

  /// Fired as the user edits the text.
  final ValueChanged<String> onChanged;

  /// Creates a string knob.
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
