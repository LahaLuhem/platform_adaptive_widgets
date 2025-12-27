import 'package:flutter/material.dart' show FloatingActionButton;
import 'package:flutter/widgets.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: HomeViewModel(),
    viewBuilder: (context, viewModel) => PlatformScaffold(
      appBarData: const PlatformAppBar(title: Text('Home page')),
      materialScaffoldData: MaterialScaffoldData(
        // No nested FABs
        // ignore: prefer-define-hero-tag
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.onAddPressed,
          child: const Text('FAB'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const .all(16),
          child: CustomScrollView(
            slivers: [
              const _SectionHeader(title: 'Painting'),
              SliverList.list(children: const [Center(child: PlatformProgressIndicator())]),
              const _SectionHeader(title: 'Interaction'),
              SliverList.list(
                children: [
                  ValueListenableBuilder(
                    valueListenable: viewModel.sliderValueListenable,
                    builder: (_, sliderValue, _) => PlatformSlider(
                      platformSliderData: PlatformSliderData(
                        value: sliderValue,
                        onChanged: viewModel.onSliderChanged,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: viewModel.isSwitchEnabledListenable,
                    builder: (_, isSwitchEnabled, _) => PlatformSwitch(
                      platformSwitchData: PlatformSwitchData(
                        value: isSwitchEnabled,
                        onChanged: viewModel.onSwitchChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

final class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const .symmetric(vertical: 16),
    sliver: AdaptiveHeightSliverPersistentHeader(
      initialHeight: 24,
      floating: true,
      needRepaint: true,
      child: Text(title),
    ),
  );
}
