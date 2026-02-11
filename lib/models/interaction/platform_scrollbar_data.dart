// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

/// Common configuration for platform-adaptive scrollbars.
abstract final class _PlatformScrollbarData {
  /// A key to identify the widget.
  final Key? widgetKey;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The scroll controller that the scrollbar should listen to.
  final ScrollController? controller;

  /// Whether the scrollbar thumb should be visible.
  final bool? thumbVisibility;

  /// The thickness of the scrollbar thumb.
  final double? thickness;

  /// The radius of the scrollbar thumb's corners.
  final Radius? radius;

  /// A predicate to filter scroll notifications.
  final ScrollNotificationPredicate? notificationPredicate;

  /// The orientation of the scrollbar.
  final ScrollbarOrientation? scrollbarOrientation;

  /// Creates a [_PlatformScrollbarData].
  const _PlatformScrollbarData({
    this.widgetKey,
    this.child,
    this.controller,
    this.thumbVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.scrollbarOrientation,
  });
}

/// Material-specific configuration for a platform scrollbar.
///
/// Maps to properties of `Scrollbar` on Android.
final class MaterialScrollbarData extends _PlatformScrollbarData {
  /// Whether the scrollbar track is visible.
  final bool? trackVisibility;

  /// Whether the scrollbar is interactive (can be dragged).
  final bool? interactive;

  /// Creates Material-specific scrollbar configuration.
  const MaterialScrollbarData({
    super.widgetKey,
    super.child,
    super.controller,
    super.thumbVisibility,
    super.thickness,
    super.radius,
    super.scrollbarOrientation,
    this.trackVisibility,
    super.notificationPredicate,
    this.interactive,
  });
}

/// Cupertino-specific configuration for a platform scrollbar.
///
/// Maps to properties of `CupertinoScrollbar` on iOS.
final class CupertinoScrollbarData extends _PlatformScrollbarData {
  /// Thickness of the scrollbar while being dragged.
  final double thicknessWhileDragging;

  /// Radius of the scrollbar while being dragged.
  final Radius radiusWhileDragging;

  /// Margin along the main axis of the scrollbar.
  final double? mainAxisMargin;

  /// Default value for [thickness].
  static const kDefaultThickness = 3.0;

  /// Default value for [radius].
  static const kDefaultRadius = Radius.circular(1.5);

  /// Default value for [thicknessWhileDragging].
  static const kDefaultThicknessWhileDragging = 8.0;

  /// Default value for [radiusWhileDragging].
  static const kDefaultRadiusWhileDragging = Radius.circular(4);

  /// Default value for [mainAxisMargin].
  static const kScrollbarMainAxisMargin = 3.0;

  /// Creates Cupertino-specific scrollbar configuration.
  const CupertinoScrollbarData({
    super.widgetKey,
    super.child,
    super.controller,
    super.thumbVisibility,
    super.thickness = kDefaultThickness,
    super.radius = kDefaultRadius,
    super.notificationPredicate,
    super.scrollbarOrientation,
    this.thicknessWhileDragging = kDefaultThicknessWhileDragging,
    this.radiusWhileDragging = kDefaultRadiusWhileDragging,
    this.mainAxisMargin = kScrollbarMainAxisMargin,
  });
}
