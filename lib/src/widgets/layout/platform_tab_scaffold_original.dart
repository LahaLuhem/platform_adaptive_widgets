// ignore_for_file: prefer-match-file-name

import 'dart:math' as math;

import 'package:flutter/cupertino.dart'
    show
        CupertinoColors,
        CupertinoPageScaffold,
        CupertinoTabBar,
        CupertinoTabController,
        CupertinoTabScaffold,
        CupertinoTabView,
        ObstructingPreferredSizeWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    show
        BottomNavigationBarLandscapeLayout,
        BottomNavigationBarType,
        Colors,
        DrawerCallback,
        FloatingActionButtonAnimator,
        FloatingActionButtonLocation,
        NavigationBar,
        NavigationDestination,
        NavigationDestinationLabelBehavior,
        Scaffold;
import 'package:flutter/widgets.dart';

import '/src/models/platform_widget_base.dart';
import '/src/utils/target_platform.dart';
import 'platform_app_bar.dart';

/// Base class for scaffold data.
abstract class _BaseScaffoldOriginalData {
  /// Creates a [_BaseScaffoldOriginalData].
  _BaseScaffoldOriginalData({this.widgetKey, this.backgroundColor});

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// A key to identify the widget.
  final Key? widgetKey;
}

/// Material-specific data for a tab scaffold.
class MaterialTabScaffoldOriginalData extends _BaseScaffoldOriginalData {
  /// Creates a [MaterialTabScaffoldOriginalData].
  MaterialTabScaffoldOriginalData({
    super.backgroundColor,
    super.widgetKey,
    this.bodyBuilder,
    this.appBarBuilder,
    this.controller,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.primary,
    this.bottomSheet,
    this.drawerDragStartBehavior,
    this.extendBody,
    this.resizeToAvoidBottomInset,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.extendBodyBehindAppBar,
    this.tabsBackgroundColor,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
    this.restorationId,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.persistentFooterAlignment,
    this.height,
    this.bottomSheetScrimBuilder,
    this.drawerBarrierDismissible,
    this.persistentFooterDecoration,
  });

  /// A builder for the body of the scaffold.
  final Widget Function(BuildContext context, int index)? bodyBuilder;

  /// A controller for the tab bar.
  final MaterialTabController? controller;

  /// A builder for the app bar.
  final PreferredSizeWidget? Function(BuildContext context, int index)? appBarBuilder;

  /// A drawer to display.
  final Widget? drawer;

  /// An end drawer to display.
  final Widget? endDrawer;

  /// A floating action button to display.
  final Widget? floatingActionButton;

  /// An animator for the floating action button.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// The location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// A list of persistent footer buttons to display.
  final List<Widget>? persistentFooterButtons;

  /// Whether this scaffold is the primary scaffold.
  final bool? primary;

  /// A bottom sheet to display.
  final Widget? bottomSheet;

  /// The drag start behavior for the drawer.
  final DragStartBehavior? drawerDragStartBehavior;

  /// Whether to extend the body of the scaffold.
  final bool? extendBody;

  /// Whether to resize the body of the scaffold to avoid the bottom inset.
  final bool? resizeToAvoidBottomInset;

  /// The color of the scrim that is applied to the background of the drawer.
  final Color? drawerScrimColor;

  /// The width of the area that can be used to drag the drawer.
  final double? drawerEdgeDragWidth;

  /// Whether to extend the body of the scaffold behind the app bar.
  final bool? extendBodyBehindAppBar;

  /// The background color of the tabs.
  final Color? tabsBackgroundColor;

  /// Whether to enable the open drag gesture for the drawer.
  final bool? drawerEnableOpenDragGesture;

  /// Whether to enable the open drag gesture for the end drawer.
  final bool? endDrawerEnableOpenDragGesture;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// A callback that is called when the drawer is opened or closed.
  final DrawerCallback? onDrawerChanged;

  /// A callback that is called when the end drawer is opened or closed.
  final DrawerCallback? onEndDrawerChanged;

  /// The alignment of the persistent footer buttons.
  final AlignmentDirectional? persistentFooterAlignment;

  /// The height of the scaffold.
  final double? height;

