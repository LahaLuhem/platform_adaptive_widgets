// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show ExpansionTileTransitionMode;
import 'package:flutter/material.dart' show ListTileControlAffinity, VisualDensity;
import 'package:flutter/widgets.dart';

abstract final class _PlatformExpansionTileData {
  final Key? widgetKey;
  final Widget? title;
  final Widget? child;
  final ExpansibleController? controller;

  const _PlatformExpansionTileData({this.widgetKey, this.title, this.child, this.controller});
}

final class MaterialExpansionTileData extends _PlatformExpansionTileData {
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget>? children;

  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final bool showTrailingIcon;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final CrossAxisAlignment expandedCrossAxisAlignment;
  final Alignment expandedAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final ShapeBorder? shape;
  final ShapeBorder? collapsedShape;
  final Clip? clipBehavior;
  final ListTileControlAffinity? controlAffinity;
  final bool? dense;
  final Color? splashColor;
  final VisualDensity? visualDensity;
  final double? minTileHeight;
  final bool enableFeedback;
  final bool enabled;
  final AnimationStyle? expansionAnimationStyle;
  final bool internalAddSemanticForOnTap;

  static const kDefaultShowTrailingIcon = false;
  static const kDefaultInitiallyExpanded = false;
  static const kDefaultMaintainState = false;
  static const kDefaultExpandedCrossAxisAlignment = CrossAxisAlignment.center;
  static const kDefaultExpandedAlignment = Alignment.centerLeft;
  static const kDefaultEnableFeedback = true;
  static const kDefaultEnabled = true;
  static const kDefaultInternalAddSemanticForOnTap = false;

  const MaterialExpansionTileData({
    super.widgetKey,
    super.title,
    super.child,
    super.controller,
    this.onExpansionChanged,
    this.children,
    this.leading,
    this.subtitle,
    this.trailing,
    this.showTrailingIcon = kDefaultShowTrailingIcon,
    this.initiallyExpanded = kDefaultInitiallyExpanded,
    this.maintainState = kDefaultMaintainState,
    this.tilePadding,
    this.expandedCrossAxisAlignment = kDefaultExpandedCrossAxisAlignment,
    this.expandedAlignment = kDefaultExpandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controlAffinity,
    this.dense,
    this.splashColor,
    this.visualDensity,
    this.minTileHeight,
    this.enableFeedback = kDefaultEnableFeedback,
    this.enabled = kDefaultEnabled,
    this.expansionAnimationStyle,
    this.internalAddSemanticForOnTap = kDefaultInternalAddSemanticForOnTap,
  }) : assert((child != null) ^ (children != null), 'child and children are mutually exclusive.');
}

final class CupertinoExpansionTileData extends _PlatformExpansionTileData {
  final ExpansionTileTransitionMode transitionMode;

  static const kDefaultTransitionMode = ExpansionTileTransitionMode.fade;

  const CupertinoExpansionTileData({
    super.widgetKey,
    super.title,
    super.child,
    super.controller,
    this.transitionMode = kDefaultTransitionMode,
  });
}
