import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A labelled frame around one live demo, so the catalog reads as a gallery rather than a wall of bare
/// controls. Outlined rather than filled, which keeps it cross-platform and stops a coloured box hiding
/// a Material child's own background and ink.
class DemoCard extends StatelessWidget {
  final String title;

  /// One line, under the title.
  final String? description;

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
