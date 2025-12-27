// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

abstract final class _PlatformScrollbarData {
  final Key? widgetKey;
  final Widget? child;
  final ScrollController? controller;
  final bool? thumbVisibility;
  final double? thickness;
  final Radius? radius;
  final ScrollNotificationPredicate? notificationPredicate;
  final ScrollbarOrientation? scrollbarOrientation;

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

final class MaterialScrollbarData extends _PlatformScrollbarData {
  final bool? trackVisibility;
  final bool? interactive;

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

final class CupertinoScrollbarData extends _PlatformScrollbarData {
  final double thicknessWhileDragging;
  final Radius radiusWhileDragging;
  final double? mainAxisMargin;

  static const kDefaultThickness = 3.0;
  static const kDefaultRadius = Radius.circular(1.5);
  static const kDefaultThicknessWhileDragging = 8.0;
  static const kDefaultRadiusWhileDragging = Radius.circular(4);
  static const kScrollbarMainAxisMargin = 3.0;

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
