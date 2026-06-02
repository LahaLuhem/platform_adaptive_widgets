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

/// Threshold above which Cupertino switches from
/// [CupertinoMenuAnchor]/[CupertinoMenuItem] (good for ≤5 short items) to a
/// modal-popup [CupertinoPicker] wheel (better for medium-to-long lists). Per
/// Apple's HIG picker best-practices: <https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices>.
const kCupertinoMenuPickerSmallItemCountThreshold = 5;

/// Standard 216pt height for the iOS modal-popup wheel ([CupertinoPicker]).
const _kCupertinoPickerModalHeight = 216.0;

/// Standard item extent for the iOS modal-popup wheel.
const _kCupertinoPickerModalItemExtent = 32.0;

/// A platform-adaptive picker widget that renders Material [DropdownMenu] on
/// Android and one of two Cupertino styles on iOS depending on item count:
/// - ≤[kCupertinoMenuPickerSmallItemCountThreshold] items →
///   [CupertinoMenuAnchor] + [CupertinoMenuItem] (each entry can carry an
///   icon).
/// - More items → a modal-popup [CupertinoPicker] wheel (text-only, no
///   per-item icons — see [MenuPickerItem]'s class-level note).
///
/// Per-platform tuning is opt-in via [materialMenuPickerData] /
/// [cupertinoMenuPickerData]. Both data classes provide an `.iconButton`
/// named ctor for the compact icon-button rendering — the widget's
/// [leadingIcon] becomes the button's content; `labelText` is ignored.
///
/// Example:
/// ```dart
/// PlatformMenuPicker<String>(
///   items: const ['Day', 'Week', 'Month'],
///   currentValue: _view,
///   labelText: 'View',
///   onSelected: (v) => setState(() => _view = v),
///   menuPickerItemTransformer: (v) => MenuPickerItem(label: v),
/// )
/// ```
class PlatformMenuPicker<T extends Object> extends PlatformWidgetKeyedBase {
  /// Items shown in the picker. Must be non-empty; for the Cupertino
  /// small-item variant, three is the practical minimum (HIG guideline).
  final List<T> items;

  /// Currently-selected value. `null` means no selection.
  final T? currentValue;

  /// Whether the picker is enabled and tappable.
  final bool isEnabled;

  /// Icon shown before the picker's label (or as the icon-button's content in
  /// the `.iconButton` data-class variants).
  final Widget? leadingIcon;

  /// Label text shown above the picker (Material) or as the field title
  /// (Cupertino standard variant). Ignored by the `.iconButton` variants.
  final String? labelText;

  /// Callback fired when the user picks an item.
  final ValueChanged<T>? onSelected;

  /// Transforms each item value into a [MenuPickerItem] describing how it
  /// renders. Defaults to `MenuPickerItem(label: choice.toString())`.
  final MenuPickerItem Function(T choice) menuPickerItemTransformer;

  /// Material-only configuration. Optional.
  final MaterialMenuPickerData? materialMenuPickerData;

  /// Cupertino-only configuration. Optional.
  final CupertinoMenuPickerData? cupertinoMenuPickerData;

  /// Default transformer — calls `toString()` on the choice.
  static MenuPickerItem _defaultMenuPickerItemTransformer<T extends Object>(T choice) =>
      MenuPickerItem(label: choice.toString());

  /// Creates a platform-adaptive menu picker.
  const PlatformMenuPicker({
    required this.items,
    this.currentValue,
    this.isEnabled = true,
    this.leadingIcon,
    this.labelText,
    this.onSelected,
    MenuPickerItem Function(T choice)? menuPickerItemTransformer,
    this.materialMenuPickerData,
    this.cupertinoMenuPickerData,
    super.widgetKey,
    super.key,
  }) : menuPickerItemTransformer = menuPickerItemTransformer ?? _defaultMenuPickerItemTransformer;

  /// Transformed-item list for this build — computed once and shared across
  /// the Material and Cupertino branches (avoids the v1 issue of invoking the
  /// transformer 3+ times per build).
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

/// Cupertino rendering for ≤[kCupertinoMenuPickerSmallItemCountThreshold]
/// items — a [CupertinoMenuAnchor] whose menu shows one [CupertinoMenuItem]
/// per choice (each can carry an icon).
final class _SmallItemCupertinoPicker<T extends Object> extends StatelessWidget {
  final List<T> items;
  final List<MenuPickerItem> transformed;
  final T? currentValue;
  final bool isEnabled;
  final bool useIconButton;
  final Widget? leadingIcon;
  final String? labelText;
  final Color? backgroundColor;
  final ValueChanged<T>? onSelected;

  /// Per Apple's HIG, this menu style is intended for **at least 3 items**
  /// (the 'Balance menu length with ease of use' section of
  /// <https://developer.apple.com/design/human-interface-guidelines/pull-down-buttons>).
  /// Below that, prefer a different UI element (segmented control,
  /// inline radio group, etc.).
  const _SmallItemCupertinoPicker({
    required this.items,
    required this.transformed,
    required this.currentValue,
    required this.isEnabled,
    required this.useIconButton,
    required this.leadingIcon,
    required this.labelText,
    required this.backgroundColor,
    required this.onSelected,
  }) : assert(
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

/// Cupertino rendering for >[kCupertinoMenuPickerSmallItemCountThreshold]
/// items — a tappable field that opens a modal-popup [CupertinoPicker] wheel.
/// Per-item icons aren't supported in this mode (HIG / [CupertinoPicker]
/// constraint).
final class _LargeItemCupertinoPicker<T extends Object> extends StatelessWidget {
  final List<T> items;
  final List<MenuPickerItem> transformed;
  final T? currentValue;
  final bool isEnabled;
  final bool useIconButton;
  final Widget? leadingIcon;
  final String? labelText;
  final Color? backgroundColor;
  final ValueChanged<T>? onSelected;

  const _LargeItemCupertinoPicker({
    required this.items,
    required this.transformed,
    required this.currentValue,
    required this.isEnabled,
    required this.useIconButton,
    required this.leadingIcon,
    required this.labelText,
    required this.backgroundColor,
    required this.onSelected,
  });

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

/// The clickable field rendered in the Cupertino branch — either a
/// [CupertinoButton] (icon-button variant) or a [CupertinoListTile] (standard
/// variant) showing the current selection.
final class _CupertinoPickerField<T extends Object> extends StatelessWidget {
  final T? currentValue;
  final List<MenuPickerItem> transformed;
  final List<T> items;
  final bool isEnabled;
  final bool useIconButton;
  final String? labelText;

  // Cupertino accepts only FutureOr<void> for some callback positions.
  // ignore: avoid_futureor_void
  final FutureOr<void> Function()? onTap;
  final Color? backgroundColor;
  final Widget? leadingIcon;

  const _CupertinoPickerField({
    required this.currentValue,
    required this.transformed,
    required this.items,
    required this.isEnabled,
    required this.useIconButton,
    this.labelText,
    this.onTap,
    this.backgroundColor,
    this.leadingIcon,
  });

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
