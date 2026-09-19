// Signature matching
// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: prefer-match-file-name

import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show Colors, FloatingActionButtonAnimator, FloatingActionButtonLocation;

/// Default value for whether scaffold should resize to avoid bottom inset. Read by both `PlatformScaffold`
/// and `PlatformTabScaffold`.
const kDefaultResizeToAvoidBottomInset = true;

/// Shared-visual base for the 2 scaffold records, holding the one property worth varying per platform.
/// Everything else (`body`, `resizeToAvoidBottomInset`, `widgetKey`) stays flat on `PlatformScaffold`.
/// Private, never exported.
base class const _PlatformScaffoldData({final Color? backgroundColor});

/// Material-side settings for a platform scaffold, mapping onto `Scaffold`. The content itself stays
/// flat on `PlatformScaffold`.
base class const MaterialScaffoldData({
  super.backgroundColor,

  final PreferredSizeWidget? appBar,

  final Widget? floatingActionButton,

  final FloatingActionButtonLocation? floatingActionButtonLocation,

  /// How the button moves when its location changes.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator,

  /// Pinned along the bottom, above any [bottomNavigationBar].
  final List<Widget>? persistentFooterButtons,

  final AlignmentDirectional persistentFooterAlignment = kDefaultPersistentFooterAlignment,

  final BoxDecoration? persistentFooterDecoration,

  /// Slides in from the start edge.
  final Widget? drawer,

  /// Fires with `true` on open, `false` on close.
  final void Function(bool)? onDrawerChanged,

  /// Slides in from the end edge.
  final Widget? endDrawer,

  final void Function(bool)? onEndDrawerChanged,

  /// A sheet that stays put, unlike the one `showPlatformModalBottomSheet` puts up.
  final Widget? bottomSheet,

  /// `CupertinoPageScaffold` has no such slot. For an iOS tab bar reach for `PlatformTabScaffold`, this
  /// one is for a plain `Scaffold`'s bottom bar, a `BottomAppBar` with a FAB notch say.
  final Widget? bottomNavigationBar,

  /// Leaves room for the status bar.
  final bool primary = kPrimary,

  final DragStartBehavior drawerDragStartBehavior = kDrawerDragStartBehavior,

  /// Runs the body under the [bottomNavigationBar].
  final bool extendBody = kExtendBody,

  final bool drawerBarrierDismissible = kDrawerBarrierDismissible,

  /// Runs the body under the [appBar].
  final bool extendBodyBehindAppBar = kExtendBodyBehindAppBar,

  final Color? drawerScrimColor,

  final Widget? Function(BuildContext, Animation<double>)? bottomSheetScrimBuilder,

  /// How wide a strip along the edge starts a drawer drag.
  final double? drawerEdgeDragWidth,

  final bool drawerEnableOpenDragGesture = kDrawerEnableOpenDragGesture,

  final bool endDrawerEnableOpenDragGesture = kEndDrawerEnableOpenDragGesture,

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

  final ObstructingPreferredSizeWidget? navigationBar,
}) extends _PlatformScaffoldData {
  /// Creates Cupertino-side scaffold settings.
  this;
}
