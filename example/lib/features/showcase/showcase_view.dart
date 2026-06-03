import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// The Showcase tab — a realistic screen composed entirely from the library's
/// widgets.
///
/// Placeholder for now; the composed screen lands in a later chunk.
class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) => PlatformScaffold(
    appBarData: const PlatformAppBar(title: Text('Showcase')),
    body: Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          Icon(
            context.platformIcon(
              material: Icons.auto_awesome_outlined,
              cupertino: CupertinoIcons.sparkles,
            ),
            size: 48,
          ),
          const Text('A real screen, all PlatformXxx'),
        ],
      ),
    ),
  );
}
