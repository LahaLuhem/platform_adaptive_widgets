// 2 data classes in one file, both Material-only dialog config, split by dialog shape (centred vs
// full-screen). Cupertino has no counterpart, since neither of its routes needs more than the show
// functions' flat args.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
library;

import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

/// Default value for [MaterialDialogData.useSafeArea]. Same as `showDialog`'s.
const kDefaultMaterialDialogUseSafeArea = true;

/// Default value for [MaterialDialogData.insetAnimationDuration] and [MaterialFullscreenDialogData.insetAnimationDuration].
/// Same as `Dialog`'s.
const kDefaultMaterialDialogInsetAnimationDuration = Duration(milliseconds: 100);

/// Default value for [MaterialDialogData.insetAnimationCurve] and [MaterialFullscreenDialogData.insetAnimationCurve].
/// Same as `Dialog`'s.
const kDefaultMaterialDialogInsetAnimationCurve = Curves.decelerate;

/// Default value for [MaterialDialogData.semanticsRole] and [MaterialFullscreenDialogData.semanticsRole].
/// Same as `Dialog`'s.
const kDefaultMaterialDialogSemanticsRole = SemanticsRole.dialog;

/// Material-side settings for `showPlatformDialog`, the centred one, passed as `materialDialogData`.
/// None of it reaches Cupertino, where `showCupertinoDialog` only takes the function-level args that
/// already sit flat on the show function.
///
/// Going full-screen instead? That's `showPlatformFullscreenDialog` with [MaterialFullscreenDialogData],
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
/// Only what a full-screen dialog honours. A centred dialog's knobs on [MaterialDialogData] (alignment,
/// shape, insets and the like) would do nothing here, so they're left out. The background is the flat
/// `backgroundColor` on the show function, shared with Cupertino.
final class const MaterialFullscreenDialogData({
  final AnimationStyle? animationStyle,

  final TraversalEdgeBehavior? traversalEdgeBehavior,

  /// Picks which screen of a foldable the dialog opens on.
  final Offset? anchorPoint,

  /// How the dialog slides up out of the keyboard's way.
  final Duration insetAnimationDuration = kDefaultMaterialDialogInsetAnimationDuration,

  final Curve insetAnimationCurve = kDefaultMaterialDialogInsetAnimationCurve,

  final SemanticsRole semanticsRole = kDefaultMaterialDialogSemanticsRole,
}) {
  /// Creates Material-side settings for `showPlatformFullscreenDialog`.
  this;
}
