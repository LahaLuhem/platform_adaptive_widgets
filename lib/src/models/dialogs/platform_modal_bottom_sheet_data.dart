// Per-platform records for showPlatformRawModalBottomSheet and showPlatformChoices (no shared private
// base. Material's showModalBottomSheet and Cupertino's showCupertinoModalPopup have only a small set
// of overlapping show-function args that live as flat parameters. Everything else is platform-only).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_modal_bottom_sheet.dart';
library;

import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

/// Default value for [MaterialModalBottomSheetData.isScrollControlled]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetIsScrollControlled = false;

/// Default value for [MaterialModalBottomSheetData.scrollControlDisabledMaxHeightRatio]. Matches upstream
/// `_kDefaultScrollControlDisabledMaxHeightRatio` (9/16).
const kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

/// Default value for [MaterialModalBottomSheetData.enableDrag]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetEnableDrag = true;

/// Default value for [MaterialModalBottomSheetData.useSafeArea]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetUseSafeArea = false;

/// Default value for [CupertinoModalPopupData.semanticsDismissible]. Matches upstream `showCupertinoModalPopup`'s
/// default.
@Deprecated('Goes with CupertinoModalPopupData.semanticsDismissible in the next major.')
const kDefaultCupertinoModalPopupSemanticsDismissible = false;

/// Material-side settings for `showPlatformRawModalBottomSheet` and `showPlatformChoices`, passed as
/// `materialModalBottomSheetData`. None of it reaches Cupertino.
final class const MaterialModalBottomSheetData({
  /// The sheet's fill, passed to [showModalBottomSheet].
  final Color? backgroundColor,

  /// What screen readers call the barrier, passed to [showModalBottomSheet].
  final String? barrierLabel,

  /// How far the sheet lifts off the page, passed to [showModalBottomSheet].
  final double? elevation,

  /// Usually a rounded top edge.
  final ShapeBorder? shape,

  /// How the sheet clips its content, passed to [showModalBottomSheet].
  final Clip? clipBehavior,

  /// Limits the sheet's size, passed to [showModalBottomSheet].
  final BoxConstraints? constraints,

  /// Lets the sheet grow past its preferred height, up to the full screen.
  final bool isScrollControlled = kDefaultMaterialModalBottomSheetIsScrollControlled,

  /// The ceiling while [isScrollControlled] is off, as a fraction of the screen.
  final double scrollControlDisabledMaxHeightRatio =
      kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio,

  /// A swipe down still closes the sheet when `barrierDismissible` is off.
  final bool enableDrag = kDefaultMaterialModalBottomSheetEnableDrag,

  /// The little grab bar above the content. Left out, the theme decides.
  final bool? showDragHandle,

  /// Keeps the sheet clear of system intrusions at the top and sides, passed to [showModalBottomSheet].
  final bool useSafeArea = kDefaultMaterialModalBottomSheetUseSafeArea,

  /// Rarely needed.
  final AnimationController? transitionAnimationController,

  /// Overrides the sheet's open and close animation, passed to [showModalBottomSheet].
  final AnimationStyle? sheetAnimationStyle,
}) {
  /// Creates Material-side settings for the raw sheet and the choices.
  this;
}

/// Cupertino-side settings for `showPlatformChoices`, passed as `cupertinoModalPopupData`.
final class const CupertinoModalPopupData({
  /// Usually a Gaussian blur, for the frosted glass look iOS goes in for.
  final ImageFilter? filter,

  /// Does nothing now. Screen readers follow `barrierDismissible`.
  @Deprecated('Screen readers follow barrierDismissible now. Goes in the next major.')
  final bool semanticsDismissible = false,
}) {
  /// Creates Cupertino-side settings for `showPlatformChoices`.
  this;
}
