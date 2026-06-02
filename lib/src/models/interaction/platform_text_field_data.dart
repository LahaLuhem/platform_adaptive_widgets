// Per-platform records for PlatformTextField (no shared private base — Material
// concentrates its decoration in a single InputDecoration blob while Cupertino
// exposes individual placeholder/prefix/suffix/padding/etc. fields, so nothing
// overlaps in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_text_field.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show OverlayVisibilityMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show InputCounterWidgetBuilder, InputDecoration;

/// Default value for [MaterialTextFieldData.decoration]. Matches upstream
/// `TextField.decoration`'s `const InputDecoration()` default.
///
/// The build site merges the widget's flat [PlatformTextField.hintText],
/// [PlatformTextField.prefix], and [PlatformTextField.suffix] into this base
/// via `copyWith` — data-class decoration values win when explicitly set; flat
/// widget values fill the gaps. See [PlatformTextField]'s class dartdoc.
const kDefaultMaterialTextFieldDecoration = InputDecoration();

/// Default value for [MaterialTextFieldData.canRequestFocus]. Matches upstream.
const kDefaultMaterialTextFieldCanRequestFocus = true;

/// Default value for [MaterialTextFieldData.onTapAlwaysCalled]. Matches upstream.
const kDefaultMaterialTextFieldOnTapAlwaysCalled = false;

/// Default value for [CupertinoTextFieldData.clearButtonMode]. Matches upstream
/// `CupertinoTextField.clearButtonMode`.
const kDefaultCupertinoTextFieldClearButtonMode = OverlayVisibilityMode.never;

/// Default value for [CupertinoTextFieldData.crossAxisAlignment]. Matches
/// upstream `CupertinoTextField.crossAxisAlignment`.
const kDefaultCupertinoTextFieldCrossAxisAlignment = CrossAxisAlignment.center;

/// Default value for [CupertinoTextFieldData.padding]. Matches upstream
/// `CupertinoTextField.padding`.
const kDefaultCupertinoTextFieldPadding = EdgeInsets.all(7);

/// Default value for [CupertinoTextFieldData.prefixMode]. Matches upstream.
const kDefaultCupertinoTextFieldPrefixMode = OverlayVisibilityMode.always;

/// Default value for [CupertinoTextFieldData.suffixMode]. Matches upstream.
const kDefaultCupertinoTextFieldSuffixMode = OverlayVisibilityMode.always;

/// Material-only configuration for [PlatformTextField].
///
/// Pass this via `PlatformTextField.materialTextFieldData` when tuning Material
/// rendering. The fields declared here have no Cupertino equivalent — Material
/// concentrates its visual surface in [InputDecoration], while Cupertino
/// exposes individual placeholder / prefix / suffix / padding / border fields
/// on [CupertinoTextFieldData].
///
/// **Common slots are flat on the widget.** [PlatformTextField.hintText],
/// [PlatformTextField.prefix], and [PlatformTextField.suffix] live on the
/// widget directly — set those for the common case. The [decoration] field
/// here is for the rest of Material's decoration surface (border, label,
/// helper / error text, counter, etc.). If you set `decoration.hintText` /
/// `decoration.prefixIcon` / `decoration.suffixIcon` here, your values win
/// over the widget-level flat fields.
final class MaterialTextFieldData {
  /// Builder for a custom input counter widget.
  final InputCounterWidgetBuilder? buildCounter;

  /// Whether the text field can request focus. Defaults to
  /// [kDefaultMaterialTextFieldCanRequestFocus].
  final bool canRequestFocus;

  /// Cursor colour shown when the field is in an error state. When `null`,
  /// Material falls through to the theme's `colorScheme.error`.
  final Color? cursorErrorColor;

  /// Input decoration. Defaults to [kDefaultMaterialTextFieldDecoration]
  /// (the upstream-matched `const InputDecoration()` sentinel). The build
  /// site merges the widget's flat [PlatformTextField.hintText] /
  /// [PlatformTextField.prefix] / [PlatformTextField.suffix] into this base —
  /// when this decoration has `hintText` / `prefixIcon` / `suffixIcon`
  /// explicitly set, those win; otherwise the flat widget values fill the
  /// gap.
  final InputDecoration decoration;

  /// Locales used by the hint text for locale-specific glyph variants. Rarely
  /// needed.
  final List<Locale>? hintLocales;

