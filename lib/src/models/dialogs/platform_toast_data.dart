// Per-platform records for showPlatformToast.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_toast.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show SnackBarAction, SnackBarBehavior, SnackBarClosedReason;

/// Default value for the toast's display duration on both platforms. Matches Material's `SnackBar.duration`
/// upstream default.
const kDefaultPlatformToastDuration = Duration(seconds: 4);

/// Default value for [CupertinoToastData.backgroundColor]. A translucent HUD that flips with the theme.
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

  /// An inline button, the classic being "Undo".
  final SnackBarAction? action,

  /// How wide the [action] may get before it drops onto its own line.
  final double? actionOverflowThreshold,

  final bool? showCloseIcon,

  final Color? closeIconColor,

  /// Keeps the bar up past its duration, until something dismisses it.
  final bool? persist,

  final Animation<double>? animation,

  final VoidCallback? onVisible,

  /// Which way the user can swipe it away.
  final DismissDirection? dismissDirection,

  final Clip clipBehavior = Clip.hardEdge,
}) {
  /// Creates Material-side settings for `showPlatformToast`.
  this;
}

/// Cupertino-side settings for `showPlatformToast`. iOS ships no toast of its own, so this drives the
/// HUD-style banner the package draws instead.
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

/// Re-exported so awaiting the Material toast's close future doesn't drag in a `material_ui` import
/// just for the enum.
typedef PlatformToastClosedReason = SnackBarClosedReason;
