// Per-platform records for showPlatformModalBottomSheet (no shared private
// base. Material's showModalBottomSheet and Cupertino's showCupertinoModalPopup
// have only a small set of overlapping show-function args that live as flat
// parameters. Everything else is platform-only).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_modal_bottom_sheet.dart';
library;

import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart' show kCupertinoModalBarrierColor;
import 'package:flutter/widgets.dart';

/// Default value for [MaterialModalBottomSheetData.isScrollControlled]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetIsScrollControlled = false;

/// Default value for [MaterialModalBottomSheetData.scrollControlDisabledMaxHeightRatio]. Matches upstream
/// `_kDefaultScrollControlDisabledMaxHeightRatio` (9/16).
const kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

/// Default value for [MaterialModalBottomSheetData.isDismissible]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetIsDismissible = true;

/// Default value for [MaterialModalBottomSheetData.enableDrag]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetEnableDrag = true;

/// Default value for [MaterialModalBottomSheetData.useSafeArea]. Matches upstream `showModalBottomSheet`'s
/// default.
const kDefaultMaterialModalBottomSheetUseSafeArea = false;

/// Default value for [CupertinoModalPopupData.barrierColor]. Matches upstream `kCupertinoModalBarrierColor`.
const kDefaultCupertinoModalPopupBarrierColor = kCupertinoModalBarrierColor;

/// Default value for [CupertinoModalPopupData.barrierDismissible]. Matches upstream `showCupertinoModalPopup`'s
/// default.
const kDefaultCupertinoModalPopupBarrierDismissible = true;

/// Default value for [CupertinoModalPopupData.semanticsDismissible]. Matches upstream `showCupertinoModalPopup`'s
/// default.
const kDefaultCupertinoModalPopupSemanticsDismissible = false;

/// Material-side settings for `showPlatformModalBottomSheet`, passed as `materialModalBottomSheetData`.
/// None of it reaches iOS, where `showCupertinoModalPopup` is a far plainer thing with its own fields
/// on [CupertinoModalPopupData].
///
/// Dismissing is 2 separate ideas here and one over there, so set them per platform. [isDismissible]
/// covers tapping outside or swiping down, [enableDrag] covers dragging the sheet to resize or throw
/// it away, and iOS only has [CupertinoModalPopupData.barrierDismissible] for the tap.
final class const MaterialModalBottomSheetData({
  final Color? backgroundColor,

  final String? barrierLabel,

  final double? elevation,

  /// Usually a rounded top edge.
  final ShapeBorder? shape,

  final Clip? clipBehavior,

  final BoxConstraints? constraints,

  /// Lets the sheet grow past its preferred height, up to the full screen.
  final bool isScrollControlled = kDefaultMaterialModalBottomSheetIsScrollControlled,

  /// The ceiling while [isScrollControlled] is off, as a fraction of the screen.
  final double scrollControlDisabledMaxHeightRatio =
      kDefaultMaterialModalBottomSheetScrollControlDisabledMaxHeightRatio,

  final bool isDismissible = kDefaultMaterialModalBottomSheetIsDismissible,

  final bool enableDrag = kDefaultMaterialModalBottomSheetEnableDrag,

  /// The little grab bar above the content. Left out, the theme decides.
  final bool? showDragHandle,

  final bool useSafeArea = kDefaultMaterialModalBottomSheetUseSafeArea,

  /// Rarely needed.
  final AnimationController? transitionAnimationController,

  final AnimationStyle? sheetAnimationStyle,
}) {
  /// Creates Material-side settings for `showPlatformModalBottomSheet`.
  this;
}

/// Cupertino-side settings for `showPlatformModalBottomSheet`, passed as `cupertinoModalPopupData`.
final class const CupertinoModalPopupData({
  /// Usually a Gaussian blur, for the frosted glass look iOS goes in for.
  final ImageFilter? filter,

  final Color barrierColor = kDefaultCupertinoModalPopupBarrierColor,

  /// Lets a tap outside dismiss the popup.
  final bool barrierDismissible = kDefaultCupertinoModalPopupBarrierDismissible,

  /// Offers that dismiss action to screen readers too.
  final bool semanticsDismissible = kDefaultCupertinoModalPopupSemanticsDismissible,
}) {
  /// Creates Cupertino-side settings for `showPlatformModalBottomSheet`.
  this;
}
