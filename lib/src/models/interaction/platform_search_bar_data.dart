// Per-platform records for PlatformSearchBar (no shared private base, every
// visual-overlap field has a divergent type per platform, e.g. Material's
// WidgetStateProperty<…> vs Cupertino's direct value).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_search_bar.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoIcons, OverlayVisibilityMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Leading widget the Cupertino branch falls back to.
///
/// `CupertinoSearchTextField.prefixIcon` can't be null and hard-codes this, without exposing a constant
/// for it, so we keep our own copy.
const kDefaultCupertinoSearchBarLeading = Icon(CupertinoIcons.search);

/// Default value for [MaterialSearchBarData.scrollPadding]. Matches Material's upstream `SearchBar.scrollPadding`
/// default.
const kDefaultSearchBarScrollPadding = EdgeInsets.all(20);

/// Default value for [MaterialSearchBarData.readOnly]. Matches upstream.
const kDefaultSearchBarReadOnly = false;

/// Default value for [CupertinoSearchBarData.padding]. Matches upstream, written the short way since
/// start and end match.
const kDefaultCupertinoSearchBarPadding = EdgeInsets.symmetric(horizontal: 5.5, vertical: 8);

/// Default value for [CupertinoSearchBarData.itemColor], the prefix and suffix glyph colour. Matches
/// upstream.
const kDefaultCupertinoSearchBarItemColor = CupertinoColors.secondaryLabel;

/// Default value for [CupertinoSearchBarData.itemSize]. Matches upstream.
const kDefaultCupertinoSearchBarItemSize = 20.0;

/// Default value for [CupertinoSearchBarData.prefixInsets]. Matches upstream, written with `.only` since
/// end is zero.
const kDefaultCupertinoSearchBarPrefixInsets = EdgeInsetsDirectional.only(
  start: 6,
  top: 8,
  bottom: 8,
);

/// Default value for [CupertinoSearchBarData.suffixInsets]. Matches upstream, written with `.only` since
/// start is zero.
const kDefaultCupertinoSearchBarSuffixInsets = EdgeInsetsDirectional.only(
  top: 8,
  end: 5,
  bottom: 8,
);

/// Default value for [CupertinoSearchBarData.suffixIcon]. Matches upstream.
const kDefaultCupertinoSearchBarSuffixIcon = Icon(CupertinoIcons.xmark_circle_fill);

/// Default value for [CupertinoSearchBarData.suffixMode]. Matches upstream.
const kDefaultCupertinoSearchBarSuffixMode = OverlayVisibilityMode.editing;

/// Default value for [CupertinoSearchBarData.enableIMEPersonalizedLearning]. Matches upstream.
const kDefaultCupertinoSearchBarEnableIMEPersonalizedLearning = true;

/// Default value for [CupertinoSearchBarData.autocorrect]. Matches upstream.
const kDefaultCupertinoSearchBarAutocorrect = true;

/// Default value for [CupertinoSearchBarData.cursorWidth]. Matches upstream.
const kDefaultCupertinoSearchBarCursorWidth = 2.0;

/// Default value for [CupertinoSearchBarData.cursorRadius]. Matches upstream.
const kDefaultCupertinoSearchBarCursorRadius = Radius.circular(2);

/// Default value for [CupertinoSearchBarData.cursorOpacityAnimates]. Matches upstream.
const kDefaultCupertinoSearchBarCursorOpacityAnimates = true;

