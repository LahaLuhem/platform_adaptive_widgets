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
import 'package:flutter/foundation.dart';
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

import '../../models/platform_widget_base.dart';
import 'platform_app_bar.dart';

abstract class _BaseScaffoldOriginalData {
  _BaseScaffoldOriginalData({this.widgetKey, this.backgroundColor});

  final Color? backgroundColor;
  final Key? widgetKey;
}

class MaterialTabScaffoldOriginalData extends _BaseScaffoldOriginalData {
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

  final Widget Function(BuildContext context, int index)? bodyBuilder;
  final MaterialTabController? controller;
  final PreferredSizeWidget? Function(BuildContext context, int index)? appBarBuilder;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final bool? primary;
  final Widget? bottomSheet;
  final DragStartBehavior? drawerDragStartBehavior;
  final bool? extendBody;
  final bool? resizeToAvoidBottomInset;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool? extendBodyBehindAppBar;
  final Color? tabsBackgroundColor;
  final bool? drawerEnableOpenDragGesture;
  final bool? endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;
  final AlignmentDirectional? persistentFooterAlignment;
  final double? height;
  final Widget? Function(BuildContext, Animation<double>)? bottomSheetScrimBuilder;
  final bool? drawerBarrierDismissible;
  final BoxDecoration? persistentFooterDecoration;
}

abstract class _BaseTabBarData {
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

  final Key? widgetKey;
  final List<BottomNavigationBarItem>? items;
  final Color? backgroundColor;
  final double? iconSize;
  final Color? activeColor;
  final int? currentIndex;
  final void Function(int)? itemChanged;
  final double? height;
}

class CupertinoTabViewData {
  CupertinoTabViewData({
    this.defaultTitle,
    this.navigatorKey,
    this.navigatorObservers,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.routes,
  });

  final String? defaultTitle;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<NavigatorObserver>? navigatorObservers;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final Map<String, WidgetBuilder>? routes;
}

class CupertinoTabScaffoldOriginalData extends _BaseScaffoldOriginalData {
  CupertinoTabScaffoldOriginalData({
    super.backgroundColor,
    super.widgetKey,
    this.items,
    this.bodyBuilder,
    this.appBarBuilder,
    this.tabViewDataBuilder,
    this.useCupertinoTabView = true,
    this.resizeToAvoidBottomInset,
    this.resizeToAvoidBottomInsetTab,
    this.tabsBackgroundColor,
    this.controller,
    this.restorationId,
    this.restorationScopeIdTabView,
    this.navBarHeight,
  });

  final List<BottomNavigationBarItem>? items;

  final CupertinoTabViewData Function(BuildContext context, int index)? tabViewDataBuilder;

  final Widget Function(BuildContext context, int index)? bodyBuilder;
  final ObstructingPreferredSizeWidget? Function(BuildContext context, int index)? appBarBuilder;
  final bool? resizeToAvoidBottomInset;
  final bool? resizeToAvoidBottomInsetTab;
  final Color? tabsBackgroundColor;
  final CupertinoTabController? controller;
  final bool? useCupertinoTabView;
  final String? restorationId;
  final String? restorationScopeIdTabView;
  final double? navBarHeight;
}

class CupertinoTabBarData extends _BaseTabBarData {
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

  final Color? inactiveColor;
  final Border? border;
}

class MaterialNavigationBarData {
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

  final Key? widgetKey;
  final List<NavigationDestination>? items;
  final double? height;
  final Duration? animationDuration;
  final Color? backgroundColor;
  final double? elevation;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final ValueChanged<int>? onDestinationSelected;
  final int? selectedIndex;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final EdgeInsetsGeometry? labelPadding;
  final WidgetStateProperty<TextStyle?>? labelTextStyle;
  final bool? maintainBottomViewPadding;
}

class MaterialNavBarData extends _BaseTabBarData {
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

  final double? selectedFontSize;
  final double? elevation;
  final BottomNavigationBarType? type;
  final Key? bottomNavigationBarKey;
  final NotchedShape? shape;
  final Clip? clipBehavior;
  final double? notchMargin;
  final Color? selectedItemColor;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final double? unselectedFontSize;
  final Color? unselectedItemColor;
  final IconThemeData? selectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? unselectedLabelStyle;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;
  final bool useLegacyColorScheme;
  final EdgeInsetsGeometry? padding;
  final Color? surfaceTintColor;
  final Color? shadowColor;
}

