import 'dart:async' show FutureOr;

import 'package:flutter/cupertino.dart'
    show
        CupertinoColors,
        CupertinoIcons,
        CupertinoListTile,
        CupertinoPicker,
        showCupertinoModalPopup;
import 'package:flutter/material.dart' show DropdownMenu, DropdownMenuEntry;
import 'package:flutter/widgets.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '/models/dialogs/platform_menu_picker_data.dart';
import '/models/platform_widget_base.dart';

class PlatformMenuPicker<T extends Object> extends PlatformWidgetKeyedBase {
  final Iterable<T> items;
  final T? currentValue;

  final bool isEnabled;
  final Widget? leadingIcon;
  final String? labelText;

  final ValueChanged<T>? onSelected;
  final String Function(T choice) valueTransformer;

  final MaterialMenuPickerData? materialMenuPickerData;
  final CupertinoMenuPickerData? cupertinoMenuPickerData;

  static String _defaultTransformer<T>(T choice) => choice.toString();

  const PlatformMenuPicker({
    required this.items,
    this.currentValue,
    this.isEnabled = true,
    this.leadingIcon,
    this.labelText,
    this.onSelected,
    String Function(T choice)? valueTransformer,
    this.materialMenuPickerData,
    this.cupertinoMenuPickerData,
    super.widgetKey,
    super.key,
  }) : valueTransformer = valueTransformer ?? _defaultTransformer;

  @override
  Widget buildMaterial(BuildContext context) => DropdownMenu(
    expandedInsets: materialMenuPickerData?.expandedInsets,
    enabled: isEnabled,
    initialSelection: currentValue,
    leadingIcon: leadingIcon,
    enableSearch: false,
    label: labelText == null ? null : Text(labelText!),
    onSelected: (newValue) => newValue == null ? null : onSelected?.call(newValue),
    dropdownMenuEntries: [
      for (final item in items) DropdownMenuEntry(value: item, label: valueTransformer.call(item)),
    ],
  );

  @override
  Widget buildCupertino(BuildContext context) => _CupertinoPickerCommon<T>(
    items: items,
    currentValue: currentValue,
    isEnabled: isEnabled,
    leadingIcon: leadingIcon,
    labelText: labelText,
    cupertinoBackgroundColor: cupertinoMenuPickerData?.backgroundColor,
    valueTransformer: valueTransformer,
    onSelected: onSelected,
  );
}

final class _CupertinoPickerCommon<T> extends StatelessWidget {
  final Iterable<T> items;
  final T? currentValue;
  final bool isEnabled;
  final Widget? leadingIcon;
  final String? labelText;
  final Color? cupertinoBackgroundColor;
  final String Function(T choice) valueTransformer;
  final ValueChanged<T>? onSelected;

  static const _smallItemCountThreshold = 5;

  const _CupertinoPickerCommon({
    required this.items,
    required this.currentValue,
    required this.isEnabled,
    required this.leadingIcon,
    required this.labelText,
    required this.cupertinoBackgroundColor,
    required this.onSelected,
    required this.valueTransformer,
  });

  @override
  Widget build(BuildContext context) => items.length <= _smallItemCountThreshold
      ? _SmallItemCupertinoPicker(
          items: items,
          currentValue: currentValue,
          isEnabled: isEnabled,
          leadingIcon: leadingIcon,
          labelText: labelText,
          cupertinoBackgroundColor: cupertinoBackgroundColor,
          valueTransformer: valueTransformer,
          onSelected: onSelected,
        )
      : _LargeItemCupertinoPicker(
          items: items.toList(growable: false),
          currentValue: currentValue,
          isEnabled: isEnabled,
          leadingIcon: leadingIcon,
          labelText: labelText,
          cupertinoBackgroundColor: cupertinoBackgroundColor,
          valueTransformer: valueTransformer,
          onSelected: onSelected,
        );
}

final class _CupertinoPickerField<T> extends StatelessWidget {
  final T? value;
  final String Function(T choice) valueTransformer;
  final bool isEnabled;
  final String? labelText;

  // Library accepts only that
  //ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap;
  final Color? backgroundColor;
  final Widget? leading;

  const _CupertinoPickerField({
    required this.value,
    required this.valueTransformer,
    required this.isEnabled,
    this.labelText,
    this.onTap,
    this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) => CupertinoListTile(
    onTap: !isEnabled ? null : onTap,
    title: Text(labelText ?? ''),
    padding: const .only(left: 8, right: 12),
    leadingToTitle: 8,
    additionalInfo: value == null ? null : Text(valueTransformer.call(value as T)),
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

final class _SmallItemCupertinoPicker<T> extends StatelessWidget {
  final Iterable<T> items;
  final T? currentValue;
  final bool isEnabled;
  final Widget? leadingIcon;
  final String? labelText;
  final Color? cupertinoBackgroundColor;
  final String Function(T choice) valueTransformer;
  final ValueChanged<T>? onSelected;

  const _SmallItemCupertinoPicker({
    required this.items,
    required this.currentValue,
    required this.isEnabled,
    required this.leadingIcon,
    required this.labelText,
    required this.cupertinoBackgroundColor,
    required this.valueTransformer,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => PullDownButton(
    buttonBuilder: (context, showMenu) => _CupertinoPickerField(
      value: currentValue,
      valueTransformer: valueTransformer,
      labelText: labelText,
      leading: leadingIcon,
      backgroundColor: cupertinoBackgroundColor,
      isEnabled: isEnabled,
      onTap: showMenu,
    ),
    itemBuilder: (context) => [
      for (final item in items)
        PullDownMenuItem.selectable(
          onTap: () => onSelected?.call(item),
          selected: item == currentValue,
          title: valueTransformer.call(item),
        ),
    ],
  );
}

final class _LargeItemCupertinoPicker<T> extends StatelessWidget {
  final List<T> items;
  final T? currentValue;
  final bool isEnabled;

  final Widget? leadingIcon;
  final String? labelText;
  final Color? cupertinoBackgroundColor;

  final String Function(T choice) valueTransformer;
  final ValueChanged<T>? onSelected;

  const _LargeItemCupertinoPicker({
    required this.items,
    required this.currentValue,
    required this.isEnabled,
    required this.leadingIcon,
    required this.labelText,
    required this.cupertinoBackgroundColor,
    required this.valueTransformer,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => _CupertinoPickerField(
    value: currentValue,
    valueTransformer: valueTransformer,
    labelText: labelText,
    leading: leadingIcon,
    backgroundColor: cupertinoBackgroundColor,
    isEnabled: isEnabled,
    onTap: () => _showModalPicker(context),
  );

  Future<void> _showModalPicker(BuildContext context) async {
    var highlightedValue = items.first;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (valueIndex) => highlightedValue = items[valueIndex],
            scrollController: FixedExtentScrollController(
              initialItem: currentValue == null ? 0 : items.indexOf(currentValue as T),
            ),
            children: [for (final item in items) Center(child: Text(valueTransformer.call(item)))],
          ),
        ),
      ),
    );

    onSelected?.call(highlightedValue);
  }
}
