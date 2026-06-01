// Multiple data classes in one file; private base + per-platform records.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/painting/platform_list_tile.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show ListTileStyle, ListTileTitleAlignment, VisualDensity;

/// Default value for [MaterialListTileData.autofocus].
const kDefaultListTileAutofocus = false;

/// Default value for [MaterialListTileData.internalAddSemanticForOnTap].
const kDefaultListTileInternalAddSemanticForOnTap = false;

/// Default value for [MaterialListTileData.selected].
const kDefaultListTileSelected = false;

/// Default value for [MaterialListTileData.titleAlignment].
const kDefaultListTileTitleAlignment = ListTileTitleAlignment.threeLine;

/// Default leading-size for the **base** Cupertino variant of
/// [PlatformListTile].
///
/// Mirrors Flutter's private `_kLeadingSize` in
/// `package:flutter/src/cupertino/list_tile.dart`. The Cupertino branch
/// substitutes this when the widget's flat `leadingWidth` is `null` and the
/// tile is the base ([CupertinoListTileData.isNotched] = `false`) variant.
/// Re-validate on Flutter SDK bumps — the upstream constant is private.
const kDefaultCupertinoListTileLeadingSize = 28.0;

/// Default leading-to-title gap for the **base** Cupertino variant of
/// [PlatformListTile].
///
/// Mirrors Flutter's private `_kLeadingToTitle` in
/// `package:flutter/src/cupertino/list_tile.dart`. Re-validate on Flutter
/// SDK bumps — the upstream constant is private.
const kDefaultCupertinoListTileLeadingToTitle = 16.0;

/// Default leading-size for the **notched** Cupertino variant of
/// [PlatformListTile] ([CupertinoListTile.notched]).
///
/// Mirrors Flutter's private `_kNotchedLeadingSize`. The Cupertino branch
/// substitutes this when the widget's flat `leadingWidth` is `null` and
/// [CupertinoListTileData.isNotched] is `true`. Notched defaults differ
/// from the base variant — the previous package version used the base
/// defaults for both, silently breaking notched's idiomatic visuals.
/// Re-validate on Flutter SDK bumps — the upstream constant is private.
const kDefaultCupertinoNotchedListTileLeadingSize = 30.0;

/// Default leading-to-title gap for the **notched** Cupertino variant of
/// [PlatformListTile] ([CupertinoListTile.notched]).
///
/// Mirrors Flutter's private `_kNotchedLeadingToTitle`. Re-validate on
/// Flutter SDK bumps — the upstream constant is private.
const kDefaultCupertinoNotchedListTileLeadingToTitle = 12.0;

/// Default value for [CupertinoListTileData.isNotched].
const kDefaultCupertinoListTileIsNotched = false;

/// Internal abstract base holding shared-visual fields for
/// [PlatformListTile].
///
/// Inherited by [MaterialListTileData] and [CupertinoListTileData] so each
/// per-platform record carries the shared-visual surface via `super.x`
/// constructor forwarding. Library-private — never exported from the
/// package.
///
/// See `APPENDIX.md#field-classification` for the rule placing shared-visual
/// fields on a private base. The fields in this base have name divergences
/// across platforms — see `APPENDIX.md#cross-platform-field-mappings`.
abstract class _PlatformListTileData {
  /// Width of the leading widget slot.
  ///
  /// Maps to [ListTile.minLeadingWidth] on Android and to
  /// [CupertinoListTile.leadingSize] on iOS (Cupertino is non-null with
  /// per-variant defaults — see [kDefaultCupertinoListTileLeadingSize] /
  /// [kDefaultCupertinoNotchedListTileLeadingSize]). See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final double? leadingWidth;

  /// Background colour of the tile.
  ///
  /// Maps to [ListTile.tileColor] on Android and to
  /// [CupertinoListTile.backgroundColor] on iOS. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final Color? color;

