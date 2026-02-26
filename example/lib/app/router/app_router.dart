import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '/features/home/home_view.dart';
import '/features/home/l1/home_l1_view.dart';
import '/features/settings/settings_view.dart';
import '/main_go_router.dart';
import 'app_route.dart';

final _homeShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Home Shell');
final _settingsShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Settings Shell');

final class AppRouter {
  static const _homeViewArgs = HomeViewArgs(isUsingGoRouter: true);

  static final router = GoRouter(
    initialLocation: AppRoute.home.routeAddress,
    routes: [
      StatefulShellRoute(
        builder: (_, _, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) =>
            MyGoRouterRootPage(navigationShell: navigationShell, children: children),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeShellNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoute.home.name,
                path: AppRoute.home.routeAddress,
                builder: (_, _) => const HomeView(args: _homeViewArgs),
                routes: [
                  GoRoute(
                    name: AppRoute.homeL1.name,
                    path: AppRoute.homeL1.routeAddress,
                    builder: (_, _) => const HomeL1View(homeViewArgs: _homeViewArgs),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsShellNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoute.settings.name,
                path: AppRoute.settings.routeAddress,
                builder: (_, _) => const SettingsView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
