// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/painting/platform_progress_indicator.dart';
library;

import 'package:flutter/widgets.dart';

/// Default value for [CupertinoProgressIndicatorData.animating].
const kDefaultProgressIndicatorAnimating = true;

/// Default value for [CupertinoProgressIndicatorData.radius].
const kDefaultProgressIndicatorRadius = 10.0;

/// Shared-visual fields for [PlatformProgressIndicator], forwarded into both records via `super.x`.
/// Private, never exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformProgressIndicatorData({final Color? color});

/// Material-side settings for [PlatformProgressIndicator], passed as `materialProgressIndicatorData`.
/// The inherited [color] overrides the widget's flat one on this branch, and everything declared here
/// has no Cupertino counterpart, iOS's activity indicator being a much plainer thing.
final class const MaterialProgressIndicatorData({
  super.color,

  /// Leave it out for the spinning kind. iOS only does that kind.
  final double? value,

  /// Fills the track behind the bar.
  final Color? backgroundColor,

  /// Animates the bar's own colour, overriding [color] while it runs.
  final Animation<Color?>? valueColor,

  final double? strokeWidth,

  /// Whether the stroke sits inside, outside or centred on the indicator's edge.
  final double? strokeAlign,

  /// iOS writes its own, so this is Material's alone.
  final String? semanticsLabel,

  final String? semanticsValue,

  /// Rounds or squares off the ends of the stroke.
  final StrokeCap? strokeCap,

  final BoxConstraints? constraints,

  /// Space between the filled part and the track behind it.
  final double? trackGap,

  final EdgeInsetsGeometry? padding,

  /// Drives the animation yourself instead of letting it run free.
  final AnimationController? controller,
}) extends _PlatformProgressIndicatorData {
  /// Creates Material-side settings for [PlatformProgressIndicator].
  this;
}

/// Cupertino-side settings for [PlatformProgressIndicator], passed as `cupertinoProgressIndicatorData`.
/// The inherited [color] overrides the widget's flat one on this branch.
final class const CupertinoProgressIndicatorData({
  super.color,

  /// Freezes the spinner mid-turn when off. Material's has no such switch.
  final bool animating = kDefaultProgressIndicatorAnimating,

  final double radius = kDefaultProgressIndicatorRadius,
}) extends _PlatformProgressIndicatorData {
  /// Creates Cupertino-side settings for [PlatformProgressIndicator].
  this;
}
