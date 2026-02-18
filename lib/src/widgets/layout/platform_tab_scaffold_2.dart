import 'package:flutter/cupertino.dart'
    show CupertinoTabBar, CupertinoTabScaffold, CupertinoTabView;
import 'package:flutter/material.dart' show NavigationBar, NavigationDestination, Scaffold;
import 'package:flutter/widgets.dart';

import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/layout/platform_tab_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive tab scaffold
class PlatformTabScaffold2 extends PlatformWidgetKeyedBase {
  /// The index of the currently selected tab. Needed when not using a [tabDestinationsData].view
  /// and the state is managed/rebuilt externally.
  final int selectedIndex;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should resize to avoid the bottom inset.
  final bool resizeToAvoidBottomInset;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// A list of destinations to display in the tab bar.
  final List<TabDestinationData>? tabDestinationsData;

  /// A controller for the tab bar.
  final PlatformTabController? controller;

  /// A callback that is called when a tab destination is tapped.
  final ValueChanged<int>? onTabDestinationTap;

  /// A builder for the content of each tab.
  final IndexedWidgetBuilder? tabBuilder;

  /// Material-specific data for the tab scaffold.
  final MaterialTabScaffoldData? materialTabScaffoldData;

  /// Cupertino-specific data for the tab scaffold.
  final CupertinoTabScaffoldData? cupertinoTabScaffoldData;

