import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoIcons, OverlayVisibilityMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final class PlatformSearchBarData {
  final Key? widgetKey;
  final TextEditingController? controller;

  final String? hintText;
  final Widget? leading;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final TextInputType? keyboardType;
  final bool autoFocus;
  final FocusNode? focusNode;
  final bool enabled;

  static const kDefaultAutoFocus = false;
  static const kDefaultEnabled = true;

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

final class MaterialSearchBarData extends PlatformSearchBarData {
  final Iterable<Widget>? trailing;
  final TapRegionCallback? onTapOutside;
  final BoxConstraints? constraints;

  final WidgetStateProperty<double?>? elevation;
  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? shadowColor;
  final WidgetStateProperty<Color?>? surfaceTintColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<BorderSide?>? side;
  final WidgetStateProperty<OutlinedBorder?>? shape;
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;
  final WidgetStateProperty<TextStyle?>? textStyle;
  final WidgetStateProperty<TextStyle?>? hintStyle;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final EdgeInsets scrollPadding;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool readOnly;

  static const kDefaultScrollPadding = EdgeInsets.all(20);
  static const kDefaultReadOnly = false;

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

final class CupertinoSearchBarData extends PlatformSearchBarData {
  final TextStyle? style;
  final TextStyle? placeholderStyle;
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final Color itemColor;
  final double itemSize;
  final EdgeInsetsGeometry prefixInsets;
  final EdgeInsetsGeometry suffixInsets;
  final Icon suffixIcon;
  final OverlayVisibilityMode suffixMode;
  final VoidCallback? onSuffixTap;
  final String? restorationId;
  final SmartQuotesType? smartQuotesType;
  final SmartDashesType? smartDashesType;
  final bool enableIMEPersonalizedLearning;
  final bool autocorrect;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius cursorRadius;
  final bool cursorOpacityAnimates;
  final Color? cursorColor;

  static const kDefaultLeading = Icon(CupertinoIcons.search);
  static const kDefaultPadding = EdgeInsets.all(8);
  static const kDefaultItemColor = CupertinoColors.placeholderText;
  static const kDefaultItemSize = 20.0;
  static const kDefaultPrefixInsets = EdgeInsetsDirectional.only(start: 6, top: 8, bottom: 8);
  static const kDefaultSuffixInsets = EdgeInsetsDirectional.only(top: 8, end: 5, bottom: 8);
  static const kDefaultSuffixIcon = Icon(CupertinoIcons.xmark_circle_fill);
  static const kDefaultSuffixMode = OverlayVisibilityMode.editing;
  static const kDefaultEnableIMEPersonalizedLearning = true;
  static const kDefaultAutocorrect = true;
  static const kDefaultCursorWidth = 2.0;
  static const kDefaultCursorRadius = Radius.circular(2);
  static const kDefaultCursorOpacityAnimates = true;

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
