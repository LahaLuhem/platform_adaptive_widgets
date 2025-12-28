import 'package:flutter/cupertino.dart' show CupertinoSearchTextField;
import 'package:flutter/material.dart' show SearchBar;
import 'package:flutter/widgets.dart';

import '/models/interaction/platform_search_bar_data.dart';
import '/models/platform_widget_base.dart';

class PlatformSearchBar extends PlatformWidgetBase {
  final PlatformSearchBarData? platformSearchBarData;
  final MaterialSearchBarData? materialSearchBarData;
  final CupertinoSearchBarData? cupertinoSearchBarData;

  const PlatformSearchBar({
    this.platformSearchBarData,
    this.materialSearchBarData,
    this.cupertinoSearchBarData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => SearchBar(
    key: materialSearchBarData?.widgetKey ?? platformSearchBarData?.widgetKey,
    controller: materialSearchBarData?.controller ?? platformSearchBarData?.controller,
    focusNode: materialSearchBarData?.focusNode ?? platformSearchBarData?.focusNode,
    hintText: materialSearchBarData?.hintText ?? platformSearchBarData?.hintText,
    leading: materialSearchBarData?.leading ?? platformSearchBarData?.leading,
    trailing: materialSearchBarData?.trailing,
    onTap: materialSearchBarData?.onTap ?? platformSearchBarData?.onTap,
    onTapOutside: materialSearchBarData?.onTapOutside,
    onChanged: materialSearchBarData?.onChanged ?? platformSearchBarData?.onChanged,
    onSubmitted: materialSearchBarData?.onSubmitted ?? platformSearchBarData?.onSubmitted,
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
    enabled:
        materialSearchBarData?.enabled ??
        platformSearchBarData?.enabled ??
        PlatformSearchBarData.kDefaultEnabled,
    autoFocus:
        materialSearchBarData?.autoFocus ??
        platformSearchBarData?.autoFocus ??
        PlatformSearchBarData.kDefaultAutoFocus,
    textInputAction: materialSearchBarData?.textInputAction,
    keyboardType: materialSearchBarData?.keyboardType ?? platformSearchBarData?.keyboardType,
    scrollPadding:
        materialSearchBarData?.scrollPadding ?? MaterialSearchBarData.kDefaultScrollPadding,
    contextMenuBuilder: materialSearchBarData?.contextMenuBuilder,
    readOnly: materialSearchBarData?.readOnly ?? MaterialSearchBarData.kDefaultReadOnly,
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSearchTextField(
    key: cupertinoSearchBarData?.widgetKey ?? platformSearchBarData?.widgetKey,
    controller: cupertinoSearchBarData?.controller ?? platformSearchBarData?.controller,
    onChanged: cupertinoSearchBarData?.onChanged ?? platformSearchBarData?.onChanged,
    onSubmitted: cupertinoSearchBarData?.onSubmitted ?? platformSearchBarData?.onSubmitted,
    style: cupertinoSearchBarData?.style,
    placeholder: cupertinoSearchBarData?.hintText ?? platformSearchBarData?.hintText,
    placeholderStyle: cupertinoSearchBarData?.placeholderStyle,
    decoration: cupertinoSearchBarData?.decoration,
    backgroundColor: cupertinoSearchBarData?.backgroundColor,
    borderRadius: cupertinoSearchBarData?.borderRadius,
    keyboardType: cupertinoSearchBarData?.keyboardType ?? platformSearchBarData?.keyboardType,
    padding: cupertinoSearchBarData?.padding ?? CupertinoSearchBarData.kDefaultPadding,
    itemColor: cupertinoSearchBarData?.itemColor ?? CupertinoSearchBarData.kDefaultItemColor,
    itemSize: cupertinoSearchBarData?.itemSize ?? CupertinoSearchBarData.kDefaultItemSize,
    prefixInsets:
        cupertinoSearchBarData?.prefixInsets ?? CupertinoSearchBarData.kDefaultPrefixInsets,
    prefixIcon:
        cupertinoSearchBarData?.leading ??
        platformSearchBarData?.leading ??
        CupertinoSearchBarData.kDefaultLeading,
    suffixInsets:
        cupertinoSearchBarData?.suffixInsets ?? CupertinoSearchBarData.kDefaultSuffixInsets,
    suffixIcon: cupertinoSearchBarData?.suffixIcon ?? CupertinoSearchBarData.kDefaultSuffixIcon,
    suffixMode: cupertinoSearchBarData?.suffixMode ?? CupertinoSearchBarData.kDefaultSuffixMode,
    onSuffixTap: cupertinoSearchBarData?.onSuffixTap,
    restorationId: cupertinoSearchBarData?.restorationId,
    focusNode: cupertinoSearchBarData?.focusNode ?? platformSearchBarData?.focusNode,
    smartQuotesType: cupertinoSearchBarData?.smartQuotesType,
    smartDashesType: cupertinoSearchBarData?.smartDashesType,
    enableIMEPersonalizedLearning:
        cupertinoSearchBarData?.enableIMEPersonalizedLearning ??
        CupertinoSearchBarData.kDefaultEnableIMEPersonalizedLearning,
    autofocus:
        cupertinoSearchBarData?.autoFocus ??
        platformSearchBarData?.autoFocus ??
        PlatformSearchBarData.kDefaultAutoFocus,
    onTap: cupertinoSearchBarData?.onTap ?? platformSearchBarData?.onTap,
    autocorrect: cupertinoSearchBarData?.autocorrect ?? CupertinoSearchBarData.kDefaultAutocorrect,
    enabled:
        cupertinoSearchBarData?.enabled ??
        platformSearchBarData?.enabled ??
        PlatformSearchBarData.kDefaultEnabled,
    cursorWidth: cupertinoSearchBarData?.cursorWidth ?? CupertinoSearchBarData.kDefaultCursorWidth,
    cursorHeight: cupertinoSearchBarData?.cursorHeight,
    cursorRadius:
        cupertinoSearchBarData?.cursorRadius ?? CupertinoSearchBarData.kDefaultCursorRadius,
    cursorOpacityAnimates:
        cupertinoSearchBarData?.cursorOpacityAnimates ??
        CupertinoSearchBarData.kDefaultCursorOpacityAnimates,
    cursorColor: cupertinoSearchBarData?.cursorColor,
  );
}
