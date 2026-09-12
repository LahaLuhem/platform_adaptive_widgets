import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '/features/about/views/about_view.dart';
import '/features/catalog/views/catalog_view.dart';
import '/features/core/data/models/app_args.dart';
import '/features/error/views/error_view.dart';
import '/features/root/views/root_tabs_router_view.dart';
import '/features/showcase/views/showcase_view.dart';
import 'app_route.dart';

final _catalogNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Catalog');
final _showcaseNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Showcase');
final _aboutNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'About');

/// go_router configuration: a [StatefulShellRoute] with one branch per top-level tab. The shell's
/// container is [RootTabsRouterView]. Tab selection is owned by the shell. Unmatched locations fall
/// through to [ErrorView] via `errorBuilder`.
final class AppRouter {
  static const _args = AppArgs(isUsingGoRouter: true);

  static final router = GoRouter(
    initialLocation: AppRoute.catalog.routeAddress,
    errorBuilder: (_, state) => ErrorView(error: state.error),
    routes: [
      StatefulShellRoute(
        builder: (_, _, navigationShell) => navigationShell,
        navigatorContainerBuilder: (_, navigationShell, children) =>
            RootTabsRouterView(navigationShell: navigationShell, children: children),
        branches: [
          StatefulShellBranch(
            navigatorKey: _catalogNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoute.catalog.name,
                path: AppRoute.catalog.routeAddress,
                builder: (_, _) => const CatalogView(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _showcaseNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoute.showcase.name,
                path: AppRoute.showcase.routeAddress,
                builder: (_, _) => const ShowcaseView(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _aboutNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoute.about.name,
                path: AppRoute.about.routeAddress,
                builder: (_, _) => const AboutView(args: _args),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
