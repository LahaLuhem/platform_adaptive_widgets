// ignore_for_file: prefer-match-file-name

import 'package:flutter/material.dart' show InputBorder, InputDecorationThemeData;
import 'package:flutter/widgets.dart';

/// Common configuration for platform-adaptive menu pickers.
abstract final class _PlatformMenuPickerData {
  /// Creates a [_PlatformMenuPickerData].
  final Widget? leadingIcon;
  final String? labelText;

  const _PlatformMenuPickerData({this.leadingIcon, this.labelText});
}

/// Material-specific configuration for a platform menu picker.
///
/// Maps to properties of `DropdownMenu` on Android.
final class MaterialMenuPickerData extends _PlatformMenuPickerData {
  /// Insets applied when the dropdown menu is expanded.
  final EdgeInsetsGeometry? expandedInsets;

  /// Whether to show the trailing icon.
  final bool showTrailingIcon;

  /// Theme for the input decoration.
  final InputDecorationThemeData? inputDecorationThemeData;

  /// Default value for [showTrailingIcon].
  static const kDefaultShowTrailingIcon = true;

  /// Creates Material-specific menu picker configuration.
  const MaterialMenuPickerData({
    super.leadingIcon,
    super.labelText,
    this.expandedInsets,
    this.showTrailingIcon = kDefaultShowTrailingIcon,
    this.inputDecorationThemeData,
  });

  /// Creates Material-specific menu picker configuration allowing for just an icon button instead of
  /// the normal text-field.
  ///
  /// The icon for the button can be set using [leadingIcon].
  const MaterialMenuPickerData.iconButton({super.leadingIcon, this.expandedInsets})
    : showTrailingIcon = false,
      inputDecorationThemeData = const InputDecorationThemeData(
        contentPadding: .zero,
        constraints: BoxConstraints.tightFor(width: 24),
        enabledBorder: InputBorder.none,
      ),
      super(labelText: null);
}

/// Cupertino-specific configuration for a platform menu picker.
///
/// Maps to properties of the Cupertino-style picker on iOS.
final class CupertinoMenuPickerData extends _PlatformMenuPickerData {
  /// Background color of the picker.
  final Color? backgroundColor;

  /// Whether to use the icon button variant.
  final bool useIconButtonVariant;

  /// Default value for [useIconButtonVariant].
  static const kDefaultUseIconButtonVariant = false;

  /// Creates Cupertino-specific menu picker configuration.
  const CupertinoMenuPickerData({super.leadingIcon, super.labelText, this.backgroundColor})
    : useIconButtonVariant = kDefaultUseIconButtonVariant;

  /// Creates Cupertino-specific menu picker configuration for the icon button variant instead of
  /// the normal full-width button.
  ///
  /// The icon for the button can be set using [leadingIcon].
  const CupertinoMenuPickerData.iconButton({super.leadingIcon, this.backgroundColor})
    : useIconButtonVariant = true,
      super(labelText: null);
}

/// Represents an item in a menu picker.
///
/// The [iconData] will be ignored on iOS if the number of items forces the use of a modal picker as per
/// **medium-to-long lists of items ** from https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices
final class MenuPickerItem<T extends Object> {
  /// Label text to display for the item.
  final String? label;

  /// Icon to display for the item.
  final IconData? iconData;

  /// Creates a menu picker item.
  const MenuPickerItem({this.label, this.iconData});
}
