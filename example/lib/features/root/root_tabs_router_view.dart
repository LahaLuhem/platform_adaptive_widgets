import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import 'root_tab.dart';

/// Controlled-mode tab shell (the `main_go_router.dart` entry point): tab
/// selection is owned by go_router's [StatefulNavigationShell]. The scaffold
/// reflects [StatefulNavigationShell.currentIndex] and routes taps through
/// [StatefulNavigationShell.goBranch]; the branch navigators arrive as
/// [children] and are shown via `tabBodyBuilder`.
class RootTabsRouterView extends StatelessWidget {
  /// go_router's shell — the source of truth for the selected tab.
  final StatefulNavigationShell navigationShell;

  /// The branch navigators, one per tab, indexed by tab position.
  final List<Widget> children;

  const RootTabsRouterView({required this.navigationShell, required this.children, super.key});

  @override
  Widget build(BuildContext context) => PlatformTabScaffold(
    selectedIndex: navigationShell.currentIndex,
    onTabDestinationTap: navigationShell.goBranch,
    tabBodyBuilder: (_, index) => children[index],
    tabDestinations: [
      for (final tab in RootTab.values)
        TabDestination(
          inactiveIcon: tab.inactiveIcon(context),
          activeIcon: tab.activeIcon(context),
          label: tab.label,
        ),
    ],
  );
}
