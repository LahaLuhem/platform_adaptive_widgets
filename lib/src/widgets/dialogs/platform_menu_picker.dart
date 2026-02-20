import 'dart:async' show FutureOr;

import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoButton,
        CupertinoColors,
        CupertinoIcons,
        CupertinoListTile,
        CupertinoPicker,
        showCupertinoModalPopup;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show DropdownMenu, DropdownMenuEntry;
import 'package:pull_down_button/pull_down_button.dart';

import '/src/models/dialogs/platform_menu_picker_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive menu picker that renders Material DropdownMenu on Android
/// and CupertinoPicker with CupertinoListTile on iOS.
///
/// This widget automatically selects the appropriate menu picker implementation based on the target platform:
/// - On Android: renders Material Design DropdownMenu
/// - On iOS: depends on the number of items (see https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices).
///     - For 5 or less, it uses PullDownButton.
///     - For more, it uses showCupertinoModalPopup.
///
/// The menu picker can be configured with platform-specific data through [materialMenuPickerData]
/// and [cupertinoMenuPickerData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformMenuPicker<String>(
///   items: ['Option 1', 'Option 2', 'Option 3'],
///   currentValue: _selectedOption,
///   onSelected: (value) => setState(() => _selectedOption = value),
///   labelText: 'Choose an option',
/// )
/// ```
class PlatformMenuPicker<T extends Object> extends PlatformWidgetKeyedBase {
  /// The list of items to display in the menu.
  final Iterable<T> items;

  /// The currently selected value.
  final T? currentValue;

  /// Whether the menu picker is enabled and interactive.
  final bool isEnabled;

  /// Icon to display before the menu items.
  final Widget? leadingIcon;

  /// Label text to display above the menu items.
  final String? labelText;

  /// Callback when an item is selected.
  final ValueChanged<T>? onSelected;

  /// Function to transform the selected value to a [MenuPickerItem] representation.
  final MenuPickerItem<T> Function(T choice) menuPickerItemTransformer;

  /// Material-specific menu picker data.
  final MaterialMenuPickerData? materialMenuPickerData;

  /// Cupertino-specific menu picker data.
  final CupertinoMenuPickerData? cupertinoMenuPickerData;

  /// Default transformer that converts choices to strings.
  static MenuPickerItem<T> _defaultMenuPickerItemTransformer<T extends Object>(T choice) =>
      MenuPickerItem(label: choice.toString());

  /// Creates a platform-adaptive menu picker.
  ///
  /// The menu picker will render as a Material DropdownMenu on Android and a CupertinoPicker on iOS.
  const PlatformMenuPicker({
    required this.items,
    this.currentValue,
    this.isEnabled = true,
    this.leadingIcon,
    this.labelText,
    this.onSelected,
    MenuPickerItem<T> Function(T choice)? menuPickerItemTransformer,
    this.materialMenuPickerData,
    this.cupertinoMenuPickerData,
    super.widgetKey,
    super.key,
  }) : menuPickerItemTransformer = menuPickerItemTransformer ?? _defaultMenuPickerItemTransformer;

  @override
  Widget buildMaterial(BuildContext context) => DropdownMenu(
    expandedInsets: materialMenuPickerData?.expandedInsets,
    showTrailingIcon:
        materialMenuPickerData?.showTrailingIcon ?? MaterialMenuPickerData.kDefaultShowTrailingIcon,
    inputDecorationTheme: materialMenuPickerData?.inputDecorationThemeData,
    enabled: isEnabled,
    initialSelection: currentValue,
    leadingIcon: leadingIcon,
    enableSearch: false,
    label: labelText == null ? null : Text(labelText!),
    onSelected: (newValue) => newValue == null ? null : onSelected?.call(newValue),
    dropdownMenuEntries: [
      for (final valuesAndMenuPickerItems in _Pair.zip(
        items.toList(growable: false),
        items.map(menuPickerItemTransformer).toList(growable: false),
      ))
        DropdownMenuEntry(
          value: valuesAndMenuPickerItems.a,
          label: valuesAndMenuPickerItems.b.label ?? '',
          leadingIcon: valuesAndMenuPickerItems.b.iconData == null
              ? null
              : Icon(valuesAndMenuPickerItems.b.iconData),
        ),
    ],
  );

