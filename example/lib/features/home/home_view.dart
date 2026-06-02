import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '../core/data/extensions/platform_adaptive_icons_extension.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  final HomeViewArgs args;

  const HomeView({required this.args, super.key});

  static const _shrunkCupertinoButtonData = CupertinoButtonData(padding: .zero);

  @override
  Widget build(BuildContext context) {
    final platformTheme = PlatformTheme.of(context);

    return MVVM.builder(
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
                const _SectionHeader(title: 'Dialogs'),
                SliverList.list(
                  children: [
                    Wrap(
                      spacing: 16,
                      children: [
                        PlatformButton(
                          onPressed: viewModel.onShowGeneralDialogPressed,
                          cupertinoButtonData: _shrunkCupertinoButtonData,
                          child: const Text('show general dialog', maxLines: 2),
                        ),
                        PlatformButton(
                          onPressed: viewModel.onShowAlertDialogPressed,
                          cupertinoButtonData: _shrunkCupertinoButtonData,
                          child: const Text('show alert dialog', maxLines: 2),
                        ),
                        PlatformButton(
                          onPressed: viewModel.onShowSimpleAlertPressed,
                          cupertinoButtonData: _shrunkCupertinoButtonData,
                          child: const Text('show toast → acknowledge', maxLines: 2),
                        ),
                        PlatformButton(
                          isEnabled: false,
                          // Will always be disabled for showcase
                          // ignore: no-empty-block
                          onPressed: () {},
                          cupertinoButtonData: _shrunkCupertinoButtonData,
                          child: const Text('Disabled', maxLines: 2),
                        ),
                        if (args.isUsingGoRouter)
                          PlatformButton(
                            onPressed: viewModel.onSubRoutePressed,
                            cupertinoButtonData: _shrunkCupertinoButtonData,
                            child: const Text('Sub-route', maxLines: 2),
                          ),
                      ],
                    ),
                    Center(
                      child: PlatformButton(
                        onPressed: viewModel.onShowGeneralBottomSheetPressed,
                        materialButtonVariant: .outlined,
                        cupertinoButtonVariant: .filled,
                        child: const Text('show general bottom sheet', maxLines: 2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 16,
                      children: [
                        PlatformButton(
                          onPressed: viewModel.onShowDatePickerPressed,
                          materialButtonVariant: .text,
                          cupertinoButtonVariant: .tinted,
                          child: ValueListenableBuilder(
                            valueListenable: viewModel.selectedDateListenable,
                            builder: (_, selectedDate, _) =>
                                Text(selectedDate?.toString() ?? 'No date selected'),
                          ),
                        ),
                        PlatformButton(
                          onPressed: viewModel.onShowTimePickerPressed,
                          materialButtonVariant: .text,
                          cupertinoButtonVariant: .tinted,
                          child: ValueListenableBuilder(
                            valueListenable: viewModel.selectedTimeListenable,
                            builder: (_, selectedTime, _) =>
                                Text(selectedTime?.toString() ?? 'No time selected'),
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: viewModel.directionalityListenable,
                      child: const PlatformIcon(PlatformIcons.crop),
                      builder: (context, directionality, leadingIcon) => PlatformMenuPicker(
                        // Replace with `const [...AxisDirection.values, ...AxisDirection.values]` to see the other picker variant
                        items: AxisDirection.values,
                        currentValue: directionality,
                        onSelected: viewModel.onDirectionalityChanged,
                        labelText: 'Menu picker',
                        leadingIcon: leadingIcon,
                        menuPickerItemTransformer: (direction) => MenuPickerItem(
                          label: direction.name,
                          iconData: switch (direction) {
                            AxisDirection.left => Icons.adaptive.arrow_back,
                            AxisDirection.right => Icons.adaptive.arrow_forward,
                            AxisDirection.up => context.platformAdaptiveIcons.arrowUpward,
                            AxisDirection.down => context.platformAdaptiveIcons.arrowDownward,
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const _SectionHeader(title: 'Painting'),
                SliverList.list(
                  children: [
                    const Center(child: PlatformProgressIndicator()),
                    PlatformListTile(
                      title: const Text('List tile'),
                      subtitle: const Text('Subtitle'),
                      color: platformTheme.primaryContrastingColor,
                      leading: Icon(
                        context.platformIcon(
                          material: Icons.list_alt,
                          cupertino: CupertinoIcons.square_list,
                        ),
                      ),
                      trailing: const PlatformIcon(PlatformIcons.forward),
                    ),
                  ],
                ),
                const _SectionHeader(title: 'Interaction'),
                SliverList.list(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: viewModel.checkboxValueListenable,
                      builder: (_, checkboxValue, _) => PlatformCheckbox(
                        value: checkboxValue,
                        tristate: true,
                        onChanged: viewModel.onCheckboxChanged,
                      ),
                    ),
                    PlatformExpansionTile(
                      title: const Text('Expansion tile'),
                      controller: viewModel.expansibleController,
                      cupertinoExpansionTileData: const CupertinoExpansionTileData(
                        transitionMode: .scroll,
                      ),
                      child: const Text('Expansion tile content'),
                    ),
                    ValueListenableBuilder(
                      valueListenable: viewModel.directionalityListenable,
                      builder: (context, directionality, _) =>
                          PlatformRadioGroupBuilder<AxisDirection>(
                            values: AxisDirection.values,
                            groupValue: directionality,
                            onChanged: viewModel.onDirectionalityChanged,
                            itemBuilder: (_, dir) => Row(
                              mainAxisSize: .min,
                              children: [
                                PlatformRadio(
                                  value: dir,
                                  materialRadioData: const MaterialRadioData(
                                    visualDensity: .compact,
                                  ),
                                ),
                                Text(dir.name),
                              ],
                            ),
                          ),
                    ),
                    PlatformSearchBar(
                      hintText: 'Search',
                      controller: viewModel.searchController,
                      onChanged: viewModel.onSearchChanged,
                      onSubmitted: viewModel.onSearchChanged,
                      leading: const Icon(Icons.search),
                    ),
                    SizedBox(
                      height: 120,
                      child: PlatformScrollbar(
                        thumbVisibility: true,
                        controller: viewModel.scrollController,
                        child: ListView.builder(
                          itemCount: 100,
                          // Needed for scrollbar to be visible
                          controller: viewModel.scrollController,
                          itemBuilder: (context, index) => Text('Item $index'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const .symmetric(vertical: 16),
                      child: ValueListenableBuilder(
                        valueListenable: viewModel.directionalityListenable,
                        builder: (_, directionality, _) => PlatformSegmentButton(
                          choices: AxisDirection.values,
                          segmentBuilder: (direction) => Text(direction.name),
                          selectedChoice: directionality,
                          onSelectionChanged: viewModel.onDirectionalityChanged,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: viewModel.sliderValueListenable,
                      builder: (_, sliderValue, _) =>
                          PlatformSlider(value: sliderValue, onChanged: viewModel.onSliderChanged),
                    ),
                    ValueListenableBuilder(
                      valueListenable: viewModel.isSwitchEnabledListenable,
                      builder: (_, isSwitchEnabled, _) => PlatformSwitch(
                        value: isSwitchEnabled,
                        onChanged: viewModel.onSwitchChanged,
                      ),
                    ),
                    PlatformTextField(
                      controller: viewModel.textFieldController,
                      onSubmitted: viewModel.onTextSubmitted,
                      hintText: 'Text field hint',
                      materialTextFieldData: const MaterialTextFieldData(
                        decoration: InputDecoration(labelText: 'Android labelText'),
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

final class HomeViewArgs {
  final bool isUsingGoRouter;

  const HomeViewArgs({this.isUsingGoRouter = false});
}
