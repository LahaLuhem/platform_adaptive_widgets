import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSearchTextField;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show SearchBar;

import '/src/models/interaction/platform_search_bar_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive search bar that renders Material SearchBar on Android
/// and CupertinoSearchTextField on iOS.
///
/// This widget automatically selects the appropriate search bar implementation based on the target platform:
/// - On Android: renders Material Design SearchBar
/// - On iOS: renders CupertinoSearchTextField
///
/// The search bar can be configured with platform-specific data through [materialSearchBarData]
/// and [cupertinoSearchBarData], or with common properties.
///
/// Example:
/// ```dart
/// PlatformSearchBar(
///   platformSearchBarData: PlatformSearchBarData(
///     hintText: 'Search...',
///     onChanged: (value) => print('Searching: $value'),
///   ),
/// )
/// ```
class PlatformSearchBar extends PlatformWidgetBase {
  /// Platform-shared search bar configuration.
  final PlatformSearchBarData? platformSearchBarData;

  /// Material-specific search bar data.
  final MaterialSearchBarData? materialSearchBarData;

  /// Cupertino-specific search bar data.
  final CupertinoSearchBarData? cupertinoSearchBarData;

  /// Creates a platform-adaptive search bar.
  ///
  /// The search bar will render as a Material SearchBar on Android and a CupertinoSearchTextField on iOS.
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
