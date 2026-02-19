import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/layout/platform_tab_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive tab scaffold that renders a Material scaffold with a
/// navigation bar on Android, and a Cupertino tab scaffold on iOS.
class PlatformTabScaffold extends PlatformWidgetKeyedBase {
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

  /// A builder for the content of each tab.
  final IndexedWidgetBuilder? tabBodyBuilder;

  /// Material-specific data for the tab scaffold.
  final MaterialTabScaffoldData? materialTabScaffoldData;

  /// Cupertino-specific data for the tab scaffold.
  final CupertinoTabScaffoldData? cupertinoTabScaffoldData;

  /// 3 modes for state management:
  /// 1. [tabDestinations] with the `view` property defined: direct definition of tab content. State is both stored and managed internally in this case.
  /// 2. Instead of managing the state internally, you can also provide a [controller] and manage the state externally.
  /// 3. Instead of storing the state internally, you can also provide a [tabBodyBuilder]  to build the tab content (usable in GoRouter's shell route for example).
  const PlatformTabScaffold({
    this.materialTabScaffoldData,
    this.cupertinoTabScaffoldData,
    this.tabDestinations,
    this.controller,
    this.tabBodyBuilder,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
    this.restorationId,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => _MaterialTabScaffold(
    platformTabController: controller,
    materialTabScaffoldData: MaterialTabScaffoldData(
      tabDestinations:
          materialTabScaffoldData?.tabDestinations ?? tabDestinations ?? <TabDestination>[],
      controller: materialTabScaffoldData?.controller,
      tabBodyBuilder: materialTabScaffoldData?.tabBodyBuilder ?? tabBodyBuilder,
      widgetKey: materialTabScaffoldData?.widgetKey ?? widgetKey,
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
      drawerEdgeDragWidth: materialTabScaffoldData?.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture:
          materialTabScaffoldData?.drawerEnableOpenDragGesture ??
          MaterialScaffoldData.kDrawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture:
          materialTabScaffoldData?.endDrawerEnableOpenDragGesture ??
          MaterialScaffoldData.kEndDrawerEnableOpenDragGesture,
      restorationId: materialTabScaffoldData?.restorationId ?? restorationId,
    ),
  );

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedTabDestinations =
        cupertinoTabScaffoldData?.tabDestinations ?? tabDestinations ?? <TabDestination>[];
    final resolvedTabBodyBuilder = cupertinoTabScaffoldData?.tabBodyBuilder ?? tabBodyBuilder;

    assert(
      (resolvedTabBodyBuilder != null) ^ (resolvedTabDestinations.every((e) => e.view != null)),
      'Either provide a tabBodyBuilder or a view for each tab destination.',
    );

    return CupertinoTabScaffold(
      key: cupertinoTabScaffoldData?.widgetKey ?? widgetKey,
      backgroundColor: cupertinoTabScaffoldData?.backgroundColor ?? backgroundColor,
      resizeToAvoidBottomInset:
          cupertinoTabScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
      restorationId: cupertinoTabScaffoldData?.restorationId ?? restorationId,
      controller: cupertinoTabScaffoldData?.controller ?? controller?.toCupertinoController(),
      tabBar: CupertinoTabBar(
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
      tabBuilder: (_, index) => CupertinoTabView(
        builder: (context) =>
            resolvedTabBodyBuilder?.call(context, index) ?? resolvedTabDestinations[index].view!,
      ),
    );
  }
}

class _MaterialTabScaffold extends StatefulWidget {
  final MaterialTabScaffoldData materialTabScaffoldData;
  final PlatformTabController? platformTabController;

  /// [platformTabController] is passed separately as 'vsync' context is needed for conversion to native.
  const _MaterialTabScaffold({
    required this.materialTabScaffoldData,
    required this.platformTabController,
  });

  @override
  State<_MaterialTabScaffold> createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState extends State<_MaterialTabScaffold> with TickerProviderStateMixin {
  late final _resolvedTabController =
      widget.materialTabScaffoldData.controller ??
      widget.platformTabController?.toMaterialController(
        vsync: this,
        length: widget.materialTabScaffoldData.tabDestinations!.length,
      ) ??
      TabController(length: widget.materialTabScaffoldData.tabDestinations!.length, vsync: this);

  @override
  void initState() {
    super.initState();

    assert(
      (widget.materialTabScaffoldData.tabBodyBuilder != null) ^
          (widget.materialTabScaffoldData.tabDestinations?.every((e) => e.view != null) ?? false),
      'Either provide a tabBodyBuilder or a view for each tab destination.',
    );
  }

  @override
  void dispose() {
    _resolvedTabController.dispose();
    widget.materialTabScaffoldData.controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: widget.materialTabScaffoldData.widgetKey,
    backgroundColor: widget.materialTabScaffoldData.backgroundColor,
    resizeToAvoidBottomInset: widget.materialTabScaffoldData.resizeToAvoidBottomInset,
    floatingActionButton: widget.materialTabScaffoldData.floatingActionButton,
    floatingActionButtonLocation: widget.materialTabScaffoldData.floatingActionButtonLocation,
    floatingActionButtonAnimator: widget.materialTabScaffoldData.floatingActionButtonAnimator,
    persistentFooterButtons: widget.materialTabScaffoldData.persistentFooterButtons,
    persistentFooterAlignment: widget.materialTabScaffoldData.persistentFooterAlignment,
    persistentFooterDecoration: widget.materialTabScaffoldData.persistentFooterDecoration,
    drawer: widget.materialTabScaffoldData.drawer,
    onDrawerChanged: widget.materialTabScaffoldData.onDrawerChanged,
    endDrawer: widget.materialTabScaffoldData.endDrawer,
    onEndDrawerChanged: widget.materialTabScaffoldData.onEndDrawerChanged,
    bottomSheet: widget.materialTabScaffoldData.bottomSheet,
    primary: widget.materialTabScaffoldData.primary,
    drawerDragStartBehavior: widget.materialTabScaffoldData.drawerDragStartBehavior,
    extendBody: widget.materialTabScaffoldData.extendBody,
    drawerBarrierDismissible: widget.materialTabScaffoldData.drawerBarrierDismissible,
    extendBodyBehindAppBar: widget.materialTabScaffoldData.extendBodyBehindAppBar,
    drawerScrimColor: widget.materialTabScaffoldData.drawerScrimColor,
    bottomSheetScrimBuilder:
        widget.materialTabScaffoldData.bottomSheetScrimBuilder ??
        MaterialScaffoldData.kDefaultBottomSheetScrimBuilder,
    drawerEdgeDragWidth: widget.materialTabScaffoldData.drawerEdgeDragWidth,
    drawerEnableOpenDragGesture: widget.materialTabScaffoldData.drawerEnableOpenDragGesture,
    endDrawerEnableOpenDragGesture: widget.materialTabScaffoldData.endDrawerEnableOpenDragGesture,
    restorationId: widget.materialTabScaffoldData.restorationId,
    bottomNavigationBar: ListenableBuilder(
      listenable: _resolvedTabController,
      builder: (_, _) => _MaterialNavigationBar(
        selectedIndex: _resolvedTabController.index,
        onDestinationSelected: _onDestinationSelected,
        tabDestinations: widget.materialTabScaffoldData.tabDestinations!,
      ),
    ),
    body: ListenableBuilder(
      listenable: _resolvedTabController,
      builder: (_, _) =>
          widget.materialTabScaffoldData.tabBodyBuilder?.call(
            context,
            _resolvedTabController.index,
          ) ??
          widget.materialTabScaffoldData.tabDestinations![_resolvedTabController.index].view!,
    ),
  );

  // intended to be a common callback
  //ignore: use_setters_to_change_properties
  void _onDestinationSelected(int newTabIndex) => _resolvedTabController.index = newTabIndex;
}

class _MaterialNavigationBar extends NavigationBar {
  _MaterialNavigationBar({
    required super.selectedIndex,
    required List<TabDestination> tabDestinations,
    required super.onDestinationSelected,
  }) : super(
         destinations: [
           for (final tabDestinationData in tabDestinations)
             NavigationDestination(
               icon: tabDestinationData.inactiveIcon,
               selectedIcon: tabDestinationData.activeIcon,
               label: tabDestinationData.label,
               tooltip: tabDestinationData.tooltip,
             ),
         ],
       );
}
