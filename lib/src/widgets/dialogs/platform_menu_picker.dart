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
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show DropdownMenu, DropdownMenuEntry;

import '/src/models/dialogs/platform_menu_picker_data.dart';
import '/src/models/platform_widget_base.dart';

/// Up to this many items Cupertino shows a menu, and past it a wheel. Apple gives no number, so this
/// one is the package's own: a wheel is about 5 rows tall
/// ([2019 HIG](https://web.archive.org/web/20190609215648/https://developer.apple.com/design/human-interface-guidelines/ios/controls/pickers/)),
/// so a list that short gains nothing from one.
const kCupertinoMenuPickerSmallItemCountThreshold = 5;

/// Standard 216pt height for the Cupertino modal-popup wheel ([CupertinoPicker]).
const _kCupertinoPickerModalHeight = 216.0;

/// Standard item extent for the Cupertino modal-popup wheel.
const _kCupertinoPickerModalItemExtent = 32.0;

/// [DropdownMenu] on Material. On Cupertino it depends on how many items there are: up to
/// [kCupertinoMenuPickerSmallItemCountThreshold] get a [CupertinoMenuAnchor], more than that get a
/// [CupertinoPicker] wheel in a popup.
///
/// Per-platform tuning lives in [materialMenuPickerData] / [cupertinoMenuPickerData]. Both offer an
/// `.iconButton` constructor that shrinks the whole thing to a button showing just [leadingIcon], with
/// [labelText] going unused.
///
/// Guidelines: [M3 menus](https://m3.material.io/components/menus/guidelines),
/// [HIG pickers](https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_menu_picker.dart#platform_menu_picker}
class const PlatformMenuPicker<T extends Object>({
  /// An empty list shows the picker disabled.
  required final List<T> items,

  /// `null`, or a value missing from [items], shows nothing picked.
  final T? currentValue,

  final bool isEnabled = true,

  /// Sits before the label, or becomes the whole thing under an `.iconButton` variant.
  final Widget? leadingIcon,

  /// Above the picker on Material, the field title on Cupertino. Unused by the `.iconButton` variants.
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

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) => _MaterialMenuPicker<T>(
    items: items,
    transformed: _transformedItems(),
    selectedIndex: _selectedIndex(),
    isEnabled: _canOpen,
    leadingIcon: leadingIcon,
    labelText: labelText,
    onSelected: onSelected,
    data: materialMenuPickerData,
  );

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    final transformed = _transformedItems();
    final selectedIndex = _selectedIndex();
    final useIconButton =
        cupertinoMenuPickerData?.useIconButtonVariant ??
        kDefaultCupertinoMenuPickerUseIconButtonVariant;

    return items.length <= kCupertinoMenuPickerSmallItemCountThreshold
        ? _SmallItemCupertinoPicker(
            items: items,
            transformed: transformed,
            selectedIndex: selectedIndex,
            isEnabled: _canOpen,
            useIconButton: useIconButton,
            leadingIcon: leadingIcon,
            labelText: labelText,
            backgroundColor: cupertinoMenuPickerData?.backgroundColor,
            onSelected: onSelected,
          )
        : _LargeItemCupertinoPicker(
            items: items,
            transformed: transformed,
            selectedIndex: selectedIndex,
            isEnabled: _canOpen,
            useIconButton: useIconButton,
            leadingIcon: leadingIcon,
            labelText: labelText,
            backgroundColor: cupertinoMenuPickerData?.backgroundColor,
            onSelected: onSelected,
          );
  }

  /// Run once per build and shared across both branches, since an earlier version called the transformer
  /// 3 times over.
  List<MenuPickerItem> _transformedItems() => [
    for (final item in items) menuPickerItemTransformer(item),
  ];

  // An empty list shows as disabled on both, instead of opening on nothing.
  bool get _canOpen => isEnabled && items.isNotEmpty;

  // A value missing from the list counts as nothing picked.
  int? _selectedIndex() {
    final currentVal = currentValue;
    if (currentVal == null) return null;

    final index = items.indexOf(currentVal);

    return index == -1 ? null : index;
  }
}

/// Owns the field's text, since [DropdownMenu] keeps an old label when the value goes null, leaves the
/// list or gets renamed.
final class const _MaterialMenuPicker<T extends Object>({
  required final List<T> items,
  required final List<MenuPickerItem> transformed,
  required final int? selectedIndex,
  required final bool isEnabled,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final ValueChanged<T>? onSelected,
  required final MaterialMenuPickerData? data,
}) extends StatefulWidget {
  @override
  State<_MaterialMenuPicker<T>> createState() => _MaterialMenuPickerState<T>();
}