  /// A builder for the bottom sheet scrim.
  final Widget? Function(BuildContext, Animation<double>)? bottomSheetScrimBuilder;

  /// Whether the drawer can be dismissed by tapping the scrim.
  final bool? drawerBarrierDismissible;

  /// The decoration to apply to the persistent footer buttons.
  final BoxDecoration? persistentFooterDecoration;
}

/// Base class for tab bar data.
abstract class _BaseTabBarData {
  /// Creates a [_BaseTabBarData].
  _BaseTabBarData({
    this.widgetKey,
    this.items,
    this.backgroundColor,
    this.iconSize,
    this.activeColor,
    this.currentIndex,
    this.itemChanged,
    this.height,
  });

  /// A key to identify the widget.
  final Key? widgetKey;

  /// The items to display in the tab bar.
  final List<BottomNavigationBarItem>? items;

  /// The background color of the tab bar.
  final Color? backgroundColor;

  /// The size of the icons in the tab bar.
  final double? iconSize;

  /// The color of the active item in the tab bar.
  final Color? activeColor;

  /// The index of the currently selected item.
  final int? currentIndex;

  /// A callback that is called when an item is tapped.
  final void Function(int)? itemChanged;

  /// The height of the tab bar.
  final double? height;
}

/// Data for a Cupertino tab view.
class CupertinoTabViewData {
  /// Creates a [CupertinoTabViewData].
  CupertinoTabViewData({
    this.defaultTitle,
    this.navigatorKey,
    this.navigatorObservers,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.routes,
  });

  /// The default title to display in the tab view.
  final String? defaultTitle;

  /// A key to identify the navigator.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// A list of navigator observers to apply to the tab view.
  final List<NavigatorObserver>? navigatorObservers;

  /// A callback that is called when a route is generated.
  final RouteFactory? onGenerateRoute;

  /// A callback that is called when a route is unknown.
  final RouteFactory? onUnknownRoute;

  /// A map of routes to display in the tab view.
  final Map<String, WidgetBuilder>? routes;
}

/// Cupertino-specific data for a tab scaffold.
class CupertinoTabScaffoldOriginalData extends _BaseScaffoldOriginalData {
  /// Creates a [CupertinoTabScaffoldOriginalData].
  CupertinoTabScaffoldOriginalData({
    super.backgroundColor,
    super.widgetKey,
    this.items,
    this.bodyBuilder,
    this.appBarBuilder,
    this.tabViewDataBuilder,
    this.resizeToAvoidBottomInset,
    this.resizeToAvoidBottomInsetTab,
    this.tabsBackgroundColor,
    this.controller,
    this.restorationId,
    this.restorationScopeIdTabView,
    this.navBarHeight,
  });

  /// The items to display in the tab bar.
  final List<BottomNavigationBarItem>? items;

  /// A builder for the tab view data.
  final CupertinoTabViewData Function(BuildContext context, int index)? tabViewDataBuilder;

  /// A builder for the body of the scaffold.
  final Widget Function(BuildContext context, int index)? bodyBuilder;

  /// A builder for the app bar.
  final ObstructingPreferredSizeWidget? Function(BuildContext context, int index)? appBarBuilder;

  /// Whether to resize the body of the scaffold to avoid the bottom inset.
  final bool? resizeToAvoidBottomInset;

  /// Whether to resize the tab view to avoid the bottom inset.
  final bool? resizeToAvoidBottomInsetTab;

  /// The background color of the tabs.
  final Color? tabsBackgroundColor;

  /// A controller for the tab bar.
  final CupertinoTabController? controller;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// A restoration scope ID to save and restore the state of the tab view.
  final String? restorationScopeIdTabView;

  /// The height of the navigation bar.
  final double? navBarHeight;
}

/// Cupertino-specific data for a tab bar.
class CupertinoTabBarData extends _BaseTabBarData {
  /// Creates a [CupertinoTabBarData].
  CupertinoTabBarData({
    super.backgroundColor,
    super.items,
    super.activeColor,
    super.widgetKey,
    super.itemChanged,
    super.iconSize,
    super.currentIndex,
    super.height,
    this.inactiveColor,
    this.border,
  });

  /// The color of the inactive items in the tab bar.
  final Color? inactiveColor;

