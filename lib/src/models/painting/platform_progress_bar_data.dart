// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/painting/platform_progress_bar.dart';
library;

import 'package:flutter/widgets.dart';

/// Shared-visual fields for [PlatformProgressBar], forwarded into both records via `super.x`.
/// Private, never exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformProgressBarData({final Color? color});

/// Material-side settings for [PlatformProgressBar], passed as `materialProgressBarData`. The inherited
/// [color] overrides the widget's flat one on this branch. The rest has no Cupertino counterpart, since
/// Cupertino's bar draws a fixed track.
final class const MaterialProgressBarData({
  super.color,

  /// Fills the track behind the bar.
  final Color? backgroundColor,

  /// Animates the bar's own colour, overriding [color] while it runs.
  final Animation<Color?>? valueColor,

  final BorderRadiusGeometry? borderRadius,

  /// The dot at the end of the track, which M3 wants when the track is hard to see.
  final Color? stopIndicatorColor,

  final double? stopIndicatorRadius,

  /// Space between the filled part and the track behind it.
  final double? trackGap,
}) extends _PlatformProgressBarData {
  /// Creates Material-side settings for [PlatformProgressBar].
  this;
}

/// Cupertino-side settings for [PlatformProgressBar], passed as `cupertinoProgressBarData`. The inherited
/// [color] overrides the widget's flat one on this branch.
final class const CupertinoProgressBarData({super.color}) extends _PlatformProgressBarData {
  /// Creates Cupertino-side settings for [PlatformProgressBar].
  this;
}