  /// Creates a platform-adaptive tab scaffold.
  ///
  /// [tabBuilder] is central to determining how state is managed. When it is provided, it is assumed that the state is managed externally
  /// ([tabDestinationsData].view is ignored/not needed in this case).
  /// When it is not provided, it is assumed that the state is managed internally and [tabDestinationsData].view is used to build the tab content.
  ///
  /// Cupertino already has [CupertinoTabView] that makes it trivial to be able to handle state internally.
  /// That is used when [tabDestinationsData].view is provided.
  ///
  /// Material revolves around using a `selectedIndex`
  const PlatformTabScaffold2({
    this.selectedIndex = 0,
    this.tabDestinationsData,
    this.controller,
    this.onTabDestinationTap,
    this.tabBuilder,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
    this.restorationId,
    this.materialTabScaffoldData,
    this.cupertinoTabScaffoldData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    final selectedIndex = materialTabScaffoldData?.selectedIndex ?? this.selectedIndex;
    final resolvedTabBuilder = materialTabScaffoldData?.tabBuilder ?? tabBuilder;
    final resolvedTabDestinations =
        materialTabScaffoldData?.tabDestinationsData ?? tabDestinationsData!;

    assert(
      (resolvedTabBuilder != null) ^
          (resolvedTabDestinations.every((tabDest) => tabDest.view != null)),
      'Either provide a tabBuilder or a view for each tab destination.',
    );

    return Scaffold(
      key: materialTabScaffoldData?.widgetKey ?? widgetKey,
      backgroundColor: materialTabScaffoldData?.backgroundColor ?? backgroundColor,
      resizeToAvoidBottomInset:
          materialTabScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
      floatingActionButton: materialTabScaffoldData?.floatingActionButton,
      floatingActionButtonLocation: materialTabScaffoldData?.floatingActionButtonLocation,
      floatingActionButtonAnimator: materialTabScaffoldData?.floatingActionButtonAnimator,
      persistentFooterButtons: materialTabScaffoldData?.persistentFooterButtons,
      persistentFooterAlignment:
          materialTabScaffoldData?.persistentFooterAlignment ??
          MaterialScaffoldData.kDefaultPersistentFooterAlignment,
      persistentFooterDecoration: materialTabScaffoldData?.persistentFooterDecoration,
      drawer: materialTabScaffoldData?.drawer,
      onDrawerChanged: materialTabScaffoldData?.onDrawerChanged,
      endDrawer: materialTabScaffoldData?.endDrawer,
      onEndDrawerChanged: materialTabScaffoldData?.onEndDrawerChanged,
      bottomSheet: materialTabScaffoldData?.bottomSheet,
      primary: materialTabScaffoldData?.primary ?? MaterialScaffoldData.kPrimary,
      drawerDragStartBehavior:
          materialTabScaffoldData?.drawerDragStartBehavior ??
          MaterialScaffoldData.kDrawerDragStartBehavior,
      extendBody: materialTabScaffoldData?.extendBody ?? MaterialScaffoldData.kExtendBody,
      drawerBarrierDismissible:
          materialTabScaffoldData?.drawerBarrierDismissible ??
          MaterialScaffoldData.kDrawerBarrierDismissible,
      extendBodyBehindAppBar:
          materialTabScaffoldData?.extendBodyBehindAppBar ??
          MaterialScaffoldData.kExtendBodyBehindAppBar,
      drawerScrimColor: materialTabScaffoldData?.drawerScrimColor,
      bottomSheetScrimBuilder:
          materialTabScaffoldData?.bottomSheetScrimBuilder ??
          MaterialScaffoldData.kDefaultBottomSheetScrimBuilder,
      drawerEdgeDragWidth: materialTabScaffoldData?.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture:
          materialTabScaffoldData?.drawerEnableOpenDragGesture ??
          MaterialScaffoldData.kDrawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture:
          materialTabScaffoldData?.endDrawerEnableOpenDragGesture ??
          MaterialScaffoldData.kEndDrawerEnableOpenDragGesture,
      restorationId: materialTabScaffoldData?.restorationId ?? restorationId,
      //TODO(lahaluhem): Wrap conditionally with `ListenableBuilder` when `resolvedTabBuilder` is not provided => state must be internally managed
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: materialTabScaffoldData?.onTabDestinationTap ?? onTabDestinationTap,
        destinations: [
          for (final tabDestinationData in resolvedTabDestinations)
            NavigationDestination(
              icon: tabDestinationData.inactiveIcon,
              selectedIcon: tabDestinationData.activeIcon,
              label: tabDestinationData.label,
              tooltip: tabDestinationData.tooltip,
            ),
        ],
      ),
      body:
          resolvedTabBuilder?.call(context, selectedIndex) ??
          resolvedTabDestinations[selectedIndex].view!,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedTabDestinations =
        cupertinoTabScaffoldData?.tabDestinationsData ?? tabDestinationsData!;
    final resolvedTabBuilder = cupertinoTabScaffoldData?.tabBuilder ?? tabBuilder;

    assert(
      (resolvedTabBuilder != null) ^
          (resolvedTabDestinations.every((tabDest) => tabDest.view != null)),
      'Either provide a tabBuilder or a view for each tab destination.',
    );

    return CupertinoTabScaffold(
      key: cupertinoTabScaffoldData?.widgetKey ?? widgetKey,
      backgroundColor: cupertinoTabScaffoldData?.backgroundColor ?? backgroundColor,
      resizeToAvoidBottomInset:
          cupertinoTabScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
      restorationId: cupertinoTabScaffoldData?.restorationId ?? restorationId,
      controller: cupertinoTabScaffoldData?.controller,
      tabBar: CupertinoTabBar(
        currentIndex: cupertinoTabScaffoldData?.selectedIndex ?? selectedIndex,
        onTap: cupertinoTabScaffoldData?.onTabDestinationTap ?? onTabDestinationTap,
        items: [
          for (final tabDestinationData in resolvedTabDestinations)
            BottomNavigationBarItem(
              icon: tabDestinationData.inactiveIcon,
              activeIcon: tabDestinationData.activeIcon,
              label: tabDestinationData.label,
              tooltip: tabDestinationData.tooltip,
            ),
        ],
      ),
      tabBuilder: (context, index) =>
          resolvedTabBuilder?.call(context, index) ??
          CupertinoTabView(builder: (_) => resolvedTabDestinations[index].view!),
    );
  }
}
