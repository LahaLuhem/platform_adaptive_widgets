// Multiple data classes in one file; private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/painting/platform_progress_indicator.dart';
library;

import 'package:flutter/widgets.dart';

/// Default value for [CupertinoProgressIndicatorData.animating].
const kDefaultProgressIndicatorAnimating = true;

/// Default value for [CupertinoProgressIndicatorData.radius].
const kDefaultProgressIndicatorRadius = 10.0;

/// Internal abstract base holding shared-visual fields for
/// [PlatformProgressIndicator].
///
/// Inherited by [MaterialProgressIndicatorData] and
/// [CupertinoProgressIndicatorData] so each per-platform record carries the
/// shared-visual surface via `super.x` constructor forwarding. Library-private
/// — never exported from the package.
///
/// See `APPENDIX.md#field-classification` for the rule placing shared-visual
/// fields on a private base.
abstract class _PlatformProgressIndicatorData {
  /// The color of the progress indicator.
  final Color? color;

  const _PlatformProgressIndicatorData({this.color});
}

/// Material-only configuration for [PlatformProgressIndicator].
///
/// Pass this via `PlatformProgressIndicator.materialProgressIndicatorData`
/// when tuning Material rendering. The inherited [color] field overrides the
/// widget's flat default on the Material branch; the fields declared here
/// have no Cupertino equivalent.
///
/// Houses both Material-only visual fields (`backgroundColor`, `strokeWidth`,
/// `padding`, etc.) and Material-only functional fields (`value`,
/// `controller`, `semanticsLabel`, `semanticsValue`) per the platform-only
/// bucket in `APPENDIX.md#field-classification` — Cupertino's activity
/// indicator exposes none of these.
final class MaterialProgressIndicatorData extends _PlatformProgressIndicatorData {
  /// The value of the progress indicator. `null` indicates indeterminate
  /// progress. Functional, but Material-only — Cupertino's activity
  /// indicator is always indeterminate.
  final double? value;

  /// The background color of the progress indicator.
  final Color? backgroundColor;

  /// The animation of the progress indicator's value.
  final Animation<Color?>? valueColor;

  /// The width of the stroke used to draw the indicator.
  final double? strokeWidth;

  /// The alignment of the stroke within the indicator's bounds.
  final double? strokeAlign;

  /// The semantic label for the progress indicator. Material-only —
  /// Cupertino auto-generates accessibility semantics for the spinner.
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

  /// The controller for the progress indicator's animation. Functional, but
  /// Material-only.
  final AnimationController? controller;

  /// Creates Material-only configuration for [PlatformProgressIndicator].
  const MaterialProgressIndicatorData({
    super.color,
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
  });
}

/// Cupertino-only configuration for [PlatformProgressIndicator].
///
/// Pass this via `PlatformProgressIndicator.cupertinoProgressIndicatorData`
/// when tuning Cupertino rendering. The inherited [color] field overrides
/// the widget's flat default on the Cupertino branch; the fields declared
/// here have no Material equivalent.
final class CupertinoProgressIndicatorData extends _PlatformProgressIndicatorData {
  /// Whether the progress indicator is animating. Functional toggle,
  /// Cupertino-only — Material's progress indicator has no animating-toggle
  /// equivalent. Defaults to [kDefaultProgressIndicatorAnimating].
  final bool animating;

  /// The radius of the progress indicator. Defaults to
  /// [kDefaultProgressIndicatorRadius].
  final double radius;

  /// Creates Cupertino-only configuration for [PlatformProgressIndicator].
  const CupertinoProgressIndicatorData({
    super.color,
    this.animating = kDefaultProgressIndicatorAnimating,
    this.radius = kDefaultProgressIndicatorRadius,
  });
}
