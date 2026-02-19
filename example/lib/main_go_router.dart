// ignore_for_file: prefer-match-file-name
//ignore_for_file: unreachable_from_main

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart'
    hide PlatformTabController;
import 'package:platform_adaptive_widgets/src/widgets/layout/platform_tab_scaffold_2.dart';
import 'package:platform_icons/platform_icons.dart';

import 'app/router/app_router.dart';

void main() {
  runApp(const _MyAppGoRouter());
}

class _MyAppGoRouter extends StatelessWidget {
  const _MyAppGoRouter();

  @override
  Widget build(BuildContext context) => PlatformApp.router(
    appRouterData: PlatformAppRouterData(
      title: 'Platform Adaptive Widgets GoRouter Example',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    ),
  );
}

/// Root page for the GoRouter app.
class MyGoRouterRootPage extends StatelessWidget {
  /// The navigation shell that this page is the root of.
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  /// Creates a [MyGoRouterRootPage].
  const MyGoRouterRootPage({required this.navigationShell, required this.children, super.key});

  @override
  Widget build(BuildContext context) => PlatformTabScaffold2(
    selectedIndex: navigationShell.currentIndex,
    onTabDestinationTap: navigationShell.goBranch,
    tabBodyBuilder: (_, index) => children[index],
    tabDestinations: const [
      TabDestination(inactiveIcon: PlatformIcon(PlatformIcons.home), label: 'Home'),
      TabDestination(inactiveIcon: PlatformIcon(PlatformIcons.settings), label: 'Settings'),
    ],
  );
}