  /// The border to display at the top of the tab bar.
  final Border? border;
}

/// Material-specific data for a navigation bar.
class MaterialNavigationBarData {
  /// Creates a [MaterialNavigationBarData].
  MaterialNavigationBarData({
    this.widgetKey,
    this.items,
    this.height,
    this.animationDuration,
    this.backgroundColor,
    this.elevation,
    this.indicatorColor,
    this.indicatorShape,
    this.labelBehavior,
    this.onDestinationSelected,
    this.selectedIndex,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.labelPadding,
    this.labelTextStyle,
    this.maintainBottomViewPadding,
  });

  /// A key to identify the widget.
  final Key? widgetKey;

  /// The destinations to display in the navigation bar.
  final List<NavigationDestination>? items;

  /// The height of the navigation bar.
  final double? height;

  /// The duration of the animation to play when an item is selected.
  final Duration? animationDuration;

  /// The background color of the navigation bar.
  final Color? backgroundColor;

  /// The elevation of the navigation bar.
  final double? elevation;

  /// The color of the indicator that is displayed around the selected item.
  final Color? indicatorColor;

  /// The shape of the indicator that is displayed around the selected item.
  final ShapeBorder? indicatorShape;

  /// The behavior of the labels in the navigation bar.
  final NavigationDestinationLabelBehavior? labelBehavior;

  /// A callback that is called when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  /// The index of the currently selected destination.
  final int? selectedIndex;

  /// The color of the shadow that is displayed below the navigation bar.
  final Color? shadowColor;

  /// The color of the surface tint that is applied to the navigation bar.
  final Color? surfaceTintColor;

  /// The color of the overlay that is displayed when an item is pressed.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The padding to apply to the labels.
  final EdgeInsetsGeometry? labelPadding;

  /// The text style to apply to the labels.
  final WidgetStateProperty<TextStyle?>? labelTextStyle;

  /// Whether to maintain the bottom view padding.
  final bool? maintainBottomViewPadding;
}

/// Material-specific data for a navigation bar.
class MaterialNavBarData extends _BaseTabBarData {
  /// Creates a [MaterialNavBarData].
  MaterialNavBarData({
    super.items,
    super.backgroundColor,
    super.iconSize,
    this.elevation,
    Color? fixedColor,
    super.widgetKey,
    super.itemChanged,
    super.currentIndex,
    super.height,
    this.type,
    this.bottomNavigationBarKey,
    this.shape,
    this.clipBehavior,
    this.notchMargin,
    this.selectedFontSize,
    this.selectedItemColor,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.unselectedFontSize,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.selectedLabelStyle,
    this.unselectedIconTheme,
    this.unselectedLabelStyle,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
    this.padding,
    this.surfaceTintColor,
    this.shadowColor,
  }) : super(activeColor: fixedColor);

  /// The font size of the selected item.
  final double? selectedFontSize;

  /// The elevation of the navigation bar.
  final double? elevation;

  /// The type of the navigation bar.
  final BottomNavigationBarType? type;

  /// A key to identify the bottom navigation bar.
  final Key? bottomNavigationBarKey;

  /// The shape of the navigation bar.
  final NotchedShape? shape;

  /// The clip behavior of the navigation bar.
  final Clip? clipBehavior;

  /// The margin of the notch in the navigation bar.
  final double? notchMargin;

  /// The color of the selected item.
  final Color? selectedItemColor;

  /// Whether to show the labels of the selected items.
  final bool? showSelectedLabels;

  /// Whether to show the labels of the unselected items.
  final bool? showUnselectedLabels;

  /// The font size of the unselected items.
  final double? unselectedFontSize;

  /// The color of the unselected items.
  final Color? unselectedItemColor;

  /// The theme of the selected icons.
  final IconThemeData? selectedIconTheme;

  /// The text style of the selected labels.
  final TextStyle? selectedLabelStyle;

  /// The theme of the unselected icons.
  final IconThemeData? unselectedIconTheme;

  /// The text style of the unselected labels.
  final TextStyle? unselectedLabelStyle;

  /// The mouse cursor to display when the navigation bar is hovered.
  final MouseCursor? mouseCursor;

