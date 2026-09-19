// Per-platform records for PlatformTextField (no shared private base. Material
// concentrates its decoration in a single InputDecoration blob while Cupertino
// exposes individual placeholder/prefix/suffix/padding/etc. fields, so nothing
// overlaps in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_text_field.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show OverlayVisibilityMode;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show InputCounterWidgetBuilder, InputDecoration;

/// Starting point the widget's flat [PlatformTextField.hintText] / `prefix` / `suffix` get merged into.
/// Matches upstream's own `const InputDecoration()`.
const kDefaultMaterialTextFieldDecoration = InputDecoration();

/// Default value for [MaterialTextFieldData.canRequestFocus]. Matches upstream.
const kDefaultMaterialTextFieldCanRequestFocus = true;

/// Default value for [MaterialTextFieldData.onTapAlwaysCalled]. Matches upstream.
const kDefaultMaterialTextFieldOnTapAlwaysCalled = false;

/// Default value for [CupertinoTextFieldData.clearButtonMode]. Matches upstream `CupertinoTextField.clearButtonMode`.
const kDefaultCupertinoTextFieldClearButtonMode = OverlayVisibilityMode.never;

/// Default value for [CupertinoTextFieldData.crossAxisAlignment]. Matches upstream `CupertinoTextField.crossAxisAlignment`.
const kDefaultCupertinoTextFieldCrossAxisAlignment = CrossAxisAlignment.center;

/// Default value for [CupertinoTextFieldData.padding]. Matches upstream `CupertinoTextField.padding`.
const kDefaultCupertinoTextFieldPadding = EdgeInsets.all(7);

/// Default value for [CupertinoTextFieldData.prefixMode]. Matches upstream.
const kDefaultCupertinoTextFieldPrefixMode = OverlayVisibilityMode.always;

/// Default value for [CupertinoTextFieldData.suffixMode]. Matches upstream.
const kDefaultCupertinoTextFieldSuffixMode = OverlayVisibilityMode.always;

/// Material-side settings for [PlatformTextField], passed as `materialTextFieldData`. Everything declared
/// here has no Cupertino counterpart at all, since Material puts its whole look in [InputDecoration]
/// where Cupertino uses separate placeholder / prefix / suffix / padding fields.
///
/// The everyday slots stay flat on the widget: [PlatformTextField.hintText], `prefix` and `suffix`.
/// Reach for [decoration] for the rest of Material's surface (border, label, helper and error text,
/// counter). Set `hintText` / `prefixIcon` / `suffixIcon` on it and yours beat the flat ones.
final class const MaterialTextFieldData({
  final InputCounterWidgetBuilder? buildCounter,

  final bool canRequestFocus = kDefaultMaterialTextFieldCanRequestFocus,

  /// Falls through to the theme's `colorScheme.error` when left out.
  final Color? cursorErrorColor,

  /// Everything the flat widget fields don't cover. See the note above on which side wins.
  final InputDecoration decoration = kDefaultMaterialTextFieldDecoration,

  /// Picks locale-specific glyph shapes for the hint. Rarely needed.
  final List<Locale>? hintLocales,

  /// Left out, Material works it out from `enabled`.
  final bool? ignorePointers,

  /// [CupertinoTextField] takes no top-level cursor, so this one is Material's alone.
  final MouseCursor? mouseCursor,

  final AppPrivateCommandCallback? onAppPrivateCommand,

  /// Fires [PlatformTextField.onTap] even on a field that already has focus.
  final bool onTapAlwaysCalled = kDefaultMaterialTextFieldOnTapAlwaysCalled,

  final WidgetStatesController? statesController,
}) {
  /// Creates Material-side settings for [PlatformTextField].
  this;
}

/// Cupertino-side settings for [PlatformTextField], passed as `cupertinoTextFieldData`. Everything declared
/// here has no Material counterpart at all, which Material folds into [InputDecoration] on [MaterialTextFieldData].
///
/// The everyday slots stay flat on the widget: [PlatformTextField.hintText], `prefix` and `suffix`.
/// [placeholder], [prefix] and [suffix] here are for when iOS wants something different, shorter copy
/// say, and they beat the flat ones when set.
final class const CupertinoTextFieldData({
  /// Left out, you get Cupertino's rounded rectangle border.
  final BoxDecoration? decoration,

  /// When the clear (x) button shows up. Never, out of the box.
  final OverlayVisibilityMode clearButtonMode = kDefaultCupertinoTextFieldClearButtonMode,

  final String? clearButtonSemanticLabel,

  final CrossAxisAlignment crossAxisAlignment = kDefaultCupertinoTextFieldCrossAxisAlignment,

  final EdgeInsetsGeometry padding = kDefaultCupertinoTextFieldPadding,

  /// iOS's name for the hint text.
  final String? placeholder,

  final TextStyle? placeholderStyle,

  /// Sits before the input. [prefixMode] decides when it's on screen.
  final Widget? prefix,

  final OverlayVisibilityMode prefixMode = kDefaultCupertinoTextFieldPrefixMode,

  /// Sits after the input. [suffixMode] decides when it's on screen.
  final Widget? suffix,

  final OverlayVisibilityMode suffixMode = kDefaultCupertinoTextFieldSuffixMode,
}) {
  /// Creates Cupertino-side settings for [PlatformTextField].
  this;
}
