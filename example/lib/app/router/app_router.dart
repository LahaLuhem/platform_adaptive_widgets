import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '/features/about/about_view.dart';
import '/features/catalog/catalog_view.dart';
import '/features/catalog/categories/buttons/buttons_demo_view.dart';
import '/features/catalog/categories/containers/containers_demo_view.dart';
import '/features/catalog/categories/dialogs/dialogs_demo_view.dart';
import '/features/catalog/categories/selection/selection_demo_view.dart';
import '/features/catalog/categories/text/text_demo_view.dart';
import '/features/core/models/app_args.dart';
import '/features/core/models/widget_category.dart';
import '/features/root/root_tabs_router_view.dart';
import '/features/showcase/showcase_view.dart';
import 'app_route.dart';

final _catalogNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Catalog');
final _showcaseNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Showcase');
final _aboutNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'About');

/// go_router configuration: a [StatefulShellRoute] with one branch per top-level
/// tab. The shell's container is [RootTabsRouterView]; tab selection is owned by
/// the shell. Per-category detail routes nest under the Catalog branch.
final class AppRouter {
  static const _args = AppArgs(isUsingGoRouter: true);

  static final router = GoRouter(
    initialLocation: AppRoute.catalog.routeAddress,
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
                builder: (_, _) => const CatalogView(args: _args),
                routes: [
                  GoRoute(
                    name: WidgetCategory.buttons.name,
                    path: WidgetCategory.buttons.routeAddress,
                    builder: (_, _) => const ButtonsDemoView(),
                  ),
                  GoRoute(
                    name: WidgetCategory.selection.name,
                    path: WidgetCategory.selection.routeAddress,
                    builder: (_, _) => const SelectionDemoView(),
                  ),
                  GoRoute(
                    name: WidgetCategory.text.name,
                    path: WidgetCategory.text.routeAddress,
                    builder: (_, _) => const TextDemoView(),
                  ),
                  GoRoute(
                    name: WidgetCategory.containers.name,
                    path: WidgetCategory.containers.routeAddress,
                    builder: (_, _) => const ContainersDemoView(),
                  ),
                  GoRoute(
                    name: WidgetCategory.dialogs.name,
                    path: WidgetCategory.dialogs.routeAddress,
                    builder: (_, _) => const DialogsDemoView(),
                  ),
                ],
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
