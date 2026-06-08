import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/color_knob.dart';
import '/features/catalog/widgets/property_editor/double_knob.dart';
import '/features/catalog/widgets/property_editor/enum_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import '/features/catalog/widgets/property_editor/string_knob.dart';
import 'text_demo_view_model.dart';

/// The Text & search section of the Catalog accordion — a live
/// `PlatformTextField` playground plus a `PlatformSearchBar` demo.
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
          title: 'PlatformTextField',
          description:
              'Fiddle the shared-visual properties live — type into the field to see them.',
          child: PropertyEditor(
            preview: PlatformTextField(
              controller: viewModel.playgroundController,
              hintText: viewModel.hintText,
              cursorColor: viewModel.cursorColor,
              cursorWidth: viewModel.cursorWidth,
              obscureText: viewModel.shouldObscure,
              textAlign: viewModel.textAlign,
            ),
            knobs: [
              StringKnob(
                label: 'hintText',
                value: viewModel.hintText,
                onChanged: viewModel.onHintTextChanged,
              ),
              ColorKnob(
                label: 'cursorColor',
                value: viewModel.cursorColor,
                onChanged: viewModel.onCursorColorSelected,
              ),
              DoubleKnob(
                label: 'cursorWidth',
                min: 1,
                max: 6,
                divisions: 10,
                value: viewModel.cursorWidth,
                onChanged: viewModel.onCursorWidthChanged,
              ),
              BoolKnob(
                label: 'obscureText',
                value: viewModel.shouldObscure,
                onChanged: (value) => viewModel.onObscureToggled(value: value),
              ),
              EnumKnob<TextAlign>(
                label: 'textAlign',
                value: viewModel.textAlign,
                values: TextAlign.values,
                onChanged: viewModel.onTextAlignSelected,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformSearchBar',
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
              Text(
                viewModel.searchQuery.isEmpty
                    ? 'Type to search…'
                    : 'Query: "${viewModel.searchQuery}"',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
