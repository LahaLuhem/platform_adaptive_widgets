import 'dart:async' show FutureOr;

import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoButton,
        CupertinoColors,
        CupertinoIcons,
        CupertinoListTile,
        CupertinoMenuAnchor,
        CupertinoMenuItem,
        CupertinoPicker,
        showCupertinoModalPopup;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show DropdownMenu, DropdownMenuEntry;

import '/src/models/dialogs/platform_menu_picker_data.dart';
import '/src/models/platform_widget_base.dart';

/// Where iOS gives up on a menu and reaches for a wheel instead. Apple's number, see <https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices>.
const kCupertinoMenuPickerSmallItemCountThreshold = 5;

/// Standard 216pt height for the iOS modal-popup wheel ([CupertinoPicker]).
const _kCupertinoPickerModalHeight = 216.0;

/// Standard item extent for the iOS modal-popup wheel.
const _kCupertinoPickerModalItemExtent = 32.0;

/// Material [DropdownMenu] on Android. On iOS it depends on how many items there are: up to [kCupertinoMenuPickerSmallItemCountThreshold]
/// gets a [CupertinoMenuAnchor] whose entries can carry icons, more than that gets a [CupertinoPicker]
/// wheel in a popup, which can't.
///
/// Per-platform tuning lives in [materialMenuPickerData] / [cupertinoMenuPickerData]. Both offer an
/// `.iconButton` constructor that shrinks the whole thing to a button showing just [leadingIcon], with
/// [labelText] going unused.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_menu_picker.dart#platform_menu_picker}
class const PlatformMenuPicker<T extends Object>({
  /// Can't be empty. Apple's guidance puts the practical floor at 3 for the menu variant.
  required final List<T> items,

  /// `null` for nothing selected.
  final T? currentValue,

  final bool isEnabled = true,

  /// Sits before the label, or becomes the whole thing under an `.iconButton` variant.
  final Widget? leadingIcon,

  /// Above the picker on Material, the field title on iOS. Unused by the `.iconButton` variants.
  final String? labelText,

  final ValueChanged<T>? onSelected,
  MenuPickerItem Function(T choice)? menuPickerItemTransformer,

  /// Material-branch overrides.
  final MaterialMenuPickerData? materialMenuPickerData,

  /// Cupertino-branch overrides.
  final CupertinoMenuPickerData? cupertinoMenuPickerData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Turns each item into a [MenuPickerItem]. Left out, items just get `toString()`d.
  // A named param can't be private, so there's no getter to fall back on. Const construction still works.
  // ignore: avoid_field_initializers_in_const_classes
  final MenuPickerItem Function(T choice) menuPickerItemTransformer =
      menuPickerItemTransformer ?? _defaultMenuPickerItemTransformer;

  static MenuPickerItem _defaultMenuPickerItemTransformer<T extends Object>(T choice) =>
      MenuPickerItem(label: choice.toString());

  /// Creates a platform-adaptive menu picker.
  this;

  /// Run once per build and shared across both branches, since an earlier version called the transformer
  /// 3 times over.
  List<MenuPickerItem> _transformedItems() => [
    for (final item in items) menuPickerItemTransformer(item),
  ];

  @override
  Widget buildMaterial(BuildContext context) {
    final transformed = _transformedItems();

    return DropdownMenu<T>(
      expandedInsets: materialMenuPickerData?.expandedInsets,
      showTrailingIcon:
          materialMenuPickerData?.showTrailingIcon ?? kDefaultMaterialMenuPickerShowTrailingIcon,
      inputDecorationTheme: materialMenuPickerData?.inputDecorationThemeData,
      enabled: isEnabled,
      initialSelection: currentValue,
      leadingIcon: leadingIcon,
      enableSearch: false,
      label: labelText == null ? null : Text(labelText!),
      onSelected: switch (onSelected) {
        null => null,
        final callable => (v) {
          if (v != null) callable(v);
        },
      },
      dropdownMenuEntries: [
        for (var i = 0; i < items.length; i++)
          DropdownMenuEntry(
            value: items[i],
            label: transformed[i].label ?? '',
            leadingIcon: transformed[i].iconData == null ? null : Icon(transformed[i].iconData),
          ),
      ],
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final transformed = _transformedItems();
    final useIconButton =
        cupertinoMenuPickerData?.useIconButtonVariant ??
        kDefaultCupertinoMenuPickerUseIconButtonVariant;

    return items.length <= kCupertinoMenuPickerSmallItemCountThreshold
        ? _SmallItemCupertinoPicker(
            items: items,
            transformed: transformed,
            currentValue: currentValue,
            isEnabled: isEnabled,
            useIconButton: useIconButton,
            leadingIcon: leadingIcon,
            labelText: labelText,
            backgroundColor: cupertinoMenuPickerData?.backgroundColor,
            onSelected: onSelected,
          )
        : _LargeItemCupertinoPicker(
            items: items,
            transformed: transformed,
            currentValue: currentValue,
            isEnabled: isEnabled,
            useIconButton: useIconButton,
            leadingIcon: leadingIcon,
            labelText: labelText,
            backgroundColor: cupertinoMenuPickerData?.backgroundColor,
            onSelected: onSelected,
          );
  }
}

/// Cupertino rendering for ≤[kCupertinoMenuPickerSmallItemCountThreshold] items, a [CupertinoMenuAnchor]
/// whose menu shows one [CupertinoMenuItem] per choice (each can carry an icon).
final class const _SmallItemCupertinoPicker<T extends Object>({
  required final List<T> items,
  required final List<MenuPickerItem> transformed,
  required final T? currentValue,
  required final bool isEnabled,
  required final bool useIconButton,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final Color? backgroundColor,
  required final ValueChanged<T>? onSelected,
}) extends StatelessWidget {
  /// Per Apple's HIG, this menu style is intended for **at least 3 items** (the 'Balance menu length
  /// with ease of use' section of <https://developer.apple.com/design/human-interface-guidelines/pull-down-buttons>).
  /// Below that, prefer a different UI element (segmented control, inline radio group, etc.).
  this
    : assert(
        items.length >= 3,
        'Cupertino small-item picker is intended for at least 3 items. '
        'Consider a different UI element for fewer choices.',
      );

  @override
  Widget build(BuildContext context) => CupertinoMenuAnchor(
    builder: (_, controller, _) => _CupertinoPickerField(
      currentValue: currentValue,
      transformed: transformed,
      items: items,
      labelText: labelText,
      leadingIcon: leadingIcon,
      backgroundColor: backgroundColor,
      isEnabled: isEnabled,
      useIconButton: useIconButton,
      onTap: () => controller.open(),
    ),
    menuChildren: [
      for (var i = 0; i < items.length; i++)
        CupertinoMenuItem(
          onPressed: () => onSelected?.call(items[i]),
          leading: transformed[i].iconData == null ? null : Icon(transformed[i].iconData),
          trailing: items[i] != currentValue ? null : const Icon(CupertinoIcons.check_mark),
          child: Text(transformed[i].label ?? ''),
        ),
    ],
  );
}

/// Cupertino rendering for >[kCupertinoMenuPickerSmallItemCountThreshold] items, a tappable field that
/// opens a modal-popup [CupertinoPicker] wheel. Per-item icons aren't supported in this mode (HIG /
/// [CupertinoPicker] constraint).
final class const _LargeItemCupertinoPicker<T extends Object>({
  required final List<T> items,
  required final List<MenuPickerItem> transformed,
  required final T? currentValue,
  required final bool isEnabled,
  required final bool useIconButton,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final Color? backgroundColor,
  required final ValueChanged<T>? onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _CupertinoPickerField(
    currentValue: currentValue,
    transformed: transformed,
    items: items,
    labelText: labelText,
    leadingIcon: leadingIcon,
    backgroundColor: backgroundColor,
    isEnabled: isEnabled,
    useIconButton: useIconButton,
    onTap: () => _showModalPicker(context),
  );

  Future<void> _showModalPicker(BuildContext context) async {
    var highlightedValue = currentValue ?? items.first;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: _kCupertinoPickerModalHeight,
        padding: const EdgeInsets.only(top: 6),
        // Bottom margin aligns the popup above the system navigation bar.
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: _kCupertinoPickerModalItemExtent,
            onSelectedItemChanged: (idx) => highlightedValue = items[idx],
            scrollController: FixedExtentScrollController(
              initialItem: currentValue == null ? 0 : items.indexOf(currentValue!),
            ),
            children: [for (final menuItem in transformed) Text(menuItem.label ?? '')],
          ),
        ),
      ),
    );

    onSelected?.call(highlightedValue);
  }
}

