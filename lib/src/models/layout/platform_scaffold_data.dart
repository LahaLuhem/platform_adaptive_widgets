// Signature matching
// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: prefer-match-file-name

import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show Colors, FloatingActionButtonAnimator, FloatingActionButtonLocation;

/// Default value for whether scaffold should resize to avoid bottom inset.
/// Read by both `PlatformScaffold` and `PlatformTabScaffold`.
const kDefaultResizeToAvoidBottomInset = true;

/// Shared-visual base for the per-platform scaffold records.
///
/// Holds only [backgroundColor] — the one scaffold property that exists on
/// both platforms and that a caller may reasonably want to differ per platform.
/// Everything functional (`body`, `resizeToAvoidBottomInset`, `widgetKey`) is
/// flat on `PlatformScaffold`, the single source of truth.
///
/// Private — [MaterialScaffoldData] and [CupertinoScaffoldData] inherit
/// [backgroundColor] via `super`-forwarding; never constructed or exported
/// directly.
base class _PlatformScaffoldData {
  /// Background color of the scaffold.
  final Color? backgroundColor;

  /// Creates platform scaffold data with the shared-visual properties.
  const _PlatformScaffoldData({this.backgroundColor});
}

/// Material-specific scaffold data.
///
/// Contains properties specific to Material Design `Scaffold` widgets. Shared
/// content (`body`, `resizeToAvoidBottomInset`, `widgetKey`) is flat on
/// `PlatformScaffold`.
base class MaterialScaffoldData extends _PlatformScaffoldData {
  /// The app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The floating action button to display.
  final Widget? floatingActionButton;

  /// The location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// The animator for the floating action button.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Buttons to display at the bottom of the scaffold.
  final List<Widget>? persistentFooterButtons;

  /// Alignment for the persistent footer buttons.
  final AlignmentDirectional persistentFooterAlignment;

  /// Decoration for the persistent footer buttons area.
  final BoxDecoration? persistentFooterDecoration;

  /// The drawer to display from the left side.
  final Widget? drawer;

  /// Callback when the drawer state changes.
  final void Function(bool)? onDrawerChanged;

  /// The drawer to display from the right side.
  final Widget? endDrawer;

  /// Callback when the end drawer state changes.
  final void Function(bool)? onEndDrawerChanged;

  /// The bottom sheet to display.
  final Widget? bottomSheet;

  /// The bottom navigation bar (or bottom app bar) to display.
  ///
  /// Material-only — `CupertinoPageScaffold` has no equivalent slot. For an
  /// iOS tab bar, use `PlatformTabScaffold`; this slot is for a plain
  /// `Scaffold`'s bottom bar (e.g. a `BottomAppBar` with a FAB notch).
  final Widget? bottomNavigationBar;

  /// Whether this scaffold is the primary scaffold.
  final bool primary;

  /// The drag start behavior for the drawer.
  final DragStartBehavior drawerDragStartBehavior;

  /// Whether to extend the body behind the app bar.
  final bool extendBody;

  /// Whether the drawer barrier can be dismissed.
  final bool drawerBarrierDismissible;

  /// Whether to extend the body behind the app bar.
  final bool extendBodyBehindAppBar;

  /// Color of the scrim that appears behind the drawer.
  final Color? drawerScrimColor;

  /// Builder for the scrim that appears behind bottom sheets.
  final Widget? Function(BuildContext, Animation<double>)? bottomSheetScrimBuilder;

  /// Width of the area that responds to drawer drag gestures.
  final double? drawerEdgeDragWidth;

  /// Whether the drawer can be opened with a drag gesture.
  final bool drawerEnableOpenDragGesture;

  /// Whether the end drawer can be opened with a drag gesture.
  final bool endDrawerEnableOpenDragGesture;

  /// Restoration ID for saving and restoring scaffold state.
  final String? restorationId;

  /// Default value for persistent footer alignment.
  static const kDefaultPersistentFooterAlignment = AlignmentDirectional.centerEnd;

  /// Default value for primary scaffold.
  static const kPrimary = true;

  /// Default value for drawer drag start behavior.
  static const kDrawerDragStartBehavior = DragStartBehavior.start;

  /// Default value for extend body.
  static const kExtendBody = false;

  /// Default value for drawer barrier dismissible.
  static const kDrawerBarrierDismissible = true;

  /// Default value for extend body behind app bar.
  static const kExtendBodyBehindAppBar = false;

  /// Default value for drawer enable open drag gesture.
  static const kDrawerEnableOpenDragGesture = true;

  /// Default value for end drawer enable open drag gesture.
  static const kEndDrawerEnableOpenDragGesture = true;

  /// Default builder for the scrim that appears behind bottom sheets.
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

  /// Creates Material-specific scaffold data.
  const MaterialScaffoldData({
    super.backgroundColor,
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
    this.bottomNavigationBar,
    this.primary = kPrimary,
    this.drawerDragStartBehavior = kDrawerDragStartBehavior,
    this.extendBody = kExtendBody,
    this.drawerBarrierDismissible = kDrawerBarrierDismissible,
    this.extendBodyBehindAppBar = kExtendBodyBehindAppBar,
    this.drawerScrimColor,
    this.bottomSheetScrimBuilder,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = kDrawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture = kEndDrawerEnableOpenDragGesture,
    this.restorationId,
  });
}

/// Cupertino-specific scaffold data.
///
/// Shared content (`body`, `resizeToAvoidBottomInset`, `widgetKey`) is flat on
/// `PlatformScaffold`.
base class CupertinoScaffoldData extends _PlatformScaffoldData {
  /// The navigation bar to display at the top of the scaffold.
  final ObstructingPreferredSizeWidget? navigationBar;

  /// Creates Cupertino-specific scaffold data.
  const CupertinoScaffoldData({super.backgroundColor, this.navigationBar});
}
