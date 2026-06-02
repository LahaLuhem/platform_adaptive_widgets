// Per-platform records for PlatformSearchBar (no shared private base — every
// visual-overlap field has a divergent type per platform, e.g. Material's
// WidgetStateProperty<…> vs Cupertino's direct value).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/interaction/platform_search_bar.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoIcons, OverlayVisibilityMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Default leading widget for the Cupertino branch of [PlatformSearchBar].
///
/// `CupertinoSearchTextField.prefixIcon` is non-nullable with an inline
/// default of `Icon(CupertinoIcons.search)`; no public
/// `CupertinoSearchTextField.defaultPrefixIcon` constant exists upstream, so
/// the package owns this constant. The Cupertino branch substitutes it when
/// the widget's flat `PlatformSearchBar.leading` is `null`.
const kDefaultCupertinoSearchBarLeading = Icon(CupertinoIcons.search);

/// Default value for [MaterialSearchBarData.scrollPadding]. Matches Material's
/// upstream `SearchBar.scrollPadding` default.
const kDefaultSearchBarScrollPadding = EdgeInsets.all(20);

/// Default value for [MaterialSearchBarData.readOnly]. Matches upstream.
const kDefaultSearchBarReadOnly = false;

/// Default value for [CupertinoSearchBarData.padding]. Matches upstream
/// `CupertinoSearchTextField.padding` (`EdgeInsetsDirectional.fromSTEB(5.5,
/// 8, 5.5, 8)` — simplified here since start == end makes the directional
/// form redundant).
const kDefaultCupertinoSearchBarPadding = EdgeInsets.symmetric(horizontal: 5.5, vertical: 8);

/// Default value for [CupertinoSearchBarData.itemColor]. Matches upstream
/// `CupertinoSearchTextField.itemColor` (the prefix/suffix glyph colour).
const kDefaultCupertinoSearchBarItemColor = CupertinoColors.secondaryLabel;

/// Default value for [CupertinoSearchBarData.itemSize]. Matches upstream.
const kDefaultCupertinoSearchBarItemSize = 20.0;

/// Default value for [CupertinoSearchBarData.prefixInsets]. Matches upstream
/// `CupertinoSearchTextField.prefixInsets` (`EdgeInsetsDirectional.fromSTEB(6,
/// 8, 0, 8)` — simplified to `.only` since end is zero).
const kDefaultCupertinoSearchBarPrefixInsets = EdgeInsetsDirectional.only(
  start: 6,
  top: 8,
  bottom: 8,
);

/// Default value for [CupertinoSearchBarData.suffixInsets]. Matches upstream
/// `CupertinoSearchTextField.suffixInsets` (`EdgeInsetsDirectional.fromSTEB(0,
/// 8, 5, 8)` — simplified to `.only` since start is zero).
const kDefaultCupertinoSearchBarSuffixInsets = EdgeInsetsDirectional.only(
  top: 8,
  end: 5,
  bottom: 8,
);

/// Default value for [CupertinoSearchBarData.suffixIcon]. Matches upstream.
const kDefaultCupertinoSearchBarSuffixIcon = Icon(CupertinoIcons.xmark_circle_fill);

/// Default value for [CupertinoSearchBarData.suffixMode]. Matches upstream.
const kDefaultCupertinoSearchBarSuffixMode = OverlayVisibilityMode.editing;

/// Default value for [CupertinoSearchBarData.enableIMEPersonalizedLearning].
/// Matches upstream.
const kDefaultCupertinoSearchBarEnableIMEPersonalizedLearning = true;

/// Default value for [CupertinoSearchBarData.autocorrect]. Matches upstream.
const kDefaultCupertinoSearchBarAutocorrect = true;

/// Default value for [CupertinoSearchBarData.cursorWidth]. Matches upstream.
const kDefaultCupertinoSearchBarCursorWidth = 2.0;

/// Default value for [CupertinoSearchBarData.cursorRadius]. Matches upstream.
const kDefaultCupertinoSearchBarCursorRadius = Radius.circular(2);

