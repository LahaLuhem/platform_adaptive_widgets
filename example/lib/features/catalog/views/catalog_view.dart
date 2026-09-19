import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/widget_category.dart';
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
    viewBuilder: (context, viewModel) => PlatformScaffold(
      appBarData: const PlatformAppBar(title: Text('Catalog')),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const .symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: .end,
                spacing: 8,
                children: [
                  PlatformButton(
                    onPressed: viewModel.onExpandAllPressed,
                    materialButtonVariant: .text,
                    child: const Text('Expand all'),
                  ),
                  PlatformButton(
                    onPressed: viewModel.onCollapseAllPressed,
                    materialButtonVariant: .text,
                    child: const Text('Collapse all'),
                  ),
                ],
              ),
            ),
            for (final category in WidgetCategory.values)
              PlatformExpansionTile(
                controller: viewModel.controllerFor(category),
                materialExpansionTileData: const MaterialExpansionTileData(showTrailingIcon: true),
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
                  padding: const .fromLTRB(16, 0, 16, 16),
                  child: switch (category) {
                    .buttons => const ButtonsDemoView(),
                    .selection => const SelectionDemoView(),
                    .text => const TextDemoView(),
                    .containers => const ContainersDemoView(),
                    .dialogs => const DialogsDemoView(),
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
