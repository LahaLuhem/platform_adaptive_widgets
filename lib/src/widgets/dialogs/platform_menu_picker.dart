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
import '/src/widgets/interaction/disabled_semantics.dart';

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
  Widget buildMaterial(BuildContext context) => _MaterialMenuPicker(
    menuPickerItems: _menuPickerItems(),
    selectedIndex: _selectedIndex(),
    isEnabled: _canOpen,
    leadingIcon: leadingIcon,
    labelText: labelText,
    onPicked: _onPicked,
    data: materialMenuPickerData,
  );

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) => _CupertinoMenuPicker(
    pickerSnapshot: (
      menuPickerItems: _menuPickerItems(),
      selectedIndex: _selectedIndex(),
      onPicked: _onPicked,
    ),
    isEnabled: _canOpen,
    useIconButton:
        cupertinoMenuPickerData?.useIconButtonVariant ??
        kDefaultCupertinoMenuPickerUseIconButtonVariant,
    leadingIcon: leadingIcon,
    labelText: labelText,
    backgroundColor: cupertinoMenuPickerData?.backgroundColor,
  );

  List<MenuPickerItem> _menuPickerItems() =>
      items.map(menuPickerItemTransformer).toList(growable: false);

  void _onPicked(int rowIndex) => onSelected?.call(items[rowIndex]);

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
final class const _MaterialMenuPicker({
  required final List<MenuPickerItem> menuPickerItems,
  required final int? selectedIndex,
  required final bool isEnabled,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final ValueChanged<int> onPicked,
  required final MaterialMenuPickerData? data,
}) extends StatefulWidget {
  @override
  State<_MaterialMenuPicker> createState() => _MaterialMenuPickerState();
}

final class _MaterialMenuPickerState() extends State<_MaterialMenuPicker> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _selectedLabel());
  }

  @override
  void didUpdateWidget(_MaterialMenuPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    _showSelected();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DropdownMenu<int>(
    controller: _controller,
    expandedInsets: widget.data?.expandedInsets,
    showTrailingIcon: widget.data?.showTrailingIcon ?? kDefaultMaterialMenuPickerShowTrailingIcon,
    inputDecorationTheme: widget.data?.inputDecorationThemeData,
    enabled: widget.isEnabled,
    leadingIcon: widget.leadingIcon,
    label: widget.labelText == null ? null : Text(widget.labelText!),
    // No typing, which DropdownMenu allows on desktop.
    selectOnly: true,
    // Opens on the current row. The default matches labels, and two rows can share one.
    searchCallback: (_, _) => widget.selectedIndex,
    onSelected: _onSelected,
    dropdownMenuEntries: List.generate(
      widget.menuPickerItems.length,
      (index) => DropdownMenuEntry(
        value: index,
        label: widget.menuPickerItems[index].label ?? '',
        leadingIcon: widget.menuPickerItems[index].iconData == null
            ? null
            : Icon(widget.menuPickerItems[index].iconData),
      ),
      growable: false,
    ),
  );

  void _onSelected(int? rowIndex) {
    // Re-picking the current value changes nothing.
    if (rowIndex != null && rowIndex != widget.selectedIndex) widget.onPicked(rowIndex);
    // The dropdown writes the pick into the field by itself. Put the app's value back, so only the
    // app moves it.
    _showSelected();
  }

  void _showSelected() {
    final label = _selectedLabel();
    if (_controller.text != label) _controller.text = label;
  }

  String _selectedLabel() {
    final selectedIndex = widget.selectedIndex;
    if (selectedIndex == null) return '';

    return widget.menuPickerItems[selectedIndex].label ?? '';
  }
}

final class const _CupertinoMenuPicker({
  required final _PickerSnapshot pickerSnapshot,
  required final bool isEnabled,
  required final bool useIconButton,
  required final Widget? leadingIcon,
  required final String? labelText,
  required final Color? backgroundColor,
}) extends StatefulWidget {
  @override
  State<_CupertinoMenuPicker> createState() => _CupertinoMenuPickerState();
}

/// One State behind the 3 looks, so a wheel or page open in its own route keeps up with the app,
/// whatever the count does.
final class _CupertinoMenuPickerState() extends State<_CupertinoMenuPicker> {
  final _menuController = MenuController();
  late final ValueNotifier<_PickerSnapshot> _pickerSnapshotNotifier;

