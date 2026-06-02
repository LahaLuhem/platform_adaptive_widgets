// Per-platform records for showPlatformModalBottomSheet (no shared private
// base — Material's showModalBottomSheet and Cupertino's showCupertinoModalPopup
// have only a small set of overlapping show-function args that live as flat
// parameters; everything else is platform-only).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/dialogs/platform_modal_bottom_sheet.dart';
library;

import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart' show kCupertinoModalBarrierColor;
import 'package:flutter/widgets.dart';

/// Default value for [MaterialModalBottomSheetData.isScrollControlled]. Matches
/// upstream `showModalBottomSheet`'s default.
const kDefaultMaterialModalBottomSheetIsScrollControlled = false;

/// Default value for
/// [MaterialModalBottomSheetData.scrollControlDisabledMaxHeightRatio]. Matches
/// upstream `_kDefaultScrollControlDisabledMaxHeightRatio` (9/16).
const kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

/// Default value for [MaterialModalBottomSheetData.isDismissible]. Matches
/// upstream `showModalBottomSheet`'s default.
const kDefaultMaterialModalBottomSheetIsDismissible = true;

/// Default value for [MaterialModalBottomSheetData.enableDrag]. Matches
/// upstream `showModalBottomSheet`'s default.
const kDefaultMaterialModalBottomSheetEnableDrag = true;

/// Default value for [MaterialModalBottomSheetData.useSafeArea]. Matches
/// upstream `showModalBottomSheet`'s default.
const kDefaultMaterialModalBottomSheetUseSafeArea = false;

/// Default value for [CupertinoModalPopupData.barrierColor]. Matches upstream
/// `kCupertinoModalBarrierColor`.
const kDefaultCupertinoModalPopupBarrierColor = kCupertinoModalBarrierColor;

/// Default value for [CupertinoModalPopupData.barrierDismissible]. Matches
/// upstream `showCupertinoModalPopup`'s default.
const kDefaultCupertinoModalPopupBarrierDismissible = true;

/// Default value for [CupertinoModalPopupData.semanticsDismissible]. Matches
/// upstream `showCupertinoModalPopup`'s default.
const kDefaultCupertinoModalPopupSemanticsDismissible = false;

/// Material-only configuration for `showPlatformModalBottomSheet`.
///
/// Pass this via `showPlatformModalBottomSheet`'s `materialModalBottomSheetData`
/// parameter. The fields declared here have no Cupertino equivalent —
/// `showCupertinoModalPopup` is a much simpler popup surface, with its own
/// platform-only fields living on [CupertinoModalPopupData].
///
/// **Dismissibility & dragging.** Material's bottom sheet has two distinct
/// concepts: [isDismissible] (tap-outside-or-swipe-down to dismiss) and
/// [enableDrag] (allow dragging the sheet to resize/dismiss). Cupertino's
/// popup has just [CupertinoModalPopupData.barrierDismissible] (tap-outside
/// to dismiss). The package does not unify these — set on each per-platform
/// record explicitly.
final class MaterialModalBottomSheetData {
  /// Background colour of the sheet surface.
  final Color? backgroundColor;

  /// Semantic label for the modal barrier.
  final String? barrierLabel;

  /// Elevation of the sheet surface.
  final double? elevation;

  /// Shape of the sheet's border (typically a rounded top edge).
  final ShapeBorder? shape;

  /// Clip behaviour applied to the sheet's content.
  final Clip? clipBehavior;

  /// Size constraints on the sheet.
  final BoxConstraints? constraints;

  /// Whether the sheet is allowed to scroll past its preferred height.
  /// Defaults to [kDefaultMaterialModalBottomSheetIsScrollControlled].
  final bool isScrollControlled;

  /// Max-height ratio when [isScrollControlled] is `false`. Defaults to
  /// [kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio]
  /// (9/16).
  final double scrollControlDisabledMaxHeightRatio;

  /// Whether the user can dismiss the sheet by tapping outside or swiping
  /// down. Defaults to [kDefaultMaterialModalBottomSheetIsDismissible].
  final bool isDismissible;

  /// Whether the user can drag the sheet to resize / dismiss it. Defaults to
  /// [kDefaultMaterialModalBottomSheetEnableDrag].
  final bool enableDrag;

  /// Whether to show the drag-handle glyph above the sheet's content. When
  /// `null`, Material derives this from the theme.
  final bool? showDragHandle;

  /// Whether to wrap the sheet in a [SafeArea]. Defaults to
  /// [kDefaultMaterialModalBottomSheetUseSafeArea].
  final bool useSafeArea;

  /// Custom transition animation controller. Rarely needed.
  final AnimationController? transitionAnimationController;

  /// Animation style for the sheet's appearance.
  final AnimationStyle? sheetAnimationStyle;

  /// Creates Material-only configuration for `showPlatformModalBottomSheet`.
  const MaterialModalBottomSheetData({
    this.backgroundColor,
    this.barrierLabel,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.isScrollControlled = kDefaultMaterialModalBottomSheetIsScrollControlled,
    this.scrollControlDisabledMaxHeightRatio =
        kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio,
    this.isDismissible = kDefaultMaterialModalBottomSheetIsDismissible,
    this.enableDrag = kDefaultMaterialModalBottomSheetEnableDrag,
    this.showDragHandle,
    this.useSafeArea = kDefaultMaterialModalBottomSheetUseSafeArea,
    this.transitionAnimationController,
    this.sheetAnimationStyle,
  });
}

/// Cupertino-only configuration for `showPlatformModalBottomSheet`.
///
/// Pass this via `showPlatformModalBottomSheet`'s `cupertinoModalPopupData`
/// parameter. The fields declared here have no Material equivalent (or are
/// genuinely Cupertino-specific — [filter] applies the iOS-typical blur).
final class CupertinoModalPopupData {
  /// Image filter applied to the popup background — typically a Gaussian blur
  /// to mimic iOS's frosted-glass effect.
  final ImageFilter? filter;

  /// Barrier colour. Defaults to [kDefaultCupertinoModalPopupBarrierColor]
  /// (the iOS-standard translucent black).
  final Color barrierColor;

  /// Whether the user can dismiss the popup by tapping outside. Defaults to
  /// [kDefaultCupertinoModalPopupBarrierDismissible].
  final bool barrierDismissible;

  /// Whether the dismiss action is exposed to accessibility tooling.
  /// Defaults to [kDefaultCupertinoModalPopupSemanticsDismissible].
  final bool semanticsDismissible;

  /// Creates Cupertino-only configuration for `showPlatformModalBottomSheet`.
  const CupertinoModalPopupData({
    this.filter,
    this.barrierColor = kDefaultCupertinoModalPopupBarrierColor,
    this.barrierDismissible = kDefaultCupertinoModalPopupBarrierDismissible,
    this.semanticsDismissible = kDefaultCupertinoModalPopupSemanticsDismissible,
  });
}
