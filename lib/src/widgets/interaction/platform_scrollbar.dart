import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoScrollbar;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Scrollbar;

import '/src/models/interaction/platform_scrollbar_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [Scrollbar] on Android, [CupertinoScrollbar] on iOS.
///
/// Wraps a [child] scroll view and rides its [ScrollController]. Per-platform tuning lives in [materialScrollbarData]
/// / [cupertinoScrollbarData]. See `APPENDIX.md#field-classification`.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_scrollbar.dart#platform_scrollbar}
class const PlatformScrollbar({
  required super.child,

  final ScrollController? controller,

  /// Pins the thumb on screen. Left out, it fades away like the platform normally does.
  final bool? thumbVisibility,

  /// Which scroll notifications the bar reacts to. Left out, each platform brings its own rule.
  final ScrollNotificationPredicate? notificationPredicate,

  final double? thickness,

  /// Rounds the thumb's ends.
  final Radius? radius,

  final ScrollbarOrientation? scrollbarOrientation,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialScrollbarData? materialScrollbarData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoScrollbarData? cupertinoScrollbarData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBuilderBase {
  /// Creates a platform-adaptive scrollbar.
  this;

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
