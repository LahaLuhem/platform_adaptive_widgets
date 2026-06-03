import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '/features/core/models/app_args.dart';

/// The Catalog tab — browse the library's widgets by category.
///
/// Placeholder for now; the category list and per-category detail pages land in
/// the next chunk. [args] (navigation mode) will drive how detail pages are
/// pushed.
class CatalogView extends StatelessWidget {
  /// Host args — selects how category detail pages are navigated to.
  final AppArgs args;

  const CatalogView({required this.args, super.key});

  @override
  Widget build(BuildContext context) => PlatformScaffold(
    appBarData: const PlatformAppBar(title: Text('Catalog')),
    body: Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          Icon(
            context.platformIcon(
              material: Icons.widgets_outlined,
              cupertino: CupertinoIcons.square_grid_2x2,
            ),
            size: 48,
          ),
          const Text('Widget catalog'),
        ],
      ),
    ),
  );
}
