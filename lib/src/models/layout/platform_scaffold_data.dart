// Signature matching
// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: prefer-match-file-name

import 'dart:math' as math;

import 'package:flutter/cupertino.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    show Colors, FloatingActionButtonAnimator, FloatingActionButtonLocation;
import 'package:flutter/widgets.dart';

/// Default value for whether scaffold should resize to avoid bottom inset.
const kDefaultResizeToAvoidBottomInset = true;

/// Base class for platform scaffold data.
///
/// Contains common properties that apply to both Material and Cupertino scaffolds.
base class _PlatformScaffoldData {
  /// Optional key for the scaffold widget.
  final Key? widgetKey;

  /// Background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should resize to avoid the bottom inset.
  final bool resizeToAvoidBottomInset;

  /// The main content of the scaffold.
  final Widget? body;

  /// Creates platform scaffold data with common properties.
  const _PlatformScaffoldData({
    this.widgetKey,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = kDefaultResizeToAvoidBottomInset,
    this.body,
  });
}

/// Material-specific scaffold data.
///
/// Contains properties specific to Material Design Scaffold widgets.
@protected
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
    this.bottomSheetScrimBuilder,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = kDrawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture = kEndDrawerEnableOpenDragGesture,
    this.restorationId,
  });
}

/// Cupertino-specific scaffold data.
@protected
base class CupertinoScaffoldData extends _PlatformScaffoldData {
  /// The navigation bar to display at the top of the scaffold.
  final ObstructingPreferredSizeWidget? navigationBar;

  /// Creates Cupertino-specific scaffold data.
  const CupertinoScaffoldData({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.body,
    this.navigationBar,
  });
}
