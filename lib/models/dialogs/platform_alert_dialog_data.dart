// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

/// Common configuration for platform-adaptive alert dialogs.
abstract final class _PlatformAlertDialogData {
  /// A title to display at the top of the dialog.
  final Widget? title;

  /// The main content of the dialog.
  final Widget? content;

  /// A list of widgets to display as actions at the bottom of the dialog.
  final List<Widget>? actions;

  /// A key to identify the widget.
  final Key? widgetKey;

  /// Creates a [_PlatformAlertDialogData].
  const _PlatformAlertDialogData({this.title, this.content, this.actions, this.widgetKey});
}

/// Material-specific configuration for a platform alert dialog.
///
/// Maps to properties of `AlertDialog` on Android.
final class MaterialAlertDialogData extends _PlatformAlertDialogData {
  /// An optional icon displayed at the top of the dialog.
  final Widget? icon;

  /// Padding around the [icon].
  final EdgeInsetsGeometry? iconPadding;

  /// Color of the [icon].
  final Color? iconColor;

  /// Padding around the [title].
  final EdgeInsetsGeometry? titlePadding;

  /// Text style for the [title].
  final TextStyle? titleTextStyle;

  /// Padding around the [content].
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the [content].
  final TextStyle? contentTextStyle;

  /// Padding around the [actions].
  final EdgeInsetsGeometry? actionsPadding;

  /// Alignment of the [actions] along the main axis.
  final MainAxisAlignment? actionsAlignment;

  /// Alignment of overflowing [actions].
  final OverflowBarAlignment? actionsOverflowAlignment;

  /// Direction for overflowing [actions].
  final VerticalDirection? actionsOverflowDirection;

  /// Spacing between overflowing action buttons.
  final double? actionsOverflowButtonSpacing;

  /// Padding around each action button.
  final EdgeInsetsGeometry? buttonPadding;

  /// Background color of the dialog.
  final Color? backgroundColor;

  /// Elevation of the dialog surface.
  final double? elevation;

  /// Shadow color of the dialog.
  final Color? shadowColor;

  /// Surface tint color of the dialog.
  final Color? surfaceTintColor;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Inset padding for the dialog from screen edges.
  final EdgeInsets? insetPadding;

  /// Clip behavior for the dialog content.
  final Clip? clipBehavior;

  /// Shape of the dialog border.
  final ShapeBorder? shape;

  /// Alignment of the dialog within the screen.
  final AlignmentGeometry? alignment;

  /// Optional size constraints for the dialog.
  final BoxConstraints? constraints;

  /// Whether the dialog's [content] is scrollable.
  ///
  /// Defaults to [kDefaultScrollable].
  final bool scrollable;

  /// Default value for [scrollable].
  static const kDefaultScrollable = false;

  /// Creates Material-specific alert dialog configuration.
  const MaterialAlertDialogData({
    super.title,
    super.content,
    super.actions,
    super.widgetKey,
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
    this.scrollable = kDefaultScrollable,
  });
}

/// Cupertino-specific configuration for a platform alert dialog.
///
/// Maps to properties of `CupertinoAlertDialog` on iOS.
final class CupertinoAlertDialogData extends _PlatformAlertDialogData {
  /// A scroll controller that can be used to control the scrolling of the
  /// [content] in the dialog.
  ///
  /// Defaults to null, and is typically not needed, since most alert messages
  /// are short.
  ///
  /// If the [content] is larger than the dialog, it will automatically be
  /// wrapped in a scrollable widget.
  final ScrollController? scrollController;

  /// A scroll controller that can be used to control the scrolling of the
  /// [actions] in the dialog.
  ///
  /// Defaults to null, and is typically not needed.
  final ScrollController? actionScrollController;

  /// The duration of the animation to slide up the dialog.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the dialog slides up.
  final Curve insetAnimationCurve;

  /// Default value for [insetAnimationDuration].
  static const kDefaultInsetAnimationDuration = Duration(milliseconds: 100);

  /// Default value for [insetAnimationCurve].
  static const kDefaultInsetAnimationCurve = Curves.decelerate;

  /// Default value for [actions].
  static const kDefaultActions = <Widget>[];

  /// Creates Cupertino-specific alert dialog configuration.
  const CupertinoAlertDialogData({
    super.title,
    super.content,
    super.actions = kDefaultActions,
    super.widgetKey,
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = kDefaultInsetAnimationDuration,
    this.insetAnimationCurve = kDefaultInsetAnimationCurve,
  });
}
