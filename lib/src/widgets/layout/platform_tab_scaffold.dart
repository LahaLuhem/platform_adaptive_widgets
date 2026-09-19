import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoTabBar, CupertinoTabController, CupertinoTabScaffold, CupertinoTabView;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show NavigationBar, NavigationDestination, Scaffold;

import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/layout/platform_tab_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material `Scaffold` and `NavigationBar` on Android, `CupertinoTabScaffold` and `CupertinoTabBar`
/// on iOS.
///
/// 2 ways to use it, and [tabBodyBuilder] is what tells them apart. Leave it out and give every [TabDestination]
/// a `view`, and the scaffold handles selection itself, giving each iOS tab its own `CupertinoTabView`
/// navigator and caching the Material side to match. Pass it, along with [selectedIndex] and [onTabDestinationTap],
/// and something outside owns selection instead. That's usually `go_router`'s `StatefulShellRoute`,
/// where the 3 map onto the shell's branch navigators, `currentIndex` and `goBranch`.
///
/// One or the other, not both, which an `assert` enforces.
///
/// Each tab brings its own app bar by default, either a `PlatformScaffold` per tab or whatever [tabBodyBuilder]
/// returns, which is what both platforms expect. Material will also take a single bar above all the
/// tabs via [MaterialTabScaffoldData.appBar]. iOS won't, its HIG saying no.
///
/// Under controlled mode the one [CupertinoTabController] is kept and re-pointed as [selectedIndex]
/// changes, never rebuilt, so an outside driver doesn't leak controllers or churn rebuilds.
class const PlatformTabScaffold({
  /// 2 or more, since Material's bar refuses fewer.
  required final List<TabDestination> tabDestinations,

  /// The starting tab when the scaffold owns selection, the current one when something else does.
  final int selectedIndex = 0,

  final ValueChanged<int>? onTabDestinationTap,

  /// Passing this hands selection to the caller. See above.
  final IndexedWidgetBuilder? tabBodyBuilder,

  final Color? backgroundColor,

  /// Shrinks the body when the keyboard comes up, rather than letting it hide the bottom.
  final bool resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,

  final String? restorationId,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialTabScaffoldData? materialTabScaffoldData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive tab scaffold.
  this;

  @override
  Widget buildMaterial(BuildContext context) {
    _debugAssertUsage();

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
    _debugAssertUsage();

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

  /// Per build rather than in a constructor assert, because neither the length check nor the `.every`
  /// closure is const-evaluable and moving them up would cost every caller their `const`.
  void _debugAssertUsage() {
    assert(
      tabDestinations.length >= 2,
      'Needs at least 2 tab destinations. The Material NavigationBar requires it, so a single tab '
      'would render on iOS and crash on Android.',
    );
    assert(
      (tabBodyBuilder != null) ^ tabDestinations.every((destination) => destination.view != null),
      'Provide either a tabBodyBuilder (controlled mode) or a view for every '
      'tab destination (managed mode), not both, not neither.',
    );
  }
}

/// The iOS half. Holds one [CupertinoTabController] for its lifetime so an outside driver can move selection
/// without it being rebuilt underneath.
class const _CupertinoTabScaffold({
  required final int selectedIndex,
  required final bool resizeToAvoidBottomInset,
  required final List<TabDestination> tabDestinations,
  final Key? widgetKey,
  final Color? backgroundColor,
  final String? restorationId,
  final ValueChanged<int>? onTabDestinationTap,
  final IndexedWidgetBuilder? tabBodyBuilder,
}) extends StatefulWidget {
  @override
  State<_CupertinoTabScaffold> createState() => _CupertinoTabScaffoldState();
}

class _CupertinoTabScaffoldState() extends State<_CupertinoTabScaffold> {
  late final CupertinoTabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CupertinoTabController(initialIndex: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(_CupertinoTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Push the outside index into the controller, which the scaffold listens to. Never fires in
    // managed mode, where selectedIndex doesn't move and the controller handles taps itself.
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

/// The Android half. Keeps its own [ValueNotifier] when it owns selection, and reads [PlatformTabScaffold.selectedIndex]
/// straight through when it doesn't. [_TabSwitchingView] supplies the keep-alive caching iOS gets for
/// free and Material's `Scaffold` doesn't.
class const _MaterialTabScaffold({
  required final int selectedIndex,
  required final bool resizeToAvoidBottomInset,
  required final List<TabDestination> tabDestinations,
  final Color? backgroundColor,
  final String? restorationId,
  final ValueChanged<int>? onTabDestinationTap,
  final IndexedWidgetBuilder? tabBodyBuilder,
  final MaterialTabScaffoldData? materialTabScaffoldData,
  final Key? widgetKey,
}) extends StatefulWidget {
  @override
  State<_MaterialTabScaffold> createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState() extends State<_MaterialTabScaffold> {
  /// `null` when something outside owns selection.
  ValueNotifier<int>? _selectedIndexNotifier;

  @override
  void initState() {
    super.initState();

    if (widget.tabBodyBuilder == null) _selectedIndexNotifier = ValueNotifier(widget.selectedIndex);
  }

  @override
  void dispose() {
    _selectedIndexNotifier?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: widget.widgetKey,
    // Material only. See MaterialTabScaffoldData.appBar for why iOS has none.
    appBar: widget.materialTabScaffoldData?.appBar,
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
        // Driven from outside.
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
/// A widget laying out multiple tabs with only one active tab being built at a time and on stage. Off
/// stage tabs' animations are stopped.
class const _TabSwitchingView({
  required final int currentTabIndex,
  required final int tabCount,
  required final IndexedWidgetBuilder tabBuilder,
}) extends StatefulWidget {
  this : assert(tabCount > 0, 'Tab count must be greater than 0');

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState() extends State<_TabSwitchingView> {
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

  // Will focus the active tab if the FocusScope above it has focus already.
  // If not, then it will just mark it as the preferred focus for that scope.
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
              child: !shouldBuildTab[index]
                  ? const SizedBox.shrink()
                  : widget.tabBuilder(context, index),
            ),
          ),
        ),
      );
    }),
  );
}

class const _MaterialNavigationBar({
  required final int selectedIndex,
  required final List<TabDestination> tabDestinations,
  final ValueChanged<int>? onTabDestinationTap,
}) extends StatelessWidget {
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
