import 'package:flutter/widgets.dart';

/// A live-preview-and-controls panel for fiddling one library widget's
/// properties at runtime — the example's scoped take on a property editor.
///
/// [preview] is the widget under edit, built by the enclosing `MVVM.builder`
/// view. Because that builder is wrapped in a `Consumer`, [preview] rebuilds
/// whenever the playground view-model calls `notifyListeners()`. [knobs] are
/// the controls shown beneath it — see the `BoolKnob` / `EnumKnob` /
/// `DoubleKnob` / `StringKnob` / `ColorKnob` controls.
class PropertyEditor extends StatelessWidget {
  /// The live widget under edit, shown above the controls.
  final Widget preview;

  /// The property controls shown beneath the preview.
  final List<Widget> knobs;

  /// Creates a property editor panel.
  const PropertyEditor({required this.preview, required this.knobs, super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: 16,
    children: [
      Center(child: preview),
      Column(crossAxisAlignment: .stretch, spacing: 8, children: knobs),
    ],
  );
}
