import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoIcons, OverlayVisibilityMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Platform-shared configuration for a search bar widget.
///
/// Contains common properties used by both Material and Cupertino search bars.
final class PlatformSearchBarData {
  /// Key applied to the underlying platform widget.
  final Key? widgetKey;

  /// Text editing controller for the search input.
  final TextEditingController? controller;

  /// Hint text displayed when the search bar is empty.
  final String? hintText;

  /// Leading widget (e.g., a search icon).
  final Widget? leading;

  /// Callback when the search bar is tapped.
  final VoidCallback? onTap;

  /// Callback when the search text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the search text is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Keyboard type for the search input.
  final TextInputType? keyboardType;

  /// Whether the search bar should autofocus.
  final bool autoFocus;

  /// Focus node for the search bar.
  final FocusNode? focusNode;

  /// Whether the search bar is enabled.
  final bool enabled;

  /// Default value for [autoFocus].
  static const kDefaultAutoFocus = false;

  /// Default value for [enabled].
  static const kDefaultEnabled = true;

  /// Creates platform search bar configuration.
  const PlatformSearchBarData({
    this.widgetKey,
    this.controller,
    this.hintText,
    this.leading,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.autoFocus = kDefaultAutoFocus,
    this.focusNode,
    this.enabled = kDefaultEnabled,
  });
}

/// Material-specific configuration for a search bar widget.
///
/// Extends [PlatformSearchBarData] with Material-only properties.
final class MaterialSearchBarData extends PlatformSearchBarData {
  /// Trailing widgets (e.g., action icons).
  final Iterable<Widget>? trailing;

  /// Callback when tapping outside the search bar.
  final TapRegionCallback? onTapOutside;

  /// Size constraints for the search bar.
  final BoxConstraints? constraints;

  /// Elevation as a [WidgetStateProperty].
  final WidgetStateProperty<double?>? elevation;

  /// Background color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? backgroundColor;

  /// Shadow color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? shadowColor;

  /// Surface tint color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// Overlay color as a [WidgetStateProperty].
  final WidgetStateProperty<Color?>? overlayColor;

  /// Border side as a [WidgetStateProperty].
  final WidgetStateProperty<BorderSide?>? side;

  /// Shape as a [WidgetStateProperty].
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// Padding as a [WidgetStateProperty].
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// Text style as a [WidgetStateProperty].
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// Hint text style as a [WidgetStateProperty].
  final WidgetStateProperty<TextStyle?>? hintStyle;

  /// Text capitalization for the search input.
  final TextCapitalization? textCapitalization;

  /// Text input action for the search input.
  final TextInputAction? textInputAction;

  /// Scroll padding for the search input.
  final EdgeInsets scrollPadding;

  /// Context menu builder for the search input.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Whether the search bar is read-only.
  final bool readOnly;

  /// Default value for [scrollPadding].
  static const kDefaultScrollPadding = EdgeInsets.all(20);

  /// Default value for [readOnly].
  static const kDefaultReadOnly = false;

  /// Creates Material-specific search bar configuration.
  const MaterialSearchBarData({
    super.widgetKey,
    super.controller,
    super.hintText,
    super.leading,
    super.onTap,
    super.onChanged,
    super.onSubmitted,
    super.keyboardType,
    super.autoFocus,
    super.focusNode,
    super.enabled,
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
    this.scrollPadding = kDefaultScrollPadding,
    this.contextMenuBuilder,
    this.readOnly = kDefaultReadOnly,
  });
}

/// Cupertino-specific configuration for a search bar widget.
///
/// Maps to properties of `CupertinoSearchTextField` on iOS.
final class CupertinoSearchBarData extends PlatformSearchBarData {
  /// Text style for the search input.
  final TextStyle? style;

  /// Text style for the placeholder text.
  final TextStyle? placeholderStyle;

  /// Box decoration for the search bar.
  final BoxDecoration? decoration;

  /// Background color of the search bar.
  final Color? backgroundColor;

  /// Border radius of the search bar.
  final BorderRadius? borderRadius;

