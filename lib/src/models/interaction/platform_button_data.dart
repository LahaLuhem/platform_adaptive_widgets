// Per-platform records for PlatformButton (no shared private base. Material
// concentrates its visual surface in a single `ButtonStyle` blob while
// Cupertino exposes individual color/border/padding/etc. fields, so nothing
// overlaps in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_button.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButtonSize;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ButtonStyle;

/// Default value for [CupertinoButtonData.sizeStyle]. Matches upstream `CupertinoButton.sizeStyle`.
const kDefaultCupertinoButtonSizeStyle = CupertinoButtonSize.large;

/// Default value for [CupertinoButtonData.pressedOpacity]. Matches upstream.
const kDefaultCupertinoButtonPressedOpacity = 0.4;

/// Default value for [CupertinoButtonData.alignment]. Matches upstream.
const kDefaultCupertinoButtonAlignment = Alignment.center;

/// Gap between icon and label in [PlatformButton.icon]. Only the Cupertino branch reads it, since
/// `CupertinoButton` has no icon factory and we lay the 2 out in a [Row] ourselves. Material's factory
/// already handles its own spacing.
const kDefaultButtonIconLabelGap = 8.0;

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

  /// Only reaches a `low` button built through [PlatformButton.new], since upstream's plain [TextButton]
  /// is the only one that takes it.
  final bool? isSemanticButton,
}) {
  /// Creates Material-side settings for [PlatformButton].
  this;
}

/// Cupertino-side settings for [PlatformButton], passed as `cupertinoButtonData`. Everything declared
/// here has no Material counterpart at all, which on Material's side is all folded into [ButtonStyle].
///
/// Leave any of the nullable ones out and Cupertino falls back to whatever its size style or the
/// button's emphasis says.
final class const CupertinoButtonData({
  final CupertinoButtonSize sizeStyle = kDefaultCupertinoButtonSizeStyle,

  final EdgeInsetsGeometry? padding,

  /// Background colour. Left out, a `mediumNeutral` button takes [CupertinoColors.systemGrey].
  final Color? color,

  /// Text and icon colour. Cupertino works it out from the background when left out.
  final Color? foregroundColor,

  /// Left out, each Cupertino constructor's own default applies.
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
