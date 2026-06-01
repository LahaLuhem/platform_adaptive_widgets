// Multiple data classes in one file; private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_slider.dart';
library;

import 'package:flutter/cupertino.dart' show CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show SemanticFormatterCallback, ShowValueIndicator, SliderInteraction;

/// Default value for [MaterialSliderData.autofocus].
const kDefaultSliderAutofocus = false;

/// Default thumb colour for the Cupertino branch of [PlatformSlider].
///
/// `CupertinoSlider.thumbColor` is non-nullable with an inline default of
/// `CupertinoColors.white`; no public `CupertinoSlider.defaultThumbColor`
/// constant exists upstream, so the package owns this constant. The
/// Cupertino branch substitutes it when the widget's flat
/// `PlatformSlider.thumbColor` (typed `Color?`) is `null`.
const kDefaultCupertinoSliderThumbColor = CupertinoColors.white;

/// Internal abstract base holding shared-visual fields for [PlatformSlider].
///
/// Inherited by [MaterialSliderData] and [CupertinoSliderData] so each
/// per-platform record carries the shared-visual surface via `super.x`
/// constructor forwarding. Library-private — never exported from the
/// package.
///
/// See `APPENDIX.md#field-classification` for the rule placing shared-visual
/// fields on a private base.
abstract class _PlatformSliderData {
  /// Colour of the active portion of the slider track.
  final Color? activeColor;

  /// Colour of the slider thumb.
  ///
  /// Maps to [Slider.thumbColor] on Android (typed `Color?`, theme-falls
  /// through when `null`) and to [CupertinoSlider.thumbColor] on iOS (typed
  /// non-null `Color`, defaulting to `CupertinoColors.white`). The Cupertino
  /// branch substitutes [kDefaultCupertinoSliderThumbColor] when `null`. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Color? thumbColor;

  const _PlatformSliderData({this.activeColor, this.thumbColor});
}

/// Material-only configuration for [PlatformSlider].
///
/// Pass this via `PlatformSlider.materialSliderData` when tuning Material
/// rendering. Inherited shared-visual fields override the widget's flat
/// defaults on the Material branch; the fields declared here have no
/// Cupertino equivalent.
///
/// Houses both Material-only visual fields (`inactiveColor`,
/// `secondaryActiveColor`, `overlayColor`, `mouseCursor`, `label`, `padding`)
/// and Material-only functional fields (`secondaryTrackValue`,
/// `semanticFormatterCallback`, `focusNode`, `autofocus`, `allowedInteraction`)
/// per the platform-only bucket in `APPENDIX.md#field-classification` —
/// Cupertino's slider exposes none of these.
final class MaterialSliderData extends _PlatformSliderData {
  /// Value for the secondary track (e.g. buffered progress). Functional, but
  /// Material-only — Cupertino's slider has no secondary track.
  final double? secondaryTrackValue;

  /// Label displayed above the thumb while dragging.
  final String? label;

  /// Colour of the inactive portion of the slider track.
  final Color? inactiveColor;

  /// Colour of the secondary active track.
  final Color? secondaryActiveColor;

  /// Overlay colour as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Mouse cursor when hovering over the slider.
  final MouseCursor? mouseCursor;

  /// Callback for formatting the slider's semantic value.
  ///
  /// Functional, but Material-only — Cupertino's slider auto-generates
  /// accessibility semantics.
  final SemanticFormatterCallback? semanticFormatterCallback;

  /// Focus node for the slider. Functional, Material-only — Cupertino's
  /// slider does not participate in focus traversal.
  final FocusNode? focusNode;

  /// Whether the slider should autofocus. Defaults to
  /// [kDefaultSliderAutofocus].
  final bool autofocus;

  /// Allowed interaction type (slide-only, tap-only, both). Functional, but
  /// Material-only.
  final SliderInteraction? allowedInteraction;

  /// Padding around the slider.
  final EdgeInsetsGeometry? padding;

  /// Controls when the value-indicator label (above the thumb) is visible.
  /// Material-only — Cupertino's slider has no value-indicator. When `null`,
  /// Material applies its theme-driven default.
  final ShowValueIndicator? showValueIndicator;

  /// Creates Material-only configuration for [PlatformSlider].
  const MaterialSliderData({
    super.activeColor,
    super.thumbColor,
    this.secondaryTrackValue,
    this.label,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = kDefaultSliderAutofocus,
    this.allowedInteraction,
    this.padding,
    this.showValueIndicator,
  });
}

/// Cupertino-only configuration for [PlatformSlider].
///
/// Pass this via `PlatformSlider.cupertinoSliderData` when tuning Cupertino
/// rendering. [CupertinoSlider] has no Cupertino-only fields beyond the
/// shared-visual surface, so this record exists only to let callers
/// override the inherited [activeColor] / [thumbColor] on the Cupertino
/// branch without affecting Android. Future Cupertino-only fields would slot
/// in here.
final class CupertinoSliderData extends _PlatformSliderData {
  /// Creates Cupertino-only configuration for [PlatformSlider].
  const CupertinoSliderData({super.activeColor, super.thumbColor});
}