/// Material-side settings for [PlatformSearchBar], passed as `materialSearchBarData`.
///
/// Nothing here is shared, because even where iOS has the same idea it has a different type. Material
/// keys these off [WidgetState] and Cupertino takes a plain value, and flattening one into the other
/// would throw away the hover, pressed and focused tints. See `APPENDIX.md#cross-platform-field-mappings`.
final class const MaterialSearchBarData({
  /// Usually action icons, at the far end of the bar.
  final Iterable<Widget>? trailing,

  final TapRegionCallback? onTapOutside,

  final BoxConstraints? constraints,

  final WidgetStateProperty<double?>? elevation,

  final WidgetStateProperty<Color?>? backgroundColor,

  final WidgetStateProperty<Color?>? shadowColor,

  final WidgetStateProperty<Color?>? surfaceTintColor,

  final WidgetStateProperty<Color?>? overlayColor,

  final WidgetStateProperty<BorderSide?>? side,

  final WidgetStateProperty<OutlinedBorder?>? shape,

  /// iOS's flat twin is [CupertinoSearchBarData.padding].
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding,

  /// iOS's flat twin is [CupertinoSearchBarData.style].
  final WidgetStateProperty<TextStyle?>? textStyle,

  /// iOS's flat twin is [CupertinoSearchBarData.placeholderStyle].
  final WidgetStateProperty<TextStyle?>? hintStyle,

  final TextCapitalization? textCapitalization,

  final TextInputAction? textInputAction,

  /// How much room to keep around the field when scrolling it into view.
  final EdgeInsets scrollPadding = kDefaultSearchBarScrollPadding,

  /// Left out, you get Material's own context menu.
  final EditableTextContextMenuBuilder? contextMenuBuilder,

  final bool readOnly = kDefaultSearchBarReadOnly,
}) {
  /// Creates Material-side settings for [PlatformSearchBar].
  this;
}

/// Cupertino-side settings for [PlatformSearchBar], passed as `cupertinoSearchBarData`. The other half
/// of the type split described on [MaterialSearchBarData], flat values where Material wants state properties.
final class const CupertinoSearchBarData({
  /// Material's state-keyed twin is [MaterialSearchBarData.textStyle].
  final TextStyle? style,

  /// Material's state-keyed twin is [MaterialSearchBarData.hintStyle].
  final TextStyle? placeholderStyle,

  final BoxDecoration? decoration,

  /// Material's state-keyed twin is [MaterialSearchBarData.backgroundColor].
  final Color? backgroundColor,

  final BorderRadius? borderRadius,

  /// Material's state-keyed twin is [MaterialSearchBarData.padding].
  final EdgeInsetsGeometry padding = kDefaultCupertinoSearchBarPadding,

  /// Colours the prefix and suffix glyphs.
  final Color itemColor = kDefaultCupertinoSearchBarItemColor,

  /// Sizes the prefix and suffix glyphs.
  final double itemSize = kDefaultCupertinoSearchBarItemSize,

  final EdgeInsetsGeometry prefixInsets = kDefaultCupertinoSearchBarPrefixInsets,

  final EdgeInsetsGeometry suffixInsets = kDefaultCupertinoSearchBarSuffixInsets,

  /// The clear button, by default. [suffixMode] decides when it's on screen.
  final Icon suffixIcon = kDefaultCupertinoSearchBarSuffixIcon,

  final OverlayVisibilityMode suffixMode = kDefaultCupertinoSearchBarSuffixMode,

  final VoidCallback? onSuffixTap,

  /// Material's [SearchBar] has nothing like it, since restoration lives on [SearchAnchor] over there.
  final String? restorationId,

  /// Lets the keyboard learn from what gets typed here.
  final bool enableIMEPersonalizedLearning =
      kDefaultCupertinoSearchBarEnableIMEPersonalizedLearning,

  final bool autocorrect = kDefaultCupertinoSearchBarAutocorrect,

  final double cursorWidth = kDefaultCupertinoSearchBarCursorWidth,

  /// Left out, Cupertino sizes it from the text.
  final double? cursorHeight,

  final Radius cursorRadius = kDefaultCupertinoSearchBarCursorRadius,

  /// Whether the cursor fades in and out rather than blinking.
  final bool cursorOpacityAnimates = kDefaultCupertinoSearchBarCursorOpacityAnimates,

  /// Left out, you get the ambient theme's primary colour.
  final Color? cursorColor,
}) {
  /// Creates Cupertino-side settings for [PlatformSearchBar].
  this;
}