/// Default value for [CupertinoSearchBarData.cursorOpacityAnimates]. Matches
/// upstream.
const kDefaultCupertinoSearchBarCursorOpacityAnimates = true;

/// Material-only configuration for [PlatformSearchBar].
///
/// Pass this via `PlatformSearchBar.materialSearchBarData` when tuning
/// Material rendering. The fields declared here have no Cupertino equivalent
/// (or have a Cupertino equivalent whose underlying type diverges enough
/// that sharing would lose fidelity — e.g. Material's
/// `WidgetStateProperty<Color?>?` vs Cupertino's `Color?` for
/// `backgroundColor`). See `APPENDIX.md#cross-platform-field-mappings`.
final class MaterialSearchBarData {
  /// Trailing widgets (e.g. action icons).
  final Iterable<Widget>? trailing;

  /// Callback when tapping outside the search bar.
  final TapRegionCallback? onTapOutside;

  /// Size constraints for the search bar.
  final BoxConstraints? constraints;

  /// Elevation as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? elevation;

  /// Background colour as a [WidgetStateProperty]. Material's state-driven
  /// shape can't collapse to Cupertino's plain `Color?` without losing
  /// hover/pressed/focused tints; lives Material-only.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// Shadow colour as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? shadowColor;

  /// Surface tint colour as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// Overlay colour as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Border side as a [WidgetStateProperty].
  final WidgetStateProperty<BorderSide?>? side;

  /// Shape as a [WidgetStateProperty].
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// Padding as a [WidgetStateProperty]. Cupertino's plain
  /// [CupertinoSearchBarData.padding] is the divergent equivalent.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// Text style as a [WidgetStateProperty]. Cupertino's plain
  /// [CupertinoSearchBarData.style] is the divergent equivalent.
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// Hint text style as a [WidgetStateProperty]. Cupertino's plain
  /// [CupertinoSearchBarData.placeholderStyle] is the divergent equivalent.
  final WidgetStateProperty<TextStyle?>? hintStyle;

  /// Text capitalisation for the search input.
  final TextCapitalization? textCapitalization;

  /// Text input action for the search input.
  final TextInputAction? textInputAction;

  /// Scroll padding for the search input. Defaults to
  /// [kDefaultSearchBarScrollPadding].
  final EdgeInsets scrollPadding;

  /// Context menu builder for the search input. When `null`, Material falls
  /// through to its own default context menu.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Whether the search bar is read-only. Defaults to
  /// [kDefaultSearchBarReadOnly].
  final bool readOnly;

  /// Creates Material-only configuration for [PlatformSearchBar].
  const MaterialSearchBarData({
    this.trailing,
    this.onTapOutside,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    this.textInputAction,
    this.scrollPadding = kDefaultSearchBarScrollPadding,
    this.contextMenuBuilder,
    this.readOnly = kDefaultSearchBarReadOnly,
  });
}

/// Cupertino-only configuration for [PlatformSearchBar].
///
/// Pass this via `PlatformSearchBar.cupertinoSearchBarData` when tuning
/// Cupertino rendering. The fields declared here have no Material equivalent
/// (or have a Material equivalent whose underlying type diverges enough that
/// sharing would lose fidelity — see Material's `WidgetStateProperty<…>`
/// variants of `backgroundColor`, `padding`, `textStyle`, `hintStyle`). See
/// `APPENDIX.md#cross-platform-field-mappings`.
final class CupertinoSearchBarData {
  /// Text style for the search input. Material's divergent equivalent is
  /// [MaterialSearchBarData.textStyle] (state-property).
  final TextStyle? style;

  /// Text style for the placeholder text. Material's divergent equivalent is
  /// [MaterialSearchBarData.hintStyle] (state-property).
  final TextStyle? placeholderStyle;

  /// Box decoration for the search bar.
  final BoxDecoration? decoration;

