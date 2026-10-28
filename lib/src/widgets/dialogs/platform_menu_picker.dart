import 'dart:async' show FutureOr, unawaited;
import 'dart:math' show min;

import 'package:cupertino_ui/cupertino_ui.dart'
    show
        CupertinoButton,
        CupertinoColors,
        CupertinoIcons,
        CupertinoListTile,
        CupertinoMenuAnchor,
        CupertinoMenuItem,
        CupertinoNavigationBar,
        CupertinoPageRoute,
        CupertinoPageScaffold,
        CupertinoPicker,
        showCupertinoModalPopup;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show DropdownMenu, DropdownMenuEntry;

import '/src/models/dialogs/platform_menu_picker_data.dart';
import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/cupertino_checkmark_row.dart';

/// Cupertino shows a menu up to this many items, and a wheel past it. The number is ours, not Apple's.
/// A wheel shows about 5 rows
/// ([2019 HIG](https://web.archive.org/web/20190609215648/https://developer.apple.com/design/human-interface-guidelines/ios/controls/pickers/)),
/// so a shorter list gains nothing from one.
const kCupertinoMenuPickerSmallItemCountThreshold = 5;

/// Past this many items Cupertino gives the list its own page instead of a wheel. Also ours: Apple's
/// biggest wheel example, a list of countries, is about this long
/// ([HIG pickers](https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices)).
const kCupertinoMenuPickerLargeItemCountThreshold = 250;

/// iOS's own wheel height.
const _kCupertinoPickerModalHeight = 216.0;

/// iOS's own row height on a wheel.
const _kCupertinoPickerModalItemExtent = 32.0;

/// As long as the wheel takes to scroll to a tapped row.
const _kCupertinoPickerFollowDuration = Duration(milliseconds: 300);

/// [DropdownMenu] on Material. On Cupertino it depends on how many items there are:
///
/// - up to [kCupertinoMenuPickerSmallItemCountThreshold], a [CupertinoMenuAnchor]
/// - up to [kCupertinoMenuPickerLargeItemCountThreshold], a [CupertinoPicker] wheel in a popup
/// - past that, a page of their own, like a list in iOS Settings
///
/// Both data records have an `.iconButton` constructor that shrinks the picker to its [leadingIcon].
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

  /// Cupertino's wheel calls this each time it stops on a row other than [currentValue], while it's still
  /// open. It goes back to [currentValue] if the app doesn't take the pick.
  final ValueChanged<T>? onSelected,
  MenuPickerItem Function(T choice)? menuPickerItemTransformer,

  final MaterialMenuPickerData? materialMenuPickerData,
  final CupertinoMenuPickerData? cupertinoMenuPickerData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Turns each item into a [MenuPickerItem]. Left out, items get `toString()`d.
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

    return switch (items.length) {
      <= kCupertinoMenuPickerSmallItemCountThreshold => _CupertinoPickerMenu(
        items: items,
        transformed: transformed,
        selectedIndex: selectedIndex,
        isEnabled: _canOpen,
        useIconButton: useIconButton,
        leadingIcon: leadingIcon,
        labelText: labelText,
        backgroundColor: cupertinoMenuPickerData?.backgroundColor,
        onSelected: onSelected,
      ),
      <= kCupertinoMenuPickerLargeItemCountThreshold => _CupertinoPickerWheel(
        items: items,
        transformed: transformed,
        selectedIndex: selectedIndex,
        isEnabled: _canOpen,
        useIconButton: useIconButton,
        leadingIcon: leadingIcon,
        labelText: labelText,
        backgroundColor: cupertinoMenuPickerData?.backgroundColor,
        onSelected: onSelected,
      ),
      _ => _CupertinoPickerPage(
        items: items,
        transformed: transformed,
        selectedIndex: selectedIndex,
        isEnabled: _canOpen,
        useIconButton: useIconButton,
        leadingIcon: leadingIcon,
        labelText: labelText,
        backgroundColor: cupertinoMenuPickerData?.backgroundColor,
        onSelected: onSelected,
      ),
    };
  }

  List<MenuPickerItem> _transformedItems() =>
      items.map(menuPickerItemTransformer).toList(growable: false);

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
  late final TextEditingController _controller;

  String get _selectedLabel {
    final selectedIndex = widget.selectedIndex;
    if (selectedIndex == null) return '';

    return widget.transformed[selectedIndex].label ?? '';
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _selectedLabel);
  }

  @override
  void didUpdateWidget(_MaterialMenuPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _showSelected();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _showSelected() {
    final label = _selectedLabel;
    if (_controller.text != label) _controller.text = label;
  }

  @override
  Widget build(BuildContext context) => DropdownMenu<T>(
    controller: _controller,
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
      // Re-picking the current value changes nothing.
      if (value != null && widget.items.indexOf(value) != widget.selectedIndex) {
        widget.onSelected?.call(value);
      }
      // The dropdown writes the pick into the field by itself. Put the app's value back, so only the
      // app moves it.
      _showSelected();
    },
    dropdownMenuEntries: List.generate(
      widget.items.length,
      (index) => DropdownMenuEntry(
        value: widget.items[index],
        label: widget.transformed[index].label ?? '',
        leadingIcon: widget.transformed[index].iconData == null
            ? null
            : Icon(widget.transformed[index].iconData),
      ),
      growable: false,
    ),
  );
}

