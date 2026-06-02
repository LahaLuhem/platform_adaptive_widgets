// Per-platform records for showPlatformAlertDialog (no shared private base —
// the title/content/actions content slots are flat on the show function; the
// Material and Cupertino visual surfaces don't overlap in type).
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
library;

import 'package:flutter/widgets.dart';

/// Default value for [MaterialAlertDialogData.scrollable]. Matches upstream
/// `AlertDialog.scrollable`'s default.
const kDefaultMaterialAlertDialogScrollable = false;

/// Default value for [CupertinoAlertDialogData.insetAnimationDuration].
/// Matches upstream `CupertinoAlertDialog`'s default.
const kDefaultCupertinoAlertDialogInsetAnimationDuration = Duration(milliseconds: 100);

/// Default value for [CupertinoAlertDialogData.insetAnimationCurve]. Matches
/// upstream `CupertinoAlertDialog`'s default.
const kDefaultCupertinoAlertDialogInsetAnimationCurve = Curves.decelerate;

/// Material-only configuration for `showPlatformAlertDialog`.
///
/// Pass this via `showPlatformAlertDialog`'s `materialAlertDialogData`
/// parameter when tuning the Material [AlertDialog] specifically. Common
/// content (title, content, actions, widgetKey) lives flat on the show
/// function — set those for the cross-platform case.
///
/// Distinct from `MaterialDialogData` (used by `showPlatformDialog` to style
/// the wrapping [Dialog] widget). [AlertDialog] is its own Dialog under the
/// hood, so the package never wraps it — alert-dialog calls bypass the
/// `MaterialDialogData` surface entirely.
final class MaterialAlertDialogData {
  /// Optional icon displayed above the title.
  final Widget? icon;

  /// Padding around the [icon].
  final EdgeInsetsGeometry? iconPadding;

  /// Colour of the [icon].
  final Color? iconColor;

  /// Padding around the dialog's title.
  final EdgeInsetsGeometry? titlePadding;

  /// Text style for the dialog's title.
  final TextStyle? titleTextStyle;

  /// Padding around the dialog's content.
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the dialog's content.
  final TextStyle? contentTextStyle;

  /// Padding around the action-button row.
  final EdgeInsetsGeometry? actionsPadding;

  /// Alignment of action buttons along the main axis.
  final MainAxisAlignment? actionsAlignment;

  /// Alignment of overflowing action buttons.
  final OverflowBarAlignment? actionsOverflowAlignment;

  /// Direction for overflowing action buttons.
  final VerticalDirection? actionsOverflowDirection;

  /// Spacing between overflowing action buttons.
  final double? actionsOverflowButtonSpacing;

  /// Padding around each individual action button.
  final EdgeInsetsGeometry? buttonPadding;

  /// Background colour of the dialog surface.
  final Color? backgroundColor;

  /// Elevation of the dialog surface.
  final double? elevation;

  /// Shadow colour of the dialog.
  final Color? shadowColor;

  /// Surface-tint colour of the dialog.
  final Color? surfaceTintColor;

  /// Semantic label for accessibility tooling.
  final String? semanticLabel;

  /// Inset padding (distance from screen edges).
  final EdgeInsets? insetPadding;

  /// Clip behaviour applied to the dialog's content.
  final Clip? clipBehavior;

  /// Shape of the dialog border.
  final ShapeBorder? shape;

  /// Alignment of the dialog within the screen.
  final AlignmentGeometry? alignment;

  /// Size constraints on the dialog.
  final BoxConstraints? constraints;

  /// Whether the dialog's content is scrollable. Defaults to
  /// [kDefaultMaterialAlertDialogScrollable].
  final bool scrollable;

  /// Creates Material-only configuration for `showPlatformAlertDialog`.
  const MaterialAlertDialogData({
    this.icon,
    this.iconPadding,
    this.iconColor,
    this.titlePadding,
    this.titleTextStyle,
    this.contentPadding,
    this.contentTextStyle,
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
    this.insetPadding,
    this.clipBehavior,
    this.shape,
    this.alignment,
    this.constraints,
    this.scrollable = kDefaultMaterialAlertDialogScrollable,
  });
}

/// Cupertino-only configuration for `showPlatformAlertDialog`.
///
/// Pass this via `showPlatformAlertDialog`'s `cupertinoAlertDialogData`
/// parameter when tuning the Cupertino [CupertinoAlertDialog] specifically.
/// Common content (title, content, actions, widgetKey) lives flat on the
/// show function.
final class CupertinoAlertDialogData {
  /// Scroll controller for the content. Typically unnecessary — Cupertino
  /// auto-wraps oversized content in a scroll view.
  final ScrollController? scrollController;

  /// Scroll controller for the actions row. Typically unnecessary.
  final ScrollController? actionScrollController;

  /// Duration of the inset-slide animation when the keyboard appears.
  /// Defaults to [kDefaultCupertinoAlertDialogInsetAnimationDuration].
  final Duration insetAnimationDuration;

  /// Curve of the inset-slide animation. Defaults to
  /// [kDefaultCupertinoAlertDialogInsetAnimationCurve].
  final Curve insetAnimationCurve;

  /// Creates Cupertino-only configuration for `showPlatformAlertDialog`.
  const CupertinoAlertDialogData({
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = kDefaultCupertinoAlertDialogInsetAnimationDuration,
    this.insetAnimationCurve = kDefaultCupertinoAlertDialogInsetAnimationCurve,
  });
}
