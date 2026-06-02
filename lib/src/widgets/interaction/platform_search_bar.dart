import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSearchTextField;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show SearchBar;

import '/src/models/interaction/platform_search_bar_data.dart';
import '/src/models/platform_widget_base.dart';

/// A platform-adaptive search bar that renders Material [SearchBar] on
/// Android and [CupertinoSearchTextField] on iOS.
///
/// All functional inputs (controller, callbacks, hint, leading slot,
/// keyboard / focus / enabled state) live as flat constructor parameters.
/// Per-platform visual + behavioural tuning is opt-in via
/// [materialSearchBarData] and [cupertinoSearchBarData]. See
/// `APPENDIX.md#field-classification` for the classification rule and
/// `APPENDIX.md#cross-platform-field-mappings` for the type-divergent
/// shared visuals that consequently live per-platform rather than as a
/// shared private base (notably `backgroundColor`, `padding`, `textStyle`,
/// `hintStyle` — Material exposes them as [WidgetStateProperty] while
/// Cupertino exposes them as direct values).
///
/// Example:
/// ```dart
/// PlatformSearchBar(
///   hintText: 'Search',
///   controller: _controller,
///   onChanged: (q) => _runSearch(q),
/// )
/// ```
class PlatformSearchBar extends PlatformWidgetKeyedBase {
  /// Text-editing controller for the search input.
  final TextEditingController? controller;

  /// Hint / placeholder text displayed when the search bar is empty. Maps to
  /// [SearchBar.hintText] on Android and [CupertinoSearchTextField.placeholder]
  /// on iOS — see `APPENDIX.md#cross-platform-field-mappings`.
  final String? hintText;

  /// Leading widget — typically a search-glyph icon.
  ///
  /// Maps to [SearchBar.leading] on Android (typed `Widget?`, no default) and
  /// [CupertinoSearchTextField.prefixIcon] on iOS (typed non-null `Widget`,
  /// defaulting to `Icon(CupertinoIcons.search)`). The Cupertino branch
  /// substitutes [kDefaultCupertinoSearchBarLeading] when `null`. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Widget? leading;

  /// Callback fired when the search text changes.
  ///
  /// Required and non-null per the callback-nullability rule
  /// (`APPENDIX.md#callback-nullability`) — a search bar without change
  /// observation is just a text field with a glyph. To disable the search
  /// bar, set [isEnabled] to `false`.
  final ValueChanged<String> onChanged;

  /// Callback fired when the user submits (presses the keyboard's action
  /// key). Optional — most controllers consume [onChanged] live and treat
  /// submit as a no-op.
  final ValueChanged<String>? onSubmitted;

  /// Callback fired when the search bar itself is tapped (distinct from the
  /// editing callbacks). Optional.
  final VoidCallback? onTap;

  /// Keyboard type for the search input. When `null`, each platform applies
  /// its own default (Cupertino defaults to [TextInputType.text]; Material
  /// hands `null` straight through to its inner [EditableText]).
  final TextInputType? keyboardType;

  /// Whether the search bar should autofocus on mount. Defaults to `false`.
  /// Maps to [SearchBar.autoFocus] on Android and
  /// [CupertinoSearchTextField.autofocus] (lower-`f`) on iOS — see
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final bool autoFocus;

  /// Focus node for the search bar.
  final FocusNode? focusNode;

  /// Whether the search bar is enabled and responds to input. Defaults to
  /// `true`. Passed straight to each platform's `enabled` (Material defaults
  /// to `true`; Cupertino's `enabled` is nullable and `null`-means-enabled —
  /// the package collapses both to the same boolean).
  final bool isEnabled;

  /// Smart-dashes input feature. When `null`, each platform applies its own
  /// default.
  final SmartDashesType? smartDashesType;

  /// Smart-quotes input feature. When `null`, each platform applies its own
  /// default.
  final SmartQuotesType? smartQuotesType;

  /// Material-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Material branch only; Material-only
  /// fields (`trailing`, `onTapOutside`, `constraints`, `elevation`,
  /// `backgroundColor`/`padding`/`textStyle`/`hintStyle` as state-properties,
  /// `shadowColor`, `surfaceTintColor`, `overlayColor`, `side`, `shape`,
  /// `textCapitalization`, `textInputAction`, `scrollPadding`,
  /// `contextMenuBuilder`, `readOnly`) are read only from here.
  final MaterialSearchBarData? materialSearchBarData;

  /// Cupertino-only visual + functional overrides. Optional.
  ///
  /// Fields set on this record drive the Cupertino branch only; Cupertino-only
  /// fields (`style`, `placeholderStyle`, `decoration`, plain-typed
  /// `backgroundColor` / `padding`, `borderRadius`, `itemColor`, `itemSize`,
  /// `prefixInsets`, `suffixInsets`, `suffixIcon`, `suffixMode`, `onSuffixTap`,
  /// `restorationId`, `enableIMEPersonalizedLearning`, `autocorrect`, cursor
  /// metrics) are read only from here.
  final CupertinoSearchBarData? cupertinoSearchBarData;

  /// Creates a platform-adaptive search bar.
  const PlatformSearchBar({
    required this.onChanged,
    this.controller,
    this.hintText,
    this.leading,
    this.onSubmitted,
    this.onTap,
    this.keyboardType,
    this.autoFocus = false,
    this.focusNode,
    this.isEnabled = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.materialSearchBarData,
    this.cupertinoSearchBarData,
    super.widgetKey,
    super.key,
  });

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