/// Up to [kCupertinoMenuPickerSmallItemCountThreshold] items, a [CupertinoMenuAnchor] whose menu shows
/// one [CupertinoMenuItem] per choice.
final class const _CupertinoPickerMenu<T extends Object>({
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
    menuChildren: List.generate(
      items.length,
      (index) => CupertinoMenuItem(
        // Not null for the current row, which would grey it out. A tap on it only closes the menu.
        onPressed: () {
          if (index != selectedIndex) onSelected?.call(items[index]);
        },
        // iOS's slots. Only the trailing one hides at accessibility text sizes, so the checkmark leads.
        leading: index != selectedIndex ? null : const Icon(CupertinoIcons.check_mark),
        trailing: transformed[index].iconData == null ? null : Icon(transformed[index].iconData),
        child: Text(transformed[index].label ?? ''),
      ),
      growable: false,
    ),
  );
}

/// Up to [kCupertinoMenuPickerLargeItemCountThreshold] items, a field that opens a [CupertinoPicker]
/// wheel in a popup.
final class const _CupertinoPickerWheel<T extends Object>({
  required final List<T> items,
  required final List<MenuPickerItem> transformed,
  required final int? selectedIndex,
  required final bool isEnabled,
  required final bool useIconButton,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final Color? backgroundColor,
  required final ValueChanged<T>? onSelected,
}) extends StatefulWidget {
  @override
  State<_CupertinoPickerWheel<T>> createState() => _CupertinoPickerWheelState<T>();
}

/// Hands the app's value to the open wheel, which the field's rebuilds don't reach.
final class _CupertinoPickerWheelState<T extends Object>() extends State<_CupertinoPickerWheel<T>> {
  late final ValueNotifier<int?> _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = ValueNotifier(widget.selectedIndex);
  }

  @override
  void didUpdateWidget(_CupertinoPickerWheel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectedIndex.value = widget.selectedIndex;
  }

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _CupertinoPickerField(
    selectedIndex: widget.selectedIndex,
    transformed: widget.transformed,
    labelText: widget.labelText,
    leadingIcon: widget.leadingIcon,
    backgroundColor: widget.backgroundColor,
    isEnabled: widget.isEnabled,
    useIconButton: widget.useIconButton,
    onTap: () => showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => _CupertinoWheelPopup(
        transformed: widget.transformed,
        selectedIndex: _selectedIndex,
        onStopped: (index) => widget.onSelected?.call(widget.items[index]),
      ),
    ),
  );
}

/// Always shows the app's value, like SwiftUI's wheel.
final class const _CupertinoWheelPopup({
  required final List<MenuPickerItem> transformed,
  required final ValueListenable<int?> selectedIndex,
  required final ValueChanged<int> onStopped,
}) extends StatefulWidget {
  @override
  State<_CupertinoWheelPopup> createState() => _CupertinoWheelPopupState();
}

