/// @docImport 'platform_app_bar.dart';
library;

import 'package:flutter/cupertino.dart' show CupertinoPageScaffold;
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';

import '/models/layout/platform_app_bar_data.dart';
import '/models/layout/platform_scaffold_data.dart';
import '/models/platform_widget_base.dart';

class PlatformScaffold extends PlatformWidgetKeyedBase {
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Widget body;

  final PlatformAppBarData? appBarData;
  final MaterialScaffoldData? materialScaffoldData;
  final CupertinoScaffoldData? cupertinoScaffoldData;

  /// [appBarData] has a premade implementation of [PlatformAppBar]
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
  Widget buildMaterial(BuildContext context) =>
      materialScaffoldData?.bottomSheetScrimBuilder == null
      ? Scaffold(
          key: widgetKey,
          appBar: materialScaffoldData?.appBar ?? appBarData?.materialBuilder(context),
          backgroundColor: materialScaffoldData?.backgroundColor ?? backgroundColor,
          resizeToAvoidBottomInset:
              materialScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
          body: materialScaffoldData?.body ?? body,
          floatingActionButton: materialScaffoldData?.floatingActionButton,
          floatingActionButtonLocation: materialScaffoldData?.floatingActionButtonLocation,
          floatingActionButtonAnimator: materialScaffoldData?.floatingActionButtonAnimator,
          persistentFooterButtons: materialScaffoldData?.persistentFooterButtons,
          persistentFooterAlignment:
              materialScaffoldData?.persistentFooterAlignment ??
              MaterialScaffoldData.kDefaultPersistentFooterAlignment,
          persistentFooterDecoration: materialScaffoldData?.persistentFooterDecoration,
          drawer: materialScaffoldData?.drawer,
          onDrawerChanged: materialScaffoldData?.onDrawerChanged,
          endDrawer: materialScaffoldData?.endDrawer,
          onEndDrawerChanged: materialScaffoldData?.onEndDrawerChanged,
          bottomSheet: materialScaffoldData?.bottomSheet,
          primary: materialScaffoldData?.primary ?? MaterialScaffoldData.kPrimary,
          drawerDragStartBehavior:
              materialScaffoldData?.drawerDragStartBehavior ??
              MaterialScaffoldData.kDrawerDragStartBehavior,
          extendBody: materialScaffoldData?.extendBody ?? MaterialScaffoldData.kExtendBody,
          drawerBarrierDismissible:
              materialScaffoldData?.drawerBarrierDismissible ??
              MaterialScaffoldData.kDrawerBarrierDismissible,
          extendBodyBehindAppBar:
              materialScaffoldData?.extendBodyBehindAppBar ??
              MaterialScaffoldData.kExtendBodyBehindAppBar,
          drawerScrimColor: materialScaffoldData?.drawerScrimColor,
          drawerEdgeDragWidth: materialScaffoldData?.drawerEdgeDragWidth,
          drawerEnableOpenDragGesture:
              materialScaffoldData?.drawerEnableOpenDragGesture ??
              MaterialScaffoldData.kDrawerEnableOpenDragGesture,
          endDrawerEnableOpenDragGesture:
              materialScaffoldData?.endDrawerEnableOpenDragGesture ??
              MaterialScaffoldData.kEndDrawerEnableOpenDragGesture,
          restorationId: materialScaffoldData?.restorationId,
        )
      : Scaffold(
          key: widgetKey,
          appBar: materialScaffoldData?.appBar ?? appBarData?.materialBuilder(context),
          backgroundColor: materialScaffoldData?.backgroundColor ?? backgroundColor,
          resizeToAvoidBottomInset:
              materialScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
          body: materialScaffoldData?.body ?? body,
          floatingActionButton: materialScaffoldData?.floatingActionButton,
          floatingActionButtonLocation: materialScaffoldData?.floatingActionButtonLocation,
          floatingActionButtonAnimator: materialScaffoldData?.floatingActionButtonAnimator,
          persistentFooterButtons: materialScaffoldData?.persistentFooterButtons,
          persistentFooterAlignment:
              materialScaffoldData?.persistentFooterAlignment ??
              MaterialScaffoldData.kDefaultPersistentFooterAlignment,
          persistentFooterDecoration: materialScaffoldData?.persistentFooterDecoration,
          drawer: materialScaffoldData?.drawer,
          onDrawerChanged: materialScaffoldData?.onDrawerChanged,
          endDrawer: materialScaffoldData?.endDrawer,
          onEndDrawerChanged: materialScaffoldData?.onEndDrawerChanged,
          bottomSheet: materialScaffoldData?.bottomSheet,
          primary: materialScaffoldData?.primary ?? MaterialScaffoldData.kPrimary,
          drawerDragStartBehavior:
              materialScaffoldData?.drawerDragStartBehavior ??
              MaterialScaffoldData.kDrawerDragStartBehavior,
          extendBody: materialScaffoldData?.extendBody ?? MaterialScaffoldData.kExtendBody,
          drawerBarrierDismissible:
              materialScaffoldData?.drawerBarrierDismissible ??
              MaterialScaffoldData.kDrawerBarrierDismissible,
          extendBodyBehindAppBar:
              materialScaffoldData?.extendBodyBehindAppBar ??
              MaterialScaffoldData.kExtendBodyBehindAppBar,
          drawerScrimColor: materialScaffoldData?.drawerScrimColor,
          bottomSheetScrimBuilder: materialScaffoldData!.bottomSheetScrimBuilder!,
          drawerEdgeDragWidth: materialScaffoldData?.drawerEdgeDragWidth,
          drawerEnableOpenDragGesture:
              materialScaffoldData?.drawerEnableOpenDragGesture ??
              MaterialScaffoldData.kDrawerEnableOpenDragGesture,
          endDrawerEnableOpenDragGesture:
              materialScaffoldData?.endDrawerEnableOpenDragGesture ??
              MaterialScaffoldData.kEndDrawerEnableOpenDragGesture,
          restorationId: materialScaffoldData?.restorationId,
        );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoPageScaffold(
    key: widgetKey,
    navigationBar: cupertinoScaffoldData?.navigationBar ?? appBarData?.cupertinoBuilder(context),
    backgroundColor: cupertinoScaffoldData?.backgroundColor ?? backgroundColor,
    resizeToAvoidBottomInset:
        cupertinoScaffoldData?.resizeToAvoidBottomInset ?? resizeToAvoidBottomInset,
    child: cupertinoScaffoldData?.body ?? body,
  );
}
