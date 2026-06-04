import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '/features/about/views/about_view.dart';
import '/features/catalog/views/catalog_view.dart';
import '/features/core/data/models/app_args.dart';
import '/features/root/data/enums/root_tab.dart';
import '/features/showcase/views/showcase_view.dart';

/// Managed-mode tab shell (the `main.dart` entry point): [PlatformTabScaffold]
/// owns the selected-tab state and caches each tab's `view`.
class RootTabsView extends StatelessWidget {
  const RootTabsView({super.key});

  static const _args = AppArgs();

  @override
  Widget build(BuildContext context) => PlatformTabScaffold(
    tabDestinations: [
      for (final tab in RootTab.values)
        TabDestination(
          inactiveIcon: tab.inactiveIcon(context),
          activeIcon: tab.activeIcon(context),
          label: tab.label,
          view: switch (tab) {
            .catalog => const CatalogView(),
            .showcase => const ShowcaseView(),
            .about => const AboutView(args: _args),
          },
        ),
    ],
  );
}
