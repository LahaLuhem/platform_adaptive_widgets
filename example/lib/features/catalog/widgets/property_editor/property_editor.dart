import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A live-preview-and-controls panel for fiddling one library widget's
/// properties at runtime — the example's scoped take on a property editor.
///
/// [preview] is the widget under edit (rebuilt by the enclosing `MVVM.builder`
/// `Consumer` on `notifyListeners()`). [knobs] are the cross-platform controls,
/// always shown. [materialKnobs] / [cupertinoKnobs] are platform-only controls —
/// only the set matching the *currently rendered* platform shows (it follows
/// `defaultTargetPlatform`, which the About tab's platform override mirrors),
/// since the preview only renders one platform at a time. Flip the override to
/// see the other side. When platform knobs are present the groups are labelled
/// ("Shared" + "Material" / "Cupertino"); otherwise the bare [knobs] render.
class PropertyEditor extends StatelessWidget {
  /// The live widget under edit, shown above the controls.
  final Widget preview;

  /// Cross-platform controls, shown on every platform.
  final List<Widget> knobs;

  /// Material-only controls, shown only while the app renders as Material.
  final List<Widget> materialKnobs;

  /// Cupertino-only controls, shown only while the app renders as Cupertino.
  final List<Widget> cupertinoKnobs;

  /// Creates a property editor panel.
  const PropertyEditor({
    required this.preview,
    required this.knobs,
    this.materialKnobs = const [],
    this.cupertinoKnobs = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Knob-list selection stays a ternary: a List<Widget> through a
    // value-returning function trips DCM's avoid-returning-widgets. The cheap
    // label string below is fine through platformValue.
    final platformKnobs = isAndroid ? materialKnobs : cupertinoKnobs;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        Center(child: preview),
        if (platformKnobs.isEmpty)
          Column(crossAxisAlignment: .stretch, spacing: 8, children: knobs)
        else ...[
          _KnobGroup(label: 'Shared', knobs: knobs),
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
final class _KnobGroup extends StatelessWidget {
  final String label;
  final List<Widget> knobs;

  const _KnobGroup({required this.label, required this.knobs});

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
