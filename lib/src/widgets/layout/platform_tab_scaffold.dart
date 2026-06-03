import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoTabBar, CupertinoTabController, CupertinoTabScaffold, CupertinoTabView;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show NavigationBar, NavigationDestination, Scaffold;

import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/layout/platform_tab_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive tab scaffold — Material `Scaffold` + `NavigationBar` on
/// Android, `CupertinoTabScaffold` + `CupertinoTabBar` on iOS.
///
/// Works in one of two modes, distinguished by whether [tabBodyBuilder] is set:
///
/// - **Managed** — give each [TabDestination] a `view` and omit
///   [tabBodyBuilder]. The scaffold owns selection: tapping a tab switches
///   content itself. On iOS each tab gets its own `CupertinoTabView` navigator
///   (native deep-nav semantics); the Material side replicates the keep-alive
///   caching via [_TabSwitchingView].
/// - **Controlled** — provide [tabBodyBuilder] plus [selectedIndex] and
///   [onTabDestinationTap]. An external emitter owns selection — most commonly
///   `go_router`'s `StatefulShellRoute`, where `selectedIndex` is
///   `navigationShell.currentIndex`, `onTabDestinationTap` is `goBranch`, and
///   `tabBodyBuilder` returns the shell's branch navigators.
///
/// Exactly one mode must be used — a constructor `assert` enforces "either
/// `tabBodyBuilder`, or a `view` on every destination".
///
/// On iOS the underlying `CupertinoTabScaffold` is controller-driven. In
/// controlled mode this widget owns one persistent [CupertinoTabController] and
/// syncs `controller.index` to [selectedIndex] when the external index changes
/// — it does **not** recreate the controller each build, so an external emitter
/// like `go_router` drives it without leaking controllers or rebuild churn.
class PlatformTabScaffold extends PlatformWidgetKeyedBase {
  /// The selected tab index.
  ///
  /// In managed mode this is the initial tab. In controlled mode it's the
  /// current tab, driven by the external emitter.
  final int selectedIndex;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should resize to avoid the bottom inset.
  final bool resizeToAvoidBottomInset;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// The destinations to display in the tab bar.
  final List<TabDestination> tabDestinations;

  /// Called when a tab destination is tapped.
  final ValueChanged<int>? onTabDestinationTap;

  /// Builds the body for each tab — presence selects controlled mode.
  final IndexedWidgetBuilder? tabBodyBuilder;

  /// Material-specific data for the tab scaffold.
  final MaterialTabScaffoldData? materialTabScaffoldData;

