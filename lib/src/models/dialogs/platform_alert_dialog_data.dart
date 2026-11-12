// Per-platform records for showPlatformAcknowledge and showPlatformConfirm (no shared private base,
// the title and message are flat on the show function. The Material and Cupertino visual surfaces
// don't overlap in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:flutter/widgets.dart';

/// Default value for [MaterialAlertDialogData.scrollable]. Matches upstream `AlertDialog.scrollable`'s
/// default.
const kDefaultMaterialAlertDialogScrollable = false;

/// Default value for [CupertinoAlertDialogData.insetAnimationDuration]. Matches upstream `CupertinoAlertDialog`'s
/// default.
const kDefaultCupertinoAlertDialogInsetAnimationDuration = Duration(milliseconds: 100);

/// Default value for [CupertinoAlertDialogData.insetAnimationCurve]. Matches upstream `CupertinoAlertDialog`'s
/// default.
const kDefaultCupertinoAlertDialogInsetAnimationCurve = Curves.decelerate;

/// Material-side settings for `showPlatformAcknowledge` and `showPlatformConfirm`, passed as
/// `materialAlertDialogData`.
final class const MaterialAlertDialogData({
  /// Sits above the title.
  final Widget? icon,

  /// Forwards to [AlertDialog.iconPadding].
  final EdgeInsetsGeometry? iconPadding,

  /// Forwards to [AlertDialog.iconColor].
  final Color? iconColor,

  /// Forwards to [AlertDialog.titlePadding].
  final EdgeInsetsGeometry? titlePadding,

  /// Forwards to [AlertDialog.titleTextStyle].
  final TextStyle? titleTextStyle,

  /// Left out, a lone message with no icon gets M3's 24 on every side, where [AlertDialog.contentPadding]
  /// leaves 16 above it.
  final EdgeInsetsGeometry? contentPadding,

  /// Forwards to [AlertDialog.contentTextStyle].
  final TextStyle? contentTextStyle,

  /// Wraps the whole action row, where [buttonPadding] wraps each button inside it.
  final EdgeInsetsGeometry? actionsPadding,

  /// Forwards to [AlertDialog.actionsAlignment].
  final MainAxisAlignment? actionsAlignment,

  /// The 3 `actionsOverflow*` fields only bite once the buttons stop fitting on one row and stack.
  final OverflowBarAlignment? actionsOverflowAlignment,

  /// Up, unlike upstream, so a stack puts the confirming action on top as M3 asks.
  final VerticalDirection actionsOverflowDirection = .up,

  /// Forwards to [AlertDialog.actionsOverflowButtonSpacing].
  final double? actionsOverflowButtonSpacing,

  /// Forwards to [AlertDialog.buttonPadding].
  final EdgeInsetsGeometry? buttonPadding,

  /// Forwards to [AlertDialog.backgroundColor].
  final Color? backgroundColor,

  /// {@macro material_ui.dialog.elevation}
  final double? elevation,

  /// {@macro material_ui.dialog.shadowColor}
  final Color? shadowColor,

  /// {@macro material_ui.dialog.surfaceTintColor}
  final Color? surfaceTintColor,

  /// Forwards to [AlertDialog.semanticLabel].
  final String? semanticLabel,

  /// How far the dialog keeps off the screen edges.
  final EdgeInsets? insetPadding,

  /// {@macro material_ui.dialog.clipBehavior}
  final Clip? clipBehavior,

  /// {@macro material_ui.dialog.shape}
  final ShapeBorder? shape,

  /// {@macro material_ui.dialog.alignment}
  final AlignmentGeometry? alignment,

  /// {@macro material_ui.dialog.constraints}
  final BoxConstraints? constraints,

  /// Forwards to [AlertDialog.scrollable].
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

  /// Forwards to [CupertinoAlertDialog.actionScrollController].
  final ScrollController? actionScrollController,

  /// How the dialog slides up out of the keyboard's way.
  final Duration insetAnimationDuration = kDefaultCupertinoAlertDialogInsetAnimationDuration,

  /// {@macro cupertino_ui.dialog.insetAnimationCurve}
  final Curve insetAnimationCurve = kDefaultCupertinoAlertDialogInsetAnimationCurve,
}) {
  /// Creates Cupertino-side settings for an alert.
  this;
}
