// Named after the widget it serves, not after its first record.
// ignore_for_file: prefer-match-file-name

/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show InputBorder, InputDecorationThemeData;

/// Default value for [MaterialMenuPickerData.showTrailingIcon]. Matches upstream `DropdownMenu`'s default
/// of showing a chevron at the trailing edge.
const kDefaultMaterialMenuPickerShowTrailingIcon = true;

/// Default value for [CupertinoMenuPickerData.useIconButtonVariant]. The default full-width field variant
/// is the common case. The icon-button variant is opt-in via the `.iconButton` named ctor.
const kDefaultCupertinoMenuPickerUseIconButtonVariant = false;

/// Material-side settings for [PlatformMenuPicker], passed as `materialMenuPickerData`. The content
/// slots stay flat on the widget, and this is for tweaking how the `DropdownMenu` looks and behaves.
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

  /// Creates Material-side settings that shrink the picker to a 24x24 icon button, by dropping the chevron
  /// and tightening the input decoration.
  ///
  /// The icon comes from the widget's flat [PlatformMenuPicker.leadingIcon]. `labelText` goes unused.
  const new iconButton({this.expandedInsets})
    : showTrailingIcon = false,
      inputDecorationThemeData = const InputDecorationThemeData(
        contentPadding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: 24),
        enabledBorder: InputBorder.none,
      );
}

/// Cupertino-side settings for [PlatformMenuPicker], passed as `cupertinoMenuPickerData`.
final class CupertinoMenuPickerData {
  /// Behind the picker UI.
  final Color? backgroundColor;

  /// Shrinks the picker to an icon button. The `.iconButton` constructor turns it on.
  final bool useIconButtonVariant;

  /// Creates Cupertino-side settings for the usual full-width field.
  const new({this.backgroundColor})
    : useIconButtonVariant = kDefaultCupertinoMenuPickerUseIconButtonVariant;

  /// Creates Cupertino-side settings that swap the `CupertinoListTile` field for a compact `CupertinoButton`
  /// holding just the icon.
  ///
  /// The icon comes from the widget's flat [PlatformMenuPicker.leadingIcon]. `labelText` goes unused.
  const new iconButton({this.backgroundColor}) : useIconButtonVariant = true;
}

/// One entry in the picker's list, built by [PlatformMenuPicker.menuPickerItemTransformer].
final class const MenuPickerItem({final String? label, final IconData? iconData}) {
  /// Creates a menu picker item.
  this;
}
