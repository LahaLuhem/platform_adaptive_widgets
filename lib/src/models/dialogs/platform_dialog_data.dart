// Two data classes in one file, both Material-only dialog config, split by
// dialog shape (centered vs fullscreen). Cupertino has no `…DialogData`
// counterpart: `showCupertinoDialog` has no params beyond the shared
// show-function flat args, so there's no platform-only Cupertino surface.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
library;

import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

/// Default value for [MaterialDialogData.useSafeArea] and [MaterialFullscreenDialogData.useSafeArea].
/// Matches upstream `showDialog`'s default.
const kDefaultMaterialDialogUseSafeArea = true;

/// Default value for [MaterialDialogData.insetAnimationDuration] and [MaterialFullscreenDialogData.insetAnimationDuration].
/// Matches upstream `Dialog`'s default.
const kDefaultMaterialDialogInsetAnimationDuration = Duration(milliseconds: 100);

/// Default value for [MaterialDialogData.insetAnimationCurve] and [MaterialFullscreenDialogData.insetAnimationCurve].
/// Matches upstream `Dialog`'s default.
const kDefaultMaterialDialogInsetAnimationCurve = Curves.decelerate;

/// Default value for [MaterialDialogData.semanticsRole] and [MaterialFullscreenDialogData.semanticsRole].
/// Matches upstream `Dialog`'s default.
const kDefaultMaterialDialogSemanticsRole = SemanticsRole.dialog;

/// Material-only configuration for `showPlatformDialog` (centered dialog).
///
/// Pass this via `showPlatformDialog`'s `materialDialogData` parameter when tuning the Material
/// branch. The fields declared here have no Cupertino equivalent, `showCupertinoDialog` shares only
/// the function-level args (`anchorPoint`, `barrierColor`, `barrierDismissible`, …) which live as
/// flat parameters on the show function.
///
/// **For fullscreen dialogs**, use `showPlatformFullscreenDialog` with [MaterialFullscreenDialogData],
/// that surface only exposes the `Dialog.fullscreen()` params (background, animation, semantics),
/// without the centered-Dialog-only knobs ([alignment], [shape], [clipBehavior], [constraints],
/// [elevation], [insetPadding], [shadowColor], [surfaceTintColor]) that would be silently dropped
/// here.
final class const MaterialDialogData({
  /// Animation style for the dialog's transition.
  final AnimationStyle? animationStyle,

  /// Edge behaviour for focus traversal.
  final TraversalEdgeBehavior? traversalEdgeBehavior,

  /// Whether to wrap the dialog in a [SafeArea]. Defaults to [kDefaultMaterialDialogUseSafeArea].
  final bool useSafeArea = kDefaultMaterialDialogUseSafeArea,

  /// Background colour of the dialog surface.
  final Color? backgroundColor,

  /// Duration of the inset animation when the keyboard appears.
  final Duration insetAnimationDuration = kDefaultMaterialDialogInsetAnimationDuration,

  /// Curve of the inset animation when the keyboard appears.
  final Curve insetAnimationCurve = kDefaultMaterialDialogInsetAnimationCurve,

  /// Semantics role for accessibility tooling.
  final SemanticsRole semanticsRole = kDefaultMaterialDialogSemanticsRole,

  /// Alignment of the dialog within the screen.
  final AlignmentGeometry? alignment,

  /// Shape of the dialog border.
  final ShapeBorder? shape,

  /// Clip behaviour applied to the dialog's content.
  final Clip? clipBehavior,

  /// Size constraints on the dialog.
  final BoxConstraints? constraints,

  /// Elevation of the dialog surface.
  final double? elevation,

  /// Inset padding around the dialog (distance from screen edges).
  final EdgeInsets? insetPadding,

  /// Shadow colour of the dialog.
  final Color? shadowColor,

  /// Surface-tint colour of the dialog.
  final Color? surfaceTintColor,
}) {
  // ---- showDialog (function-level) ----

  // ---- Dialog (widget-level, shared with fullscreen variant) ----

  // ---- Dialog (widget-level, centered-only) ----

  /// Creates Material-only configuration for `showPlatformDialog`.
  this;
}

/// Material-only configuration for `showPlatformFullscreenDialog`.
///
/// Pass this via `showPlatformFullscreenDialog`'s `materialDialogData` parameter. Mirrors
/// [Dialog.fullscreen]'s param set, deliberately *omitting* the centered-only knobs
/// ([MaterialDialogData.alignment], [MaterialDialogData.shape], [MaterialDialogData.clipBehavior],
/// [MaterialDialogData.constraints], [MaterialDialogData.elevation], [MaterialDialogData.insetPadding],
/// [MaterialDialogData.shadowColor], [MaterialDialogData.surfaceTintColor]). Those have no effect on
/// `Dialog.fullscreen()` and were silently dropped in the v1 single-flag design.
final class const MaterialFullscreenDialogData({
  /// Animation style for the dialog's transition.
  final AnimationStyle? animationStyle,

  /// Edge behaviour for focus traversal.
  final TraversalEdgeBehavior? traversalEdgeBehavior,

  /// Whether to wrap the dialog in a [SafeArea]. Defaults to [kDefaultMaterialDialogUseSafeArea].
  final bool useSafeArea = kDefaultMaterialDialogUseSafeArea,

  /// Background colour of the fullscreen dialog surface.
  final Color? backgroundColor,

  /// Duration of the inset animation when the keyboard appears.
  final Duration insetAnimationDuration = kDefaultMaterialDialogInsetAnimationDuration,

  /// Curve of the inset animation when the keyboard appears.
  final Curve insetAnimationCurve = kDefaultMaterialDialogInsetAnimationCurve,

  /// Semantics role for accessibility tooling.
  final SemanticsRole semanticsRole = kDefaultMaterialDialogSemanticsRole,
}) {
  /// Creates Material-only configuration for `showPlatformFullscreenDialog`.
  this;
}
