// Per-platform records for PlatformButton (no shared private base. Material
// concentrates its visual surface in a single `ButtonStyle` blob while
// Cupertino exposes individual color/border/padding/etc. fields, so nothing
// overlaps in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_button.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButtonSize, CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ButtonStyle, ElevatedButton, FilledButton, OutlinedButton, TextButton;

/// Default value for [CupertinoButtonData.sizeStyle]. Matches upstream `CupertinoButton.sizeStyle`.
const kDefaultCupertinoButtonSizeStyle = CupertinoButtonSize.large;

/// Default value for [CupertinoButtonData.pressedOpacity]. Matches upstream.
const kDefaultCupertinoButtonPressedOpacity = 0.4;

/// Default value for [CupertinoButtonData.alignment]. Matches upstream.
const kDefaultCupertinoButtonAlignment = Alignment.center;

/// Gap between icon and label in [PlatformButton.icon]. Only the Cupertino branch reads it, since iOS
/// has no icon-button factory and we lay the 2 out in a [Row] ourselves. Material's factory already
/// handles its own spacing.
const kDefaultButtonIconLabelGap = 8.0;

/// Which Material button class [PlatformButton.materialButtonVariant] renders.
enum MaterialButtonVariant() {
  /// [TextButton], or [TextButton.icon] with [PlatformButton.icon].
  text,

  /// [ElevatedButton], or [ElevatedButton.icon] with [PlatformButton.icon].
  elevated,

  /// [OutlinedButton], or [OutlinedButton.icon] with [PlatformButton.icon].
  outlined,

  /// [FilledButton], or [FilledButton.icon] with [PlatformButton.icon].
  filled,

  /// [FilledButton.tonal], or [FilledButton.tonalIcon] with [PlatformButton.icon]. Sits between [filled]
  /// and [outlined], for a secondary action that still wants some weight.
  tonal,
}

/// Material-side settings for [PlatformButton], passed as `materialButtonData`. Everything declared
/// here has no Cupertino counterpart at all.
///
/// Thin on purpose. Material funnels almost every visual through [ButtonStyle], where Cupertino spreads
/// the same ground over separate colour / border / padding fields on [CupertinoButtonData]. The mouse
/// cursor is the one that catches people out: it's `style.mouseCursor` here, a plain field there.
final class const MaterialButtonData({
  final ValueChanged<bool>? onHover,

  /// Material's whole visual surface, keyed by [WidgetState]. `null` leaves it to the theme.
  final ButtonStyle? style,

  final Clip? clipBehavior,

  final WidgetStatesController? statesController,

  /// Only reaches the widget for the `.text` variant built through [PlatformButton.new]. Upstream doesn't
  /// take it anywhere else, so every other combination drops it on the floor.
  final bool? isSemanticButton,
}) {
  /// Creates Material-side settings for [PlatformButton].
  this;
}

/// Cupertino-side settings for [PlatformButton], passed as `cupertinoButtonData`. Everything declared
/// here has no Material counterpart at all, which on Material's side is all folded into [ButtonStyle].
///
/// Leave any of the nullable ones out and Cupertino falls back to whatever its size style or variant
/// says.
final class const CupertinoButtonData({
  final CupertinoButtonSize sizeStyle = kDefaultCupertinoButtonSizeStyle,

  final EdgeInsetsGeometry? padding,

  /// Background colour.
  final Color? color,

  /// Text and icon colour. Cupertino works it out from the background when left out.
  final Color? foregroundColor,

  /// Left out, the build site fills in the rendered variant's [CupertinoButtonVariant.defaultDisabledColor],
  /// which is what you'd have got from Cupertino directly.
  final Color? disabledColor,

  final Size? minimumSize,

  /// How far the button fades while held down.
  final double pressedOpacity = kDefaultCupertinoButtonPressedOpacity,

  final BorderRadius? borderRadius,

  /// Where the content sits inside the button.
  final AlignmentGeometry alignment = kDefaultCupertinoButtonAlignment,

  final Color? focusColor,

  /// Material keeps its own at `style.mouseCursor` on [MaterialButtonData], since its button classes
  /// take no top-level cursor.
  final MouseCursor? mouseCursor,
}) {
  /// Creates Cupertino-side settings for [PlatformButton].
  this;
}

/// Which Cupertino button [PlatformButton.cupertinoButtonVariant] renders.
enum CupertinoButtonVariant({
  /// Stands in for [CupertinoButtonData.disabledColor] when that's left out, copying the matching upstream
  /// constructor's own default so the untouched path renders identically.
  required final Color defaultDisabledColor,
}) {
  /// [CupertinoButton], no background fill.
  normal(defaultDisabledColor: CupertinoColors.quaternarySystemFill),

  /// [CupertinoButton.filled], solid background.
  filled(defaultDisabledColor: CupertinoColors.tertiarySystemFill),

  /// [CupertinoButton.tinted], subtle background tint.
  tinted(defaultDisabledColor: CupertinoColors.tertiarySystemFill),
}
