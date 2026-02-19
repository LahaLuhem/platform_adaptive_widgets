import 'package:flutter/cupertino.dart'
    show CupertinoTabBar, CupertinoTabScaffold, CupertinoTabView;
import 'package:flutter/material.dart' show NavigationBar, NavigationDestination, Scaffold;
import 'package:flutter/widgets.dart';

import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/layout/platform_tab_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive tab scaffold
class PlatformTabScaffold2 extends PlatformWidgetKeyedBase {
  /// The index of the currently selected tab. Needed when not using a [tabDestinations].view
  /// and the state is managed/rebuilt externally.
  final int selectedIndex;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should resize to avoid the bottom inset.
  final bool resizeToAvoidBottomInset;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// A list of destinations to display in the tab bar.
  final List<TabDestination>? tabDestinations;

  /// A controller for the tab bar.
  final PlatformTabController? controller;

  /// A callback that is called when a tab destination is tapped.
  final ValueChanged<int>? onTabDestinationTap;

  /// A builder for the content of each tab.
  final IndexedWidgetBuilder? tabBodyBuilder;

  /// Material-specific data for the tab scaffold.
  final MaterialTabScaffoldData? materialTabScaffoldData;

  /// Cupertino-specific data for the tab scaffold.
  final CupertinoTabScaffoldData? cupertinoTabScaffoldData;

