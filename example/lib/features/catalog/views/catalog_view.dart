import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/widget_category.dart';
import '/features/catalog/data/extensions/platform_adaptive_icons_extension.dart';
import '/features/catalog/views/buttons_demo/buttons_demo_view.dart';
import '/features/catalog/views/containers_demo/containers_demo_view.dart';
import '/features/catalog/views/dialogs_demo/dialogs_demo_view.dart';
import '/features/catalog/views/selection_demo/selection_demo_view.dart';
import '/features/catalog/views/text_demo/text_demo_view.dart';
import 'catalog_view_model.dart';

/// Every widget the library offers, in expandable sections you can poke in place. Expand all for one
/// long hands-on scroll, collapse all for a list you can scan. Nothing is more than a scroll away.
class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: CatalogViewModel(),
    viewBuilder: (context, viewModel) => ValueListenableBuilder(
      valueListenable: viewModel.shouldEnableListenable,
      builder: (context, shouldEnable, _) => ListenableBuilder(
        listenable: viewModel.sectionsListenable,
        builder: (context, body) => PlatformScaffold(
          appBarData: PlatformAppBar(
            title: const Text('Catalog'),
            actions: [
              if (viewModel.isAnySectionExpanded)
                PlatformBarAction(
                  label: 'Collapse all',
                  icon: Icon(context.platformAdaptiveIcons.collapseAll),
                  onPressed: viewModel.onCollapseAllPressed,
                )
              else
                PlatformBarAction(
                  label: 'Expand all',
                  icon: Icon(context.platformAdaptiveIcons.expandAll),
                  onPressed: viewModel.onExpandAllPressed,
                ),
              PlatformBarAction(
                label: shouldEnable ? 'Disable widgets' : 'Enable widgets',
                icon: Icon(
                  shouldEnable
                      ? context.platformAdaptiveIcons.disable
                      : context.platformAdaptiveIcons.enable,
                ),
                onPressed: viewModel.onEnableTogglePressed,
              ),
            ],
          ),
          body: body!,
        ),
        child: SafeArea(
          child: ListView(
            children: [
              for (final category in WidgetCategory.values)
                PlatformExpansionTile(
                  controller: viewModel.controllerFor(category),
                  materialExpansionTileData: const MaterialExpansionTileData(
                    showTrailingIcon: true,
                  ),
                  cupertinoExpansionTileData: const CupertinoExpansionTileData(
                    transitionMode: .scroll,
                  ),
                  title: Row(
                    children: [
                      category.icon(context),
                      // 12: icon-to-label gap, between the 8 and 16 grid steps.
                      const Gap(12),
                      Text(category.label),
                    ],
                  ),
                  child: Padding(
                    padding: const .only(left: 16, top: 16, bottom: 16),
                    child: switch (category) {
                      .buttons => ButtonsDemoView(shouldEnable: shouldEnable),
                      .selection => SelectionDemoView(shouldEnable: shouldEnable),
                      .text => TextDemoView(shouldEnable: shouldEnable),
                      .containers => ContainersDemoView(shouldEnable: shouldEnable),
                      .dialogs => DialogsDemoView(shouldEnable: shouldEnable),
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
