// The shared action and the per-platform records for showPlatformToast.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_toast.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show SnackBarBehavior;

/// Default value for the toast's display duration on both platforms. Same as `SnackBar.duration`'s.
const kDefaultPlatformToastDuration = Duration(seconds: 4);

/// The toast's one action, like Undo ([M3 snackbar](https://m3.material.io/components/snackbar/guidelines)).
/// A [SnackBarAction] on Material, a text button in the banner on Cupertino. Tapping it runs [onPressed]
/// and closes the toast.
final class const PlatformToastAction({
  required final String label,
  required final VoidCallback onPressed,
}) {
  /// Creates the toast's action.
  this;
}

/// Material-side settings for `showPlatformToast`. Backed by [SnackBar].
final class const MaterialToastData({
  final Color? backgroundColor,

  final double? elevation,

  final EdgeInsetsGeometry? margin,

  final EdgeInsetsGeometry? padding,

  /// Left out, the bar spans the screen.
  final double? width,

  final ShapeBorder? shape,

  final HitTestBehavior? hitTestBehavior,

  /// Anchored to the bottom, or floating above it.
  final SnackBarBehavior? snackBarBehavior,

  /// How wide the toast's action may get before it drops onto its own line.
  final double? actionOverflowThreshold,

  final bool? showCloseIcon,

  final Color? closeIconColor,

  final Animation<double>? animation,

  final VoidCallback? onVisible,

  /// Which way the user can swipe it away.
  final DismissDirection? dismissDirection,

  final Clip clipBehavior = Clip.hardEdge,
}) {
  /// Creates Material-side settings for `showPlatformToast`.
  this;
}

/// Cupertino-side settings for `showPlatformToast`. iOS has no toast of its own, so this styles the
/// banner the package draws instead.
final class const CupertinoToastData({
  final Color backgroundColor = const CupertinoDynamicColor.withBrightness(
    color: Color(0xCC1F1F1F),
    darkColor: Color(0xCCFAFAFA),
  ),

  /// Colours the message text. The background inverted, so the text reads.
  final Color foregroundColor = const CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),

  /// Around the message text, where [outerMargin] holds the whole toast off the screen edges. Matches
  /// the inset on iOS's own notification banner.
  final EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

  final EdgeInsetsGeometry outerMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

  /// Matches iOS's own notification banner.
  final BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(14)),

  /// Stops the toast spanning a tablet or desktop screen.
  final double maxWidth = 480,

  /// Left out, you get 15pt in [foregroundColor].
  final TextStyle? textStyle,

  /// Covers the slide and fade in.
  final Duration transitionDuration = const Duration(milliseconds: 250),
}) {
  /// Creates Cupertino-side settings for `showPlatformToast`.
  this;
}