  @override
  Widget buildCupertino(BuildContext context) => _CupertinoPickerCommon<T>(
    items: items,
    currentValue: currentValue,
    isEnabled: isEnabled,
    useIconButtonVariant:
        cupertinoMenuPickerData?.useIconButtonVariant ??
        CupertinoMenuPickerData.kDefaultUseIconButtonVariant,
    leadingIcon: leadingIcon,
    labelText: labelText,
    cupertinoBackgroundColor: cupertinoMenuPickerData?.backgroundColor,
    menuPickerItemTransformer: menuPickerItemTransformer,
    onSelected: onSelected,
  );
}

final class _CupertinoPickerCommon<T extends Object> extends StatelessWidget {
  final Iterable<T> items;
  final T? currentValue;
  final bool isEnabled;
  final bool useIconButtonVariant;
  final Widget? leadingIcon;
  final String? labelText;
  final Color? cupertinoBackgroundColor;
  final MenuPickerItem<T> Function(T choice) menuPickerItemTransformer;
  final ValueChanged<T>? onSelected;

  static const _smallItemCountThreshold = 5;

  const _CupertinoPickerCommon({
    required this.items,
    required this.currentValue,
    required this.isEnabled,
    required this.useIconButtonVariant,
    required this.leadingIcon,
    required this.labelText,
    required this.cupertinoBackgroundColor,
    required this.onSelected,
    required this.menuPickerItemTransformer,
  });

  @override
  Widget build(BuildContext context) => items.length <= _smallItemCountThreshold
      ? _SmallItemCupertinoPicker(
          items: items,
          currentValue: currentValue,
          isEnabled: isEnabled,
          useIconButtonVariant: useIconButtonVariant,
          leadingIcon: leadingIcon,
          labelText: labelText,
          cupertinoBackgroundColor: cupertinoBackgroundColor,
          menuPickerItemTransformer: menuPickerItemTransformer,
          onSelected: onSelected,
        )
      : _LargeItemCupertinoPicker(
          items: items.toList(growable: false),
          currentValue: currentValue,
          isEnabled: isEnabled,
          useIconButtonVariant: useIconButtonVariant,
          leadingIcon: leadingIcon,
          labelText: labelText,
          cupertinoBackgroundColor: cupertinoBackgroundColor,
          menuPickerItemTransformer: menuPickerItemTransformer,
          onSelected: onSelected,
        );
}

final class _SmallItemCupertinoPicker<T extends Object> extends StatelessWidget {
  final Iterable<T> items;
  final T? currentValue;
  final bool isEnabled;
  final bool useIconButtonVariant;
  final Widget? leadingIcon;
  final String? labelText;
  final Color? cupertinoBackgroundColor;
  final MenuPickerItem<T> Function(T choice) menuPickerItemTransformer;
  final ValueChanged<T>? onSelected;

