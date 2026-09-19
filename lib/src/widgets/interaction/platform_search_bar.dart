import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSearchTextField;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show SearchBar;

import '/src/models/interaction/platform_search_bar_data.dart';
import '/src/models/platform_widget_base.dart';

/// Material [SearchBar] on Android, [CupertinoSearchTextField] on iOS.
///
/// Per-platform tuning lives in [materialSearchBarData] / [cupertinoSearchBarData], and there's more
/// of it here than usual: `backgroundColor`, `padding`, `textStyle` and `hintStyle` all exist on both
/// platforms but with different types, Material keying them off [WidgetStateProperty] where Cupertino
/// takes a plain value. See `APPENDIX.md#field-classification` and `APPENDIX.md#cross-platform-field-mappings`.
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_search_bar.dart#platform_search_bar}
class const PlatformSearchBar({
  /// Stays required and non-null. A search bar nobody listens to is a text field with a magnifying glass.
  /// Disable it with [isEnabled] instead. See `APPENDIX.md#callback-nullability`.
  required final ValueChanged<String> onChanged,

  final TextEditingController? controller,

  /// Shown while the bar is empty. iOS calls it the placeholder.
  final String? hintText,

  /// Usually the magnifying glass. iOS insists on having one, so it falls back to [kDefaultCupertinoSearchBarLeading]
  /// when you leave this out. Android is happy without.
  final Widget? leading,

  /// Fires on the keyboard's action key. Often unused, since [onChanged] already reports every keystroke.
  final ValueChanged<String>? onSubmitted,

  /// Fires on a tap of the bar itself, which is separate from the editing callbacks.
  final VoidCallback? onTap,

  /// Left out, each platform brings its own default.
  final TextInputType? keyboardType,

  /// Note the capital F, which iOS spells lowercase underneath. See `APPENDIX.md#cross-platform-field-mappings`.
  final bool autoFocus = false,

  final FocusNode? focusNode,

  /// One boolean for both, though iOS's own `enabled` is nullable and treats `null` as enabled.
  final bool isEnabled = true,

  final SmartDashesType? smartDashesType,

  final SmartQuotesType? smartQuotesType,

  /// Material-branch overrides, plus the knobs Cupertino has no answer for.
  final MaterialSearchBarData? materialSearchBarData,

  /// Cupertino-branch overrides, plus the knobs Material has no answer for.
  final CupertinoSearchBarData? cupertinoSearchBarData,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive search bar.
  this;

  @override
  Widget buildMaterial(BuildContext context) => SearchBar(
    key: widgetKey,
    controller: controller,
    focusNode: focusNode,
    hintText: hintText,
    leading: leading,
    trailing: materialSearchBarData?.trailing,
    onTap: onTap,
    onTapOutside: materialSearchBarData?.onTapOutside,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    constraints: materialSearchBarData?.constraints,
    elevation: materialSearchBarData?.elevation,
    backgroundColor: materialSearchBarData?.backgroundColor,
    shadowColor: materialSearchBarData?.shadowColor,
    surfaceTintColor: materialSearchBarData?.surfaceTintColor,
    overlayColor: materialSearchBarData?.overlayColor,
    side: materialSearchBarData?.side,
    shape: materialSearchBarData?.shape,
    padding: materialSearchBarData?.padding,
    textStyle: materialSearchBarData?.textStyle,
    hintStyle: materialSearchBarData?.hintStyle,
    textCapitalization: materialSearchBarData?.textCapitalization,
    enabled: isEnabled,
    autoFocus: autoFocus,
    textInputAction: materialSearchBarData?.textInputAction,
    keyboardType: keyboardType,
    scrollPadding: materialSearchBarData?.scrollPadding ?? kDefaultSearchBarScrollPadding,
    contextMenuBuilder: materialSearchBarData?.contextMenuBuilder,
    readOnly: materialSearchBarData?.readOnly ?? kDefaultSearchBarReadOnly,
    smartDashesType: smartDashesType,
    smartQuotesType: smartQuotesType,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSearchTextField(
    key: widgetKey,
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    style: cupertinoSearchBarData?.style,
    placeholder: hintText,
    placeholderStyle: cupertinoSearchBarData?.placeholderStyle,
    decoration: cupertinoSearchBarData?.decoration,
    backgroundColor: cupertinoSearchBarData?.backgroundColor,
    borderRadius: cupertinoSearchBarData?.borderRadius,
    keyboardType: keyboardType,
    padding: cupertinoSearchBarData?.padding ?? kDefaultCupertinoSearchBarPadding,
    itemColor: cupertinoSearchBarData?.itemColor ?? kDefaultCupertinoSearchBarItemColor,
    itemSize: cupertinoSearchBarData?.itemSize ?? kDefaultCupertinoSearchBarItemSize,
    prefixInsets: cupertinoSearchBarData?.prefixInsets ?? kDefaultCupertinoSearchBarPrefixInsets,
    prefixIcon: leading ?? kDefaultCupertinoSearchBarLeading,
    suffixInsets: cupertinoSearchBarData?.suffixInsets ?? kDefaultCupertinoSearchBarSuffixInsets,
    suffixIcon: cupertinoSearchBarData?.suffixIcon ?? kDefaultCupertinoSearchBarSuffixIcon,
    suffixMode: cupertinoSearchBarData?.suffixMode ?? kDefaultCupertinoSearchBarSuffixMode,
    onSuffixTap: cupertinoSearchBarData?.onSuffixTap,
    restorationId: cupertinoSearchBarData?.restorationId,
    focusNode: focusNode,
    smartQuotesType: smartQuotesType,
    smartDashesType: smartDashesType,
    enableIMEPersonalizedLearning:
        cupertinoSearchBarData?.enableIMEPersonalizedLearning ??
        kDefaultCupertinoSearchBarEnableIMEPersonalizedLearning,
    autofocus: autoFocus,
    onTap: onTap,
    autocorrect: cupertinoSearchBarData?.autocorrect ?? kDefaultCupertinoSearchBarAutocorrect,
    enabled: isEnabled,
    cursorWidth: cupertinoSearchBarData?.cursorWidth ?? kDefaultCupertinoSearchBarCursorWidth,
    cursorHeight: cupertinoSearchBarData?.cursorHeight,
    cursorRadius: cupertinoSearchBarData?.cursorRadius ?? kDefaultCupertinoSearchBarCursorRadius,
    cursorOpacityAnimates:
        cupertinoSearchBarData?.cursorOpacityAnimates ??
        kDefaultCupertinoSearchBarCursorOpacityAnimates,
    cursorColor: cupertinoSearchBarData?.cursorColor,
  );
}
