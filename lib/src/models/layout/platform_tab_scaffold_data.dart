// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoTabController;
import 'package:flutter/material.dart' show TabController;
import 'package:flutter/widgets.dart';

import 'platform_scaffold_data.dart';

/// Data for a single destination in a tab-based navigation structure.
final class TabDestinationData {
  /// An optional key for the destination.
  final Key? key;

  /// The icon to display when the destination is inactive.
  final Widget inactiveIcon;

  /// The icon to display when the destination is active.
  final Widget? activeIcon;

  /// The widget to display as the content for this destination.
  final Widget? view;

  /// A label to display for the destination.
  final String label;

  /// A tooltip to display for the destination.
  final String? tooltip;

  //TODO(lahaluhem): account for material's `enabled` property
  /// Creates a [TabDestinationData].
  const TabDestinationData({
    required this.inactiveIcon,
    this.view,
    this.activeIcon,
    this.label = '',
    this.tooltip,
    this.key,
  });
}

/// Material-specific data for a tab-based scaffold.
final class MaterialTabScaffoldData extends MaterialScaffoldData {
  /// The index of the currently selected tab. Needed when not using a [tabDestinationsData].view
  /// and the state is managed/rebuilt externally.
  final int selectedIndex;

  /// A list of destinations to display in the tab bar.
  final List<TabDestinationData>? tabDestinationsData;

  /// A controller for the tab bar.
  final TabController? controller;

  /// A callback that is called when a tab destination is tapped.
  final ValueChanged<int>? onTabDestinationTap;

  /// A builder for the content of each tab.
  final IndexedWidgetBuilder? tabBodyBuilder;

  //TODO(lahaluhem): `bottomSheetScrimBuilder` is missing
  /// Creates a [MaterialTabScaffoldData].
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
    this.selectedIndex = 0,
    this.tabDestinationsData,
    this.controller,
    this.onTabDestinationTap,
    this.tabBodyBuilder,
  });
}

/// Cupertino-specific data for a tab-based scaffold.
final class CupertinoTabScaffoldData extends CupertinoScaffoldData {
  /// The index of the currently selected tab. Needed when not using a [tabDestinationsData].view
  /// and the state is managed/rebuilt externally.
  final int selectedIndex;

  /// A list of destinations to display in the tab bar.
  final List<TabDestinationData>? tabDestinationsData;

  /// A controller for the tab bar.
  final CupertinoTabController? controller;

  /// A builder for the content of each tab.
  final IndexedWidgetBuilder? tabBodyBuilder;

  /// A callback that is called when a tab destination is tapped.
  final ValueChanged<int>? onTabDestinationTap;

  /// A restoration ID for the tab scaffold.
  final String? restorationId;

  /// Creates a [CupertinoTabScaffoldData].
  const CupertinoTabScaffoldData({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    this.selectedIndex = 0,
    this.tabDestinationsData,
    this.controller,
    this.tabBodyBuilder,
    this.onTabDestinationTap,
    this.restorationId,
  }) : super(body: null, navigationBar: null);
}

/// A unified tab controller that works for both Material and Cupertino tabs
/// Simplified version based on CupertinoTabController with essential features
/// Uses WeakReference pattern to avoid memory leaks:
final class PlatformTabController extends ChangeNotifier {
  int _index;
  final List<VoidCallback> _cleanupCallbacks = [];

  /// Creates a [PlatformTabController].
  PlatformTabController({int initialIndex = 0})
    : _index = initialIndex,
      assert(initialIndex >= 0, 'initialIndex must be greater than or equal to 0');

  /// The index of the currently selected tab.
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

/// An extension on [PlatformTabController] to create platform-specific controllers.
@protected
extension TabControllerExtensions on PlatformTabController {
  /// Creates a Material [TabController] that follows this platform controller.
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

  /// Creates a Cupertino [CupertinoTabController] that follows this platform controller.
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
