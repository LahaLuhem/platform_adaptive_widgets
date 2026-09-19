import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// One entry in the Under-the-hood tour. Outlined rather than filled, so it stays clear of Material's
/// surface and works on both platforms.
class NuanceCard extends StatelessWidget {
  final String title;

  /// What a naive wrapper gets wrong, and what this one does instead.
  final String body;

  /// Rendered in a monospace block.
  final String? code;

  final Widget? demo;

  const NuanceCard({required this.title, required this.body, this.code, this.demo, super.key});

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
          Text(body),
          if (code != null) _CodeBlock(code: code!),
          ?demo,
        ],
      ),
    );
  }
}

/// The tinted monospace block inside a [NuanceCard].
class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    // 12: code-block inset (between the 8 and 16 steps).
    padding: const .all(12),
    decoration: BoxDecoration(
      color: PlatformTheme.of(context).primaryColor.withValues(alpha: 0.1),
      borderRadius: const .all(.circular(8)),
    ),
    child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
  );
}
