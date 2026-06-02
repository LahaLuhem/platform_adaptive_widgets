// Per-platform records for PlatformButton (no shared private base — Material
// concentrates its visual surface in a single `ButtonStyle` blob while
// Cupertino exposes individual color/border/padding/etc. fields, so nothing
// overlaps in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_button.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButtonSize, CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ButtonStyle, ElevatedButton, FilledButton, OutlinedButton, TextButton;

/// Default value for [CupertinoButtonData.sizeStyle]. Matches upstream
/// `CupertinoButton.sizeStyle`.
const kDefaultCupertinoButtonSizeStyle = CupertinoButtonSize.large;

/// Default value for [CupertinoButtonData.pressedOpacity]. Matches upstream.
const kDefaultCupertinoButtonPressedOpacity = 0.4;

/// Default value for [CupertinoButtonData.alignment]. Matches upstream.
const kDefaultCupertinoButtonAlignment = Alignment.center;

/// Default gap between the icon and the label rendered by
/// [PlatformButton.icon]. On the Material branch this spacing is implicit in
/// the underlying `.icon` factory's layout; on the Cupertino branch the
/// package wraps the icon and label in a [Row] with `spacing` set to this
/// constant (Cupertino has no native icon-button factory).
const kDefaultButtonIconLabelGap = 8.0;

/// Material button variants for [PlatformButton.materialButtonVariant].
///
/// Each variant pairs with a different Material button class, and (when
/// [PlatformButton.icon] is used) with that class's `.icon` factory.
enum MaterialButtonVariant {
  /// Renders as [TextButton] (or [TextButton.icon] via [PlatformButton.icon]).
  text,

  /// Renders as [ElevatedButton] (or [ElevatedButton.icon] via
  /// [PlatformButton.icon]).
  elevated,

  /// Renders as [OutlinedButton] (or [OutlinedButton.icon] via
  /// [PlatformButton.icon]).
  outlined,

  /// Renders as [FilledButton] (or [FilledButton.icon] via [PlatformButton.icon]).
  filled,

  /// Renders as [FilledButton.tonal] (or [FilledButton.tonalIcon] via
  /// [PlatformButton.icon]). The tonal variant is a middle ground between
  /// [filled] and [outlined] — useful for secondary actions that need more
  /// emphasis than an outline but less than a fill.
  tonal,
}

/// Material-only configuration for [PlatformButton].
///
/// Pass this via `PlatformButton.materialButtonData` when tuning Material
/// rendering. The fields declared here have no Cupertino equivalent — Material
/// concentrates its visual surface in [ButtonStyle], while Cupertino exposes
/// individual colour / border / padding fields on [CupertinoButtonData].
///
/// **Mouse cursor.** Material's button classes don't expose a top-level
/// `mouseCursor` parameter — set it via `style.mouseCursor`
/// ([ButtonStyle.mouseCursor]). Cupertino's equivalent lives on
/// [CupertinoButtonData.mouseCursor].
final class MaterialButtonData {
  /// Callback when the hover state changes (mouse enter / leave the button
  /// area).
  final ValueChanged<bool>? onHover;

  /// Button style. Houses Material's full visual surface (background colour,
  /// foreground colour, text style, padding, mouse cursor, etc.) keyed by
  /// [WidgetState]. When `null`, the underlying Material variant applies its
  /// theme-driven defaults.
  final ButtonStyle? style;

  /// Clip behaviour. When `null`, each underlying Material button applies its
  /// own ctor-level default (typically `Clip.none`).
  final Clip? clipBehavior;

  /// Controller for the widget's interaction states.
  final WidgetStatesController? statesController;

  /// Whether the button is announced as a semantic button. Honoured only when
  /// [PlatformButton.materialButtonVariant] is `.text` and the button is
  /// constructed via [PlatformButton.new] (not [PlatformButton.icon]) —
  /// upstream's other variants and all `.icon` factories don't surface the
  /// parameter, and the package silently drops it for those combinations.
  final bool? isSemanticButton;

