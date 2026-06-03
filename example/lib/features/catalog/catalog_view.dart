import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/core/models/app_args.dart';
import '/features/core/models/widget_category.dart';
import 'catalog_view_model.dart';

/// The Catalog tab — one tappable row per [WidgetCategory], each opening a
/// detail page of labelled widget demos.
class CatalogView extends StatelessWidget {
  /// Host args — threaded into the view model to pick the navigation backend.
  final AppArgs args;

  const CatalogView({required this.args, super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: CatalogViewModel(args),
    viewBuilder: (context, viewModel) => PlatformScaffold(
      appBarData: const PlatformAppBar(title: Text('Catalog')),
      body: SafeArea(
        child: ListView(
          children: [
            for (final category in WidgetCategory.values)
              PlatformListTile(
                leading: category.icon(context),
                title: Text(category.label),
                subtitle: Text(category.description),
                trailing: const PlatformIcon(PlatformIcons.forward),
                onTap: () => viewModel.onCategoryPressed(category),
              ),
          ],
        ),
      ),
    ),
  );
}
