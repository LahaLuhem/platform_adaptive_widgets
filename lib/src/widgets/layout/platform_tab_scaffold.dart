import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoTabBar, CupertinoTabController, CupertinoTabScaffold, CupertinoTabView;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show NavigationBar, NavigationDestination, Scaffold;

import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/layout/platform_tab_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive tab scaffold
class PlatformTabScaffold extends PlatformWidgetKeyedBase {
  /// The index of the currently selected tab. Needed when not using a [tabDestinations].view
  /// and the state is managed/rebuilt externally.
  final int? selectedIndex;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should resize to avoid the bottom inset.
  final bool resizeToAvoidBottomInset;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// A list of destinations to display in the tab bar.
  final List<TabDestination>? tabDestinations;

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
  /// [tabBodyBuilder] is central to determining how state is managed.
  /// When it is provided, it is assumed that the state is managed (and rebuilt) externally ([tabDestinations].view is ignored/not needed in this case).
  /// When it is not provided, it is assumed that the state is managed internally and [tabDestinations].view is used to build the tab content.
  ///
  /// Cupertino already has [CupertinoTabView] that makes it trivial to be able to handle state internally.
  /// That is used when [tabDestinations].view is provided.
  ///
  /// Material revolves around using a `selectedIndex` that is changed when a tab is tapped.
  ///
  /// Since [CupertinoTabScaffold].tabBuilder automatically caches the tab content prevent rebuilds when switching tabs,
  /// the material side has been extended to replicate this functionality.
  const PlatformTabScaffold({
    this.selectedIndex = 0,
    this.tabDestinations,
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

  static const _kDefaultSelectedIndex = 0;

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
      resolvedSelectedIndex:
          materialTabScaffoldData?.selectedIndex ?? selectedIndex ?? _kDefaultSelectedIndex,
      resizeToAvoidBottomInset:
          materialTabScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
      backgroundColor: materialTabScaffoldData?.backgroundColor ?? backgroundColor,
      restorationId: materialTabScaffoldData?.restorationId ?? restorationId,
      resolvedTabDestinations: resolvedTabDestinations,
      onTabDestinationTap: onTabDestinationTap,
      resolvedTabBodyBuilder: resolvedTabBodyBuilder,
      materialTabScaffoldData: materialTabScaffoldData,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final resolvedSelectedIndex =
        cupertinoTabScaffoldData?.selectedIndex ?? selectedIndex ?? _kDefaultSelectedIndex;
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
      controller: CupertinoTabController(initialIndex: resolvedSelectedIndex),
      tabBar: CupertinoTabBar(
        currentIndex: resolvedSelectedIndex,
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
    // Implies that resolvedTabBodyBuilder != null
    bottomNavigationBar: _selectedIndexNotifier == null
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
    body: widget.resolvedTabBodyBuilder != null
        ? _TabSwitchingView(
            currentTabIndex: widget.resolvedSelectedIndex,
            tabCount: widget.resolvedTabDestinations.length,
            tabBuilder: widget.resolvedTabBodyBuilder!,
          )
        : ValueListenableBuilder(
            valueListenable: _selectedIndexNotifier!,
            builder: (_, selectedIndex, _) => _TabSwitchingView(
              currentTabIndex: selectedIndex,
              tabCount: widget.resolvedTabDestinations.length,
              tabBuilder: (_, index) => widget.resolvedTabDestinations[index].view!,
            ),
          ),
  );
}

/// Ripped from Cupertino's `_TabSwitchingView`.
///
/// A widget laying out multiple tabs with only one active tab being built
/// at a time and on stage. Off stage tabs' animations are stopped.
class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabIndex,
    required this.tabCount,
    required this.tabBuilder,
  }) : assert(tabCount > 0, 'Tab count must be greater than 0');

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  final shouldBuildTab = <bool>[];
  final tabFocusNodes = <FocusScopeNode>[];

  // When focus nodes are no longer needed, we need to dispose of them, but we
  // can't be sure that nothing else is listening to them until this widget is
  // disposed of, so when they are no longer needed, we move them to this list,
  // and dispose of them when we dispose of this widget.
  final discardedNodes = <FocusScopeNode>[];

  @override
  void initState() {
    super.initState();

    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only partially invalidate the tabs cache to avoid breaking the current
    // behavior. We assume that the only possible change is either:
    // - new tabs are appended to the tab list, or
    // - some trailing tabs are removed.
    // If the above assumption is not true, some tabs may lose their state.
    final lengthDiff = widget.tabCount - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount, shouldBuildTab.length);
    }
    _focusActiveTab();
  }

  // Will focus the active tab if the FocusScope above it has focus already. If
  // not, then it will just mark it as the preferred focus for that scope.
  void _focusActiveTab() {
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount));
        tabFocusNodes.removeRange(widget.tabCount, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount - tabFocusNodes.length,
            (index) => FocusScopeNode(debugLabel: '$Scaffold Tab ${index + tabFocusNodes.length}'),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (final focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: List<Widget>.generate(widget.tabCount, (index) {
      final active = index == widget.currentTabIndex;
      shouldBuildTab[index] = active || shouldBuildTab[index];

      return HeroMode(
        enabled: active,
        child: Offstage(
          offstage: !active,
          child: TickerMode(
            enabled: active,
            child: FocusScope(
              node: tabFocusNodes[index],
              child: shouldBuildTab[index]
                  ? widget.tabBuilder(context, index)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      );
    }),
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
