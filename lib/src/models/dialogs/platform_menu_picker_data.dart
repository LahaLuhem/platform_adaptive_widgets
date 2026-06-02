// Per-platform records for PlatformMenuPicker (no shared private base — the
// inherited `leadingIcon`/`labelText` fields in the v1 wrapper were dead code
// because the widget reads its own flat copies; they're gone).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show InputBorder, InputDecorationThemeData;

/// Default value for [MaterialMenuPickerData.showTrailingIcon]. Matches
/// upstream `DropdownMenu`'s default of showing a chevron at the trailing edge.
const kDefaultMaterialMenuPickerShowTrailingIcon = true;

/// Default value for [CupertinoMenuPickerData.useIconButtonVariant]. The
/// default full-width field variant is the common case; the icon-button
/// variant is opt-in via the `.iconButton` named ctor.
const kDefaultCupertinoMenuPickerUseIconButtonVariant = false;

/// Material-only configuration for [PlatformMenuPicker].
///
/// Pass this via `PlatformMenuPicker.materialMenuPickerData` when tuning the
/// Material `DropdownMenu` specifically. The widget's flat `leadingIcon` /
/// `labelText` / `isEnabled` / etc. drive the cross-platform content slots;
/// fields here are Material-only visual / behavioural tweaks.
final class MaterialMenuPickerData {
  /// Insets applied when the dropdown is laid out in an expanded
  /// (full-width) configuration.
  final EdgeInsetsGeometry? expandedInsets;

  /// Whether to show the trailing chevron icon. Defaults to
  /// [kDefaultMaterialMenuPickerShowTrailingIcon]. The `.iconButton` named
  /// ctor sets this to `false` for compact icon-button rendering.
  final bool showTrailingIcon;

  /// Theme overrides for the dropdown's underlying input decoration.
  final InputDecorationThemeData? inputDecorationThemeData;

  /// Creates Material-only configuration for [PlatformMenuPicker] in its
  /// standard full-width-field rendering.
  const MaterialMenuPickerData({
    this.expandedInsets,
    this.showTrailingIcon = kDefaultMaterialMenuPickerShowTrailingIcon,
    this.inputDecorationThemeData,
  });

  /// Creates Material-only configuration for the **icon-button variant** —
  /// renders the picker as a compact 24x24 icon button instead of the standard
  /// full-width field. Sets [showTrailingIcon] to `false` and uses a tight
  /// input-decoration theme matching the icon-button visual.
  ///
  /// The icon itself is the widget's flat [PlatformMenuPicker.leadingIcon];
  /// `labelText` is ignored in this variant.
  const MaterialMenuPickerData.iconButton({this.expandedInsets})
    : showTrailingIcon = false,
      inputDecorationThemeData = const InputDecorationThemeData(
        contentPadding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: 24),
        enabledBorder: InputBorder.none,
      );
}

/// Cupertino-only configuration for [PlatformMenuPicker].
///
/// Pass this via `PlatformMenuPicker.cupertinoMenuPickerData` when tuning the
/// Cupertino branch. Cupertino's render strategy is item-count-dependent: ≤5
/// items use [CupertinoMenuAnchor]; >5 use [CupertinoPicker] in a modal popup
/// (per Apple's HIG picker best-practices).
final class CupertinoMenuPickerData {
  /// Background colour for the picker UI.
  final Color? backgroundColor;

  /// Whether to render as a compact icon-button instead of a full-width field.
  /// The `.iconButton` named ctor sets this to `true`.
  final bool useIconButtonVariant;

  /// Creates Cupertino-only configuration for [PlatformMenuPicker] in its
  /// standard full-width-field rendering.
  const CupertinoMenuPickerData({this.backgroundColor})
    : useIconButtonVariant = kDefaultCupertinoMenuPickerUseIconButtonVariant;

  /// Creates Cupertino-only configuration for the **icon-button variant** —
  /// renders the picker as a compact `CupertinoButton` with the icon as its
  /// child, instead of the standard `CupertinoListTile` field.
  ///
  /// The icon itself is the widget's flat [PlatformMenuPicker.leadingIcon];
  /// `labelText` is ignored in this variant.
  const CupertinoMenuPickerData.iconButton({this.backgroundColor}) : useIconButtonVariant = true;
}

/// One entry in the menu picker's dropdown / wheel list.
///
/// Returned by [PlatformMenuPicker.menuPickerItemTransformer] for each item
/// in the picker's `items` list.
///
/// **Note.** The [iconData] is ignored on iOS when the item count exceeds the
/// small-item threshold (5) — Apple's HIG specifies a wheel picker for
/// medium-to-long lists, and [CupertinoPicker] doesn't render per-item icons.
/// See <https://developer.apple.com/design/human-interface-guidelines/pickers#Best-practices>.
final class MenuPickerItem {
  /// Label text shown on the entry.
  final String? label;

  /// Icon shown alongside the label. Ignored on iOS for >5-item lists (see
  /// class-level note).
  final IconData? iconData;

  /// Creates a menu picker item.
  const MenuPickerItem({this.label, this.iconData});
}
