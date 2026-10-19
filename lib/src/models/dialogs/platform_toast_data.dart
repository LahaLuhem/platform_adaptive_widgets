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

/// Default value for [CupertinoToastData.backgroundColor]. Translucent, and flips with the theme.
const kDefaultCupertinoToastBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xCC1F1F1F),
  darkColor: Color(0xCCFAFAFA),
);

/// Default value for [CupertinoToastData.foregroundColor]. The background inverted, so the text reads.
const kDefaultCupertinoToastForegroundColor = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.white,
  darkColor: CupertinoColors.black,
);

/// Default value for [CupertinoToastData.padding]. Matches the inset on iOS's own notification banner.
const kDefaultCupertinoToastPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

/// Default value for [CupertinoToastData.outerMargin], keeping the toast off the screen edges so it
/// doesn't hug the sides of a phone.
const kDefaultCupertinoToastOuterMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

/// Default value for [CupertinoToastData.borderRadius]. Matches iOS's own notification banner.
const kDefaultCupertinoToastBorderRadius = BorderRadius.all(Radius.circular(14));

/// Default value for [CupertinoToastData.maxWidth], stopping the toast spanning a tablet or desktop
/// screen.
const kDefaultCupertinoToastMaxWidth = 480.0;

/// Default value for [CupertinoToastData.transitionDuration], covering the slide and fade in.
const kDefaultCupertinoToastTransitionDuration = Duration(milliseconds: 250);

/// The toast's one action, like Undo ([M3 snackbar](https://m3.material.io/components/snackbar/guidelines)).
/// A [SnackBarAction] on Android, a text button in the banner on iOS. Tapping it runs [onPressed] and
/// closes the toast.
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
  final Color backgroundColor = kDefaultCupertinoToastBackgroundColor,

  /// Colours the message text.
  final Color foregroundColor = kDefaultCupertinoToastForegroundColor,

  /// Around the message text, where [outerMargin] holds the whole toast off the screen edges.
  final EdgeInsetsGeometry padding = kDefaultCupertinoToastPadding,

  final EdgeInsetsGeometry outerMargin = kDefaultCupertinoToastOuterMargin,

  final BorderRadiusGeometry borderRadius = kDefaultCupertinoToastBorderRadius,

  final double maxWidth = kDefaultCupertinoToastMaxWidth,

  /// Left out, you get 15pt in [foregroundColor].
  final TextStyle? textStyle,

  final Duration transitionDuration = kDefaultCupertinoToastTransitionDuration,
}) {
  /// Creates Cupertino-side settings for `showPlatformToast`.
  this;
}