  /// Whether to enable feedback when an item is tapped.
  final bool? enableFeedback;

  /// The layout of the navigation bar in landscape mode.
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  /// Whether to use the legacy color scheme.
  final bool useLegacyColorScheme;

  /// The padding to apply to the navigation bar.
  final EdgeInsetsGeometry? padding;

  /// The color of the surface tint that is applied to the navigation bar.
  final Color? surfaceTintColor;

  /// The color of the shadow that is displayed below the navigation bar.
  final Color? shadowColor;
}

/// Exists as a temporary solution for [not working with go-router issue](https://github.com/flutter/flutter/issues/113757)
class PlatformTabScaffoldOriginal extends PlatformWidgetBase {
  /// A key to identify the widget.
  final Key? widgetKey;

  /// A builder for the body of the scaffold.
  final Widget Function(BuildContext context, int index)? bodyBuilder;

  /// The background color of the page.
  final Color? pageBackgroundColor;

  /// The background color of the tabs.
  final Color? tabsBackgroundColor;

  /// A callback that is called when an item is tapped.
  final void Function(int index)? itemChanged;

  /// Material-specific data for the scaffold.
  final MaterialTabScaffoldOriginalData? material;

  /// A builder for the Material-specific data for the scaffold.
  final MaterialTabScaffoldOriginalData Function(int index)? materialBuilder;

  /// Material-specific data for the tabs.
  final MaterialNavBarData? materialTabs;

  /// Material 3-specific data for the tabs.
  final MaterialNavigationBarData? material3Tabs;

  /// Cupertino-specific data for the scaffold.
  final CupertinoTabScaffoldOriginalData? cupertino;

  /// Cupertino-specific data for the tabs.
  final CupertinoTabBarData? cupertinoTabs;

  /// A controller for the tab bar.
  final PlatformTabController? tabController;

  /// The items to display in the tab bar.
  final List<BottomNavigationBarItem>? items;

  /// A builder for the app bar.
  final PlatformAppBar? Function(BuildContext context, int index)? appBarBuilder;

  /// A restoration ID to save and restore the state of the scaffold.
  final String? restorationId;

  /// The height of the navigation bar.
  final double? navBarHeight;

  /// Creates a [PlatformTabScaffoldOriginal].
  const PlatformTabScaffoldOriginal({
    super.key,
    this.widgetKey,
    this.items,
    this.bodyBuilder,
    this.pageBackgroundColor,
    this.tabsBackgroundColor,
    this.appBarBuilder,
    this.tabController,
    this.itemChanged,
    this.restorationId,
    this.navBarHeight,
    this.material,
    this.materialBuilder,
    this.materialTabs,
    this.material3Tabs,
    this.cupertino,
    this.cupertinoTabs,
  }) : assert(
         (material != null && materialBuilder == null) || material == null,
         'Cannot provide both material and materialBuilder. '
         'Use either material for static configuration or materialBuilder for dynamic configuration based on tab index.',
       ),
       assert(
         (material == null && materialBuilder != null) || materialBuilder == null,
         'Cannot provide both material and materialBuilder. '
         'Use either material for static configuration or materialBuilder for dynamic configuration based on tab index.',
       );

  @override
  Widget buildMaterial(BuildContext context) {
    final data = material;

    final controller = data?.controller ?? tabController?._material();

    assert(
      controller != null,
      'MaterialTabController cannot be null. '
      'Either have material: (_, __) => MaterialTabScaffoldData(controller: controller) '
      'or PlatformTabScaffold(tabController: controller) ',
    );

    return AnimatedBuilder(
      animation: controller!,
      builder: (context, _) =>
          _buildMaterial(context, materialBuilder?.call(controller.index) ?? data, controller),
    );
  }