  // An open menu stays a menu when the count grows past its range, so it doesn't vanish mid-pick.
  bool get _showsMenu =>
      _menuController.isOpen ||
      widget.pickerSnapshot.menuPickerItems.length <= kCupertinoMenuPickerSmallItemCountThreshold;

  @override
  void initState() {
    super.initState();

    _pickerSnapshotNotifier = ValueNotifier(widget.pickerSnapshot);
  }

  @override
  void didUpdateWidget(_CupertinoMenuPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    _pickerSnapshotNotifier.value = widget.pickerSnapshot;
  }

  @override
  void dispose() {
    _pickerSnapshotNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.pickerSnapshot;
    final field = _CupertinoPickerField(
      selectedIndex: snapshot.selectedIndex,
      menuPickerItems: snapshot.menuPickerItems,
      labelText: widget.labelText,
      leadingIcon: widget.leadingIcon,
      backgroundColor: widget.backgroundColor,
      isEnabled: widget.isEnabled,
      useIconButton: widget.useIconButton,
      onTap: _open,
    );
    if (!_showsMenu) return field;

    return CupertinoMenuAnchor(
      controller: _menuController,
      menuChildren: List.generate(
        snapshot.menuPickerItems.length,
        (index) => CupertinoMenuItem(
          // Not null for the current row, which would grey it out. A tap on it only closes the menu.
          onPressed: () {
            if (index != snapshot.selectedIndex) snapshot.onPicked(index);
          },
          // iOS's slots. Only the trailing one hides at accessibility text sizes, so the checkmark leads.
          leading: index != snapshot.selectedIndex ? null : const Icon(CupertinoIcons.check_mark),
          trailing: snapshot.menuPickerItems[index].iconData == null
              ? null
              : Icon(snapshot.menuPickerItems[index].iconData),
          child: Text(snapshot.menuPickerItems[index].label ?? ''),
        ),
        growable: false,
      ),
      child: field,
    );
  }

  Future<void> _open() async => switch (widget.pickerSnapshot.menuPickerItems.length) {
    _ when _showsMenu => _menuController.open(),
    <= kCupertinoMenuPickerLargeItemCountThreshold => await _openWheel(),
    _ => await _openPage(),
  };

  Future<void> _openWheel() => showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => _PickerSnapshotBuilder(
      pickerSnapshotListenable: _pickerSnapshotNotifier,
      builder: (snapshot, catchUp) => _CupertinoWheelPopup(snapshot: snapshot, catchUp: catchUp),
    ),
  );

  Future<void> _openPage() async {
    final listScrollController = ScrollController();
    final firstRow = GlobalKey();
    // Opens on the current row once the page has laid out. Every row is as tall as the first, which
    // says where the current one sits, and stopping at the list's end keeps it from bouncing back.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rowHeight = firstRow.currentContext?.size?.height;
      if (rowHeight != null && listScrollController.hasClients) {
        listScrollController.jumpTo(
          min(
            (widget.pickerSnapshot.selectedIndex ?? 0) * rowHeight,
            listScrollController.position.maxScrollExtent,
          ),
        );
      }
    });

    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (context) => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: widget.labelText == null ? null : Text(widget.labelText!),
          ),
          child: _PickerSnapshotBuilder(
            pickerSnapshotListenable: _pickerSnapshotNotifier,
            builder: (snapshot, _) => ListView.builder(
              controller: listScrollController,
              itemCount: snapshot.menuPickerItems.length,
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
                  label: snapshot.menuPickerItems[index].label ?? '',
                  iconData: snapshot.menuPickerItems[index].iconData,
                  isPicked: index == snapshot.selectedIndex,
                  onTap: () {
                    Navigator.of(context).pop();
                    if (index != snapshot.selectedIndex) snapshot.onPicked(index);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    listScrollController.dispose();
  }
}

/// Builds an open wheel or page from the picker's latest snapshot. The picker can't rebuild another
/// route in the middle of its own build, so this one catches up right after.
final class const _PickerSnapshotBuilder({
  required final ValueListenable<_PickerSnapshot> pickerSnapshotListenable,
  required final Widget Function(_PickerSnapshot pickerSnapshot, VoidCallback catchUp) builder,
}) extends StatefulWidget {
  @override
  State<_PickerSnapshotBuilder> createState() => _PickerSnapshotBuilderState();
}

final class _PickerSnapshotBuilderState() extends State<_PickerSnapshotBuilder> {
  late _PickerSnapshot _shownPickerSnapshot;

  @override
  void initState() {
    super.initState();

    _shownPickerSnapshot = widget.pickerSnapshotListenable.value;
    widget.pickerSnapshotListenable.addListener(_catchUp);
  }

  @override
  void dispose() {
    widget.pickerSnapshotListenable.removeListener(_catchUp);

    super.dispose();
  }

  void _catchUp() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) setState(() => _shownPickerSnapshot = widget.pickerSnapshotListenable.value);
  });

  @override
  Widget build(BuildContext context) => widget.builder(_shownPickerSnapshot, _catchUp);
}

