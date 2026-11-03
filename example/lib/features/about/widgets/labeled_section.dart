import 'package:flutter/widgets.dart';

/// A heading above its [child]. Used by the Showcase and About screens to break a page into sections.
class const LabeledSection({required final String title, required final Widget child, super.key})
    extends StatelessWidget {
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
