import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButtonSize, CupertinoIcons;
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
import 'buttons_demo_view_model.dart';

/// A live `PlatformButton` playground. Only Cupertino gets a platform panel here, since Material puts
/// its whole surface behind `ButtonStyle` and there are no individual fields to knob.
class ButtonsDemoView extends StatelessWidget {
  const ButtonsDemoView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: ButtonsDemoViewModel(),
    viewBuilder: (context, viewModel) {
      final cupertinoData = CupertinoButtonData(
        color: viewModel.cupertinoColor,
        foregroundColor: viewModel.cupertinoForegroundColor,
        pressedOpacity: viewModel.cupertinoPressedOpacity,
        sizeStyle: viewModel.cupertinoSizeStyle,
      );

      return Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          DemoCard(
            title: 'PlatformButton',
            description: 'Ranks the same on Material and Cupertino, from high to low.',
            child: PropertyEditor(
              preview: viewModel.shouldUseIcon
                  ? PlatformButton.icon(
                      onPressed: () => viewModel.onButtonPressed('Playground'),
                      isEnabled: viewModel.shouldEnable,
                      emphasis: viewModel.emphasis,
                      cupertinoButtonData: cupertinoData,
                      icon: Icon(
                        context.platformIcon(material: Icons.add, cupertino: CupertinoIcons.add),
                      ),
                      label: const Text('Add'),
                    )
                  : PlatformButton(
                      onPressed: () => viewModel.onButtonPressed('Playground'),
                      isEnabled: viewModel.shouldEnable,
                      emphasis: viewModel.emphasis,
                      cupertinoButtonData: cupertinoData,
                      child: const Text('Button'),
                    ),
              knobs: [
                EnumKnob<PlatformButtonEmphasis>(
                  label: 'emphasis',
                  value: viewModel.emphasis,
                  values: PlatformButtonEmphasis.values,
                  onChanged: viewModel.onEmphasisSelected,
                ),
                BoolKnob(
                  label: 'isEnabled',
                  value: viewModel.shouldEnable,
                  onChanged: (value) => viewModel.onEnabledToggled(value: value),
                ),
                BoolKnob(
                  label: 'icon + label',
                  value: viewModel.shouldUseIcon,
                  onChanged: (value) => viewModel.onUseIconToggled(value: value),
                ),
              ],
              cupertinoKnobs: [
                ColorKnob(
                  label: 'color',
                  value: viewModel.cupertinoColor,
                  onChanged: viewModel.onCupertinoColorSelected,
                  onCleared: () => viewModel.onCupertinoColorSelected(null),
                ),
                ColorKnob(
                  label: 'foregroundColor',
                  value: viewModel.cupertinoForegroundColor,
                  onChanged: viewModel.onCupertinoForegroundColorSelected,
                  onCleared: () => viewModel.onCupertinoForegroundColorSelected(null),
                ),
                DoubleKnob(
                  label: 'pressedOpacity',
                  min: 0,
                  max: 1,
                  divisions: 10,
                  value: viewModel.cupertinoPressedOpacity,
                  onChanged: viewModel.onCupertinoPressedOpacityChanged,
                ),
                EnumKnob<CupertinoButtonSize>(
                  label: 'sizeStyle',
                  value: viewModel.cupertinoSizeStyle,
                  values: CupertinoButtonSize.values,
                  onChanged: viewModel.onCupertinoSizeStyleSelected,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
