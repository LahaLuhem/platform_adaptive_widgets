import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A live widget above a pile of controls, for poking at one library widget's properties while the app
/// runs.
///
/// Only the knobs for the platform currently being rendered show up, since the preview can only be one
/// of them at a time. Flip the About tab's platform override to see the other side. With both sets in
/// play the groups get labelled, otherwise [knobs] render bare.
class const PropertyEditor({
  /// The widget under edit, rebuilt by the enclosing `Consumer`.
  required final Widget preview,

  /// Always shown.
  required final List<Widget> knobs,

  /// Shown only while the app renders as Material.
  final List<Widget> materialKnobs = const [],

  /// Shown only while the app renders as Cupertino.
  final List<Widget> cupertinoKnobs = const [],
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A switch, not platformValue, since a List<Widget> through it trips DCM's avoid-returning-widgets.
    // The label string below is fine.
    final platformKnobs = switch (designLanguage) {
      .material => materialKnobs,
      .cupertino => cupertinoKnobs,
    };

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        Center(child: preview),
        if (platformKnobs.isEmpty)
          Column(crossAxisAlignment: .stretch, spacing: 8, children: knobs)
        else ...[
          if (knobs.isNotEmpty) _KnobGroup(label: 'Shared', knobs: knobs),
          _KnobGroup(
            label: platformValue(material: 'Material', cupertino: 'Cupertino'),
            knobs: platformKnobs,
          ),
        ],
      ],
    );
  }
}

/// A labelled group of knobs within a [PropertyEditor].
final class const _KnobGroup({required final String label, required final List<Widget> knobs})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .stretch,
    spacing: 8,
    children: [
      Text(label, style: const TextStyle(fontWeight: .w600)),
      ...knobs,
    ],
  );
}
