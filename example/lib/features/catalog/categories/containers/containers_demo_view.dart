import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/core/widgets/demo_card.dart';
import 'containers_demo_view_model.dart';

/// The Lists & containers section of the Catalog accordion.
class ContainersDemoView extends StatelessWidget {
  const ContainersDemoView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: ContainersDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'List tile',
          description: 'Material ListTile · CupertinoListTile.',
          child: PlatformListTile(
            leading: Icon(
              context.platformIcon(material: Icons.list_alt, cupertino: CupertinoIcons.square_list),
            ),
            title: const Text('List tile'),
            subtitle: const Text('With leading and trailing'),
            trailing: const PlatformIcon(.forward),
          ),
        ),
        DemoCard(
          title: 'Expansion tile',
          description: 'Expands to reveal content.',
          child: PlatformExpansionTile(
            title: const Text('Tap to expand'),
            controller: viewModel.expansibleController,
            cupertinoExpansionTileData: const CupertinoExpansionTileData(transitionMode: .scroll),
            child: const Text('Expansion tile content.'),
          ),
        ),
        DemoCard(
          title: 'Scrollbar',
          description: 'An always-visible scrollbar over a scrolling list.',
          child: SizedBox(
            height: 160,
            child: PlatformScrollbar(
              thumbVisibility: true,
              controller: viewModel.scrollController,
              child: ListView.builder(
                controller: viewModel.scrollController,
                itemCount: 50,
                itemBuilder: (_, index) => Text('Item $index'),
              ),
            ),
          ),
        ),
        const DemoCard(
          title: 'Progress indicator',
          description: 'Material CircularProgressIndicator · CupertinoActivityIndicator.',
          child: Center(child: PlatformProgressIndicator()),
        ),
      ],
    ),
  );
}
