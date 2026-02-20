import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoScrollbar;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Scrollbar;

import '/src/models/interaction/platform_scrollbar_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive scrollbar that renders Material Scrollbar on Android
/// and CupertinoScrollbar on iOS.
///
/// This widget automatically selects the appropriate scrollbar implementation based on the target platform:
/// - On Android: renders Material Design Scrollbar
/// - On iOS: renders CupertinoScrollbar
///
/// The scrollbar can be configured with platform-specific data through [materialScrollbarData]
/// and [cupertinoScrollbarData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformScrollbar(
///   controller: _scrollController,
///   thumbVisibility: true,
///   child: SingleChildScrollView(
///     controller: _scrollController,
///     child: Text('Scrollable content'),
///   ),
/// )
/// ```
class PlatformScrollbar extends PlatformWidgetKeyedBuilderBase {
  /// The scroll controller to attach the scrollbar to.
  final ScrollController? controller;

  /// Whether the scrollbar thumb should be visible.
  final bool? thumbVisibility;

  /// The thickness of the scrollbar.
  final double? thickness;

  /// The radius of the scrollbar corners.
  final Radius? radius;

  /// Predicate for determining which scroll notifications to respond to.
  final ScrollNotificationPredicate? notificationPredicate;

  /// The orientation of the scrollbar.
  final ScrollbarOrientation? scrollbarOrientation;

  /// Material-specific scrollbar data.
  final MaterialScrollbarData? materialScrollbarData;

  /// Cupertino-specific scrollbar data.
  final CupertinoScrollbarData? cupertinoScrollbarData;

  /// Creates a platform-adaptive scrollbar.
  ///
  /// The scrollbar will render as a Material Scrollbar on Android and a CupertinoScrollbar on iOS.
  const PlatformScrollbar({
    required super.child,
    super.widgetKey,
    this.controller,
    this.thumbVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.scrollbarOrientation,
    this.materialScrollbarData,
    this.cupertinoScrollbarData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Scrollbar(
    key: widgetKey,
    controller: materialScrollbarData?.controller ?? controller,
    thumbVisibility: materialScrollbarData?.thumbVisibility ?? thumbVisibility,
    trackVisibility: materialScrollbarData?.trackVisibility,
    thickness: materialScrollbarData?.thickness ?? thickness,
    radius: materialScrollbarData?.radius ?? radius,
    notificationPredicate: materialScrollbarData?.notificationPredicate ?? notificationPredicate,
    interactive: materialScrollbarData?.interactive,
    scrollbarOrientation: materialScrollbarData?.scrollbarOrientation ?? scrollbarOrientation,
    child: child,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoScrollbar(
    key: widgetKey,
    controller: cupertinoScrollbarData?.controller ?? controller,
    thumbVisibility: cupertinoScrollbarData?.thumbVisibility ?? thumbVisibility,
    thickness:
        cupertinoScrollbarData?.thickness ?? thickness ?? CupertinoScrollbar.defaultThickness,
    thicknessWhileDragging:
        cupertinoScrollbarData?.thicknessWhileDragging ??
        CupertinoScrollbar.defaultThicknessWhileDragging,
    radius: cupertinoScrollbarData?.radius ?? radius ?? CupertinoScrollbar.defaultRadius,
    radiusWhileDragging:
        cupertinoScrollbarData?.radiusWhileDragging ??
        CupertinoScrollbar.defaultRadiusWhileDragging,
    notificationPredicate: cupertinoScrollbarData?.notificationPredicate ?? notificationPredicate,
    scrollbarOrientation: cupertinoScrollbarData?.scrollbarOrientation ?? scrollbarOrientation,
    mainAxisMargin:
        cupertinoScrollbarData?.mainAxisMargin ?? CupertinoScrollbarData.kScrollbarMainAxisMargin,
    child: child,
  );
}