  /// Padding around the tile content.
  ///
  /// Maps to [ListTile.contentPadding] on Android and to
  /// [CupertinoListTile.padding] on iOS. See
  /// `APPENDIX.md#cross-platform-field-mappings`.
  final EdgeInsetsGeometry? padding;

  const _PlatformListTileData({this.leadingWidth, this.color, this.padding});
}

/// Material-only configuration for [PlatformListTile].
///
/// Pass this via `PlatformListTile.materialListTileData` when tuning
/// Material rendering. Inherited shared-visual fields override the widget's
/// flat defaults on the Material branch; the fields declared here have no
/// Cupertino equivalent.
///
/// Houses both Material-only visual fields (`mouseCursor`, `focusColor`,
/// `iconColor`, `selectedColor`, `shape`, `splashColor`, `style`, text
/// styles, `horizontalTitleGap`, `visualDensity`, etc.) and Material-only
/// functional fields (`statesController`, `focusNode`, `autofocus`,
/// `onFocusChange`, `onLongPress`, `enableFeedback`, `selected`,
/// `internalAddSemanticForOnTap`, `isThreeLine`) per the platform-only
/// bucket in `APPENDIX.md#field-classification` — Cupertino's list tile
/// exposes none of these.
final class MaterialListTileData extends _PlatformListTileData {
  /// Controller for managing the tile's interaction states. Functional,
  /// Material-only.
  final WidgetStatesController? statesController;

  /// Cursor to display when hovering over the tile.
  final MouseCursor? mouseCursor;

  /// Whether the tile should autofocus when mounted. Functional,
  /// Material-only — Cupertino's list tile does not participate in focus
  /// traversal. Defaults to [kDefaultListTileAutofocus].
  final bool autofocus;

  /// Whether to play haptic feedback on tap. Functional, Material-only —
  /// Cupertino's list tile has no equivalent toggle.
  final bool? enableFeedback;

  /// Colour of the tile when focused.
  final Color? focusColor;

  /// Focus node for the tile. Functional, Material-only.
  final FocusNode? focusNode;

  /// Horizontal gap between the leading content and the title.
  ///
  /// Material-only — see [CupertinoListTileData.leadingToTitle] for
  /// Cupertino's similar-but-not-identical concept. They differ in
  /// geometry (leading-content-edge vs leading-edge) and default value
  /// per-variant; kept separate per the "don't unify superficially similar
  /// fields" rule in `APPENDIX.md#field-classification`.
  final double? horizontalTitleGap;

  /// Colour of the tile when hovered.
  final Color? hoverColor;

  /// Colour of the leading and trailing icons.
  final Color? iconColor;

  /// Whether to add semantic annotations for tap events. Functional,
  /// Material-only. Defaults to
  /// [kDefaultListTileInternalAddSemanticForOnTap].
  final bool internalAddSemanticForOnTap;

  /// Whether to display the tile in the three-line layout. Functional,
  /// Material-only — Cupertino's list tile auto-sizes.
  final bool? isThreeLine;

  /// Text style for leading and trailing widgets.
  final TextStyle? leadingAndTrailingTextStyle;

  /// Minimum height of the tile.
  final double? minTileHeight;

  /// Minimum vertical padding of the tile.
  final double? minVerticalPadding;

  /// Callback fired when the tile gains or loses focus. Functional,
  /// Material-only.
  final ValueChanged<bool>? onFocusChange;

  /// Callback fired when the tile is long-pressed. Functional,
  /// Material-only — Cupertino's list tile has no long-press handling.
  final VoidCallback? onLongPress;

  /// Whether the tile is currently selected. Material-only — drives the
  /// selected-state visuals. Defaults to [kDefaultListTileSelected].
  final bool selected;

  /// Colour of the selected tile's content (text + icons).
  final Color? selectedColor;

  /// Background colour of the selected tile.
  final Color? selectedTileColor;

  /// Shape border of the tile.
  final ShapeBorder? shape;