  /// Creates a platform-adaptive tab scaffold.
  ///
  /// [tabBodyBuilder] is central to determining how state is managed. When it is provided, it is assumed that the state is managed externally
  /// ([tabDestinations].view is ignored/not needed in this case).
  /// When it is not provided, it is assumed that the state is managed internally and [tabDestinations].view is used to build the tab content.
  ///
  /// Cupertino already has [CupertinoTabView] that makes it trivial to be able to handle state internally.
  /// That is used when [tabDestinations].view is provided.
  ///
  /// Material revolves around using a `selectedIndex`
  const PlatformTabScaffold2({
    this.selectedIndex = 0,
    this.tabDestinations,
    this.controller,
    this.onTabDestinationTap,
    this.tabBodyBuilder,
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
    final resolvedTabBodyBuilder = materialTabScaffoldData?.tabBodyBuilder ?? tabBodyBuilder;
    final resolvedTabDestinations = materialTabScaffoldData?.tabDestinations ?? tabDestinations!;

    assert(
      (resolvedTabBodyBuilder != null) ^
          (resolvedTabDestinations.every((tabDest) => tabDest.view != null)),
      'Either provide a tabBodyBuilder or a view for each tab destination.',
    );

    return _MaterialTabScaffold(
      resolvedWidgetKey: materialTabScaffoldData?.widgetKey ?? widgetKey,
      resolvedSelectedIndex: selectedIndex,
      resizeToAvoidBottomInset:
          materialTabScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
      backgroundColor: materialTabScaffoldData?.backgroundColor ?? backgroundColor,
      restorationId: materialTabScaffoldData?.restorationId ?? restorationId,
      resolvedTabDestinations: resolvedTabDestinations,
      controller: controller,
      onTabDestinationTap: onTabDestinationTap,
      resolvedTabBodyBuilder: resolvedTabBodyBuilder,
      materialTabScaffoldData: materialTabScaffoldData,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedTabDestinations = cupertinoTabScaffoldData?.tabDestinations ?? tabDestinations!;
    final resolvedTabBodyBuilder = cupertinoTabScaffoldData?.tabBodyBuilder ?? tabBodyBuilder;

    assert(
      (resolvedTabBodyBuilder != null) ^
          (resolvedTabDestinations.every((tabDest) => tabDest.view != null)),
      'Either provide a tabBodyBuilder or a view for each tab destination.',
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
          resolvedTabBodyBuilder?.call(context, index) ??
          CupertinoTabView(builder: (_) => resolvedTabDestinations[index].view!),
    );
  }
}

class _MaterialTabScaffold extends StatefulWidget {
  final int resolvedSelectedIndex;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final String? restorationId;

  final List<TabDestination> resolvedTabDestinations;

  final PlatformTabController? controller;

  final ValueChanged<int>? onTabDestinationTap;

  final IndexedWidgetBuilder? resolvedTabBodyBuilder;

  final MaterialTabScaffoldData? materialTabScaffoldData;

  final Key? resolvedWidgetKey;

  const _MaterialTabScaffold({
    required this.resolvedSelectedIndex,
    required this.resizeToAvoidBottomInset,
    required this.resolvedTabDestinations,
    this.backgroundColor,
    this.restorationId,
    this.controller,
    this.onTabDestinationTap,
    this.resolvedTabBodyBuilder,
    this.materialTabScaffoldData,
    this.resolvedWidgetKey,
  });

  @override
  State<_MaterialTabScaffold> createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState extends State<_MaterialTabScaffold> {
  late final ValueNotifier<int>? _selectedIndexNotifier;

  @override
  void initState() {
    super.initState();

    _selectedIndexNotifier = widget.resolvedTabBodyBuilder != null
        ? null
        : ValueNotifier(widget.resolvedSelectedIndex);
  }

  @override
  void dispose() {
    _selectedIndexNotifier?.dispose();
    _selectedIndexNotifier = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: widget.resolvedWidgetKey,
    backgroundColor: widget.materialTabScaffoldData?.backgroundColor ?? widget.backgroundColor,
    resizeToAvoidBottomInset:
        widget.materialTabScaffoldData?.resizeToAvoidBottomInset ?? widget.resizeToAvoidBottomInset,
    floatingActionButton: widget.materialTabScaffoldData?.floatingActionButton,
    floatingActionButtonLocation: widget.materialTabScaffoldData?.floatingActionButtonLocation,
    floatingActionButtonAnimator: widget.materialTabScaffoldData?.floatingActionButtonAnimator,
    persistentFooterButtons: widget.materialTabScaffoldData?.persistentFooterButtons,
    persistentFooterAlignment:
        widget.materialTabScaffoldData?.persistentFooterAlignment ??
        MaterialScaffoldData.kDefaultPersistentFooterAlignment,
    persistentFooterDecoration: widget.materialTabScaffoldData?.persistentFooterDecoration,
    drawer: widget.materialTabScaffoldData?.drawer,
    onDrawerChanged: widget.materialTabScaffoldData?.onDrawerChanged,
    endDrawer: widget.materialTabScaffoldData?.endDrawer,
    onEndDrawerChanged: widget.materialTabScaffoldData?.onEndDrawerChanged,
    bottomSheet: widget.materialTabScaffoldData?.bottomSheet,
    primary: widget.materialTabScaffoldData?.primary ?? MaterialScaffoldData.kPrimary,
    drawerDragStartBehavior:
        widget.materialTabScaffoldData?.drawerDragStartBehavior ??
        MaterialScaffoldData.kDrawerDragStartBehavior,
    extendBody: widget.materialTabScaffoldData?.extendBody ?? MaterialScaffoldData.kExtendBody,
    drawerBarrierDismissible:
        widget.materialTabScaffoldData?.drawerBarrierDismissible ??
        MaterialScaffoldData.kDrawerBarrierDismissible,
    extendBodyBehindAppBar:
        widget.materialTabScaffoldData?.extendBodyBehindAppBar ??
        MaterialScaffoldData.kExtendBodyBehindAppBar,
    drawerScrimColor: widget.materialTabScaffoldData?.drawerScrimColor,
    bottomSheetScrimBuilder:
        widget.materialTabScaffoldData?.bottomSheetScrimBuilder ??
        MaterialScaffoldData.kDefaultBottomSheetScrimBuilder,
    drawerEdgeDragWidth: widget.materialTabScaffoldData?.drawerEdgeDragWidth,
    drawerEnableOpenDragGesture:
        widget.materialTabScaffoldData?.drawerEnableOpenDragGesture ??
        MaterialScaffoldData.kDrawerEnableOpenDragGesture,
    endDrawerEnableOpenDragGesture:
        widget.materialTabScaffoldData?.endDrawerEnableOpenDragGesture ??
        MaterialScaffoldData.kEndDrawerEnableOpenDragGesture,
    restorationId: widget.materialTabScaffoldData?.restorationId ?? widget.restorationId,
    bottomNavigationBar:
        _selectedIndexNotifier ==
            null // => resolvedTabBodyBuilder != null
        ? _MaterialNavigationBar(
            selectedIndex: widget.resolvedSelectedIndex,
            tabDestinations: widget.resolvedTabDestinations,
            onTabDestinationTap: widget.onTabDestinationTap,
          )
        : ValueListenableBuilder(
            valueListenable: _selectedIndexNotifier,
            builder: (_, selectedIndex, _) => _MaterialNavigationBar(
              selectedIndex: selectedIndex,
              tabDestinations: widget.resolvedTabDestinations,
              onTabDestinationTap: (tabIndex) {
                _selectedIndexNotifier.value = tabIndex;
                widget.onTabDestinationTap?.call(tabIndex);
              },
            ),
          ),
    body:
        widget.resolvedTabBodyBuilder?.call(context, widget.resolvedSelectedIndex) ??
        ValueListenableBuilder(
          valueListenable: _selectedIndexNotifier!,
          builder: (_, selectedIndex, _) => widget.resolvedTabDestinations[selectedIndex].view!,
        ),
  );
}

class _MaterialNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<TabDestination> tabDestinations;
  final ValueChanged<int>? onTabDestinationTap;

  const _MaterialNavigationBar({
    required this.selectedIndex,
    required this.tabDestinations,
    this.onTabDestinationTap,
  });

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: onTabDestinationTap,
    destinations: [
      for (final tabDestination in tabDestinations)
        NavigationDestination(
          icon: tabDestination.inactiveIcon,
          selectedIcon: tabDestination.activeIcon,
          label: tabDestination.label,
          tooltip: tabDestination.tooltip,
        ),
    ],
  );
}
