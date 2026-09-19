/// @docImport 'platform_app_bar.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPageScaffold;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Scaffold;

import '/src/models/layout/platform_app_bar_data.dart';
import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material `Scaffold` on Android, `CupertinoPageScaffold` on iOS.
///
/// Per-platform tuning lives in [materialScaffoldData] / [cupertinoScaffoldData], which can also override
/// [backgroundColor] on one side alone.
///
/// Example:
/// {@example /example/lib/snippets/layout/platform_scaffold.dart#platform_scaffold}
class const PlatformScaffold({
  required final Widget body,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialScaffoldData? materialScaffoldData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoScaffoldData? cupertinoScaffoldData,

  /// The bar across the top. [PlatformAppBar] is the ready-made one, and gets unwrapped to the right
  /// widget on each branch.
  final PlatformAppBarData? appBarData,

  final Color? backgroundColor,

  /// Shrinks the body when the keyboard comes up, rather than letting it hide the bottom.
  final bool resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive scaffold.
  this;

  @override
  Widget buildMaterial(BuildContext context) {
    // Shared values resolved once, both bottomSheetScrimBuilder branches below pass the identical set.
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

    // Scaffold's own default for bottomSheetScrimBuilder is private, so the param is omitted rather
    // than filled with a copy of it that could drift.
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