  const _SmallItemCupertinoPicker({
    required this.items,
    required this.currentValue,
    required this.isEnabled,
    required this.useIconButtonVariant,
    required this.leadingIcon,
    required this.labelText,
    required this.cupertinoBackgroundColor,
    required this.menuPickerItemTransformer,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => PullDownButton(
    buttonBuilder: (context, showMenu) => _CupertinoPickerField(
      value: currentValue,
      menuPickerItemTransformer: menuPickerItemTransformer,
      labelText: labelText,
      leading: leadingIcon,
      backgroundColor: cupertinoBackgroundColor,
      isEnabled: isEnabled,
      useIconButtonVariant: useIconButtonVariant,
      onTap: showMenu,
    ),
    itemBuilder: (context) => [
      for (final valuesAndMenuPickerItems in _Pair.zip(
        items.toList(growable: false),
        items.map(menuPickerItemTransformer).toList(growable: false),
      ))
        PullDownMenuItem.selectable(
          onTap: () => onSelected?.call(valuesAndMenuPickerItems.a),
          selected: valuesAndMenuPickerItems.a == currentValue,
          title: valuesAndMenuPickerItems.b.label ?? '',
          icon: valuesAndMenuPickerItems.b.iconData,
        ),
    ],
  );
}

final class _LargeItemCupertinoPicker<T extends Object> extends StatelessWidget {
  final List<T> items;
  final T? currentValue;
  final bool isEnabled;
  final bool useIconButtonVariant;

  final Widget? leadingIcon;
  final String? labelText;
  final Color? cupertinoBackgroundColor;

  final MenuPickerItem<T> Function(T choice) menuPickerItemTransformer;
  final ValueChanged<T>? onSelected;

  const _LargeItemCupertinoPicker({
    required this.items,
    required this.currentValue,
    required this.isEnabled,
    required this.useIconButtonVariant,
    required this.leadingIcon,
    required this.labelText,
    required this.cupertinoBackgroundColor,
    required this.menuPickerItemTransformer,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => _CupertinoPickerField(
    value: currentValue,
    menuPickerItemTransformer: menuPickerItemTransformer,
    labelText: labelText,
    leading: leadingIcon,
    backgroundColor: cupertinoBackgroundColor,
    isEnabled: isEnabled,
    useIconButtonVariant: useIconButtonVariant,
    onTap: () => _showModalPicker(context),
  );

  Future<void> _showModalPicker(BuildContext context) async {
    var highlightedValue = items.first;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const .only(top: 6),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (valueIndex) => highlightedValue = items[valueIndex],
            scrollController: FixedExtentScrollController(
              initialItem: currentValue == null ? 0 : items.indexOf(currentValue!),
            ),
            children: [
              for (final menuPickerItem in items.map(menuPickerItemTransformer))
                Text(menuPickerItem.label ?? ''),
            ],
          ),
        ),
      ),
    );

    onSelected?.call(highlightedValue);
  }
}

final class _CupertinoPickerField<T extends Object> extends StatelessWidget {
  final T? value;
  final MenuPickerItem<T> Function(T choice) menuPickerItemTransformer;
  final bool isEnabled;
  final bool useIconButtonVariant;
  final String? labelText;

  // Library accepts only that
  //ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap;
  final Color? backgroundColor;
  final Widget? leading;

  const _CupertinoPickerField({
    required this.value,
    required this.menuPickerItemTransformer,
    required this.isEnabled,
    required this.useIconButtonVariant,
    this.labelText,
    this.onTap,
    this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final menuPickerItemForAdditionalInfo = value == null
        ? null
        : menuPickerItemTransformer.call(value!);

    return useIconButtonVariant && leading != null
        ? CupertinoButton(onPressed: onTap, sizeStyle: .medium, padding: .zero, child: leading!)
        : CupertinoListTile(
            onTap: !isEnabled ? null : onTap,
            title: Text(labelText ?? ''),
            padding: const .only(left: 8, right: 12),
            leadingToTitle: 8,
            additionalInfo: menuPickerItemForAdditionalInfo?.label == null
                ? null
                : Text(menuPickerItemForAdditionalInfo!.label!),
            trailing: IconTheme(
              data: IconThemeData(color: isEnabled ? null : CupertinoColors.inactiveGray),
              child: const Column(
                mainAxisSize: .min,
                children: [
                  Icon(CupertinoIcons.chevron_up, size: 12),
                  Icon(CupertinoIcons.chevron_down, size: 12),
                ],
              ),
            ),
            backgroundColor: backgroundColor,
            leading: leading,
          );
  }
}

final class _Pair<A, B> {
  const _Pair(this.a, this.b);

  final A a;

  final B b;

  /// Zips up the given Iterables for parallel iteration, and yielding
  /// Only to be used when the lengths of the data-sources do not change after creation, because 'lazy'
  static Iterable<_Pair<A, B>> zip<A, B>(List<A> listA, List<B> listB) sync* {
    assert(listA.length == listB.length, 'For zipping, lengths of the lists must match');
    for (var i = 0; i < listA.length; i++) {
      yield _Pair(listA[i], listB[i]);
    }
  }
}
