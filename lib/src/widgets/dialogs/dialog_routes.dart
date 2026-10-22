import 'package:cupertino_ui/cupertino_ui.dart' show showCupertinoDialog;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show showDialog;

import '/src/models/dialogs/const_values.dart';

/// Takes an already-wrapped [builder] and only passes arguments along. Top-level rather than inline, so
/// release builds can drop the other platform's branch.
Future<T?> showMaterialDialogRoute<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required bool isFullscreenRoute,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool? barrierDismissible,
  required String? barrierLabel,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
  required AnimationStyle? animationStyle,
  required TraversalEdgeBehavior? traversalEdgeBehavior,
  required bool useSafeArea,
}) => showDialog(
  context: context,
  builder: builder,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible ?? kMaterialBarrierDismissible,
  barrierLabel: barrierLabel,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
  animationStyle: animationStyle,
  fullscreenDialog: isFullscreenRoute,
  traversalEdgeBehavior: traversalEdgeBehavior,
  useSafeArea: useSafeArea,
);

/// The Cupertino half of [showMaterialDialogRoute].
Future<T?> showCupertinoDialogRoute<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required bool? barrierDismissible,
  required String? barrierLabel,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showCupertinoDialog(
  context: context,
  builder: builder,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible ?? kCupertinoBarrierDismissible,
  barrierLabel: barrierLabel,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
);
