import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/menu_picker_length.dart';
import '/features/catalog/data/extensions/platform_adaptive_icons_extension.dart';
import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/color_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import '/features/catalog/widgets/property_editor/segment_knob.dart';
import '/features/catalog/widgets/property_editor/string_knob.dart';
import 'selection_demo_view_model.dart';

/// The Catalog's Selection controls section.
class SelectionDemoView extends StatelessWidget {
  final bool shouldEnable;

  const SelectionDemoView({required this.shouldEnable, super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: SelectionDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'PlatformMultiSelectList',
          description: 'Material CheckboxListTiles · checkmark rows in a Cupertino section.',
          child: PropertyEditor(
            preview: PlatformMultiSelectList(
              options: Weekday.values.toSet(),
              selected: viewModel.repeatDays,
              label: (day) => day.name,
              onChanged: viewModel.onRepeatDaysChanged,
              header: viewModel.repeatHeader,
            ),
            knobs: [
              StringKnob(
                label: 'header',
                value: viewModel.repeatHeader ?? '',
                onChanged: viewModel.onRepeatHeaderChanged,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformSwitch',
          description: 'Material Switch · CupertinoSwitch.',
          child: PropertyEditor(
            preview: PlatformSwitch(
              value: viewModel.isSwitchOn,
              onChanged: (value) => viewModel.onSwitchToggled(value: value),
              isEnabled: shouldEnable,
              activeTrackColor: viewModel.switchActiveTrackColor,
              activeThumbColor: viewModel.switchActiveThumbColor,
              inactiveThumbColor: viewModel.switchInactiveThumbColor,
            ),
            knobs: [
              ColorKnob(
                label: 'activeTrackColor',
                value: viewModel.switchActiveTrackColor,
                onChanged: viewModel.onSwitchActiveTrackColorSelected,
                onCleared: () => viewModel.onSwitchActiveTrackColorSelected(null),
              ),
              ColorKnob(
                label: 'activeThumbColor',
                value: viewModel.switchActiveThumbColor,
                onChanged: viewModel.onSwitchActiveThumbColorSelected,
                onCleared: () => viewModel.onSwitchActiveThumbColorSelected(null),
              ),
              ColorKnob(
                label: 'inactiveThumbColor',
                value: viewModel.switchInactiveThumbColor,
                onChanged: viewModel.onSwitchInactiveThumbColorSelected,
                onCleared: () => viewModel.onSwitchInactiveThumbColorSelected(null),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformSlider',
          description: 'Material Slider · CupertinoSlider.',
          child: PropertyEditor(
            preview: PlatformSlider(
              value: viewModel.sliderValue,
              onChanged: viewModel.onSliderChanged,
              isEnabled: shouldEnable,
              activeColor: viewModel.sliderActiveColor,
              thumbColor: viewModel.sliderThumbColor,
              materialSliderData: MaterialSliderData(inactiveColor: viewModel.sliderInactiveColor),
            ),
            knobs: [
              ColorKnob(
                label: 'activeColor',
                value: viewModel.sliderActiveColor,
                onChanged: viewModel.onSliderActiveColorSelected,
                onCleared: () => viewModel.onSliderActiveColorSelected(null),
              ),
              ColorKnob(
                label: 'thumbColor',
                value: viewModel.sliderThumbColor,
                onChanged: viewModel.onSliderThumbColorSelected,
                onCleared: () => viewModel.onSliderThumbColorSelected(null),
              ),
            ],
            materialKnobs: [
              ColorKnob(
                label: 'inactiveColor',
                value: viewModel.sliderInactiveColor,
                onChanged: viewModel.onSliderInactiveColorSelected,
                onCleared: () => viewModel.onSliderInactiveColorSelected(null),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Shared selection',
          description:
              'Segmented button, single-select list and menu picker bound to one value, '
              'change any one and the others follow.',
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              PlatformSegmentButton(
                choices: AxisDirection.values.toSet(),
                selectedChoice: viewModel.selectedDirection,
                segmentBuilder: (direction) => Text(direction.name),
                onSelectionChanged: viewModel.onDirectionChanged,
                // Material can't disable a segment upstream, so only Cupertino dims these.
                cupertinoSegmentButtonData: CupertinoSegmentButtonData(
                  disabledChildren: {if (!shouldEnable) ...AxisDirection.values},
                ),
              ),
              PlatformSingleSelectList(
                options: AxisDirection.values.toSet(),
                selected: viewModel.selectedDirection,
                label: (direction) => direction.name,
                onChanged: viewModel.onDirectionChanged,
              ),
              PlatformMenuPicker(
                items: AxisDirection.values.toSet(),
                currentValue: viewModel.selectedDirection,
                onSelected: viewModel.onDirectionChanged,
                isEnabled: shouldEnable,
                labelText: 'Direction',
                leadingIcon: const PlatformIcon(.crop),
                menuPickerItemTransformer: (direction) => MenuPickerItem(
                  label: direction.name,
                  iconData: switch (direction) {
                    .left => Icons.adaptive.arrow_back,
                    .right => Icons.adaptive.arrow_forward,
                    .up => context.platformAdaptiveIcons.arrowUpward,
                    .down => context.platformAdaptiveIcons.arrowDownward,
                  },
                ),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'PlatformMenuPicker',
          description:
              'A dropdown on Material, at any length. On Cupertino, a menu up to '
              '$kCupertinoMenuPickerSmallItemCountThreshold items, a wheel up to '
              '$kCupertinoMenuPickerLargeItemCountThreshold and a page past that, icons included.',
          child: PropertyEditor(
            preview: PlatformMenuPicker(
              items: Iterable.generate(
                viewModel.menuPickerLength.itemCount,
                (index) => index + 1,
              ).toSet(),
              currentValue: viewModel.pickedItem,
              onSelected: viewModel.onPickerItemSelected,
              isEnabled: shouldEnable,
              labelText: 'Item',
              menuPickerItemTransformer: (item) => MenuPickerItem(
                label: 'Item $item',
                iconData: context.platformIcon(
                  material: Icons.star,
                  cupertino: CupertinoIcons.star,
                ),
              ),
            ),
            knobs: const [],
            cupertinoKnobs: [
              SegmentKnob(
                label: 'items',
                value: viewModel.menuPickerLength,
                values: MenuPickerLength.values.toSet(),
                onChanged: viewModel.onMenuPickerLengthChanged,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
