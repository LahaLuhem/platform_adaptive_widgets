import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/core/widgets/demo_card.dart';
import 'buttons_demo_view_model.dart';

/// The Buttons section of the Catalog accordion — the `PlatformButton`
/// variants, the icon constructor, and the disabled state.
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
          title: 'Filled',
          description: 'High-emphasis primary action.',
          child: PlatformButton(
            onPressed: () => viewModel.onButtonPressed('Filled'),
            materialButtonVariant: .filled,
            cupertinoButtonVariant: .filled,
            child: const Text('Filled'),
          ),
        ),
        DemoCard(
          title: 'Tonal & tinted',
          description: 'Medium emphasis — Material tonal, Cupertino tinted.',
          child: PlatformButton(
            onPressed: () => viewModel.onButtonPressed('Tonal'),
            materialButtonVariant: .tonal,
            cupertinoButtonVariant: .tinted,
            child: const Text('Tonal / tinted'),
          ),
        ),
        DemoCard(
          title: 'Outlined',
          description: 'Material outline; Cupertino renders its normal button.',
          child: PlatformButton(
            onPressed: () => viewModel.onButtonPressed('Outlined'),
            materialButtonVariant: .outlined,
            child: const Text('Outlined'),
          ),
        ),
        DemoCard(
          title: 'Text',
          description: 'Low-emphasis — Material text button, Cupertino plain.',
          child: PlatformButton(
            onPressed: () => viewModel.onButtonPressed('Text'),
            materialButtonVariant: .text,
            child: const Text('Text'),
          ),
        ),
        DemoCard(
          title: 'Icon + label',
          description: 'PlatformButton.icon — an adaptive icon-and-label layout.',
          child: PlatformButton.icon(
            onPressed: () => viewModel.onButtonPressed('Icon'),
            materialButtonVariant: .filled,
            cupertinoButtonVariant: .filled,
            icon: Icon(context.platformIcon(material: Icons.add, cupertino: CupertinoIcons.add)),
            label: const Text('Add'),
          ),
        ),
        DemoCard(
          title: 'Disabled',
          description: 'isEnabled: false — the callback never fires.',
          child: PlatformButton(
            onPressed: () => viewModel.onButtonPressed('Disabled'),
            isEnabled: false,
            child: const Text('Disabled'),
          ),
        ),
      ],
    ),
  );
}
