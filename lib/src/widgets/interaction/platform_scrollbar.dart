import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoScrollbar;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Scrollbar;

import '/src/models/interaction/platform_scrollbar_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive scrollbar that renders Material [Scrollbar] on
/// Android and [CupertinoScrollbar] on iOS.
///
/// Wraps a [child] scroll view and attaches to its [ScrollController]. All
/// functional inputs and shared visual defaults are flat parameters on the
/// widget; per-platform tuning is opt-in via [materialScrollbarData] and
/// [cupertinoScrollbarData]. See `APPENDIX.md#field-classification`.
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
  /// Scroll controller the scrollbar listens to.
  final ScrollController? controller;

  /// Whether the scrollbar thumb should be visible.
  ///
  /// Behavioral toggle — when `true`, the thumb is always visible; when
  /// `false` or `null`, the platform's default auto-hide behavior applies.
  final bool? thumbVisibility;

  /// Predicate for determining which scroll notifications to respond to.
  ///
  /// When `null`, each underlying platform widget applies its own default
  /// predicate.
  final ScrollNotificationPredicate? notificationPredicate;

  /// The thickness of the scrollbar.
  final double? thickness;

  /// The radius of the scrollbar corners.
  final Radius? radius;

  /// The orientation of the scrollbar.
  final ScrollbarOrientation? scrollbarOrientation;

  /// Material-only configuration. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Material branch; Material-only fields
  /// (`trackVisibility`, `interactive`) are read only from here.
  final MaterialScrollbarData? materialScrollbarData;

  /// Cupertino-only configuration. Optional.
  ///
  /// Fields set on this record override the widget's flat shared-visual
  /// defaults on the Cupertino branch; Cupertino-only fields
  /// (`thicknessWhileDragging`, `radiusWhileDragging`, `mainAxisMargin`)
  /// are read only from here.
  final CupertinoScrollbarData? cupertinoScrollbarData;

  /// Creates a platform-adaptive scrollbar.
  const PlatformScrollbar({
    required super.child,
    this.controller,
    this.thumbVisibility,
    this.notificationPredicate,
    this.thickness,
    this.radius,
    this.scrollbarOrientation,
    this.materialScrollbarData,
    this.cupertinoScrollbarData,
    super.widgetKey,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Scrollbar(
    key: widgetKey,
    controller: controller,
    thumbVisibility: thumbVisibility,
    notificationPredicate: notificationPredicate,
    thickness: materialScrollbarData?.thickness ?? thickness,
    radius: materialScrollbarData?.radius ?? radius,
    scrollbarOrientation: materialScrollbarData?.scrollbarOrientation ?? scrollbarOrientation,
    trackVisibility: materialScrollbarData?.trackVisibility,
    interactive: materialScrollbarData?.interactive,
    child: child,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoScrollbar(
    key: widgetKey,
    controller: controller,
    thumbVisibility: thumbVisibility,
    notificationPredicate: notificationPredicate,
    thickness:
        cupertinoScrollbarData?.thickness ?? thickness ?? CupertinoScrollbar.defaultThickness,
    radius: cupertinoScrollbarData?.radius ?? radius ?? CupertinoScrollbar.defaultRadius,
    scrollbarOrientation: cupertinoScrollbarData?.scrollbarOrientation ?? scrollbarOrientation,
    thicknessWhileDragging:
        cupertinoScrollbarData?.thicknessWhileDragging ??
        CupertinoScrollbar.defaultThicknessWhileDragging,
    radiusWhileDragging:
        cupertinoScrollbarData?.radiusWhileDragging ??
        CupertinoScrollbar.defaultRadiusWhileDragging,
    mainAxisMargin:
        cupertinoScrollbarData?.mainAxisMargin ?? kDefaultCupertinoScrollbarMainAxisMargin,
    child: child,
  );
}
