// Signature matching
// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    show FloatingActionButtonAnimator, FloatingActionButtonLocation;
import 'package:flutter/widgets.dart';

const kDefaultResizeToAvoidBottomInset = true;

base class _BaseData {
  final Key? widgetKey;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Widget? body;

  const _BaseData({
    this.widgetKey,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
    this.body,
  });
}

@protected
base class MaterialScaffoldData extends _BaseData {
  final PreferredSizeWidget? appBar;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final BoxDecoration? persistentFooterDecoration;

  final Widget? drawer;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;

  final Widget? bottomSheet;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool drawerBarrierDismissible;
  final bool extendBodyBehindAppBar;

  final Color? drawerScrimColor;
  final Widget? Function(BuildContext, Animation<double>)? bottomSheetScrimBuilder;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  static const kDefaultPersistentFooterAlignment = AlignmentDirectional.centerEnd;
  static const kPrimary = true;
  static const kDrawerDragStartBehavior = DragStartBehavior.start;
  static const kExtendBody = false;
  static const kDrawerBarrierDismissible = true;
  static const kExtendBodyBehindAppBar = false;
  static const kDrawerEnableOpenDragGesture = true;
  static const kEndDrawerEnableOpenDragGesture = true;

  const MaterialScaffoldData({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = kDefaultPersistentFooterAlignment,
    this.persistentFooterDecoration,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomSheet,
    this.primary = kPrimary,
    this.drawerDragStartBehavior = kDrawerDragStartBehavior,
    this.extendBody = kExtendBody,
    this.drawerBarrierDismissible = kDrawerBarrierDismissible,
    this.extendBodyBehindAppBar = kExtendBodyBehindAppBar,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = kDrawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture = kEndDrawerEnableOpenDragGesture,
    this.restorationId,
  }) : bottomSheetScrimBuilder = null;

  const MaterialScaffoldData.withBottomSheetScrimBuilder({
    required this.bottomSheetScrimBuilder,
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = kDefaultPersistentFooterAlignment,
    this.persistentFooterDecoration,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomSheet,
    this.primary = kPrimary,
    this.drawerDragStartBehavior = kDrawerDragStartBehavior,
    this.extendBody = kExtendBody,
    this.drawerBarrierDismissible = kDrawerBarrierDismissible,
    this.extendBodyBehindAppBar = kExtendBodyBehindAppBar,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = kDrawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture = kEndDrawerEnableOpenDragGesture,
    this.restorationId,
  });
}

@protected
base class CupertinoScaffoldData extends _BaseData {
  final ObstructingPreferredSizeWidget? navigationBar;

  const CupertinoScaffoldData({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.body,
    this.navigationBar,
  });
}