  Widget _buildMaterial(
    BuildContext context,
    MaterialTabScaffoldOriginalData? data,
    MaterialTabController controller,
  ) {
    final tabBar = _MaterialTabBar(
      items: items,
      backgroundColor: data?.tabsBackgroundColor ?? tabsBackgroundColor,
      currentIndex: controller.index,
      itemChanged: (index) {
        controller.index = index;
        itemChanged?.call(index);
      },
      height: data?.height ?? navBarHeight,
      material3: material3Tabs,
    );

    final child =
        data?.bodyBuilder?.call(context, controller.index) ??
        bodyBuilder?.call(context, controller.index);

    return Scaffold(
      key: data?.widgetKey ?? widgetKey,
      backgroundColor: data?.backgroundColor ?? pageBackgroundColor,
      body: child,
      bottomNavigationBar: tabBar,
      drawer: data?.drawer,
      endDrawer: data?.endDrawer,
      floatingActionButton: data?.floatingActionButton,
      floatingActionButtonAnimator: data?.floatingActionButtonAnimator,
      floatingActionButtonLocation: data?.floatingActionButtonLocation,
      persistentFooterButtons: data?.persistentFooterButtons,
      primary: data?.primary ?? true,
      bottomSheet: data?.bottomSheet,
      drawerDragStartBehavior: data?.drawerDragStartBehavior ?? DragStartBehavior.start,
      extendBody: data?.extendBody ?? false,
      resizeToAvoidBottomInset: data?.resizeToAvoidBottomInset,
      drawerScrimColor: data?.drawerScrimColor,
      drawerEdgeDragWidth: data?.drawerEdgeDragWidth,
      extendBodyBehindAppBar: data?.extendBodyBehindAppBar ?? false,
      drawerEnableOpenDragGesture: data?.drawerEnableOpenDragGesture ?? true,
      endDrawerEnableOpenDragGesture: data?.endDrawerEnableOpenDragGesture ?? true,
      onDrawerChanged: data?.onDrawerChanged,
      onEndDrawerChanged: data?.onEndDrawerChanged,
      restorationId: data?.restorationId ?? restorationId,
      persistentFooterAlignment: data?.persistentFooterAlignment ?? AlignmentDirectional.centerEnd,
      bottomSheetScrimBuilder: data?.bottomSheetScrimBuilder ?? _defaultBottomSheetScrimBuilder,
      drawerBarrierDismissible: data?.drawerBarrierDismissible ?? true,
      persistentFooterDecoration: data?.persistentFooterDecoration,
    );
  }

  @override
  Widget buildCupertino(BuildContext context) {
    final controller = cupertino?.controller ?? tabController?._cupertino();

    assert(
      controller != null,
      'CupertinoTabController cannot be null. '
      'Either have material: (_, __) => CupertinoTabScaffoldData(controller: controller) or '
      'PlatformTabScaffold(tabController: controller)',
    );

    return CupertinoTabScaffold(
      key: widgetKey,
      tabBar: _CupertinoTabBar(
        items: items,
        backgroundColor: tabsBackgroundColor,
        currentIndex: controller!.index,
        itemChanged: itemChanged,
        cupertino: cupertinoTabs,
        height: cupertino?.navBarHeight ?? navBarHeight,
        // key: Not used ignore
        // widgetKey: Not used ignore
        // material: Not used ignore
      ),
      controller: controller,
      backgroundColor: cupertino?.tabsBackgroundColor,
      resizeToAvoidBottomInset: cupertino?.resizeToAvoidBottomInset ?? true,
      tabBuilder: (context, index) => CupertinoTabView(
        // key Not used
        defaultTitle: cupertino?.tabViewDataBuilder?.call(context, index).defaultTitle,
        navigatorKey: cupertino?.tabViewDataBuilder?.call(context, index).navigatorKey,
        navigatorObservers:
            cupertino?.tabViewDataBuilder?.call(context, index).navigatorObservers ??
            const <NavigatorObserver>[],
        onGenerateRoute: cupertino?.tabViewDataBuilder?.call(context, index).onGenerateRoute,
        onUnknownRoute: cupertino?.tabViewDataBuilder?.call(context, index).onUnknownRoute,
        routes: cupertino?.tabViewDataBuilder?.call(context, index).routes,
        builder: (context) {
          final child =
              cupertino?.bodyBuilder?.call(context, index) ?? bodyBuilder?.call(context, index);

          assert(
            child != null,
            'bodyBuilder must return a non-null widget. '
            'Provide either cupertino.bodyBuilder or bodyBuilder that returns a valid widget for tab index $index.',
          );

          return CupertinoPageScaffold(
            backgroundColor: cupertino?.backgroundColor ?? pageBackgroundColor,
            resizeToAvoidBottomInset: cupertino?.resizeToAvoidBottomInset ?? true,
            //key Not used
            child: child!,
          );
        },
        restorationScopeId: cupertino?.restorationScopeIdTabView,
      ),
      restorationId: cupertino?.restorationId ?? restorationId,
    );
  }