  /// Creates a platform-adaptive tab scaffold.
  const PlatformTabScaffold({
    required this.tabDestinations,
    this.selectedIndex = 0,
    this.onTabDestinationTap,
    this.tabBodyBuilder,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
    this.restorationId,
    this.materialTabScaffoldData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    _debugAssertSingleMode();

    return _MaterialTabScaffold(
      widgetKey: widgetKey,
      selectedIndex: selectedIndex,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      restorationId: restorationId,
      tabDestinations: tabDestinations,
      onTabDestinationTap: onTabDestinationTap,
      tabBodyBuilder: tabBodyBuilder,
      materialTabScaffoldData: materialTabScaffoldData,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    _debugAssertSingleMode();

    return _CupertinoTabScaffold(
      widgetKey: widgetKey,
      selectedIndex: selectedIndex,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      restorationId: restorationId,
      tabDestinations: tabDestinations,
      onTabDestinationTap: onTabDestinationTap,
      tabBodyBuilder: tabBodyBuilder,
    );
  }

  /// Asserts exactly one mode is in use: a [tabBodyBuilder] (controlled) XOR a
  /// `view` on every destination (managed). A constructor `assert` can't run
  /// this — the `.every` closure isn't a constant expression — so it's checked
  /// per build (debug-only).
  void _debugAssertSingleMode() {
    assert(
      (tabBodyBuilder != null) ^ tabDestinations.every((destination) => destination.view != null),
      'Provide either a tabBodyBuilder (controlled mode) or a view for every '
      'tab destination (managed mode) — not both, not neither.',
    );
  }
}

/// iOS implementation. Owns a persistent [CupertinoTabController] so an external
/// emitter (controlled mode) can drive selection by [selectedIndex] without the
/// controller being recreated each build — see [PlatformTabScaffold].
class _CupertinoTabScaffold extends StatefulWidget {
  final Key? widgetKey;
  final int selectedIndex;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final String? restorationId;
  final List<TabDestination> tabDestinations;
  final ValueChanged<int>? onTabDestinationTap;
  final IndexedWidgetBuilder? tabBodyBuilder;

  const _CupertinoTabScaffold({
    required this.selectedIndex,
    required this.resizeToAvoidBottomInset,
    required this.tabDestinations,
    this.widgetKey,
    this.backgroundColor,
    this.restorationId,
    this.onTabDestinationTap,
    this.tabBodyBuilder,
  });

  @override
  State<_CupertinoTabScaffold> createState() => _CupertinoTabScaffoldState();
}

class _CupertinoTabScaffoldState extends State<_CupertinoTabScaffold> {
  late final CupertinoTabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CupertinoTabController(initialIndex: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(_CupertinoTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Controlled mode: the external emitter (e.g. go_router's StatefulShell)
    // owns the index — push it into the persistent controller. In managed mode
    // selectedIndex is constant, so this never fires and the controller
    // self-manages on tap. `CupertinoTabScaffold` listens to the controller and
    // rebuilds on this assignment.
    if (widget.selectedIndex != oldWidget.selectedIndex &&
        _controller.index != widget.selectedIndex) {
      _controller.index = widget.selectedIndex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
    key: widget.widgetKey,
    controller: _controller,
    backgroundColor: widget.backgroundColor,
    resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    restorationId: widget.restorationId,
    tabBar: CupertinoTabBar(
      currentIndex: _controller.index,
      onTap: widget.onTabDestinationTap,
      items: [
        for (final tabDestination in widget.tabDestinations)
          BottomNavigationBarItem(
            icon: tabDestination.inactiveIcon,
            activeIcon: tabDestination.activeIcon,
            label: tabDestination.label,
            tooltip: tabDestination.tooltip,
          ),
      ],
    ),
    tabBuilder: (context, index) =>
        widget.tabBodyBuilder?.call(context, index) ??
        CupertinoTabView(builder: (_) => widget.tabDestinations[index].view!),
  );
}

/// Android implementation. In managed mode it owns a [ValueNotifier] for the
/// selected index; in controlled mode it renders [PlatformTabScaffold.selectedIndex]
/// directly. [_TabSwitchingView] gives the keep-alive tab caching that
/// `CupertinoTabScaffold` provides natively but Material's `Scaffold` does not.
class _MaterialTabScaffold extends StatefulWidget {
  final int selectedIndex;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final String? restorationId;
  final List<TabDestination> tabDestinations;
  final ValueChanged<int>? onTabDestinationTap;
  final IndexedWidgetBuilder? tabBodyBuilder;
  final MaterialTabScaffoldData? materialTabScaffoldData;
  final Key? widgetKey;

  const _MaterialTabScaffold({
    required this.selectedIndex,
    required this.resizeToAvoidBottomInset,
    required this.tabDestinations,
    this.backgroundColor,
    this.restorationId,
    this.onTabDestinationTap,
    this.tabBodyBuilder,
    this.materialTabScaffoldData,
    this.widgetKey,
  });

  @override
  State<_MaterialTabScaffold> createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState extends State<_MaterialTabScaffold> {
  /// Owns the selected index in managed mode; `null` in controlled mode (the
  /// external [PlatformTabScaffold.selectedIndex] drives selection instead).
  ValueNotifier<int>? _selectedIndexNotifier;

  @override
  void initState() {
    super.initState();

    if (widget.tabBodyBuilder == null) {
      _selectedIndexNotifier = ValueNotifier(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _selectedIndexNotifier?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: widget.widgetKey,
    backgroundColor: widget.materialTabScaffoldData?.backgroundColor ?? widget.backgroundColor,
    resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
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
    bottomNavigationBar: _selectedIndexNotifier == null
        // Controlled mode: selection is driven externally.
        ? _MaterialNavigationBar(
            selectedIndex: widget.selectedIndex,
            tabDestinations: widget.tabDestinations,
            onTabDestinationTap: widget.onTabDestinationTap,
          )
        : ValueListenableBuilder(
            valueListenable: _selectedIndexNotifier!,
            builder: (_, selectedIndex, _) => _MaterialNavigationBar(
              selectedIndex: selectedIndex,
              tabDestinations: widget.tabDestinations,
              onTabDestinationTap: (tabIndex) {
                _selectedIndexNotifier!.value = tabIndex;
                widget.onTabDestinationTap?.call(tabIndex);
              },
            ),
          ),
    body: widget.tabBodyBuilder != null
        ? _TabSwitchingView(
            currentTabIndex: widget.selectedIndex,
            tabCount: widget.tabDestinations.length,
            tabBuilder: widget.tabBodyBuilder!,
          )
        : ValueListenableBuilder(
            valueListenable: _selectedIndexNotifier!,
            builder: (_, selectedIndex, _) => _TabSwitchingView(
              currentTabIndex: selectedIndex,
              tabCount: widget.tabDestinations.length,
              tabBuilder: (_, index) => widget.tabDestinations[index].view!,
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
