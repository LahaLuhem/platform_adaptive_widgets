import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/showcase/widgets/nuance_card.dart';
import 'showcase_view_model.dart';

/// The "Under the hood" tab — not a sample screen, but a guided tour of the
/// deliberate, easy-to-get-wrong details the library handles for you. Each card
/// names a decision, says what a naive `Platform.isIOS ? … : …` wrapper gets
/// wrong, and (where it can) proves it live.
class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: ShowcaseViewModel(),
    viewBuilder: (context, viewModel) => PlatformScaffold(
      appBarData: const PlatformAppBar(title: Text('Under the hood')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              NuanceCard(
                title: 'Tabs keep their state',
                body:
                    'Cupertino manages its tab index internally, but the go_router '
                    'StatefulShell wants to own it. PlatformTabScaffold keeps one '
                    'CupertinoTabController for the scaffold lifetime and syncs its index '
                    'in didUpdateWidget, so the external source and Cupertino do not fight '
                    'and switching tabs does not rebuild a tab from scratch. Tap +, switch '
                    'tabs, then come back — the count is still here.',
                demo: ValueListenableBuilder(
                  valueListenable: viewModel.tapCountListenable,
                  builder: (_, count, _) => Row(
                    spacing: 12,
                    children: [
                      PlatformButton(
                        onPressed: viewModel.onProbeIncremented,
                        child: const Text('Tap +'),
                      ),
                      Text('Count: $count'),
                    ],
                  ),
                ),
              ),
              NuanceCard(
                title: 'Native page transitions',
                body:
                    'The library adapts widgets, not routes, so the Navigator entry point '
                    'ships a thin pushPlatformRoute. Each platform gets its own transition: '
                    'a CupertinoPageRoute on iOS (swipe from the left edge to go back), a '
                    'MaterialPageRoute on Android.',
                code: 'pushPlatformRoute(context, (_) => const DetailPage())',
                demo: PlatformButton(
                  onPressed: () => viewModel.onPushPagePressed(large: false),
                  child: const Text('Push a page'),
                ),
              ),
              NuanceCard(
                title: 'Disable, never un-wire',
                body:
                    'PlatformSwitch and friends keep onChanged non-null and gate input with '
                    'isEnabled. A null callback would conflate disabled with not-yet-wired; '
                    'isEnabled says exactly what is meant. Toggle the first switch to disable '
                    'the second.',
                demo: Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: viewModel.controlEnabledListenable,
                      builder: (_, enabled, _) => Row(
                        spacing: 12,
                        children: [
                          PlatformSwitch(
                            value: enabled,
                            onChanged: (value) => viewModel.onControlEnabledToggled(value: value),
                          ),
                          const Text('Enable the control below'),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: viewModel.controlEnabledListenable,
                      builder: (_, enabled, _) => ValueListenableBuilder(
                        valueListenable: viewModel.gatedValueListenable,
                        builder: (_, gatedValue, _) => Row(
                          spacing: 12,
                          children: [
                            PlatformSwitch(
                              value: gatedValue,
                              isEnabled: enabled,
                              onChanged: (value) => viewModel.onGatedToggled(value: value),
                            ),
                            const Text('Gated control'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              NuanceCard(
                title: 'Tri-state, faithfully',
                body:
                    'Both the Material and Cupertino checkboxes have a native third, '
                    'indeterminate state — rendered as a dash rather than a check. '
                    'PlatformCheckbox.tristate exposes it on both: value and onChanged go '
                    'nullable, and taps cycle true, false, null.',
                demo: ValueListenableBuilder(
                  valueListenable: viewModel.checkboxValueListenable,
                  builder: (_, value, _) => Row(
                    spacing: 12,
                    children: [
                      PlatformCheckbox.tristate(
                        value: value,
                        onChanged: (newValue) => viewModel.onCheckboxToggled(value: newValue),
                      ),
                      Text('Value: $value'),
                    ],
                  ),
                ),
              ),
              NuanceCard(
                title: 'Large titles, where they belong',
                body:
                    'iOS has a large navigation title that collapses on scroll; Material has '
                    'no static equivalent. CupertinoNavigationBarData.large opts in — the same '
                    'PlatformAppBar is just a standard bar on Android.',
                code: 'cupertinoNavigationBarData: CupertinoNavigationBarData(large: true)',
                demo: PlatformButton(
                  onPressed: () => viewModel.onPushPagePressed(large: true),
                  child: const Text('Push a large-title page'),
                ),
              ),
              const NuanceCard(
                title: 'One source of truth',
                body:
                    'Functional inputs — value, callbacks, controllers — live flat on the '
                    'widget, never duplicated inside a *Data class. No question of '
                    'widget.value versus data.value: the per-platform *Data classes carry '
                    'only the visual and behavioural extras specific to each platform.',
                code: 'PlatformSwitch(value: isOn, onChanged: onChanged)  // not data.value',
              ),
              const NuanceCard(
                title: 'Material-only capabilities, modelled honestly',
                body:
                    'Some things exist on one platform only — a floating action button, or a '
                    'unified app bar above a tab scaffold (the iOS HIG forbids both). Rather '
                    'than fake them everywhere, they live on the Material *Data class with no '
                    'Cupertino counterpart.',
                code: 'MaterialScaffoldData(floatingActionButton: fab)  // iOS has no FAB',
              ),
              const NuanceCard(
                title: 'heroTag collisions, handled',
                body:
                    'Two CupertinoNavigationBars on screen during a transition — a tab '
                    'scaffold and a pushed page — share a default hero tag and crash the '
                    'animation; so do two FABs. The library exposes heroTag so each can have '
                    'its own.',
                code: "CupertinoNavigationBarData(heroTag: 'profile')",
              ),
              const NuanceCard(
                title: 'The size cost of platformValue',
                body:
                    'platformValue(material:, cupertino:) evaluates both arms eagerly. '
                    'Fine for cheap values, but when an arm builds a platform-specific widget, '
                    'an inline switch on defaultTargetPlatform lets the dead arm be '
                    'tree-shaken — ≈342 KB lighter for one Cupertino widget in our size harness.',
                code: 'switch (defaultTargetPlatform) { .iOS => CupertinoX(), _ => MaterialX() }',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