/// The clickable field rendered in the Cupertino branch, either a [CupertinoButton] (icon-button variant)
/// or a [CupertinoListTile] (standard variant) showing the current selection.
final class const _CupertinoPickerField<T extends Object>({
  required final T? currentValue,
  required final List<MenuPickerItem> transformed,
  required final List<T> items,
  required final bool isEnabled,
  required final bool useIconButton,
  final String? labelText,
  // Cupertino accepts only FutureOr<void> for some callback positions.
  // ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap,
  final Color? backgroundColor,
  final Widget? leadingIcon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Look up the currently-selected item's transformed label for the
    // CupertinoListTile.additionalInfo slot. Skip the lookup when there's no
    // current value or the icon-button variant is in use (it doesn't render
    // a label).
    final selectedLabel = currentValue == null
        ? null
        : transformed[items.indexOf(currentValue!)].label;

    if (useIconButton && leadingIcon != null) {
      return CupertinoButton(
        onPressed: onTap,
        sizeStyle: .medium,
        padding: .zero,
        child: leadingIcon!,
      );
    }

    return CupertinoListTile(
      onTap: !isEnabled ? null : onTap,
      title: Text(labelText ?? ''),
      padding: const EdgeInsetsDirectional.only(start: 8, end: 12),
      leadingToTitle: 8,
      additionalInfo: selectedLabel == null ? null : Text(selectedLabel),
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
      leading: leadingIcon,
    );
  }
}
