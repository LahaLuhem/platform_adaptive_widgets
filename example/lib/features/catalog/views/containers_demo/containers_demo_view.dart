import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons, ListTileTitleAlignment;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/color_knob.dart';
import '/features/catalog/widgets/property_editor/double_knob.dart';
import '/features/catalog/widgets/property_editor/enum_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import '/features/catalog/widgets/property_editor/segment_knob.dart';
import 'containers_demo_view_model.dart';

/// The Lists & containers section of the Catalog accordion — list tile,
/// scrollbar, progress-indicator and expansion-tile playgrounds.
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
              color: viewModel.listTileColor,
              materialListTileData: MaterialListTileData(
                iconColor: viewModel.listTileIconColor,
                textColor: viewModel.listTileTextColor,
                titleAlignment: viewModel.listTileTitleAlignment,
              ),
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
              ColorKnob(
                label: 'color',
                value: viewModel.listTileColor,
                onChanged: viewModel.onListTileColorSelected,
              ),
            ],
            materialKnobs: [
              ColorKnob(
                label: 'iconColor',
                value: viewModel.listTileIconColor,
                onChanged: viewModel.onListTileIconColorSelected,
              ),
              ColorKnob(
                label: 'textColor',
                value: viewModel.listTileTextColor,
                onChanged: viewModel.onListTileTextColorSelected,
              ),
              EnumKnob<ListTileTitleAlignment>(
                label: 'titleAlignment',
                value: viewModel.listTileTitleAlignment,
                values: ListTileTitleAlignment.values,
                onChanged: viewModel.onListTileTitleAlignmentSelected,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformExpansionTile',
          description: 'Expands to reveal content.',
          child: PropertyEditor(
            preview: PlatformExpansionTile(
              title: const Text('Tap to expand'),
              controller: viewModel.expansibleController,
              cupertinoExpansionTileData: const CupertinoExpansionTileData(transitionMode: .scroll),
              materialExpansionTileData: MaterialExpansionTileData(
                showTrailingIcon: viewModel.shouldShowExpansionTrailingIcon,
                textColor: viewModel.expansionTextColor,
                iconColor: viewModel.expansionIconColor,
              ),
              child: const Text('Expansion tile content.'),
            ),
            knobs: const [],
            materialKnobs: [
              BoolKnob(
                label: 'showTrailingIcon',
                value: viewModel.shouldShowExpansionTrailingIcon,
                onChanged: (value) => viewModel.onExpansionTrailingIconToggled(value: value),
              ),
              ColorKnob(
                label: 'textColor',
                value: viewModel.expansionTextColor,
                onChanged: viewModel.onExpansionTextColorSelected,
              ),
              ColorKnob(
                label: 'iconColor',
                value: viewModel.expansionIconColor,
                onChanged: viewModel.onExpansionIconColorSelected,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformScrollbar',
          description: 'A scrollbar over a vertical list.',
          child: PropertyEditor(
            preview: SizedBox(
              height: 160,
              child: PlatformScrollbar(
                thumbVisibility: viewModel.shouldShowScrollbarThumb,
                thickness: viewModel.scrollbarThickness,
                scrollbarOrientation: viewModel.scrollbarOrientation,
                controller: viewModel.scrollController,
                materialScrollbarData: MaterialScrollbarData(
                  trackVisibility: viewModel.shouldShowScrollbarTrack,
                  interactive: viewModel.isScrollbarInteractive,
                ),
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
              SegmentKnob<ScrollbarOrientation>(
                label: 'scrollbarOrientation',
                value: viewModel.scrollbarOrientation,
                values: const [.left, .right],
                onChanged: viewModel.onScrollbarOrientationSelected,
              ),
            ],
            materialKnobs: [
              BoolKnob(
                label: 'trackVisibility',
                value: viewModel.shouldShowScrollbarTrack,
                onChanged: (value) => viewModel.onScrollbarTrackToggled(value: value),
              ),
              BoolKnob(
                label: 'interactive',
                value: viewModel.isScrollbarInteractive,
                onChanged: (value) => viewModel.onScrollbarInteractiveToggled(value: value),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformScrollbar (horizontal)',
          description: 'The same widget over a horizontal list — top / bottom orientation.',
          child: PropertyEditor(
            preview: SizedBox(
              height: 80,
              child: PlatformScrollbar(
                thumbVisibility: true,
                scrollbarOrientation: viewModel.horizontalScrollbarOrientation,
                controller: viewModel.horizontalScrollController,
                child: ListView.builder(
                  scrollDirection: .horizontal,
                  controller: viewModel.horizontalScrollController,
                  itemCount: 50,
                  itemBuilder: (_, index) =>
                      SizedBox(width: 80, child: Center(child: Text('Item $index'))),
                ),
              ),
            ),
            knobs: [
              SegmentKnob<ScrollbarOrientation>(
                label: 'scrollbarOrientation',
                value: viewModel.horizontalScrollbarOrientation,
                values: const [.top, .bottom],
                onChanged: viewModel.onHorizontalScrollbarOrientationSelected,
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
