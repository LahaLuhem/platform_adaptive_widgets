// Per-platform records for showPlatformAcknowledge and showPlatformConfirm (no shared private base,
// the title and message are flat on the show function. The Material and Cupertino visual surfaces
// don't overlap in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
library;

import 'package:flutter/widgets.dart';

/// Default value for [MaterialAlertDialogData.scrollable]. Matches upstream `AlertDialog.scrollable`'s
/// default.
const kDefaultMaterialAlertDialogScrollable = false;

/// Default value for [MaterialAlertDialogData.actionsOverflowDirection]. Up, unlike upstream, so a
/// stack puts the confirming action on top as M3 asks.
const kDefaultMaterialAlertDialogActionsOverflowDirection = VerticalDirection.up;

/// Default value for [CupertinoAlertDialogData.insetAnimationDuration]. Matches upstream `CupertinoAlertDialog`'s
/// default.
const kDefaultCupertinoAlertDialogInsetAnimationDuration = Duration(milliseconds: 100);

/// Default value for [CupertinoAlertDialogData.insetAnimationCurve]. Matches upstream `CupertinoAlertDialog`'s
/// default.
const kDefaultCupertinoAlertDialogInsetAnimationCurve = Curves.decelerate;

/// Material-side settings for `showPlatformAcknowledge` and `showPlatformConfirm`, passed as
/// `materialAlertDialogData`.
///
/// Not the same thing as `MaterialDialogData`, which styles the [Dialog] that `showPlatformDialog` wraps
/// around your content. [AlertDialog] already is a Dialog, so nothing wraps it and that surface never
/// comes into play here.
final class const MaterialAlertDialogData({
  /// Sits above the title.
  final Widget? icon,

  final EdgeInsetsGeometry? iconPadding,

  final Color? iconColor,

  final EdgeInsetsGeometry? titlePadding,

  final TextStyle? titleTextStyle,

  final EdgeInsetsGeometry? contentPadding,

  final TextStyle? contentTextStyle,

  /// Wraps the whole action row, where [buttonPadding] wraps each button inside it.
  final EdgeInsetsGeometry? actionsPadding,

  final MainAxisAlignment? actionsAlignment,

  /// The 3 `actionsOverflow*` fields only bite once the buttons stop fitting on one row and stack.
  final OverflowBarAlignment? actionsOverflowAlignment,

  final VerticalDirection actionsOverflowDirection =
      kDefaultMaterialAlertDialogActionsOverflowDirection,

  final double? actionsOverflowButtonSpacing,

  final EdgeInsetsGeometry? buttonPadding,

  final Color? backgroundColor,

  final double? elevation,

  final Color? shadowColor,

  final Color? surfaceTintColor,

  final String? semanticLabel,

  /// How far the dialog keeps off the screen edges.
  final EdgeInsets? insetPadding,

  final Clip? clipBehavior,

  final ShapeBorder? shape,

  final AlignmentGeometry? alignment,

  final BoxConstraints? constraints,

  final bool scrollable = kDefaultMaterialAlertDialogScrollable,
}) {
  /// Creates Material-side settings for an alert.
  this;
}

/// Cupertino-side settings for `showPlatformAcknowledge` and `showPlatformConfirm`, passed as
/// `cupertinoAlertDialogData`.
final class const CupertinoAlertDialogData({
  /// Rarely needed. Cupertino already puts oversized content in a scroll view for you.
  final ScrollController? scrollController,

  final ScrollController? actionScrollController,

  /// How the dialog slides up out of the keyboard's way.
  final Duration insetAnimationDuration = kDefaultCupertinoAlertDialogInsetAnimationDuration,

  final Curve insetAnimationCurve = kDefaultCupertinoAlertDialogInsetAnimationCurve,
}) {
  /// Creates Cupertino-side settings for an alert.
  this;
}
