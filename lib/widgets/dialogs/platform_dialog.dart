import 'package:flutter/cupertino.dart' show showCupertinoDialog;
import 'package:flutter/material.dart' show showDialog;
import 'package:flutter/widgets.dart';

import '/extensions/context_extensions.dart';
import '/models/dialogs/const_values.dart';
import '/models/dialogs/platform_dialog_data.dart';

Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  PlatformDialogData? platformDialogData,
  MaterialDialogData? materialDialogData,
  PlatformDialogData? cupertinoDialogData,
}) => context.platformLazyValue(
  material: () => showDialog<T>(
    context: context,
    builder: builder,
    anchorPoint: materialDialogData?.anchorPoint ?? platformDialogData?.anchorPoint,
    barrierColor: materialDialogData?.barrierColor ?? platformDialogData?.barrierColor,
    barrierDismissible:
        materialDialogData?.barrierDismissible ??
        platformDialogData?.barrierDismissible ??
        kCupertinoBarrierDismissible,
    barrierLabel: materialDialogData?.barrierLabel ?? platformDialogData?.barrierLabel,
    routeSettings: materialDialogData?.routeSettings ?? platformDialogData?.routeSettings,
    useRootNavigator:
        materialDialogData?.useRootNavigator ??
        platformDialogData?.useRootNavigator ??
        kDefaultUseRootNavigator,
    requestFocus: materialDialogData?.requestFocus ?? platformDialogData?.requestFocus,
    animationStyle: materialDialogData?.animationStyle,
    fullscreenDialog:
        materialDialogData?.fullscreenDialog ?? MaterialDialogData.kDefaultFullscreenDialog,
    traversalEdgeBehavior: materialDialogData?.traversalEdgeBehavior,
    useSafeArea: materialDialogData?.useSafeArea ?? MaterialDialogData.kDefaultUseSafeArea,
  ),
  cupertino: () => showCupertinoDialog<T>(
    context: context,
    builder: builder,
    anchorPoint: cupertinoDialogData?.anchorPoint ?? platformDialogData?.anchorPoint,
    barrierColor: cupertinoDialogData?.barrierColor ?? platformDialogData?.barrierColor,
    barrierDismissible:
        cupertinoDialogData?.barrierDismissible ??
        platformDialogData?.barrierDismissible ??
        kCupertinoBarrierDismissible,
    barrierLabel: cupertinoDialogData?.barrierLabel ?? platformDialogData?.barrierLabel,
    routeSettings: cupertinoDialogData?.routeSettings ?? platformDialogData?.routeSettings,
    useRootNavigator:
        cupertinoDialogData?.useRootNavigator ??
        platformDialogData?.useRootNavigator ??
        kDefaultUseRootNavigator,
    requestFocus: cupertinoDialogData?.requestFocus ?? platformDialogData?.requestFocus,
  ),
);
