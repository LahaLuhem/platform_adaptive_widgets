// ignore_for_file: prefer-match-file-name

/// @docImport '/src/widgets/layout/platform_app_bar.dart';
/// @docImport '/src/widgets/layout/platform_scaffold.dart';
/// @docImport '/src/widgets/layout/platform_tab_scaffold.dart';
library;

import 'package:flutter/widgets.dart';

import 'platform_scaffold_data.dart';

/// One tab: its icons, its label, and the content behind it.
final class const TabDestination({
  required final Widget inactiveIcon,

  /// What the tab shows when it's the selected one.
  final Widget? view,

  /// Left out, [inactiveIcon] is used for both states.
  final Widget? activeIcon,

  final String label = '',

  final String? tooltip,

  final Key? key,
}) {
  //TODO(lahaluhem): account for material's `enabled` property
  /// Creates a [TabDestination].
  this;
}

/// Material-side settings for a tab scaffold, a trimmed-down [MaterialScaffoldData]. The tab inputs
/// themselves (selected index, destinations, callbacks, body builder) stay flat on [PlatformTabScaffold].
///
/// `appBar` survives the trim, which makes this lopsided on purpose. Material is happy to put one persistent
/// bar above every tab, iOS is not: its HIG gives each tab its own navigation stack and nav bar, and
/// `CupertinoTabScaffold` has no top-bar slot at all. So there's no Cupertino twin of this class. For
/// something that looks right on both, leave `appBar` alone and give each tab its own [PlatformScaffold]
/// and [PlatformAppBar].
///
/// `bottomNavigationBar` doesn't survive it. The tab scaffold builds the `NavigationBar` itself, so
/// a second one would only fight it.
final class const MaterialTabScaffoldData({
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
}) extends MaterialScaffoldData {
  /// Creates a [MaterialTabScaffoldData].
  this;
}
