import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show FloatingActionButton, Icons, InputDecoration;
import 'package:flutter/widgets.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 16,
                      children: [
                        GestureDetector(
                          onTap: viewModel.onShowGeneralDialogPressed,
                          child: const Text('Show general dialog', maxLines: 2),
                        ),
                      ].map((button) => Flexible(child: button)).toList(growable: false),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: viewModel.onShowGeneralBottomSheetPressed,
                        child: const Text('Show general bottom sheet', maxLines: 2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 16,
                      children: [
                        GestureDetector(
                          onTap: viewModel.onShowDatePickerPressed,
                          child: ValueListenableBuilder(
                            valueListenable: viewModel.selectedDateListenable,
                            builder: (_, selectedDate, _) =>
                                Text(selectedDate?.toString() ?? 'No date selected'),
                          ),
                        ),
                        GestureDetector(
                          onTap: viewModel.onShowTimePickerPressed,
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
                      builder: (context, directionality, _) => PlatformMenuPicker(
                        items: AxisDirection.values,
                        currentValue: directionality,
                        labelText: 'Menu picker',
                        leadingIcon: const PlatformIcon(PlatformIcons.crop),
                        valueTransformer: (direction) => direction.name,
                        onSelected: viewModel.onDirectionalityChanged,
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
                        platformCheckboxData: PlatformCheckboxData(
                          value: checkboxValue,
                          tristate: true,
                          onChanged: viewModel.onCheckboxChanged,
                        ),
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
                      builder: (context, directionality, _) => PlatformRadioGroup<AxisDirection>(
                        materialRadioData: const MaterialRadioData(visualDensity: .compact),
                        platformRadioGroupData: PlatformRadioGroupData(
                          groupValue: directionality,
                          groupValues: AxisDirection.values,
                          groupBuilder: (directionsAndButtons) => Row(
                            spacing: 16,
                            mainAxisAlignment: .center,
                            children: [
                              for (final directionAndButton in directionsAndButtons)
                                Row(
                                  mainAxisSize: .min,
                                  children: [
                                    directionAndButton.button,
                                    Text(directionAndButton.value.name),
                                  ],
                                ),
                            ],
                          ),
                          onChanged: viewModel.onDirectionalityChanged,
                        ),
                      ),
                    ),
                    PlatformSearchBar(
                      platformSearchBarData: PlatformSearchBarData(
                        hintText: 'Search',
                        controller: viewModel.searchController,
                        onSubmitted: viewModel.onSearchChanged,
                      ),
                      materialSearchBarData: const MaterialSearchBarData(
                        leading: Icon(Icons.search),
                      ),
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
                    PlatformTextField(
                      platformTextFieldData: PlatformTextFieldData(
                        controller: viewModel.textFieldController,
                        onSubmitted: viewModel.onTextSubmitted,
                      ),
                      materialTextFieldData: const MaterialTextFieldData(
                        decoration: InputDecoration(labelText: 'Text field hint'),
                      ),
                      cupertinoTextFieldData: const CupertinoTextFieldData(
                        placeholder: 'Text field hint',
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
