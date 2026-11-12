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
  /// The button's text, [SnackBarAction.label] on Material.
  required final String label,

  /// Runs on tap, [SnackBarAction.onPressed] on Material.
  required final VoidCallback onPressed,
}) {
  /// Creates the toast's action.
  this;
}

/// Material-side settings for `showPlatformToast`. Backed by [SnackBar].
final class const MaterialToastData({
  /// Forwards to [SnackBar.backgroundColor].
  final Color? backgroundColor,

  /// Forwards to [SnackBar.elevation].
  final double? elevation,

  /// Forwards to [SnackBar.margin].
  final EdgeInsetsGeometry? margin,

  /// Forwards to [SnackBar.padding].
  final EdgeInsetsGeometry? padding,

  /// Left out, the bar spans the screen.
  final double? width,

  /// Forwards to [SnackBar.shape].
  final ShapeBorder? shape,

  /// Forwards to [SnackBar.hitTestBehavior].
  final HitTestBehavior? hitTestBehavior,

  /// Anchored to the bottom, or floating above it.
  final SnackBarBehavior? snackBarBehavior,

  /// How wide the toast's action may get before it drops onto its own line.
  final double? actionOverflowThreshold,

  /// Forwards to [SnackBar.showCloseIcon].
  final bool? showCloseIcon,

  /// Forwards to [SnackBar.closeIconColor].
  final Color? closeIconColor,

  /// Forwards to [SnackBar.animation].
  final Animation<double>? animation,

  /// Forwards to [SnackBar.onVisible].
  final VoidCallback? onVisible,

  /// Which way the user can swipe it away.
  final DismissDirection? dismissDirection,

  /// Forwards to [SnackBar.clipBehavior].
  final Clip clipBehavior = Clip.hardEdge,
}) {
  /// Creates Material-side settings for `showPlatformToast`.
  this;
}

/// Cupertino-side settings for `showPlatformToast`. iOS has no toast of its own, so this styles the
/// banner the package draws instead.
final class const CupertinoToastData({
  /// The banner's fill, dark in light mode and light in dark.
  final Color backgroundColor = const CupertinoDynamicColor.withBrightness(
    color: Color(0xCC1F1F1F),
    darkColor: Color(0xCCFAFAFA),
  ),

  /// Colours the message and action. The background inverted, so the text reads.
  final Color foregroundColor = const CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),

  /// Around the message text, where [outerMargin] holds the whole toast off the screen edges. Matches
  /// the inset on iOS's own notification banner.
  final EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

  /// Holds the whole toast off the screen edges.
  final EdgeInsetsGeometry outerMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

  /// Matches iOS's own notification banner.
  final BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(14)),

  /// Stops the toast spanning a tablet or desktop screen.
  final double maxWidth = 480,

  /// Merged over the message's and action's own styles, which follow the theme at 15pt in [foregroundColor].
  final TextStyle? textStyle,

  /// Covers the slide and fade in.
  final Duration transitionDuration = const Duration(milliseconds: 250),
}) {
  /// Creates Cupertino-side settings for `showPlatformToast`.
  this;
}
