import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/extensions/platform_adaptive_icons_extension.dart';
import '/features/catalog/widgets/demo_card.dart';
import 'selection_demo_view_model.dart';

/// The Selection-controls section of the Catalog accordion.
class SelectionDemoView extends StatelessWidget {
  const SelectionDemoView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: SelectionDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'Checkbox',
          description: 'Tri-state — taps cycle checked, unchecked and null.',
          child: ValueListenableBuilder(
            valueListenable: viewModel.checkboxValueListenable,
            builder: (_, checkboxValue, _) => PlatformCheckbox(
              value: checkboxValue,
              tristate: true,
              onChanged: (value) => viewModel.onCheckboxToggled(value: value),
            ),
          ),
        ),
        DemoCard(
          title: 'Switch',
          description: 'Material Switch · CupertinoSwitch.',
          child: ValueListenableBuilder(
            valueListenable: viewModel.isSwitchOnListenable,
            builder: (_, isSwitchOn, _) => PlatformSwitch(
              value: isSwitchOn,
              onChanged: (value) => viewModel.onSwitchToggled(value: value),
            ),
          ),
        ),
        DemoCard(
          title: 'Slider',
          description: 'Material Slider · CupertinoSlider.',
          child: ValueListenableBuilder(
            valueListenable: viewModel.sliderValueListenable,
            builder: (_, sliderValue, _) => PlatformSlider(
              value: sliderValue,
              onChanged: (value) => viewModel.onSliderChanged(value: value),
            ),
          ),
        ),
        DemoCard(
          title: 'Segmented button',
          description: 'Shares its selection with the radios and menu picker below.',
          child: ValueListenableBuilder(
            valueListenable: viewModel.selectedDirectionListenable,
            builder: (_, selectedDirection, _) => PlatformSegmentButton(
              choices: AxisDirection.values,
              selectedChoice: selectedDirection,
              segmentBuilder: (direction) => Text(direction.name),
              onSelectionChanged: viewModel.onDirectionChanged,
            ),
          ),
        ),
        DemoCard(
          title: 'Radio group',
          description: 'Bound to the same selection as the segmented button.',
          child: ValueListenableBuilder(
            valueListenable: viewModel.selectedDirectionListenable,
            builder: (_, selectedDirection, _) => PlatformRadioGroupBuilder<AxisDirection>(
              values: AxisDirection.values,
              groupValue: selectedDirection,
              onChanged: viewModel.onDirectionChanged,
              itemBuilder: (_, direction) => Row(
                mainAxisSize: .min,
                children: [
                  PlatformRadio(
                    value: direction,
                    materialRadioData: const MaterialRadioData(visualDensity: .compact),
                  ),
                  Text(direction.name),
                ],
              ),
            ),
          ),
        ),
        DemoCard(
          title: 'Menu picker',
          description: 'A dropdown on Android, an action sheet on iOS.',
          child: ValueListenableBuilder(
            valueListenable: viewModel.selectedDirectionListenable,
            builder: (context, selectedDirection, _) => PlatformMenuPicker(
              items: AxisDirection.values,
              currentValue: selectedDirection,
              onSelected: viewModel.onDirectionChanged,
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
          ),
        ),
      ],
    ),
  );
}
