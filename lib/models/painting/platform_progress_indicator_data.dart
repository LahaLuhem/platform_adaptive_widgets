// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

/// Common configuration for platform-adaptive progress indicators.
abstract final class _PlatformProgressIndicatorData {
  /// A key to identify the widget.
  final Key? widgetKey;

  /// The color of the progress indicator.
  final Color? color;

  /// Creates a [_PlatformProgressIndicatorData].
  const _PlatformProgressIndicatorData({this.widgetKey, this.color});
}

/// Material-specific configuration for a platform progress indicator.
final class MaterialProgressIndicatorData extends _PlatformProgressIndicatorData {
  /// A key to identify the widget.
  final Key? key;

  /// The value of the progress indicator. A value of null indicates an indeterminate progress indicator.
  final double? value;

  /// The background color of the progress indicator.
  final Color? backgroundColor;

  /// The animation of the progress indicator's value.
  final Animation<Color?>? valueColor;

  /// The width of the stroke used to draw the indicator.
  final double? strokeWidth;

  /// The alignment of the stroke within the indicator's bounds.
  final double? strokeAlign;

  /// The semantic label for the progress indicator.
  final String? semanticsLabel;

  /// The semantic value of the progress indicator.
  final String? semanticsValue;

  /// The shape of the progress indicator's stroke.
  final StrokeCap? strokeCap;

  /// The constraints to apply to the progress indicator.
  final BoxConstraints? constraints;

  /// The gap between the track and the indicator.
  final double? trackGap;

  /// The padding to apply to the progress indicator.
  final EdgeInsetsGeometry? padding;

  /// The controller for the progress indicator's animation.
  final AnimationController? controller;

  /// Creates a [MaterialProgressIndicatorData].
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

/// Cupertino-specific configuration for a platform progress indicator.
final class CupertinoProgressIndicatorData extends _PlatformProgressIndicatorData {
  /// Whether the progress indicator is animating.
  final bool animating;

  /// The radius of the progress indicator.
  final double radius;

  /// The default value for [animating].
  static const kDefaultAnimating = true;

  /// The default radius for the indicator.
  static const kDefaultIndicatorRadius = 10.0;

  /// Creates a [CupertinoProgressIndicatorData].
  const CupertinoProgressIndicatorData({
    this.animating = kDefaultAnimating,
    this.radius = kDefaultIndicatorRadius,
    super.widgetKey,
    super.color,
  });
}
