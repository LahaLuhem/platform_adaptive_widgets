// Per-platform records for showPlatformToast.
// ignore_for_file: prefer-match-file-name

/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/widgets/dialogs/platform_toast.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show SnackBarAction, SnackBarBehavior, SnackBarClosedReason;

/// Default value for the toast's display duration on both platforms. Matches
/// Material's `SnackBar.duration` upstream default.
const kDefaultPlatformToastDuration = Duration(seconds: 4);

/// Default value for [CupertinoToastData.backgroundColor]. Translucent black
/// HUD-style background that adapts to light/dark theming.
const kDefaultCupertinoToastBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xCC1F1F1F),
  darkColor: Color(0xCCFAFAFA),
);

/// Default value for [CupertinoToastData.foregroundColor]. Inverted of the
/// background for legibility.
const kDefaultCupertinoToastForegroundColor = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.white,
  darkColor: CupertinoColors.black,
);

/// Default value for [CupertinoToastData.padding]. Matches the iOS-native
/// notification banner inset.
const kDefaultCupertinoToastPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

/// Default value for [CupertinoToastData.outerMargin] — the gap between the
/// toast and the screen edges (so it doesn't hug the sides on phones).
const kDefaultCupertinoToastOuterMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

/// Default value for [CupertinoToastData.borderRadius]. Matches the iOS-native
/// notification banner corner radius.
const kDefaultCupertinoToastBorderRadius = BorderRadius.all(Radius.circular(14));

/// Default value for [CupertinoToastData.maxWidth] — caps the toast width on
/// tablets/desktops so it doesn't span the full screen.
const kDefaultCupertinoToastMaxWidth = 480.0;

/// Default value for [CupertinoToastData.transitionDuration]. The slide-in /
/// fade-in animation duration.
const kDefaultCupertinoToastTransitionDuration = Duration(milliseconds: 250);

/// Material-only configuration for `showPlatformToast`. Backed by [SnackBar].
final class MaterialToastData {
  /// Background colour of the snack bar.
  final Color? backgroundColor;

  /// Elevation of the snack bar surface.
  final double? elevation;

  /// Margin around the snack bar.
  final EdgeInsetsGeometry? margin;

  /// Padding inside the snack bar.
  final EdgeInsetsGeometry? padding;

  /// Fixed width of the snack bar. When `null`, fills the screen.
  final double? width;

  /// Shape of the snack bar border.
  final ShapeBorder? shape;

  /// Hit-test behaviour for the snack bar.
  final HitTestBehavior? hitTestBehavior;

  /// SnackBar behaviour — fixed (anchored to bottom) vs floating.
  final SnackBarBehavior? snackBarBehavior;

  /// Optional inline action button on the snack bar (e.g. "Undo").
  final SnackBarAction? action;

  /// Overflow threshold for the action button.
  final double? actionOverflowThreshold;

  /// Whether to show the close (×) icon.
  final bool? showCloseIcon;

  /// Colour of the close icon.
  final Color? closeIconColor;

  /// Whether the snack bar persists past its duration.
  final bool? persist;

  /// Custom animation override for the snack bar.
  final Animation<double>? animation;

  /// Callback fired when the snack bar becomes visible.
  final VoidCallback? onVisible;

  /// Direction in which the user can swipe to dismiss.
  final DismissDirection? dismissDirection;

  /// Clip behaviour applied to the snack bar.
  final Clip clipBehavior;

  /// Creates Material-only configuration for `showPlatformToast`.
  const MaterialToastData({
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.padding,
    this.width,
    this.shape,
    this.hitTestBehavior,
    this.snackBarBehavior,
    this.action,
    this.actionOverflowThreshold,
    this.showCloseIcon,
    this.closeIconColor,
    this.persist,
    this.animation,
    this.onVisible,
    this.dismissDirection,
    this.clipBehavior = Clip.hardEdge,
  });
}

/// Cupertino-only configuration for `showPlatformToast`. Drives the package's
/// custom HUD-style overlay banner (iOS has no native toast primitive).
final class CupertinoToastData {
  /// Background colour of the toast. Defaults to
  /// [kDefaultCupertinoToastBackgroundColor] — a translucent
  /// theme-adaptive HUD.
  final Color backgroundColor;

  /// Foreground (text) colour. Defaults to
  /// [kDefaultCupertinoToastForegroundColor] — inverted of the background.
  final Color foregroundColor;

  /// Padding around the message text. Defaults to
  /// [kDefaultCupertinoToastPadding].
  final EdgeInsetsGeometry padding;

  /// Margin between the toast and the screen edges. Defaults to
  /// [kDefaultCupertinoToastOuterMargin].
  final EdgeInsetsGeometry outerMargin;

  /// Corner radius of the toast. Defaults to
  /// [kDefaultCupertinoToastBorderRadius].
  final BorderRadiusGeometry borderRadius;

  /// Maximum width of the toast (so it doesn't span full-screen on
  /// tablets/desktops). Defaults to [kDefaultCupertinoToastMaxWidth].
  final double maxWidth;

  /// Optional text-style override for the message. When `null`, the package
  /// uses a 15pt sized, [foregroundColor]-coloured default.
  final TextStyle? textStyle;

  /// Duration of the slide-in / fade-in animation. Defaults to
  /// [kDefaultCupertinoToastTransitionDuration].
  final Duration transitionDuration;

  /// Creates Cupertino-only configuration for `showPlatformToast`.
  const CupertinoToastData({
    this.backgroundColor = kDefaultCupertinoToastBackgroundColor,
    this.foregroundColor = kDefaultCupertinoToastForegroundColor,
    this.padding = kDefaultCupertinoToastPadding,
    this.outerMargin = kDefaultCupertinoToastOuterMargin,
    this.borderRadius = kDefaultCupertinoToastBorderRadius,
    this.maxWidth = kDefaultCupertinoToastMaxWidth,
    this.textStyle,
    this.transitionDuration = kDefaultCupertinoToastTransitionDuration,
  });
}

/// Re-exported for callers awaiting the Material toast's close future — saves
/// them an explicit `package:flutter/material.dart` import for the enum.
typedef PlatformToastClosedReason = SnackBarClosedReason;