  /// Creates Material-only configuration for [PlatformButton].
  const MaterialButtonData({
    this.onHover,
    this.style,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton,
  });
}

/// Cupertino-only configuration for [PlatformButton].
///
/// Pass this via `PlatformButton.cupertinoButtonData` when tuning Cupertino
/// rendering. The fields declared here have no Material equivalent — Material
/// concentrates its visual surface in [ButtonStyle] on [MaterialButtonData].
final class CupertinoButtonData {
  /// Size style. Defaults to [kDefaultCupertinoButtonSizeStyle].
  final CupertinoButtonSize sizeStyle;

  /// Padding around the button content. When `null`, Cupertino applies its
  /// size-style-driven default.
  final EdgeInsetsGeometry? padding;

  /// Background colour. When `null`, Cupertino applies its variant-driven
  /// default (e.g. the theme's `primaryColor` for `.filled`).
  final Color? color;

  /// Foreground (text / icon) colour. When `null`, Cupertino derives it from
  /// the background.
  final Color? foregroundColor;

  /// Colour used when the button is disabled. When `null`, the build site
  /// substitutes [CupertinoButtonVariant.defaultDisabledColor] for the
  /// rendered variant — mirrors upstream's per-ctor inline default.
  final Color? disabledColor;

  /// Minimum size of the button. When `null`, Cupertino applies its
  /// size-style-driven default.
  final Size? minimumSize;

  /// Opacity applied while the button is being pressed. Defaults to
  /// [kDefaultCupertinoButtonPressedOpacity].
  final double pressedOpacity;

  /// Border radius. When `null`, Cupertino applies its size-style-driven
  /// default.
  final BorderRadius? borderRadius;

  /// Alignment of the button content. Defaults to
  /// [kDefaultCupertinoButtonAlignment].
  final AlignmentGeometry alignment;

  /// Colour shown while the button is focused. When `null`, Cupertino applies
  /// the theme's focus colour.
  final Color? focusColor;

  /// Mouse cursor while hovering. Cupertino-only — Material's equivalent
  /// lives at `style.mouseCursor` on [MaterialButtonData] (Material's button
  /// classes don't expose a top-level `mouseCursor` parameter).
  final MouseCursor? mouseCursor;

  /// Creates Cupertino-only configuration for [PlatformButton].
  const CupertinoButtonData({
    this.sizeStyle = kDefaultCupertinoButtonSizeStyle,
    this.padding,
    this.color,
    this.foregroundColor,
    this.disabledColor,
    this.minimumSize,
    this.pressedOpacity = kDefaultCupertinoButtonPressedOpacity,
    this.borderRadius,
    this.alignment = kDefaultCupertinoButtonAlignment,
    this.focusColor,
    this.mouseCursor,
  });
}

/// Cupertino button variants for [PlatformButton.cupertinoButtonVariant].
///
/// Each variant carries the [defaultDisabledColor] applied by the build site
/// when [CupertinoButtonData.disabledColor] is `null` — mirrors upstream's
/// per-ctor inline default (`quaternarySystemFill` for the unfilled
/// [CupertinoButton], `tertiarySystemFill` for `.filled` and `.tinted`).
enum CupertinoButtonVariant {
  /// Renders as [CupertinoButton] (no background fill).
  normal(defaultDisabledColor: CupertinoColors.quaternarySystemFill),

  /// Renders as [CupertinoButton.filled] (solid background fill).
  filled(defaultDisabledColor: CupertinoColors.tertiarySystemFill),

  /// Renders as [CupertinoButton.tinted] (subtle background tint).
  tinted(defaultDisabledColor: CupertinoColors.tertiarySystemFill);

  /// Colour applied by [PlatformButton]'s build site when
  /// [CupertinoButtonData.disabledColor] is `null`. Mirrors the matching
  /// upstream constructor's inline default — keeps the package's "no override"
  /// path bit-identical to instantiating Cupertino's button directly.
  final Color defaultDisabledColor;

  const CupertinoButtonVariant({required this.defaultDisabledColor});
}
