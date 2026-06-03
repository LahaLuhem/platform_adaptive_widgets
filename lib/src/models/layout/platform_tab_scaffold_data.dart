// ignore_for_file: prefer-match-file-name

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
/// A curated subclass of [MaterialScaffoldData]: it exposes the Material
/// `Scaffold` extras that make sense for a tab scaffold (FAB, drawers,
/// persistent footer, bottom sheet, …) but deliberately omits `appBar` and
/// `bottomNavigationBar` — a tab scaffold has no app bar and supplies its own
/// bottom navigation. The tab inputs (selected index, destinations, callbacks,
/// body builder) are functional and live flat on [PlatformTabScaffold].
final class MaterialTabScaffoldData extends MaterialScaffoldData {
  /// Creates a [MaterialTabScaffoldData].
  const MaterialTabScaffoldData({
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
