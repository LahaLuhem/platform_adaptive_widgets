// Named for the dialogs it configures, not for its one class. Cupertino has no counterpart, since its
// full-screen route needs no more than the show function's flat args.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_dialog.dart';
library;

import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';

/// What the package's dialogs pass as `showDialog`'s `useSafeArea`, its own default.
const kDefaultMaterialDialogUseSafeArea = true;

/// Default value for [MaterialFullscreenDialogData.insetAnimationDuration]. Same as `Dialog`'s.
const kDefaultMaterialDialogInsetAnimationDuration = Duration(milliseconds: 100);

/// Default value for [MaterialFullscreenDialogData.insetAnimationCurve]. Same as `Dialog`'s.
const kDefaultMaterialDialogInsetAnimationCurve = Curves.decelerate;

/// Default value for [MaterialFullscreenDialogData.semanticsRole]. Same as `Dialog`'s.
const kDefaultMaterialDialogSemanticsRole = SemanticsRole.dialog;

/// Material-side settings for `showPlatformFullscreenDialog`, passed as its `materialDialogData`.
///
/// Only what a full-screen dialog honours. The background is the flat `backgroundColor` on the show
/// function, shared with Cupertino.
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