  static Widget _defaultBottomSheetScrimBuilder(
    BuildContext context,
    Animation<double> animation,
  ) => AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final extentRemaining = _kBottomSheetDominatesPercentage * (1.0 - animation.value);
      final floatingButtonVisibilityValue = extentRemaining * _kBottomSheetDominatesPercentage * 10;

      final double opacity = math.max(
        _kMinBottomSheetScrimOpacity,
        _kMaxBottomSheetScrimOpacity - floatingButtonVisibilityValue,
      );

      // Flutter needs to migrate the method first
      //ignore: deprecated_member_use
      return ModalBarrier(dismissible: false, color: Colors.black.withOpacity(opacity));
    },
  );
}

class _MaterialTabBar extends StatelessWidget {
  final Color? backgroundColor;

  final List<BottomNavigationBarItem>? items;
  final ValueChanged<int>? itemChanged;
  final int? currentIndex;
  final double? height;

  final MaterialNavigationBarData? material3;

  const _MaterialTabBar({
    this.backgroundColor,
    this.items,
    this.itemChanged,
    this.currentIndex,
    this.height,
    this.material3,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = material3?.selectedIndex ?? currentIndex ?? 0;
    final destinations =
        material3?.items ??
        items
            ?.map(
              (item) => NavigationDestination(
                icon: item.icon,
                label: item.label ?? '',
                selectedIcon: item.activeIcon,
                tooltip: item.tooltip,
              ),
            )
            .toList() ??
        [];
    assert(
      destinations.length >= 2,
      'NavigationBar requires at least 2 destinations. '
      'Provide at least 2 items in the items list or material3.items list. '
      'Current destinations count: ${destinations.length}',
    );
    assert(
      0 <= selectedIndex && selectedIndex < destinations.length,
      'selectedIndex must be within the range of available destinations. '
      'Expected: 0 <= selectedIndex < ${destinations.length}, but got selectedIndex = $selectedIndex',
    );

    return NavigationBar(
      key: material3?.widgetKey,
      destinations: destinations,
      animationDuration: material3?.animationDuration,
      backgroundColor: material3?.backgroundColor ?? backgroundColor,
      elevation: material3?.elevation,
      height: material3?.height ?? height,
      indicatorColor: material3?.indicatorColor,
      indicatorShape: material3?.indicatorShape,
      labelBehavior: material3?.labelBehavior,
      onDestinationSelected: material3?.onDestinationSelected ?? itemChanged,
      selectedIndex: selectedIndex,
      shadowColor: material3?.shadowColor,
      surfaceTintColor: material3?.surfaceTintColor,
      overlayColor: material3?.overlayColor,
      labelPadding: material3?.labelPadding,
      labelTextStyle: material3?.labelTextStyle,
      maintainBottomViewPadding: material3?.maintainBottomViewPadding ?? false,
    );
  }
}

class _CupertinoTabBar extends CupertinoTabBar {
  // Standard iOS 10 tab bar height.
  static const _kTabBarHeight = 50.0;
  static const _kDefaultTabBarBorderColor = Color(0x4C000000);
  static const Color _kDefaultTabBarInactiveColor = CupertinoColors.inactiveGray;

