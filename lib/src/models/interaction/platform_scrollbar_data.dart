// Multiple data classes in one file. Private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_scrollbar.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoScrollbar;
import 'package:flutter/widgets.dart';

/// Fallback for [CupertinoScrollbarData.mainAxisMargin], the one Cupertino default with no public constant
/// upstream. The rest point at `CupertinoScrollbar.defaultX` so they track it themselves.
const kDefaultCupertinoScrollbarMainAxisMargin = 3.0;

/// Shared-visual fields for [PlatformScrollbar], forwarded into both records via `super.x`. Private,
/// never exported. See `APPENDIX.md#field-classification`.
abstract class const _PlatformScrollbarData({
  final double? thickness,

  final Radius? radius,

  final ScrollbarOrientation? scrollbarOrientation,
});

/// Material-side settings for [PlatformScrollbar], passed as `materialScrollbarData`. The inherited
/// shared-visual fields override the widget's flat ones on this branch, and everything declared here
/// has no Cupertino counterpart at all.
final class const MaterialScrollbarData({
  super.thickness,
  super.radius,
  super.scrollbarOrientation,

  /// Shows the groove the thumb runs in.
  final bool? trackVisibility,

  /// Lets the user drag the thumb, rather than only watch it.
  final bool? interactive,
}) extends _PlatformScrollbarData {
  /// Creates Material-side settings for [PlatformScrollbar].
  this;
}

/// Cupertino-side settings for [PlatformScrollbar], passed as `cupertinoScrollbarData`. Everything declared
/// here has no Material counterpart at all.
///
/// The inherited fields come in already set to iOS-idiomatic values, taken straight off [CupertinoScrollbar.defaultThickness]
/// and friends so an upstream change carries over on its own.
final class const CupertinoScrollbarData({
  super.thickness = CupertinoScrollbar.defaultThickness,
  super.radius = CupertinoScrollbar.defaultRadius,
  super.scrollbarOrientation,

  final double thicknessWhileDragging = CupertinoScrollbar.defaultThicknessWhileDragging,

  final Radius radiusWhileDragging = CupertinoScrollbar.defaultRadiusWhileDragging,

  /// Keeps the bar clear of the scroll view's ends.
  final double mainAxisMargin = kDefaultCupertinoScrollbarMainAxisMargin,
}) extends _PlatformScrollbarData {
  /// Creates Cupertino-side settings for [PlatformScrollbar].
  this;
}
