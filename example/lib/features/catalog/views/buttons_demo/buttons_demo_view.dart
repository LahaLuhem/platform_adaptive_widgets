import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/widgets/demo_card.dart';
import '/features/catalog/widgets/property_editor/bool_knob.dart';
import '/features/catalog/widgets/property_editor/enum_knob.dart';
import '/features/catalog/widgets/property_editor/property_editor.dart';
import 'buttons_demo_view_model.dart';

/// The Buttons section of the Catalog accordion — a live `PlatformButton`
/// playground over its shared-visual properties (per-platform variant, enabled
/// state, and the child-vs-`.icon` constructor).
class ButtonsDemoView extends StatelessWidget {
  const ButtonsDemoView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: ButtonsDemoViewModel(),
    viewBuilder: (context, viewModel) => Column(
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        DemoCard(
          title: 'PlatformButton',
          description: 'Material variants on Android · Cupertino variants on iOS.',
          child: PropertyEditor(
            preview: viewModel.shouldUseIcon
                ? PlatformButton.icon(
                    onPressed: () => viewModel.onButtonPressed('Playground'),
                    isEnabled: viewModel.shouldEnable,
                    materialButtonVariant: viewModel.materialVariant,
                    cupertinoButtonVariant: viewModel.cupertinoVariant,
                    icon: Icon(
                      context.platformIcon(material: Icons.add, cupertino: CupertinoIcons.add),
                    ),
                    label: const Text('Add'),
                  )
                : PlatformButton(
                    onPressed: () => viewModel.onButtonPressed('Playground'),
                    isEnabled: viewModel.shouldEnable,
                    materialButtonVariant: viewModel.materialVariant,
                    cupertinoButtonVariant: viewModel.cupertinoVariant,
                    child: const Text('Button'),
                  ),
            knobs: [
              EnumKnob<MaterialButtonVariant>(
                label: 'materialButtonVariant',
                value: viewModel.materialVariant,
                values: MaterialButtonVariant.values,
                onChanged: viewModel.onMaterialVariantSelected,
              ),
              EnumKnob<CupertinoButtonVariant>(
                label: 'cupertinoButtonVariant',
                value: viewModel.cupertinoVariant,
                values: CupertinoButtonVariant.values,
                onChanged: viewModel.onCupertinoVariantSelected,
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
          ),
        ),
      ],
    ),
  );
}
