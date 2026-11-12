// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show Colors, FloatingActionButtonAnimator, FloatingActionButtonLocation;

/// Default value for whether scaffold should resize to avoid bottom inset. Read by both `PlatformScaffold`
/// and `PlatformTabScaffold`.
const kDefaultResizeToAvoidBottomInset = true;

/// Default value for `useSafeArea` on `PlatformScaffold`, `showPlatformSheet` and `showPlatformFullscreenDialog`.
/// Off, so a list can scroll under an iOS bar.
const kDefaultUseSafeArea = false;

/// Shared-visual base for the 2 scaffold records, holding the one property worth varying per platform.
/// Everything else (`body`, `resizeToAvoidBottomInset`, `widgetKey`) stays flat on `PlatformScaffold`.
/// Private, never exported.
base class const _PlatformScaffoldData({final Color? backgroundColor});

/// Material-side settings for a platform scaffold, mapping onto `Scaffold`. The content itself stays
/// flat on `PlatformScaffold`.
base class const MaterialScaffoldData({
  super.backgroundColor,

  /// Forwards to [Scaffold.appBar].
  final PreferredSizeWidget? appBar,

  /// Forwards to [Scaffold.floatingActionButton].
  final Widget? floatingActionButton,

  /// Forwards to [Scaffold.floatingActionButtonLocation].
  final FloatingActionButtonLocation? floatingActionButtonLocation,

  /// How the button moves when its location changes.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator,

  /// Pinned along the bottom, above any [bottomNavigationBar].
  final List<Widget>? persistentFooterButtons,

  /// Forwards to [Scaffold.persistentFooterAlignment].
  final AlignmentDirectional persistentFooterAlignment = kDefaultPersistentFooterAlignment,

  /// Forwards to [Scaffold.persistentFooterDecoration].
  final BoxDecoration? persistentFooterDecoration,

  /// Slides in from the start edge.
  final Widget? drawer,

  /// Fires with `true` on open, `false` on close.
  final void Function(bool)? onDrawerChanged,

  /// Slides in from the end edge.
  final Widget? endDrawer,

  /// Forwards to [Scaffold.onEndDrawerChanged].
  final void Function(bool)? onEndDrawerChanged,

  /// A sheet that stays put, unlike the one `showPlatformSheet` puts up.
  final Widget? bottomSheet,

  /// `CupertinoPageScaffold` has no such slot. For a Cupertino tab bar reach for `PlatformTabScaffold`,
  /// this one is for a plain `Scaffold`'s bottom bar, a `BottomAppBar` with a FAB notch say.
  final Widget? bottomNavigationBar,

  /// Leaves room for the status bar.
  final bool primary = kPrimary,

  /// {@macro material_ui.DrawerController.dragStartBehavior}
  final DragStartBehavior drawerDragStartBehavior = kDrawerDragStartBehavior,

  /// Runs the body under the [bottomNavigationBar].
  final bool extendBody = kExtendBody,

  /// Forwards to [Scaffold.drawerBarrierDismissible].
  final bool drawerBarrierDismissible = kDrawerBarrierDismissible,

  /// Runs the body under the [appBar].
  final bool extendBodyBehindAppBar = kExtendBodyBehindAppBar,

  /// Forwards to [Scaffold.drawerScrimColor].
  final Color? drawerScrimColor,

  /// Forwards to [Scaffold.bottomSheetScrimBuilder].
  final Widget? Function(BuildContext, Animation<double>)? bottomSheetScrimBuilder,

  /// How wide a strip along the edge starts a drawer drag.
  final double? drawerEdgeDragWidth,

  /// Forwards to [Scaffold.drawerEnableOpenDragGesture].
  final bool drawerEnableOpenDragGesture = kDrawerEnableOpenDragGesture,

  /// Forwards to [Scaffold.endDrawerEnableOpenDragGesture].
  final bool endDrawerEnableOpenDragGesture = kEndDrawerEnableOpenDragGesture,

  /// Forwards to [Scaffold.restorationId].
  final String? restorationId,
}) extends _PlatformScaffoldData {
  /// Default value for [persistentFooterAlignment].
  static const kDefaultPersistentFooterAlignment = AlignmentDirectional.centerEnd;

  /// Default value for [primary].
  static const kPrimary = true;

  /// Default value for [drawerDragStartBehavior].
  static const kDrawerDragStartBehavior = DragStartBehavior.start;

  /// Default value for [extendBody].
  static const kExtendBody = false;

  /// Default value for [drawerBarrierDismissible].
  static const kDrawerBarrierDismissible = true;

  /// Default value for [extendBodyBehindAppBar].
  static const kExtendBodyBehindAppBar = false;

  /// Default value for [drawerEnableOpenDragGesture].
  static const kDrawerEnableOpenDragGesture = true;

  /// Default value for [endDrawerEnableOpenDragGesture].
  static const kEndDrawerEnableOpenDragGesture = true;

  /// Fades a scrim in behind a bottom sheet as it rises, so the content underneath recedes.
  static Widget kDefaultBottomSheetScrimBuilder(BuildContext _, Animation<double> animation) =>
      AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final extentRemaining = _kBottomSheetDominatesPercentage * (1.0 - animation.value);
          final floatingButtonVisibilityValue =
              extentRemaining * _kBottomSheetDominatesPercentage * 10;

          final double opacity = math.max(
            _kMinBottomSheetScrimOpacity,
            _kMaxBottomSheetScrimOpacity - floatingButtonVisibilityValue,
          );

          // Flutter needs to migrate the method first
          //ignore: deprecated_member_use
          return ModalBarrier(dismissible: false, color: Colors.black.withOpacity(opacity));
        },
      );
  static const _kBottomSheetDominatesPercentage = 0.3;
  static const _kMinBottomSheetScrimOpacity = 0.1;
  static const _kMaxBottomSheetScrimOpacity = 0.6;

  /// Creates Material-side scaffold settings.
  this;
}

/// Cupertino-side settings for a platform scaffold. The content itself stays flat on `PlatformScaffold`.
base class const CupertinoScaffoldData({
  super.backgroundColor,

  /// Forwards to [CupertinoPageScaffold.navigationBar].
  final ObstructingPreferredSizeWidget? navigationBar,
}) extends _PlatformScaffoldData {
  /// Creates Cupertino-side scaffold settings.
  this;
}
