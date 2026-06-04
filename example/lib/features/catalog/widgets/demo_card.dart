import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A titled, described frame around a single live widget demo.
///
/// Gives every catalog section a consistent, labelled surface so it reads as a
/// self-explanatory gallery rather than a wall of bare controls. An outlined
/// frame — a border, no fill — keeps it fully cross-platform and avoids hiding a
/// Material child's background and ink behind a coloured box.
class DemoCard extends StatelessWidget {
  /// The widget's name.
  final String title;

  /// A one-line "what it is" shown under the title.
  final String? description;

  /// The live, interactive widget being demonstrated.
  final Widget child;

  const DemoCard({required this.title, required this.child, this.description, super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = PlatformTheme.of(context).primaryColor;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
        // 12: conventional card corner radius (between the 8 and 16 steps).
        borderRadius: const .all(.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: .w600)),
          if (description != null) Text(description!),
          child,
        ],
      ),
    );
  }
}