  /// Padding around the search bar content.
  final EdgeInsetsGeometry padding;

  /// Color of prefix and suffix items.
  final Color itemColor;

  /// Size of prefix and suffix items.
  final double itemSize;

  /// Insets for the prefix widget.
  final EdgeInsetsGeometry prefixInsets;

  /// Insets for the suffix widget.
  final EdgeInsetsGeometry suffixInsets;

  /// Icon displayed as the suffix.
  final Icon suffixIcon;

  /// When the suffix icon is visible.
  final OverlayVisibilityMode suffixMode;

  /// Callback when the suffix icon is tapped.
  final VoidCallback? onSuffixTap;

  /// Restoration ID for state restoration.
  final String? restorationId;

  /// Smart quotes type for the search input.
  final SmartQuotesType? smartQuotesType;

  /// Smart dashes type for the search input.
  final SmartDashesType? smartDashesType;

  /// Whether to enable IME personalized learning.
  final bool enableIMEPersonalizedLearning;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Width of the cursor.
  final double cursorWidth;

  /// Height of the cursor.
  final double? cursorHeight;

  /// Radius of the cursor.
  final Radius cursorRadius;

  /// Whether the cursor opacity animates.
  final bool cursorOpacityAnimates;

  /// Color of the cursor.
  final Color? cursorColor;

  /// Default value for [leading].
  static const kDefaultLeading = Icon(CupertinoIcons.search);

  /// Default value for [padding].
  static const kDefaultPadding = EdgeInsets.all(8);

  /// Default value for [itemColor].
  static const kDefaultItemColor = CupertinoColors.placeholderText;

  /// Default value for [itemSize].
  static const kDefaultItemSize = 20.0;

  /// Default value for [prefixInsets].
  static const kDefaultPrefixInsets = EdgeInsetsDirectional.only(start: 6, top: 8, bottom: 8);

  /// Default value for [suffixInsets].
  static const kDefaultSuffixInsets = EdgeInsetsDirectional.only(top: 8, end: 5, bottom: 8);

  /// Default value for [suffixIcon].
  static const kDefaultSuffixIcon = Icon(CupertinoIcons.xmark_circle_fill);

  /// Default value for [suffixMode].
  static const kDefaultSuffixMode = OverlayVisibilityMode.editing;

  /// Default value for [enableIMEPersonalizedLearning].
  static const kDefaultEnableIMEPersonalizedLearning = true;

  /// Default value for [autocorrect].
  static const kDefaultAutocorrect = true;

  /// Default value for [cursorWidth].
  static const kDefaultCursorWidth = 2.0;

  /// Default value for [cursorRadius].
  static const kDefaultCursorRadius = Radius.circular(2);

  /// Default value for [cursorOpacityAnimates].
  static const kDefaultCursorOpacityAnimates = true;

  /// Creates Cupertino-specific search bar configuration.
  const CupertinoSearchBarData({
    super.widgetKey,
    super.controller,
    super.hintText,
    super.leading = kDefaultLeading,
    super.onTap,
    super.onChanged,
    super.onSubmitted,
    super.keyboardType,
    super.autoFocus,
    super.focusNode,
    super.enabled,
    this.style,
    this.placeholderStyle,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.padding = kDefaultPadding,
    this.itemColor = kDefaultItemColor,
    this.itemSize = kDefaultItemSize,
    this.prefixInsets = kDefaultPrefixInsets,
    this.suffixInsets = kDefaultSuffixInsets,
    this.suffixIcon = kDefaultSuffixIcon,
    this.suffixMode = kDefaultSuffixMode,
    this.onSuffixTap,
    this.restorationId,
    this.smartQuotesType,
    this.smartDashesType,
    this.enableIMEPersonalizedLearning = kDefaultEnableIMEPersonalizedLearning,
    this.autocorrect = kDefaultAutocorrect,
    this.cursorWidth = kDefaultCursorWidth,
    this.cursorHeight,
    this.cursorRadius = kDefaultCursorRadius,
    this.cursorOpacityAnimates = kDefaultCursorOpacityAnimates,
    this.cursorColor,
  });
}
