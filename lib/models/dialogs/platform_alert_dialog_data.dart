// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';

abstract final class _PlatformAlertDialogData {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  final Key? widgetKey;

  const _PlatformAlertDialogData({this.title, this.content, this.actions, this.widgetKey});
}

final class MaterialAlertDialogData extends _PlatformAlertDialogData {
  final Widget? icon;
  final EdgeInsetsGeometry? iconPadding;
  final Color? iconColor;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? contentTextStyle;
  final EdgeInsetsGeometry? actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final String? semanticLabel;
  final EdgeInsets? insetPadding;
  final Clip? clipBehavior;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final bool scrollable;

  static const kDefaultScrollable = false;

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

final class CupertinoAlertDialogData extends _PlatformAlertDialogData {
  final ScrollController? scrollController;
  final ScrollController? actionScrollController;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  static const kDefaultInsetAnimationDuration = Duration(milliseconds: 100);
  static const kDefaultInsetAnimationCurve = Curves.decelerate;
  static const kDefaultActions = <Widget>[];

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
