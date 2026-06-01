// Multiple data classes in one file; private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_scrollbar.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoScrollbar;
import 'package:flutter/widgets.dart';

/// Default value for [CupertinoScrollbarData.mainAxisMargin].
///
/// Cupertino's scrollbar has no public default for this field, so the
/// package owns the constant. The other Cupertino defaults reference
/// `CupertinoScrollbar.defaultX` directly.
const kDefaultCupertinoScrollbarMainAxisMargin = 3.0;

/// Internal abstract base holding shared-visual fields for
/// [PlatformScrollbar].
///
/// Inherited by [MaterialScrollbarData] and [CupertinoScrollbarData] so each
/// per-platform record carries the shared-visual surface via `super.x`
/// constructor forwarding. Library-private — never exported from the
/// package.
///
/// See `APPENDIX.md#field-classification` for the rule placing shared-visual
/// fields on a private base.
abstract class _PlatformScrollbarData {
  /// The thickness of the scrollbar thumb.
  final double? thickness;

  /// The radius of the scrollbar thumb's corners.
  final Radius? radius;

  /// The orientation of the scrollbar.
  final ScrollbarOrientation? scrollbarOrientation;

  const _PlatformScrollbarData({this.thickness, this.radius, this.scrollbarOrientation});
}

/// Material-only configuration for [PlatformScrollbar].
///
/// Pass this via `PlatformScrollbar.materialScrollbarData` when tuning
/// Material rendering. Inherited shared-visual fields override the widget's
/// flat defaults on the Material branch; the fields declared here have no
/// Cupertino equivalent.
final class MaterialScrollbarData extends _PlatformScrollbarData {
  /// Whether the scrollbar track is visible.
  final bool? trackVisibility;

  /// Whether the scrollbar is interactive (can be dragged).
  ///
  /// Functional behavioral toggle, but Material-only — Cupertino's
  /// scrollbar has no equivalent.
  final bool? interactive;

  /// Creates Material-only configuration for [PlatformScrollbar].
  const MaterialScrollbarData({
    super.thickness,
    super.radius,
    super.scrollbarOrientation,
    this.trackVisibility,
    this.interactive,
  });
}

/// Cupertino-only configuration for [PlatformScrollbar].
///
/// Pass this via `PlatformScrollbar.cupertinoScrollbarData` when tuning
/// Cupertino rendering. Inherited shared-visual fields override the widget's
/// flat defaults on the Cupertino branch with Cupertino-idiomatic defaults
/// applied at construction; the fields declared here have no Material
/// equivalent.
final class CupertinoScrollbarData extends _PlatformScrollbarData {
  /// Thickness of the scrollbar while being dragged.
  final double thicknessWhileDragging;

  /// Radius of the scrollbar while being dragged.
  final Radius radiusWhileDragging;

  /// Margin along the main axis of the scrollbar.
  final double mainAxisMargin;

  /// Creates Cupertino-only configuration for [PlatformScrollbar].
  ///
  /// Inherited [thickness] and [radius] default to Cupertino's idiomatic
  /// values via [CupertinoScrollbar.defaultThickness] / `.defaultRadius`
  /// (referenced directly so the package automatically tracks upstream
  /// changes).
  const CupertinoScrollbarData({
    super.thickness = CupertinoScrollbar.defaultThickness,
    super.radius = CupertinoScrollbar.defaultRadius,
    super.scrollbarOrientation,
    this.thicknessWhileDragging = CupertinoScrollbar.defaultThicknessWhileDragging,
    this.radiusWhileDragging = CupertinoScrollbar.defaultRadiusWhileDragging,
    this.mainAxisMargin = kDefaultCupertinoScrollbarMainAxisMargin,
  });
}
