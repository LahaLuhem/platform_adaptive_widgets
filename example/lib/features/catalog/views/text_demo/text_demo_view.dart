import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons, InputDecoration;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import 'text_demo_view_model.dart';

/// The Text & search section of the Catalog accordion.
class TextDemoView extends StatelessWidget {
  const TextDemoView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: TextDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'Text field',
          description: 'Material TextField · CupertinoTextField.',
          child: PlatformTextField(
            controller: viewModel.textFieldController,
            onSubmitted: viewModel.onTextSubmitted,
            hintText: 'Type, then submit',
            materialTextFieldData: const MaterialTextFieldData(
              decoration: InputDecoration(labelText: 'Label (Android)'),
            ),
          ),
        ),
        DemoCard(
          title: 'Search bar',
          description: 'Material SearchBar · CupertinoSearchTextField.',
          child: Column(
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              PlatformSearchBar(
                hintText: 'Search',
                controller: viewModel.searchController,
                onChanged: viewModel.onSearchChanged,
                leading: Icon(
                  context.platformIcon(material: Icons.search, cupertino: CupertinoIcons.search),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: viewModel.searchQueryListenable,
                builder: (_, query, _) =>
                    Text(query.isEmpty ? 'Type to search…' : 'Query: "$query"'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
