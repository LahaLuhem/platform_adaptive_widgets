import 'package:flutter/cupertino.dart' show CupertinoScrollbar;
import 'package:flutter/material.dart' show Scrollbar;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_scrollbar_data.dart';
import '/models/platform_widget_base.dart';

class PlatformScrollbar extends PlatformWidgetKeyedBuilderBase {
  final ScrollController? controller;
  final bool? thumbVisibility;
  final double? thickness;
  final Radius? radius;
  final ScrollNotificationPredicate? notificationPredicate;
  final ScrollbarOrientation? scrollbarOrientation;

  final MaterialScrollbarData? materialScrollbarData;
  final CupertinoScrollbarData? cupertinoScrollbarData;
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
