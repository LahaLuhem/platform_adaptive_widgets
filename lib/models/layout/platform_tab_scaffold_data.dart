// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoTabController;
import 'package:flutter/material.dart' show TabController;
import 'package:flutter/widgets.dart';

import 'platform_scaffold_data.dart';

final class TabDestinationData {
  final Key? key;
  final Widget inactiveIcon;
  final Widget? activeIcon;
  final Widget? view;

  final String label;
  final String? tooltip;

  //TODO(lahaluhem): account for material's `enabled` property
  const TabDestinationData({
    required this.inactiveIcon,
    this.view,
    this.activeIcon,
    this.label = '',
    this.tooltip,
    this.key,
  });
}

final class MaterialTabScaffoldData extends MaterialScaffoldData {
  final List<TabDestinationData>? tabDestinationsData;
  final TabController? controller;
  final IndexedWidgetBuilder? tabBuilder;

  //TODO(lahaluhem): `bottomSheetScrimBuilder` is missing
  const MaterialTabScaffoldData({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.body,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment = MaterialScaffoldData.kDefaultPersistentFooterAlignment,
    super.persistentFooterDecoration,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomSheet,
    super.primary = MaterialScaffoldData.kPrimary,
    super.drawerDragStartBehavior = MaterialScaffoldData.kDrawerDragStartBehavior,
    super.extendBody = MaterialScaffoldData.kExtendBody,
    super.drawerBarrierDismissible = MaterialScaffoldData.kDrawerBarrierDismissible,
    super.extendBodyBehindAppBar = MaterialScaffoldData.kExtendBodyBehindAppBar,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = MaterialScaffoldData.kDrawerEnableOpenDragGesture,
    super.endDrawerEnableOpenDragGesture = MaterialScaffoldData.kEndDrawerEnableOpenDragGesture,
    super.restorationId,
    this.tabDestinationsData,
    this.controller,
    this.tabBuilder,
  });
}

final class CupertinoTabScaffoldData extends CupertinoScaffoldData {
  final List<TabDestinationData>? tabDestinationsData;
  final CupertinoTabController? controller;
  final IndexedWidgetBuilder? tabBuilder;

  final String? restorationId;

  const CupertinoTabScaffoldData({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.body,
    super.navigationBar,
    this.tabDestinationsData,
    this.controller,
    this.tabBuilder,
    this.restorationId,
  });
}

/// A unified tab controller that works for both Material and Cupertino tabs
/// Simplified version based on CupertinoTabController with essential features
/// Uses WeakReference pattern to avoid memory leaks:
final class PlatformTabController extends ChangeNotifier {
  int _index;
  final List<VoidCallback> _cleanupCallbacks = [];

  PlatformTabController({int initialIndex = 0})
    : _index = initialIndex,
      assert(initialIndex >= 0, 'initialIndex must be greater than or equal to 0');

  int get index => _index;
  set index(int value) {
    assert(value >= 0, 'index must be greater than or equal to 0');
    if (_index == value) return;

    _index = value;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final cleanup in _cleanupCallbacks) {
      cleanup();
    }
    _cleanupCallbacks.clear();

    super.dispose();
  }
}

extension TabControllerExtensions on PlatformTabController {
  /// Creates a Material TabController that follows this platform controller
  @protected
  TabController toMaterialController({required TickerProvider vsync, required int length}) {
    final controller = TabController(initialIndex: index, length: length, vsync: vsync);

    // Create synchronization callback (one-way only)
    void syncToMaterial() {
      if (controller.index != index) controller.index = index;
    }

    addListener(syncToMaterial);

    // Store cleanup callback
    _cleanupCallbacks.add(() {
      removeListener(syncToMaterial);
      controller.dispose();
    });

    return controller;
  }

  /// Creates a CupertinoTabController that follows this platform controller
  @protected
  CupertinoTabController toCupertinoController() {
    final controller = CupertinoTabController(initialIndex: index);

    // Create synchronization callback (one-way only)
    void syncToCupertino() {
      if (controller.index != index) controller.index = index;
    }

    addListener(syncToCupertino);

    _cleanupCallbacks.add(() {
      removeListener(syncToCupertino);
      controller.dispose();
    });

    return controller;
  }
}
