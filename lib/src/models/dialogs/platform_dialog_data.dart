// 2 data classes in one file, both Material-only dialog config, split by
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

/// Material-side settings for `showPlatformDialog`, the centred one, passed as `materialDialogData`.
/// None of it reaches iOS, where `showCupertinoDialog` only takes the function-level args that already
/// sit flat on the show function.
///
/// Going fullscreen instead? That's `showPlatformFullscreenDialog` with [MaterialFullscreenDialogData],
/// which leaves out everything below that only a centred dialog can honour.
final class const MaterialDialogData({
  // ---- showDialog (function-level) ----
  final AnimationStyle? animationStyle,

  final TraversalEdgeBehavior? traversalEdgeBehavior,

  final bool useSafeArea = kDefaultMaterialDialogUseSafeArea,

  // ---- Dialog (widget-level, shared with fullscreen variant) ----
  final Color? backgroundColor,

  /// How the dialog slides up out of the keyboard's way.
  final Duration insetAnimationDuration = kDefaultMaterialDialogInsetAnimationDuration,

  final Curve insetAnimationCurve = kDefaultMaterialDialogInsetAnimationCurve,

  final SemanticsRole semanticsRole = kDefaultMaterialDialogSemanticsRole,

  // ---- Dialog (widget-level, centered-only) ----
  final AlignmentGeometry? alignment,

  final ShapeBorder? shape,

  final Clip? clipBehavior,

  final BoxConstraints? constraints,

  final double? elevation,

  /// How far the dialog keeps off the screen edges.
  final EdgeInsets? insetPadding,

  final Color? shadowColor,

  final Color? surfaceTintColor,
}) {
  /// Creates Material-side settings for `showPlatformDialog`.
  this;
}

/// Material-side settings for `showPlatformFullscreenDialog`, passed as its `materialDialogData`.
///
/// Matches what [Dialog.fullscreen] actually takes. The centred-only knobs on [MaterialDialogData] (alignment,
/// shape, clip, constraints, elevation, inset padding, the 2 shadow colours) are left out on purpose,
/// because a fullscreen dialog ignores them and the old single-flag design let them disappear without
/// a word.
final class const MaterialFullscreenDialogData({
  final AnimationStyle? animationStyle,

  final TraversalEdgeBehavior? traversalEdgeBehavior,

  final bool useSafeArea = kDefaultMaterialDialogUseSafeArea,

  final Color? backgroundColor,

  /// How the dialog slides up out of the keyboard's way.
  final Duration insetAnimationDuration = kDefaultMaterialDialogInsetAnimationDuration,

  final Curve insetAnimationCurve = kDefaultMaterialDialogInsetAnimationCurve,

  final SemanticsRole semanticsRole = kDefaultMaterialDialogSemanticsRole,
}) {
  /// Creates Material-side settings for `showPlatformFullscreenDialog`.
  this;
}
