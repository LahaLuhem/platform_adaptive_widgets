import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// One entry in the Under-the-hood tour: a [title], an explanatory [body], an
/// optional [code] snippet, and an optional live [demo]. Outlined (a border, no
/// fill) to stay fully cross-platform — no Material surface.
class NuanceCard extends StatelessWidget {
  /// The decision this card is about.
  final String title;

  /// The explanation — what a naive wrapper gets wrong, and what the library does.
  final String body;

  /// Optional API snippet, shown in a monospace block.
  final String? code;

  /// Optional live, interactive proof.
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

/// A monospace, tinted block for the code snippets in a [NuanceCard].
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
