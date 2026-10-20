// Named after the widget it serves, not after its first record.
// ignore_for_file: prefer-match-file-name

/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show InputBorder, InputDecorationThemeData;

/// Matches `DropdownMenu`'s own default.
const kDefaultMaterialMenuPickerShowTrailingIcon = true;

/// Off, so the full-width field is what you get unless you ask for `.iconButton`.
const kDefaultCupertinoMenuPickerUseIconButtonVariant = false;

/// Material-only settings for [PlatformMenuPicker]'s `DropdownMenu`.
final class MaterialMenuPickerData {
  /// Only read when the dropdown lays out full-width.
  final EdgeInsetsGeometry? expandedInsets;

  /// The trailing chevron. The `.iconButton` constructor turns it off.
  final bool showTrailingIcon;

  /// Overrides the theme on the input field underneath the dropdown.
  final InputDecorationThemeData? inputDecorationThemeData;

  /// Creates Material-side settings for the usual full-width field.
  const new({
    this.expandedInsets,
    this.showTrailingIcon = kDefaultMaterialMenuPickerShowTrailingIcon,
    this.inputDecorationThemeData,
  });

  /// Shrinks the picker to a 24-wide button showing [PlatformMenuPicker.leadingIcon].
  const new iconButton({this.expandedInsets})
    : showTrailingIcon = false,
      inputDecorationThemeData = const InputDecorationThemeData(
        contentPadding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: 24),
        enabledBorder: InputBorder.none,
      );
}

/// Cupertino-only settings for [PlatformMenuPicker].
final class CupertinoMenuPickerData {
  /// Behind the field.
  final Color? backgroundColor;

  /// Shrinks the picker to an icon button. The `.iconButton` constructor turns it on.
  final bool useIconButtonVariant;

  /// Creates Cupertino-side settings for the usual full-width field.
  const new({this.backgroundColor})
    : useIconButtonVariant = kDefaultCupertinoMenuPickerUseIconButtonVariant;

  /// Shrinks the picker to a button showing [PlatformMenuPicker.leadingIcon].
  const new iconButton({this.backgroundColor}) : useIconButtonVariant = true;
}

/// One entry in the picker's list, built by [PlatformMenuPicker.menuPickerItemTransformer].
final class const MenuPickerItem({final String? label, final IconData? iconData}) {
  /// Creates a menu picker item.
  this;
}
