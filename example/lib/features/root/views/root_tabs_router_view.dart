import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '/features/root/data/enums/root_tab.dart';

/// The `main_go_router.dart` tab shell, where go_router owns selection and the scaffold just reflects
/// it. Taps go back out through [StatefulNavigationShell.goBranch].
class RootTabsRouterView extends StatelessWidget {
  /// go_router's shell, the source of truth for the selected tab.
  final StatefulNavigationShell navigationShell;

  /// One per tab, in tab order.
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