final class _MaterialMenuPickerState<T extends Object>() extends State<_MaterialMenuPicker<T>> {
  late final TextEditingController _text;

  String get _selectedLabel {
    final selectedIndex = widget.selectedIndex;
    if (selectedIndex == null) return '';

    return widget.transformed[selectedIndex].label ?? '';
  }

  @override
  void initState() {
    super.initState();

    _text = TextEditingController(text: _selectedLabel);
  }

  @override
  void didUpdateWidget(_MaterialMenuPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _showSelected();
  }

  @override
  void dispose() {
    _text.dispose();

    super.dispose();
  }

  void _showSelected() {
    final label = _selectedLabel;
    if (_text.text != label) _text.text = label;
  }

  @override
  Widget build(BuildContext context) => DropdownMenu<T>(
    controller: _text,
    expandedInsets: widget.data?.expandedInsets,
    showTrailingIcon: widget.data?.showTrailingIcon ?? kDefaultMaterialMenuPickerShowTrailingIcon,
    inputDecorationTheme: widget.data?.inputDecorationThemeData,
    enabled: widget.isEnabled,
    leadingIcon: widget.leadingIcon,
    label: widget.labelText == null ? null : Text(widget.labelText!),
    // No typing, which DropdownMenu allows on desktop.
    selectOnly: true,
    // Finds the open row by value. The default matches labels, and two rows can share one.
    searchCallback: (_, _) => widget.selectedIndex,
    onSelected: (value) {
      if (value != null) widget.onSelected?.call(value);
      // The dropdown writes the picked label in by itself. Undo that, so the field only moves when
      // the app hands over a new value.
      _showSelected();
    },
    dropdownMenuEntries: [
      for (var i = 0; i < widget.items.length; i++)
        DropdownMenuEntry(
          value: widget.items[i],
          label: widget.transformed[i].label ?? '',
          leadingIcon: widget.transformed[i].iconData == null
              ? null
              : Icon(widget.transformed[i].iconData),
        ),
    ],
  );
}

/// Cupertino rendering for ≤[kCupertinoMenuPickerSmallItemCountThreshold] items, a [CupertinoMenuAnchor]
/// whose menu shows one [CupertinoMenuItem] per choice (each can carry an icon).
final class const _SmallItemCupertinoPicker<T extends Object>({
  required final List<T> items,
  required final List<MenuPickerItem> transformed,
  required final int? selectedIndex,
  required final bool isEnabled,
  required final bool useIconButton,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final Color? backgroundColor,
  required final ValueChanged<T>? onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoMenuAnchor(
    builder: (_, controller, _) => _CupertinoPickerField(
      selectedIndex: selectedIndex,
      transformed: transformed,
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
          trailing: i == selectedIndex ? const Icon(CupertinoIcons.check_mark) : null,
          child: Text(transformed[i].label ?? ''),
        ),
    ],
  );
}

/// Cupertino rendering for >[kCupertinoMenuPickerSmallItemCountThreshold] items, a tappable field that
/// opens a modal-popup [CupertinoPicker] wheel.
final class const _LargeItemCupertinoPicker<T extends Object>({
  required final List<T> items,
  required final List<MenuPickerItem> transformed,
  required final int? selectedIndex,
  required final bool isEnabled,
  required final bool useIconButton,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final Color? backgroundColor,
  required final ValueChanged<T>? onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _CupertinoPickerField(
    selectedIndex: selectedIndex,
    transformed: transformed,
    labelText: labelText,
    leadingIcon: leadingIcon,
    backgroundColor: backgroundColor,
    isEnabled: isEnabled,
    useIconButton: useIconButton,
    onTap: () async {
      // With nothing picked the wheel starts at the top, and closing it picks that row.
      var shown = selectedIndex ?? 0;
      // Made outside the builder, so there's one to dispose once the wheel closes.
      final wheel = FixedExtentScrollController(initialItem: shown);

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
              scrollController: wheel,
              onSelectedItemChanged: (index) => shown = index,
              children: [
                for (final item in transformed)
                  Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      if (item.iconData != null) Icon(item.iconData),
                      Text(item.label ?? ''),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
      wheel.dispose();

      if (shown != selectedIndex) onSelected?.call(items[shown]);
    },
  );
}

/// The clickable field rendered in the Cupertino branch, either a [CupertinoButton] (icon-button variant)
/// or a [CupertinoListTile] (standard variant) showing the current selection.
final class const _CupertinoPickerField({
  required final int? selectedIndex,
  required final List<MenuPickerItem> transformed,
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
    final selectedLabel = selectedIndex == null ? null : transformed[selectedIndex!].label;

    if (useIconButton && leadingIcon != null) {
      return CupertinoButton(
        onPressed: isEnabled ? onTap : null,
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
