// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

abstract final class _PlatformProgressIndicatorData {
  final Key? widgetKey;
  final Color? color;

  const _PlatformProgressIndicatorData({this.widgetKey, this.color});
}

final class MaterialProgressIndicatorData extends _PlatformProgressIndicatorData {
  final Key? key;
  final double? value;
  final Color? backgroundColor;

  final Animation<Color?>? valueColor;
  final double? strokeWidth;
  final double? strokeAlign;
  final String? semanticsLabel;
  final String? semanticsValue;
  final StrokeCap? strokeCap;
  final BoxConstraints? constraints;
  final double? trackGap;
  final EdgeInsetsGeometry? padding;
  final AnimationController? controller;

  const MaterialProgressIndicatorData({
    this.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth,
    this.strokeAlign,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
    this.constraints,
    this.trackGap,
    this.padding,
    this.controller,
    super.widgetKey,
    super.color,
  });
}

final class CupertinoProgressIndicatorData extends _PlatformProgressIndicatorData {
  final bool animating;
  final double radius;

  static const kDefaultAnimating = true;
  static const kDefaultIndicatorRadius = 10.0;

  const CupertinoProgressIndicatorData({
    this.animating = kDefaultAnimating,
    this.radius = kDefaultIndicatorRadius,
    super.widgetKey,
    super.color,
  });
}