/// Exists as a temporary solution for [not working with go-router issue](https://github.com/flutter/flutter/issues/113757)
class PlatformTabScaffoldOriginal extends PlatformWidgetBase {
  final Key? widgetKey;

  final Widget Function(BuildContext context, int index)? bodyBuilder;
  final Color? pageBackgroundColor;
  final Color? tabsBackgroundColor;
  final void Function(int index)? itemChanged;

  final MaterialTabScaffoldOriginalData? material;
  final MaterialTabScaffoldOriginalData Function(int index)? materialBuilder;

  final MaterialNavBarData? materialTabs;
  final MaterialNavigationBarData? material3Tabs;

  final CupertinoTabScaffoldOriginalData? cupertino;
  final CupertinoTabScaffoldOriginalData? Function(int index)? cupertinoBuilder;

  final CupertinoTabBarData? cupertinoTabs;

  final bool iosContentPadding;
  final bool iosContentBottomPadding;

  final PlatformTabController? tabController;

  final List<BottomNavigationBarItem>? items;

  final PlatformAppBar? Function(BuildContext context, int index)? appBarBuilder;

  final String? restorationId;
  final double? navBarHeight;

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
    this.iosContentPadding = false,
    this.iosContentBottomPadding = false,
    this.restorationId,
    this.navBarHeight,
    this.material,
    this.materialBuilder,
    this.materialTabs,
    this.material3Tabs,
    this.cupertino,
    this.cupertinoBuilder,
    this.cupertinoTabs,
  }) : assert((material != null && materialBuilder == null) || material == null),
       assert((material == null && materialBuilder != null) || materialBuilder == null),
       assert((cupertino != null && cupertinoBuilder == null) || cupertino == null),
       assert((cupertino == null && cupertinoBuilder != null) || cupertinoBuilder == null);

  @override
  Widget buildMaterial(BuildContext context) {
    final data = material;

    final controller = data?.controller ?? tabController?._material(context);

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
    final data = cupertino;

    final controller = data?.controller ?? tabController?._cupertino(context);

    assert(
      controller != null,
      'CupertinoTabController cannot be null. '
      'Either have material: (_, __) => CupertinoTabScaffoldData(controller: controller) or '
      'PlatformTabScaffold(tabController: controller) ',
    );

    if (cupertinoBuilder == null) {
      return _buildCupertino(context, data, controller!);
    } else {
      return AnimatedBuilder(
        animation: controller!,
        builder: (context, _) =>
            _buildCupertino(context, cupertinoBuilder?.call(controller.index), controller),
      );
    }
  }

  Widget _buildCupertino(
    BuildContext context,
    CupertinoTabScaffoldOriginalData? data,
    CupertinoTabController controller,
  ) {
    final tabBar = _CupertinoTabBar(
      items: items,
      backgroundColor: tabsBackgroundColor,
      currentIndex: controller.index,
      itemChanged: itemChanged,
      cupertino: cupertinoTabs,
      height: data?.navBarHeight ?? navBarHeight,
      // key: Not used ignore
      // widgetKey: Not used ignore
      // material: Not used ignore
    );

    final result = CupertinoTabScaffold(
      key: widgetKey,
      tabBar: tabBar,
      controller: controller,
      backgroundColor: data?.tabsBackgroundColor,
      resizeToAvoidBottomInset: data?.resizeToAvoidBottomInset ?? true,
      tabBuilder: (context, index) {
        if (data?.useCupertinoTabView ?? false) {
          return CupertinoTabView(
            // key Not used
            defaultTitle: data?.tabViewDataBuilder?.call(context, index).defaultTitle,
            navigatorKey: data?.tabViewDataBuilder?.call(context, index).navigatorKey,
            navigatorObservers:
                data?.tabViewDataBuilder?.call(context, index).navigatorObservers ??
                const <NavigatorObserver>[],
            onGenerateRoute: data?.tabViewDataBuilder?.call(context, index).onGenerateRoute,
            onUnknownRoute: data?.tabViewDataBuilder?.call(context, index).onUnknownRoute,
            routes: data?.tabViewDataBuilder?.call(context, index).routes,
            builder: (context) => _buildCupertinoPageScaffold(context, index, data, tabBar),
            restorationScopeId: data?.restorationScopeIdTabView,
          );
        }

        return _buildCupertinoPageScaffold(context, index, data, tabBar);
      },
      restorationId: data?.restorationId ?? restorationId,
    );

    // Ensure that there is Material widget at the root page level
    // as there can be Material widgets used on ios
    return result;
  }

  CupertinoPageScaffold _buildCupertinoPageScaffold(
    BuildContext context,
    int index,
    CupertinoTabScaffoldOriginalData? data,
    CupertinoTabBar tabBar,
  ) {
    final child = data?.bodyBuilder?.call(context, index) ?? bodyBuilder?.call(context, index);

    assert(child != null);

    return CupertinoPageScaffold(
      //key Not used
      child: iosContentPad(context, child!, tabBar),
      backgroundColor: data?.backgroundColor ?? pageBackgroundColor,
      resizeToAvoidBottomInset: data?.resizeToAvoidBottomInset ?? true,
    );
  }

  Widget iosContentPad(BuildContext context, Widget child, CupertinoTabBar tabBar) {
    final existingMediaQuery = MediaQuery.of(context);

    if (!iosContentPadding && !iosContentBottomPadding) {
      return child;
    }

    double top = 0;
    double bottom = 0;

    if (iosContentBottomPadding) {
      bottom = existingMediaQuery.padding.bottom;
    }

    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: child,
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
    final data = material3;
    final selectedIndex = data?.selectedIndex ?? currentIndex ?? 0;
    final destinations =
        data?.items ??
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
    assert(destinations.length >= 2);
    assert(0 <= selectedIndex && selectedIndex < destinations.length);

    return NavigationBar(
      key: data?.widgetKey,
      destinations: destinations,
      animationDuration: data?.animationDuration,
      backgroundColor: data?.backgroundColor ?? backgroundColor,
      elevation: data?.elevation,
      height: data?.height ?? height,
      indicatorColor: data?.indicatorColor,
      indicatorShape: data?.indicatorShape,
      labelBehavior: data?.labelBehavior,
      onDestinationSelected: data?.onDestinationSelected ?? itemChanged,
      selectedIndex: selectedIndex,
      shadowColor: data?.shadowColor,
      surfaceTintColor: data?.surfaceTintColor,
      overlayColor: data?.overlayColor,
      labelPadding: data?.labelPadding,
      labelTextStyle: data?.labelTextStyle,
      maintainBottomViewPadding: data?.maintainBottomViewPadding ?? false,
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

class MaterialTabControllerData {
  MaterialTabControllerData({this.initialIndex});

  final int? initialIndex;
}

class CupertinoTabControllerData {
  CupertinoTabControllerData({this.initialIndex});

  final int? initialIndex;
}

class MaterialTabController extends ChangeNotifier {
  MaterialTabController({int initialIndex = 0}) : _index = initialIndex, assert(initialIndex >= 0);

  int get index => _index;
  int _index;

  set index(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }
}

// In the same file so that the private android or ios controllers can be accessed
class PlatformTabController extends ChangeNotifier {
  MaterialTabController? _materialController;
  CupertinoTabController? _cupertinoController;

  final MaterialTabControllerData? android;
  final CupertinoTabControllerData? ios;

  final int _initialIndex;

  PlatformTabController({int initialIndex = 0, this.android, this.ios})
    : _initialIndex = initialIndex,
      assert(initialIndex >= 0);

  CupertinoTabController? _cupertino(BuildContext context) {
    _init();
    return _cupertinoController;
  }

  MaterialTabController? _material(BuildContext context) {
    _init();
    return _materialController;
  }

  int index(BuildContext context) {
    _init();

    return _materialController?.index ?? _cupertinoController?.index ?? 0;
  }

  void setIndex(BuildContext context, int index) {
    assert(index >= 0);

    _init();

    _materialController?.index = index;
    _cupertinoController?.index = index;
  }

  void _init() {
    switch (defaultTargetPlatform) {
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