  /// Background colour. Material's divergent equivalent is
  /// [MaterialSearchBarData.backgroundColor] (state-property).
  final Color? backgroundColor;

  /// Border radius of the search bar.
  final BorderRadius? borderRadius;

  /// Padding around the search bar content. Material's divergent equivalent
  /// is [MaterialSearchBarData.padding] (state-property). Defaults to
  /// [kDefaultCupertinoSearchBarPadding].
  final EdgeInsetsGeometry padding;

  /// Colour of prefix and suffix items. Defaults to
  /// [kDefaultCupertinoSearchBarItemColor].
  final Color itemColor;

  /// Size of prefix and suffix items. Defaults to
  /// [kDefaultCupertinoSearchBarItemSize].
  final double itemSize;

  /// Insets for the prefix widget. Defaults to
  /// [kDefaultCupertinoSearchBarPrefixInsets].
  final EdgeInsetsGeometry prefixInsets;

  /// Insets for the suffix widget. Defaults to
  /// [kDefaultCupertinoSearchBarSuffixInsets].
  final EdgeInsetsGeometry suffixInsets;

  /// Icon displayed as the suffix. Defaults to
  /// [kDefaultCupertinoSearchBarSuffixIcon].
  final Icon suffixIcon;

  /// When the suffix icon is visible. Defaults to
  /// [kDefaultCupertinoSearchBarSuffixMode].
  final OverlayVisibilityMode suffixMode;

  /// Callback when the suffix icon is tapped.
  final VoidCallback? onSuffixTap;

  /// Restoration ID for state restoration. Material's [SearchBar] has no
  /// equivalent (state restoration lives on [SearchAnchor]).
  final String? restorationId;

  /// Whether to enable IME personalised learning. Defaults to
  /// [kDefaultCupertinoSearchBarEnableIMEPersonalizedLearning].
  final bool enableIMEPersonalizedLearning;

  /// Whether to enable autocorrect. Defaults to
  /// [kDefaultCupertinoSearchBarAutocorrect].
  final bool autocorrect;

  /// Width of the cursor. Defaults to [kDefaultCupertinoSearchBarCursorWidth].
  final double cursorWidth;

  /// Height of the cursor. When `null`, Cupertino derives it from the text
  /// metrics.
  final double? cursorHeight;

  /// Radius of the cursor. Defaults to [kDefaultCupertinoSearchBarCursorRadius].
  final Radius cursorRadius;

  /// Whether the cursor opacity animates. Defaults to
  /// [kDefaultCupertinoSearchBarCursorOpacityAnimates].
  final bool cursorOpacityAnimates;

  /// Colour of the cursor. When `null`, Cupertino falls through to the
  /// ambient theme's primary colour.
  final Color? cursorColor;

  /// Creates Cupertino-only configuration for [PlatformSearchBar].
  const CupertinoSearchBarData({
    this.style,
    this.placeholderStyle,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.padding = kDefaultCupertinoSearchBarPadding,
    this.itemColor = kDefaultCupertinoSearchBarItemColor,
    this.itemSize = kDefaultCupertinoSearchBarItemSize,
    this.prefixInsets = kDefaultCupertinoSearchBarPrefixInsets,
    this.suffixInsets = kDefaultCupertinoSearchBarSuffixInsets,
    this.suffixIcon = kDefaultCupertinoSearchBarSuffixIcon,
    this.suffixMode = kDefaultCupertinoSearchBarSuffixMode,
    this.onSuffixTap,
    this.restorationId,
    this.enableIMEPersonalizedLearning = kDefaultCupertinoSearchBarEnableIMEPersonalizedLearning,
    this.autocorrect = kDefaultCupertinoSearchBarAutocorrect,
    this.cursorWidth = kDefaultCupertinoSearchBarCursorWidth,
    this.cursorHeight,
    this.cursorRadius = kDefaultCupertinoSearchBarCursorRadius,
    this.cursorOpacityAnimates = kDefaultCupertinoSearchBarCursorOpacityAnimates,
    this.cursorColor,
  });
}
