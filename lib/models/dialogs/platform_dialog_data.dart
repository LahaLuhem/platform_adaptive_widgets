import 'package:flutter/widgets.dart';

import 'const_values.dart';

final class PlatformDialogData {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool? barrierDismissible;
  final String? barrierLabel;
  final bool? requestFocus;
  final RouteSettings? routeSettings;
  final bool useRootNavigator;

  const PlatformDialogData({
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.requestFocus,
    this.routeSettings,
    this.useRootNavigator = kDefaultUseRootNavigator,
  });
}

final class MaterialDialogData extends PlatformDialogData {
  final AnimationStyle? animationStyle;
  final bool fullscreenDialog;
  final TraversalEdgeBehavior? traversalEdgeBehavior;
  final bool useSafeArea;

  static const kDefaultFullscreenDialog = false;
  static const kDefaultUseSafeArea = true;

  const MaterialDialogData({
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.requestFocus,
    super.routeSettings,
    super.useRootNavigator,
    this.animationStyle,
    this.fullscreenDialog = kDefaultFullscreenDialog,
    this.traversalEdgeBehavior,
    this.useSafeArea = kDefaultUseSafeArea,
  });
}
