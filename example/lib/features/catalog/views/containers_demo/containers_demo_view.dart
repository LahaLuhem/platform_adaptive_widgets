import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/color_knob.dart';
import '/features/catalog/widgets/property_editor/double_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import 'containers_demo_view_model.dart';

/// The Lists & containers section of the Catalog accordion — list tile,
/// scrollbar and progress-indicator playgrounds, plus an interactive expansion
/// tile (which has no shared-visual scalar properties to knob).
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
          title: 'PlatformListTile',
          description: 'Material ListTile · CupertinoListTile.',
          child: PropertyEditor(
            preview: PlatformListTile(
              leading: Icon(
                context.platformIcon(
                  material: Icons.list_alt,
                  cupertino: CupertinoIcons.square_list,
                ),
              ),
              title: const Text('List tile'),
              subtitle: const Text('With leading and trailing'),
              trailing: const PlatformIcon(.forward),
              isEnabled: viewModel.shouldEnableListTile,
              leadingWidth: viewModel.listTileLeadingWidth,
            ),
            knobs: [
              BoolKnob(
                label: 'isEnabled',
                value: viewModel.shouldEnableListTile,
                onChanged: (value) => viewModel.onListTileEnabledToggled(value: value),
              ),
              DoubleKnob(
                label: 'leadingWidth',
                min: 24,
                max: 72,
                divisions: 12,
                value: viewModel.listTileLeadingWidth,
                onChanged: viewModel.onListTileLeadingWidthChanged,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformExpansionTile',
          description: 'Expands to reveal content.',
          child: PlatformExpansionTile(
            title: const Text('Tap to expand'),
            controller: viewModel.expansibleController,
            cupertinoExpansionTileData: const CupertinoExpansionTileData(transitionMode: .scroll),
            child: const Text('Expansion tile content.'),
          ),
        ),
        DemoCard(
          title: 'PlatformScrollbar',
          description: 'A scrollbar over a scrolling list.',
          child: PropertyEditor(
            preview: SizedBox(
              height: 160,
              child: PlatformScrollbar(
                thumbVisibility: viewModel.shouldShowScrollbarThumb,
                thickness: viewModel.scrollbarThickness,
                controller: viewModel.scrollController,
                child: ListView.builder(
                  controller: viewModel.scrollController,
                  itemCount: 50,
                  itemBuilder: (_, index) => Text('Item $index'),
                ),
              ),
            ),
            knobs: [
              BoolKnob(
                label: 'thumbVisibility',
                value: viewModel.shouldShowScrollbarThumb,
                onChanged: (value) => viewModel.onScrollbarThumbToggled(value: value),
              ),
              DoubleKnob(
                label: 'thickness',
                min: 2,
                max: 16,
                divisions: 14,
                value: viewModel.scrollbarThickness,
                onChanged: viewModel.onScrollbarThicknessChanged,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformProgressIndicator',
          description: 'Material CircularProgressIndicator · CupertinoActivityIndicator.',
          child: PropertyEditor(
            preview: PlatformProgressIndicator(
              color: viewModel.progressColor,
              materialProgressIndicatorData: MaterialProgressIndicatorData(
                // 0 is the knob's "indeterminate" sentinel (labelled "animating").
                value: viewModel.progressValue == 0 ? null : viewModel.progressValue,
                strokeWidth: viewModel.progressStrokeWidth,
              ),
              cupertinoProgressIndicatorData: CupertinoProgressIndicatorData(
                animating: viewModel.shouldAnimateProgress,
                radius: viewModel.progressRadius,
              ),
            ),
            knobs: [
              ColorKnob(
                label: 'color',
                value: viewModel.progressColor,
                onChanged: viewModel.onProgressColorSelected,
              ),
            ],
            materialKnobs: [
              DoubleKnob(
                label: 'value',
                min: 0,
                max: 1,
                divisions: 10,
                value: viewModel.progressValue,
                onChanged: viewModel.onProgressValueChanged,
                valueLabel: (value) => value == 0 ? 'animating' : value.toStringAsFixed(1),
              ),
              DoubleKnob(
                label: 'strokeWidth',
                min: 2,
                max: 10,
                divisions: 8,
                value: viewModel.progressStrokeWidth,
                onChanged: viewModel.onProgressStrokeWidthChanged,
              ),
            ],
            cupertinoKnobs: [
              BoolKnob(
                label: 'animating',
                value: viewModel.shouldAnimateProgress,
                onChanged: (value) => viewModel.onProgressAnimatingToggled(value: value),
              ),
              DoubleKnob(
                label: 'radius',
                min: 8,
                max: 30,
                divisions: 11,
                value: viewModel.progressRadius,
                onChanged: viewModel.onProgressRadiusChanged,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
