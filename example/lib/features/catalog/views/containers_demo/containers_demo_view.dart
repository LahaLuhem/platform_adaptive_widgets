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

/// The Lists & containers section of the Catalog accordion, list tile, scrollbar, progress-indicator
/// and expansion-tile playgrounds.
class ContainersDemoView extends StatelessWidget {
  final bool shouldEnable;

  const ContainersDemoView({required this.shouldEnable, super.key});

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
              // Tappable, so disabling it has a tap to stop.
              onTap: viewModel.onListTileTapped,
              isEnabled: shouldEnable,
              leadingWidth: viewModel.listTileLeadingWidth,
              color: viewModel.listTileColor,
              materialListTileData: MaterialListTileData(
                iconColor: viewModel.listTileIconColor,
                textColor: viewModel.listTileTextColor,
                titleAlignment: viewModel.listTileTitleAlignment,
              ),
            ),
            knobs: [
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
                onCleared: () => viewModel.onListTileColorSelected(null),
              ),
            ],
            materialKnobs: [
              ColorKnob(
                label: 'iconColor',
                value: viewModel.listTileIconColor,
                onChanged: viewModel.onListTileIconColorSelected,
                onCleared: () => viewModel.onListTileIconColorSelected(null),
              ),
              ColorKnob(
                label: 'textColor',
                value: viewModel.listTileTextColor,
                onChanged: viewModel.onListTileTextColorSelected,
                onCleared: () => viewModel.onListTileTextColorSelected(null),
              ),
              EnumKnob<ListTileTitleAlignment>(
                label: 'titleAlignment',
                value: viewModel.listTileTitleAlignment,
                // Center draws like threeLine on this two-line tile.
                values: const [.threeLine, .titleHeight, .top, .bottom],
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
                onCleared: () => viewModel.onExpansionTextColorSelected(null),
              ),
              ColorKnob(
                label: 'iconColor',
                value: viewModel.expansionIconColor,
                onChanged: viewModel.onExpansionIconColorSelected,
                onCleared: () => viewModel.onExpansionIconColorSelected(null),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformScrollbar',
          description: 'A scrollbar over a list that scrolls either way.',
          child: PropertyEditor(
            preview: SizedBox(
              // A fresh scrollbar per direction, since the old one keeps the other direction's
              // measurements for a frame and fails Flutter's orientation check.
              key: ValueKey(viewModel.scrollAxis),
              height: viewModel.scrollAxis == .vertical ? 160 : 80,
              child: PlatformScrollbar(
                thumbVisibility: viewModel.shouldShowScrollbarThumb,
                thickness: viewModel.scrollbarThickness,
                scrollbarOrientation: viewModel.scrollbarOrientation,
                controller: viewModel.currentScrollController,
                materialScrollbarData: MaterialScrollbarData(
                  trackVisibility: viewModel.shouldShowScrollbarTrack,
                  interactive: viewModel.isScrollbarInteractive,
                ),
                child: ListView.builder(
                  scrollDirection: viewModel.scrollAxis,
                  controller: viewModel.currentScrollController,
                  itemCount: 50,
                  itemBuilder: (_, index) => switch (viewModel.scrollAxis) {
                    .vertical => Text('Item $index'),
                    .horizontal => SizedBox(width: 80, child: Center(child: Text('Item $index'))),
                  },
                ),
              ),
            ),
            knobs: [
              SegmentKnob<Axis>(
                label: 'scrollDirection',
                value: viewModel.scrollAxis,
                values: const [.vertical, .horizontal],
                onChanged: viewModel.onScrollAxisSelected,
              ),
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
                values: viewModel.scrollbarOrientations,
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
          title: 'Progress',
          description:
              'PlatformProgressIndicator for an unknown end, PlatformProgressBar for known progress.',
          child: PropertyEditor(
            preview: Column(
              spacing: 16,
              children: [
                PlatformProgressIndicator(
                  color: viewModel.progressColor,
                  semanticsLabel: 'Syncing inbox',
                  materialProgressIndicatorData: MaterialProgressIndicatorData(
                    strokeWidth: viewModel.progressStrokeWidth,
                  ),
                  cupertinoProgressIndicatorData: CupertinoProgressIndicatorData(
                    animating: viewModel.shouldAnimateProgress,
                    radius: viewModel.progressRadius,
                  ),
                ),
                PlatformProgressBar(
                  value: viewModel.progressValue,
                  color: viewModel.progressColor,
                  semanticsLabel: 'Downloading episode',
                ),
              ],
            ),
            knobs: [
              ColorKnob(
                label: 'color',
                value: viewModel.progressColor,
                onChanged: viewModel.onProgressColorSelected,
                onCleared: () => viewModel.onProgressColorSelected(null),
              ),
              DoubleKnob(
                label: 'value',
                min: 0,
                max: 1,
                divisions: 10,
                value: viewModel.progressValue,
                onChanged: viewModel.onProgressValueChanged,
              ),
            ],
            materialKnobs: [
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
