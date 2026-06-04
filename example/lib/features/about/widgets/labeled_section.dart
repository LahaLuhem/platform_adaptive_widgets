import 'package:flutter/widgets.dart';

/// A section label above its [child] — the consistent titled block used by the
/// Showcase and About screens to group a screen into self-explanatory sections.
class LabeledSection extends StatelessWidget {
  /// The section heading.
  final String title;

  /// The section's content.
  final Widget child;

  const LabeledSection({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: .w600)),
      child,
    ],
  );
}
