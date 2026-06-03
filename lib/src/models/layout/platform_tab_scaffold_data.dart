// ignore_for_file: prefer-match-file-name

/// @docImport '/src/widgets/layout/platform_app_bar.dart';
/// @docImport '/src/widgets/layout/platform_scaffold.dart';
/// @docImport '/src/widgets/layout/platform_tab_scaffold.dart';
library;

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
///
/// A curated subclass of [MaterialScaffoldData].
///
/// **`appBar` is exposed — a Material-only capability.** Material permits a
/// persistent top app bar above tab content (a `Scaffold` with *both* an
/// `appBar` and a `bottomNavigationBar`), so a Material app can opt into one
/// unified bar across tabs. iOS has **no equivalent**: its HIG structures each
/// tab as an independent navigation stack with its own nav bar, and
/// `CupertinoTabScaffold` has no top-bar slot — so there is deliberately no
/// Cupertino counterpart. For the cross-platform-idiomatic shape (works on both
/// platforms), give each tab its own [PlatformScaffold] with its own
/// [PlatformAppBar] instead, and leave this `appBar` unset.
///
/// **`bottomNavigationBar` is omitted** — the tab scaffold owns that slot (it
/// builds the `NavigationBar`); exposing it would be a conflicting duplicate.
///
/// The tab inputs (selected index, destinations, callbacks, body builder) are
/// functional and live flat on [PlatformTabScaffold].
final class MaterialTabScaffoldData extends MaterialScaffoldData {
  /// Creates a [MaterialTabScaffoldData].
  const MaterialTabScaffoldData({
    super.appBar,
    super.backgroundColor,
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
    super.bottomSheetScrimBuilder,
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
  });
}