final class _CupertinoWheelPopupState() extends State<_CupertinoWheelPopup> {
  late final FixedExtentScrollController _wheel;

  // Moving to the app's value isn't a pick.
  var _isFollowing = false;

  @override
  void initState() {
    super.initState();

    // With nothing picked the wheel shows the top row.
    _wheel = FixedExtentScrollController(initialItem: widget.selectedIndex.value ?? 0);
    widget.selectedIndex.addListener(_followAfterFrame);
  }

  @override
  void dispose() {
    widget.selectedIndex.removeListener(_followAfterFrame);
    _wheel.dispose();

    super.dispose();
  }

  // The app's value changes while the app builds, so the wheel moves once that's done.
  void _followAfterFrame() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_follow()));

  Future<void> _follow() async {
    final row = widget.selectedIndex.value ?? 0;
    if (!mounted || _wheel.selectedItem == row) return;

    _isFollowing = true;
    await _wheel.animateToItem(
      row,
      duration: _kCupertinoPickerFollowDuration,
      curve: Curves.easeInOut,
    );
    _isFollowing = false;
  }

  // Not onSelectedItemChanged, which skips the row the wheel opened on. With nothing picked, that row is
  // still a pick.
  bool _onStop(ScrollEndNotification notification) {
    final row = (notification.metrics as FixedExtentMetrics).itemIndex;
    if (!_isFollowing && row != widget.selectedIndex.value) {
      widget.onStopped(row);
      // An app that doesn't take the pick keeps its value, and the wheel goes back to it.
      _followAfterFrame();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) => Container(
    height: _kCupertinoPickerModalHeight,
    padding: const EdgeInsets.only(top: 6),
    // Keeps the wheel above the keyboard, if one's up.
    margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    color: CupertinoColors.systemBackground.resolveFrom(context),
    child: SafeArea(
      top: false,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: _onStop,
        child: CupertinoPicker(
          itemExtent: _kCupertinoPickerModalItemExtent,
          scrollController: _wheel,
          onSelectedItemChanged: null,
          children: [
            for (final item in widget.transformed)
              Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [if (item.iconData != null) Icon(item.iconData), Text(item.label ?? '')],
              ),
          ],
        ),
      ),
    ),
  );
}

/// Past [kCupertinoMenuPickerLargeItemCountThreshold] items, a field that pushes a page listing them all.
final class const _CupertinoPickerPage<T extends Object>({
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
    onTap: () => _onTap(context),
  );

  Future<void> _onTap(BuildContext context) async {
    final listScrollController = ScrollController();
    final firstRow = GlobalKey();
    // Opens on the current row once the page has laid out. Every row is as tall as the first, which
    // says where the current one sits, and stopping at the list's end keeps it from bouncing back.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rowHeight = firstRow.currentContext?.size?.height;
      if (rowHeight != null && listScrollController.hasClients) {
        listScrollController.jumpTo(
          min((selectedIndex ?? 0) * rowHeight, listScrollController.position.maxScrollExtent),
        );
      }
    });

    final picked = await Navigator.of(context).push(
      CupertinoPageRoute<int>(
        builder: (context) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: labelText == null ? null : Text(labelText!),
          ),
          child: ListView.builder(
            controller: listScrollController,
            itemCount: items.length,
            itemBuilder: (context, index) => DecoratedBox(
              key: index != 0 ? null : firstRow,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0,
                  ),
                ),
              ),
              child: CupertinoCheckmarkRow(
                label: transformed[index].label ?? '',
                iconData: transformed[index].iconData,
                isPicked: index == selectedIndex,
                onTap: () => Navigator.of(context).pop(index),
              ),
            ),
          ),
        ),
      ),
    );
    listScrollController.dispose();

    if (picked != null && picked != selectedIndex) onSelected?.call(items[picked]);
  }
}

/// What each Cupertino look shows until tapped: a row with the current value, or only the icon.
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