  /// Splash colour for the tile's ink effect.
  final Color? splashColor;

  /// Material text styling preset for the tile.
  final ListTileStyle? style;

  /// Text style for the subtitle.
  final TextStyle? subtitleTextStyle;

  /// Colour of the tile's text content.
  final Color? textColor;

  /// Alignment of the title within the tile. Defaults to
  /// [kDefaultListTileTitleAlignment].
  final ListTileTitleAlignment titleAlignment;

  /// Text style for the title.
  final TextStyle? titleTextStyle;

  /// Visual density of the tile.
  final VisualDensity? visualDensity;

  /// Creates Material-only configuration for [PlatformListTile].
  const MaterialListTileData({
    super.leadingWidth,
    super.color,
    super.padding,
    this.statesController,
    this.mouseCursor,
    this.autofocus = kDefaultListTileAutofocus,
    this.enableFeedback,
    this.focusColor,
    this.focusNode,
    this.horizontalTitleGap,
    this.hoverColor,
    this.iconColor,
    this.internalAddSemanticForOnTap = kDefaultListTileInternalAddSemanticForOnTap,
    this.isThreeLine,
    this.leadingAndTrailingTextStyle,
    this.minTileHeight,
    this.minVerticalPadding,
    this.onFocusChange,
    this.onLongPress,
    this.selected = kDefaultListTileSelected,
    this.selectedColor,
    this.selectedTileColor,
    this.shape,
    this.splashColor,
    this.style,
    this.subtitleTextStyle,
    this.textColor,
    this.titleAlignment = kDefaultListTileTitleAlignment,
    this.titleTextStyle,
    this.visualDensity,
  });
}

/// Cupertino-only configuration for [PlatformListTile].
///
/// Pass this via `PlatformListTile.cupertinoListTileData` when tuning
/// Cupertino rendering. Inherited shared-visual fields override the widget's
/// flat defaults on the Cupertino branch; the fields declared here have no
/// Material equivalent.
///
/// [isNotched] selects between [CupertinoListTile] (base) and
/// [CupertinoListTile.notched] — a Cupertino-specific constructor variant
/// with different default geometry. Kept on this record (rather than as a
/// `.notched()` constructor on the widget) so the variant choice is
/// scoped to the Cupertino branch — Material renders identically either way
/// and exposing a `.notched()` named constructor on the widget would
/// falsely suggest cross-platform meaning.
final class CupertinoListTileData extends _PlatformListTileData {
  /// Additional information widget displayed in the trailing area
  /// (above/beside `trailing`). Cupertino-only — Material's `ListTile` has
  /// no equivalent slot.
  final Widget? additionalInfo;

  /// Background colour of the tile while a tap is in flight.
  /// Cupertino-only.
  final Color? backgroundColorActivated;

  /// Horizontal gap between the leading edge and the title.
  ///
  /// Cupertino-only — see [MaterialListTileData.horizontalTitleGap] for
  /// Material's similar-but-not-identical concept. Defaults to
  /// [kDefaultCupertinoListTileLeadingToTitle] for the base variant or
  /// [kDefaultCupertinoNotchedListTileLeadingToTitle] for the notched
  /// variant — picked at build time based on [isNotched]. Pass `null` to
  /// accept the appropriate default.
  final double? leadingToTitle;

  /// Whether to render the notched Cupertino variant
  /// ([CupertinoListTile.notched]) instead of the base
  /// ([CupertinoListTile]). Cupertino-only — Material renders identically
  /// either way. Defaults to [kDefaultCupertinoListTileIsNotched].
  final bool isNotched;

  /// Creates Cupertino-only configuration for [PlatformListTile].
  const CupertinoListTileData({
    super.leadingWidth,
    super.color,
    super.padding,
    this.additionalInfo,
    this.backgroundColorActivated,
    this.leadingToTitle,
    this.isNotched = kDefaultCupertinoListTileIsNotched,
  });
}
