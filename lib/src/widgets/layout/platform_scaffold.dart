/// @docImport 'platform_app_bar.dart';
library;

import 'package:flutter/cupertino.dart' show CupertinoPageScaffold;
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';

import '/src/models/layout/platform_app_bar_data.dart';
import '/src/models/layout/platform_scaffold_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive scaffold that renders Material Scaffold on Android
/// and CupertinoPageScaffold on iOS.
///
/// This widget automatically selects the appropriate scaffold implementation based on the target platform:
/// - On Android: renders Material Design Scaffold
/// - On iOS: renders CupertinoPageScaffold
///
/// The scaffold can be configured with platform-specific data through [materialScaffoldData]
/// and [cupertinoScaffoldData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformScaffold(
///   appBarData: PlatformAppBarData(
///     title: Text('My App'),
///   ),
///   body: Center(child: Text('Hello World')),
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
  /// The scaffold will render as a Material Scaffold on Android and a CupertinoPageScaffold on iOS.
  /// [appBarData] has a premade implementation of [PlatformAppBar].
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