  _CupertinoTabBar({
    Color? backgroundColor,
    List<BottomNavigationBarItem>? items,
    ValueChanged<int>? itemChanged,
    int? currentIndex,
    double? height,
    CupertinoTabBarData? cupertino,
  }) : super(
         items: cupertino?.items ?? items ?? const <BottomNavigationBarItem>[],
         activeColor: cupertino?.activeColor,
         backgroundColor: cupertino?.backgroundColor ?? backgroundColor,
         currentIndex: cupertino?.currentIndex ?? currentIndex ?? 0,
         iconSize: cupertino?.iconSize ?? 30.0,
         inactiveColor: cupertino?.inactiveColor ?? _kDefaultTabBarInactiveColor,
         key: cupertino?.widgetKey,
         onTap: cupertino?.itemChanged ?? itemChanged,
         border:
             cupertino?.border ??
             const Border(
               top: BorderSide(
                 color: _kDefaultTabBarBorderColor,
                 width: 0, // One physical pixel.
               ),
             ),
         height: cupertino?.height ?? height ?? _kTabBarHeight,
       );
}

const _kBottomSheetDominatesPercentage = 0.3;
const _kMinBottomSheetScrimOpacity = 0.1;
const _kMaxBottomSheetScrimOpacity = 0.6;

/// Data for a Material tab controller.
class MaterialTabControllerData {
  /// Creates a [MaterialTabControllerData].
  MaterialTabControllerData({this.initialIndex});

  /// The initial index of the tab controller.
  final int? initialIndex;
}

/// Data for a Cupertino tab controller.
class CupertinoTabControllerData {
  /// Creates a [CupertinoTabControllerData].
  CupertinoTabControllerData({this.initialIndex});

  /// The initial index of the tab controller.
  final int? initialIndex;
}

/// A controller for a Material tab bar.
class MaterialTabController extends ChangeNotifier {
  /// Creates a [MaterialTabController].
  MaterialTabController({int initialIndex = 0})
    : _index = initialIndex,
      assert(
        initialIndex >= 0,
        'initialIndex must be non-negative. Got initialIndex = $initialIndex',
      );

  /// The index of the currently selected tab.
  int get index => _index;
  int _index;

  set index(int value) {
    assert(value >= 0, 'Tab index must be non-negative. Got index = $value');
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }
}

// In the same file so that the private android or ios controllers can be accessed
/// A controller for a platform-adaptive tab bar.
class PlatformTabController extends ChangeNotifier {
  MaterialTabController? _materialController;
  CupertinoTabController? _cupertinoController;

  /// Android-specific data for the tab controller.
  final MaterialTabControllerData? android;

  /// iOS-specific data for the tab controller.
  final CupertinoTabControllerData? ios;

  final int _initialIndex;

  /// Creates a [PlatformTabController].
  PlatformTabController({int initialIndex = 0, this.android, this.ios})
    : _initialIndex = initialIndex,
      assert(
        initialIndex >= 0,
        'initialIndex must be non-negative. Got initialIndex = $initialIndex',
      );

  CupertinoTabController? _cupertino() {
    _init();

    return _cupertinoController;
  }

  MaterialTabController? _material() {
    _init();

    return _materialController;
  }

  /// Returns the index of the currently selected tab.
  int index() {
    _init();

    return _materialController?.index ?? _cupertinoController?.index ?? 0;
  }

  /// Sets the index of the currently selected tab.
  void setIndex(int index) {
    assert(index >= 0, 'Tab index must be non-negative. Got index = $index');

    _init();

    _materialController?.index = index;
    _cupertinoController?.index = index;
  }

  void _init() {
    switch (targetPlatform) {
      case .android:
        var useIndex = android?.initialIndex ?? _initialIndex;
        if (_cupertinoController != null) {
          useIndex = _cupertinoController?.index ?? 0;

          _cupertinoController?.removeListener(_listener);
          _cupertinoController?.dispose();
          _cupertinoController = null;
        }
        _materialController = MaterialTabController(initialIndex: useIndex)..addListener(_listener);
      case .iOS:
        if (_cupertinoController == null) {
          var useIndex = ios?.initialIndex ?? _initialIndex;
          if (_materialController != null) {
            useIndex = _materialController?.index ?? 0;

            _materialController?.removeListener(_listener);
            _materialController?.dispose();
            _materialController = null;
          }

          _cupertinoController = CupertinoTabController(initialIndex: useIndex)
            ..addListener(_listener);
        }
      case _:
        throw UnimplementedError();
    }
  }

  void _listener() {
    notifyListeners();
  }

  @override
  void dispose() {
    _materialController?.removeListener(_listener);
    _materialController?.dispose();
    _materialController = null;
    _cupertinoController?.removeListener(_listener);
    _cupertinoController?.dispose();
    _cupertinoController = null;
    super.dispose();
  }
}
