/// @docImport 'platform_app_bar.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPageScaffold;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Scaffold;

import '/src/models/layout/platform_app_bar_data.dart';
import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive scaffold — Material `Scaffold` on Android,
/// `CupertinoPageScaffold` on iOS.
///
/// Shared content (`body`, `resizeToAvoidBottomInset`, `widgetKey`) is
/// functional and lives flat on this widget, single source of truth.
/// [backgroundColor] is shared-visual (per-platform override via
/// [MaterialScaffoldData.backgroundColor] / [CupertinoScaffoldData.backgroundColor]).
/// The rest of each platform's surface lives on [materialScaffoldData] /
/// [cupertinoScaffoldData].
///
/// [appBarData] is the cross-platform app bar (typically a [PlatformAppBar]);
/// it's wrapped to the right platform widget for each branch.
///
/// Example:
/// ```dart
/// PlatformScaffold(
///   appBarData: const PlatformAppBar(title: Text('My App')),
///   body: const Center(child: Text('Hello World')),
/// )
/// ```
class PlatformScaffold extends PlatformWidgetKeyedBase {
  /// Background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should resize to avoid the bottom inset.
  final bool resizeToAvoidBottomInset;

  /// The main content of the scaffold.
  final Widget body;

  /// Platform-shared app bar data.
  ///
  /// Has a premade implementation of [PlatformAppBar].
  final PlatformAppBarData? appBarData;

  /// Material-specific scaffold data.
  final MaterialScaffoldData? materialScaffoldData;

  /// Cupertino-specific scaffold data.
  final CupertinoScaffoldData? cupertinoScaffoldData;

  /// Creates a platform-adaptive scaffold.
  ///
  /// The scaffold renders as a Material `Scaffold` on Android and a
  /// `CupertinoPageScaffold` on iOS. [appBarData] has a premade implementation
  /// of [PlatformAppBar].
  const PlatformScaffold({
    required this.body,
    this.materialScaffoldData,
    this.cupertinoScaffoldData,
    this.appBarData,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) {
    // Shared values resolved once — both bottomSheetScrimBuilder branches below pass the identical set.
    final appBar = materialScaffoldData?.appBar ?? appBarData?.materialBuilder(context);
    final resolvedBackgroundColor = materialScaffoldData?.backgroundColor ?? backgroundColor;
    final persistentFooterAlignment =
        materialScaffoldData?.persistentFooterAlignment ??
        MaterialScaffoldData.kDefaultPersistentFooterAlignment;
    final primary = materialScaffoldData?.primary ?? MaterialScaffoldData.kPrimary;
    final drawerDragStartBehavior =
        materialScaffoldData?.drawerDragStartBehavior ??
        MaterialScaffoldData.kDrawerDragStartBehavior;
    final extendBody = materialScaffoldData?.extendBody ?? MaterialScaffoldData.kExtendBody;
    final drawerBarrierDismissible =
        materialScaffoldData?.drawerBarrierDismissible ??
        MaterialScaffoldData.kDrawerBarrierDismissible;
    final extendBodyBehindAppBar =
        materialScaffoldData?.extendBodyBehindAppBar ??
        MaterialScaffoldData.kExtendBodyBehindAppBar;
    final drawerEnableOpenDragGesture =
        materialScaffoldData?.drawerEnableOpenDragGesture ??
        MaterialScaffoldData.kDrawerEnableOpenDragGesture;
    final endDrawerEnableOpenDragGesture =
        materialScaffoldData?.endDrawerEnableOpenDragGesture ??
        MaterialScaffoldData.kEndDrawerEnableOpenDragGesture;

    // bottomSheetScrimBuilder is a non-null Scaffold param whose default is a
    // private SDK implementation we can't reference. When the caller doesn't
    // supply one, omit the param so Scaffold applies its own default — rather
    // than substitute a hand-rolled replica that could drift from the SDK.
    return materialScaffoldData?.bottomSheetScrimBuilder == null
        ? Scaffold(
            key: widgetKey,
            appBar: appBar,
            backgroundColor: resolvedBackgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            body: body,
            floatingActionButton: materialScaffoldData?.floatingActionButton,
            floatingActionButtonLocation: materialScaffoldData?.floatingActionButtonLocation,
            floatingActionButtonAnimator: materialScaffoldData?.floatingActionButtonAnimator,
            persistentFooterButtons: materialScaffoldData?.persistentFooterButtons,
            persistentFooterAlignment: persistentFooterAlignment,
            persistentFooterDecoration: materialScaffoldData?.persistentFooterDecoration,
            drawer: materialScaffoldData?.drawer,
            onDrawerChanged: materialScaffoldData?.onDrawerChanged,
            endDrawer: materialScaffoldData?.endDrawer,
            onEndDrawerChanged: materialScaffoldData?.onEndDrawerChanged,
            bottomSheet: materialScaffoldData?.bottomSheet,
            bottomNavigationBar: materialScaffoldData?.bottomNavigationBar,
            primary: primary,
            drawerDragStartBehavior: drawerDragStartBehavior,
            extendBody: extendBody,
            drawerBarrierDismissible: drawerBarrierDismissible,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            drawerScrimColor: materialScaffoldData?.drawerScrimColor,
            drawerEdgeDragWidth: materialScaffoldData?.drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
            restorationId: materialScaffoldData?.restorationId,
          )
        : Scaffold(
            key: widgetKey,
            appBar: appBar,
            backgroundColor: resolvedBackgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            body: body,
            floatingActionButton: materialScaffoldData?.floatingActionButton,
            floatingActionButtonLocation: materialScaffoldData?.floatingActionButtonLocation,
            floatingActionButtonAnimator: materialScaffoldData?.floatingActionButtonAnimator,
            persistentFooterButtons: materialScaffoldData?.persistentFooterButtons,
            persistentFooterAlignment: persistentFooterAlignment,
            persistentFooterDecoration: materialScaffoldData?.persistentFooterDecoration,
            drawer: materialScaffoldData?.drawer,
            onDrawerChanged: materialScaffoldData?.onDrawerChanged,
            endDrawer: materialScaffoldData?.endDrawer,
            onEndDrawerChanged: materialScaffoldData?.onEndDrawerChanged,
            bottomSheet: materialScaffoldData?.bottomSheet,
            bottomNavigationBar: materialScaffoldData?.bottomNavigationBar,
            primary: primary,
            drawerDragStartBehavior: drawerDragStartBehavior,
            extendBody: extendBody,
            drawerBarrierDismissible: drawerBarrierDismissible,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            drawerScrimColor: materialScaffoldData?.drawerScrimColor,
            bottomSheetScrimBuilder: materialScaffoldData!.bottomSheetScrimBuilder!,
            drawerEdgeDragWidth: materialScaffoldData?.drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
            restorationId: materialScaffoldData?.restorationId,
          );
  }

  @override
  Widget buildCupertino(BuildContext context) => CupertinoPageScaffold(
    key: widgetKey,
    navigationBar: cupertinoScaffoldData?.navigationBar ?? appBarData?.cupertinoBuilder(context),
    backgroundColor: cupertinoScaffoldData?.backgroundColor ?? backgroundColor,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    child: body,
  );
}
