import 'package:flutter/widgets.dart';

/// A heading above its [child]. Used by the Showcase and About screens to break a page into sections.
class LabeledSection extends StatelessWidget {
  final String title;

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