  /// Whether the text field ignores pointer events. When `null`, Material
  /// derives this from `enabled`.
  final bool? ignorePointers;

  /// Mouse cursor while hovering over the field. Material-only — Cupertino's
  /// [CupertinoTextField] has no top-level `mouseCursor` parameter.
  final MouseCursor? mouseCursor;

  /// Callback for app-private commands.
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// Whether [PlatformTextField.onTap] is invoked even when the field already
  /// has focus. Defaults to [kDefaultMaterialTextFieldOnTapAlwaysCalled].
  final bool onTapAlwaysCalled;

  /// Controller for the field's interaction states.
  final WidgetStatesController? statesController;

  /// Creates Material-only configuration for [PlatformTextField].
  const MaterialTextFieldData({
    this.buildCounter,
    this.canRequestFocus = kDefaultMaterialTextFieldCanRequestFocus,
    this.cursorErrorColor,
    this.decoration = kDefaultMaterialTextFieldDecoration,
    this.hintLocales,
    this.ignorePointers,
    this.mouseCursor,
    this.onAppPrivateCommand,
    this.onTapAlwaysCalled = kDefaultMaterialTextFieldOnTapAlwaysCalled,
    this.statesController,
  });
}

/// Cupertino-only configuration for [PlatformTextField].
///
/// Pass this via `PlatformTextField.cupertinoTextFieldData` when tuning
/// Cupertino rendering. The fields declared here have no Material equivalent —
/// Material concentrates its visual surface in [InputDecoration] on
/// [MaterialTextFieldData].
///
/// **Common slots are flat on the widget.** [PlatformTextField.hintText],
/// [PlatformTextField.prefix], and [PlatformTextField.suffix] live on the
/// widget directly — set those for the common case. The [placeholder] /
/// [prefix] / [suffix] fields here let you override the Cupertino branch
/// specifically (e.g. shorter copy on iOS); when set, they win over the
/// widget-level flat fields.
final class CupertinoTextFieldData {
  /// Box decoration. When `null`, Cupertino applies its theme-driven default
  /// (rounded rectangle border).
  final BoxDecoration? decoration;

  /// When the clear (x) button is visible. Defaults to
  /// [kDefaultCupertinoTextFieldClearButtonMode] (never shown).
  final OverlayVisibilityMode clearButtonMode;

  /// Accessibility label for the clear button.
  final String? clearButtonSemanticLabel;

  /// Cross-axis alignment of the field's content. Defaults to
  /// [kDefaultCupertinoTextFieldCrossAxisAlignment].
  final CrossAxisAlignment crossAxisAlignment;

  /// Padding around the field's content. Defaults to
  /// [kDefaultCupertinoTextFieldPadding].
  final EdgeInsetsGeometry padding;

  /// Placeholder text. When set, overrides the widget-level
  /// [PlatformTextField.hintText] for the Cupertino branch.
  final String? placeholder;

  /// Text style for the placeholder.
  final TextStyle? placeholderStyle;

  /// Widget rendered before the text input (e.g. an icon). When set, overrides
  /// the widget-level [PlatformTextField.prefix] for the Cupertino branch.
  /// See [prefixMode] for visibility control.
  final Widget? prefix;

  /// When the [prefix] widget is visible. Defaults to
  /// [kDefaultCupertinoTextFieldPrefixMode] (always shown).
  final OverlayVisibilityMode prefixMode;

  /// Widget rendered after the text input (e.g. an icon). When set, overrides
  /// the widget-level [PlatformTextField.suffix] for the Cupertino branch.
  /// See [suffixMode] for visibility control.
  final Widget? suffix;

  /// When the [suffix] widget is visible. Defaults to
  /// [kDefaultCupertinoTextFieldSuffixMode] (always shown).
  final OverlayVisibilityMode suffixMode;

  /// Creates Cupertino-only configuration for [PlatformTextField].
  const CupertinoTextFieldData({
    this.decoration,
    this.clearButtonMode = kDefaultCupertinoTextFieldClearButtonMode,
    this.clearButtonSemanticLabel,
    this.crossAxisAlignment = kDefaultCupertinoTextFieldCrossAxisAlignment,
    this.padding = kDefaultCupertinoTextFieldPadding,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.prefixMode = kDefaultCupertinoTextFieldPrefixMode,
    this.suffix,
    this.suffixMode = kDefaultCupertinoTextFieldSuffixMode,
  });
}
