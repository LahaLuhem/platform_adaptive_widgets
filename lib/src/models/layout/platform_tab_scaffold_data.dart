// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoTabController;
import 'package:flutter/widgets.dart';

import 'platform_scaffold_data.dart';

/// Data for a single destination in a tab-based navigation structure.
final class TabDestination {
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
  /// Creates a [TabDestination].
  const TabDestination({
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
  /// The index of the currently selected tab. Needed when not using a [tabDestinations].view
  /// and the state is managed/rebuilt externally.
  final int selectedIndex;

  /// A list of destinations to display in the tab bar.
  final List<TabDestination>? tabDestinations;

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
    this.tabDestinations,
    this.onTabDestinationTap,
    this.tabBodyBuilder,
  });
}

/// Cupertino-specific data for a tab-based scaffold.
final class CupertinoTabScaffoldData extends CupertinoScaffoldData {
  /// The index of the currently selected tab. Needed when not using a [tabDestinations].view
  /// and the state is managed/rebuilt externally.
  final int selectedIndex;

  /// A list of destinations to display in the tab bar.
  final List<TabDestination>? tabDestinations;

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
    this.tabDestinations,
    this.controller,
    this.tabBodyBuilder,
    this.onTabDestinationTap,
    this.restorationId,
  }) : super(body: null, navigationBar: null);
}
