import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/extensions/platform_adaptive_icons_extension.dart';
import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/color_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import 'selection_demo_view_model.dart';

/// The Selection-controls section of the Catalog accordion — checkbox / switch /
/// slider playgrounds, plus a shared-selection showcase (segmented button, radio
/// group and menu picker all bound to one value).
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
          title: 'PlatformCheckbox',
          description: 'Material Checkbox · CupertinoCheckbox.',
          child: PropertyEditor(
            preview: PlatformCheckbox(
              value: viewModel.checkboxValue,
              onChanged: (value) => viewModel.onCheckboxToggled(value: value),
              isEnabled: viewModel.shouldEnableCheckbox,
              activeColor: viewModel.checkboxActiveColor,
            ),
            knobs: [
              BoolKnob(
                label: 'isEnabled',
                value: viewModel.shouldEnableCheckbox,
                onChanged: (value) => viewModel.onCheckboxEnabledToggled(value: value),
              ),
              ColorKnob(
                label: 'activeColor',
                value: viewModel.checkboxActiveColor,
                onChanged: viewModel.onCheckboxActiveColorSelected,
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
              isEnabled: viewModel.shouldEnableSwitch,
              activeTrackColor: viewModel.switchActiveTrackColor,
            ),
            knobs: [
              BoolKnob(
                label: 'isEnabled',
                value: viewModel.shouldEnableSwitch,
                onChanged: (value) => viewModel.onSwitchEnabledToggled(value: value),
              ),
              ColorKnob(
                label: 'activeTrackColor',
                value: viewModel.switchActiveTrackColor,
                onChanged: viewModel.onSwitchActiveTrackColorSelected,
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
              isEnabled: viewModel.shouldEnableSlider,
              activeColor: viewModel.sliderActiveColor,
            ),
            knobs: [
              BoolKnob(
                label: 'isEnabled',
                value: viewModel.shouldEnableSlider,
                onChanged: (value) => viewModel.onSliderEnabledToggled(value: value),
              ),
              ColorKnob(
                label: 'activeColor',
                value: viewModel.sliderActiveColor,
                onChanged: viewModel.onSliderActiveColorSelected,
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Shared selection',
          description:
              'Segmented button, radio group and menu picker bound to one value — '
              'change any one and the others follow.',
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              PlatformSegmentButton(
                choices: AxisDirection.values,
                selectedChoice: viewModel.selectedDirection,
                segmentBuilder: (direction) => Text(direction.name),
                onSelectionChanged: viewModel.onDirectionChanged,
              ),
              PlatformRadioGroupBuilder<AxisDirection>(
                values: AxisDirection.values,
                groupValue: viewModel.selectedDirection,
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
              PlatformMenuPicker(
                items: AxisDirection.values,
                currentValue: viewModel.selectedDirection,
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
            ],
          ),
        ),
      ],
    ),
  );
}
