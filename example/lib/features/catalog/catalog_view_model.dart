import 'package:go_router/go_router.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/categories/buttons/buttons_demo_view.dart';
import '/features/catalog/categories/containers/containers_demo_view.dart';
import '/features/catalog/categories/dialogs/dialogs_demo_view.dart';
import '/features/catalog/categories/selection/selection_demo_view.dart';
import '/features/catalog/categories/text/text_demo_view.dart';
import '/features/core/models/app_args.dart';
import '/features/core/models/widget_category.dart';
import '/features/core/navigation/platform_route.dart';

/// Drives navigation from the Catalog list into each category's detail page.
/// Routes through go_router branches when the router owns navigation, otherwise
/// pushes a platform-adaptive page directly.
final class CatalogViewModel extends ViewModel {
  /// Host args — selects the navigation backend.
  final AppArgs args;

  CatalogViewModel(this.args);

  /// Opens [category]'s detail page.
  Future<void> onCategoryPressed(WidgetCategory category) {
    if (args.isUsingGoRouter) {
      return context.pushNamed(category.name);
    }

    return pushPlatformRoute(
      context,
      (_) => switch (category) {
        .buttons => const ButtonsDemoView(),
        .selection => const SelectionDemoView(),
        .text => const TextDemoView(),
        .containers => const ContainersDemoView(),
        .dialogs => const DialogsDemoView(),
      },
    );
  }
}
