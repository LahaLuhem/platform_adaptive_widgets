import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Material;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A titled, described frame around a single live widget demo.
///
/// Gives every catalog section a consistent, labelled surface so it reads as a
/// self-explanatory gallery rather than a wall of bare controls. The subtle
/// brand-tinted fill works on both platforms and in light/dark.
///
/// The surface is a [Material] rather than a plain coloured `Container`: a
/// Material `ListTile` / `ExpansionTile` child paints its ink on the nearest
/// `Material` ancestor, and an intervening coloured `DecoratedBox` would hide
/// that (Flutter asserts as much). A `Material` is inert on iOS, so the
/// Cupertino children are unaffected.
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

    return Material(
      color: primaryColor.withValues(alpha: 0.08),
      // 12: conventional card corner radius (sits between the 8 and 16 steps).
      borderRadius: const .all(.circular(12)),
      clipBehavior: .antiAlias,
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: .w600)),
            if (description != null) Text(description!),
            child,
          ],
        ),
      ),
    );
  }
}