/// Always shows the app's value, like SwiftUI's wheel.
final class const _CupertinoWheelPopup({
  required final _PickerSnapshot snapshot,
  required final VoidCallback catchUp,
}) extends StatefulWidget {
  @override
  State<_CupertinoWheelPopup> createState() => _CupertinoWheelPopupState();
}

final class _CupertinoWheelPopupState() extends State<_CupertinoWheelPopup> {
  late final FixedExtentScrollController _wheelScrollController;

  // Moving to the app's value isn't a pick.
  var _isFollowing = false;

  @override
  void initState() {
    super.initState();

    // With nothing picked the wheel shows the top row.
    _wheelScrollController = FixedExtentScrollController(
      initialItem: widget.snapshot.selectedIndex ?? 0,
    );
  }

  @override
  void didUpdateWidget(_CupertinoWheelPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    // After layout, so the wheel scrolls through the new rows, not the old ones.
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_follow()));
  }

  @override
  void dispose() {
    _wheelScrollController.dispose();

    super.dispose();
  }

  Future<void> _follow() async {
    final rowIndex = widget.snapshot.selectedIndex ?? 0;
    if (!mounted || _wheelScrollController.selectedItem == rowIndex) return;

    _isFollowing = true;
    await _wheelScrollController.animateToItem(
      rowIndex,
      duration: _kCupertinoPickerFollowDuration,
      curve: Curves.easeInOut,
    );
    _isFollowing = false;
  }

  // Not onSelectedItemChanged, which skips the row the wheel opened on. With nothing picked, that row
  // is still a pick.
  void _onStopped(ScrollEndNotification notification) {
    final rowIndex = (notification.metrics as FixedExtentMetrics).itemIndex;
    if (_isFollowing || rowIndex == widget.snapshot.selectedIndex) return;

    widget.snapshot.onPicked(rowIndex);
    // An app that doesn't take the pick keeps its value, and the wheel goes back to it.
    widget.catchUp();
  }

  @override
  Widget build(BuildContext context) => Container(
    height: _kCupertinoPickerModalHeight,
    padding: const .only(top: 6),
    // Keeps the wheel above the keyboard, if one's up.
    margin: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    color: CupertinoColors.systemBackground.resolveFrom(context),
    child: SafeArea(
      top: false,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _onStopped(notification);

          return false;
        },
        child: CupertinoPicker(
          itemExtent: _kCupertinoPickerModalItemExtent,
          scrollController: _wheelScrollController,
          onSelectedItemChanged: null,
          children: [
            for (final item in widget.snapshot.menuPickerItems)
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

/// What each Cupertino look shows until tapped: a row with the current value, or only the icon.
final class const _CupertinoPickerField({
  required final int? selectedIndex,
  required final List<MenuPickerItem> menuPickerItems,
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
    final selectedLabel = selectedIndex == null ? null : menuPickerItems[selectedIndex!].label;

    if (useIconButton && leadingIcon != null) {
      return DisabledSemantics(
        isEnabled: isEnabled,
        child: CupertinoButton(
          onPressed: !isEnabled ? null : onTap,
          sizeStyle: .medium,
          padding: .zero,
          child: leadingIcon!,
        ),
      );
    }

    return DisabledSemantics(
      isEnabled: isEnabled,
      child: CupertinoListTile(
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
      ),
    );
  }
}

/// What an open look draws from, in one piece, so the rows it shows and the pick it reports always
/// come from the same build.
typedef _PickerSnapshot = ({
  List<MenuPickerItem> menuPickerItems,
  int? selectedIndex,
  ValueChanged<int> onPicked,
});
