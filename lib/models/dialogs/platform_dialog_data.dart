import 'package:flutter/widgets.dart';

import 'const_values.dart';

/// Platform-shared configuration for showing a dialog.
///
/// Contains common properties used by both Material and Cupertino dialogs.
final class PlatformDialogData {
  /// The anchor point for the dialog positioning.
  final Offset? anchorPoint;

  /// Color of the modal barrier behind the dialog.
  final Color? barrierColor;

  /// Whether tapping the barrier dismisses the dialog.
  final bool? barrierDismissible;

  /// Semantic label for the barrier.
  final String? barrierLabel;

  /// Whether the dialog should request focus when shown.
  final bool? requestFocus;

  /// Route settings for the dialog route.
  final RouteSettings? routeSettings;

  /// Whether to use the root navigator for the dialog route.
  final bool useRootNavigator;

  /// Creates platform dialog configuration.
  const PlatformDialogData({
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.requestFocus,
    this.routeSettings,
    this.useRootNavigator = kDefaultUseRootNavigator,
  });
}

/// Material-specific configuration for showing a dialog.
///
/// Extends [PlatformDialogData] with Material-only properties.
final class MaterialDialogData extends PlatformDialogData {
  /// Animation style for the dialog transition.
  final AnimationStyle? animationStyle;

  /// Whether the dialog is a fullscreen dialog.
  final bool fullscreenDialog;

  /// Traversal edge behavior for focus traversal.
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  /// Whether to wrap the dialog in a [SafeArea].
  final bool useSafeArea;

  /// Default value for [fullscreenDialog].
  static const kDefaultFullscreenDialog = false;

  /// Default value for [useSafeArea].
  static const kDefaultUseSafeArea = true;

  /// Creates Material-specific dialog configuration.
  const MaterialDialogData({
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.requestFocus,
    super.routeSettings,
    super.useRootNavigator,
    this.animationStyle,
    this.fullscreenDialog = kDefaultFullscreenDialog,
    this.traversalEdgeBehavior,
    this.useSafeArea = kDefaultUseSafeArea,
  });
}
