// ignore_for_file: prefer-match-file-name

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

  /// Creates Material-specific menu picker configuration.
  const MaterialMenuPickerData({super.leadingIcon, super.labelText, this.expandedInsets});
}

/// Cupertino-specific configuration for a platform menu picker.
///
/// Maps to properties of the Cupertino-style picker on iOS.
final class CupertinoMenuPickerData extends _PlatformMenuPickerData {
  /// Background color of the picker.
  final Color? backgroundColor;

  /// Creates Cupertino-specific menu picker configuration.
  const CupertinoMenuPickerData({super.leadingIcon, super.labelText, this.backgroundColor});
}
