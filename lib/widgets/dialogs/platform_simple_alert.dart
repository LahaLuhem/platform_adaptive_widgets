import 'package:flutter/cupertino.dart' show CupertinoAlertDialog, showCupertinoDialog;
import 'package:flutter/material.dart'
    show ScaffoldMessenger, SnackBar, SnackBarAction, SnackBarBehavior;
import 'package:flutter/widgets.dart';

import '/extensions/context_extensions.dart';
import '/models/dialogs/const_values.dart';
import '/models/dialogs/platform_dialog_data.dart';
import 'platform_dialog.dart';

/// A pure convenience method for showing a simple alert.
/// On material, it will show a [SnackBar].
/// On cupertino, it will show a [CupertinoAlertDialog] with a single 'OK' action.
Future<void> showPlatformSimpleAlert({
  required BuildContext context,
  required String message,
  required String cupertinoOkLabel,
  Color? materialBackgroundColor,
  double? materialElevation,
  EdgeInsetsGeometry? materialMargin,
  EdgeInsetsGeometry? materialPadding,
  double? materialWidth,
  ShapeBorder? materialShape,
  HitTestBehavior? materialHitTestBehavior,
  SnackBarBehavior? materialSnackBarBehavior,
  SnackBarAction? materialAction,
  double? materialActionOverflowThreshold,
  bool? materialShowCloseIcon,
  Color? materialCloseIconColor,
  Duration materialDuration = _snackBarDisplayDuration,
  bool? materialPersist,
  Animation<double>? materialAnimation,
  VoidCallback? materialOnVisible,
  DismissDirection? materialDismissDirection,
  Clip materialClipBehavior = Clip.hardEdge,
  PlatformDialogData? cupertinoDialogData,
}) => context.platformLazyValue(
  material: () => ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: materialBackgroundColor,
          elevation: materialElevation,
          margin: materialMargin,
          padding: materialPadding,
          width: materialWidth,
          shape: materialShape,
          hitTestBehavior: materialHitTestBehavior,
          behavior: materialSnackBarBehavior,
          action: materialAction,
          actionOverflowThreshold: materialActionOverflowThreshold,
          showCloseIcon: materialShowCloseIcon,
          closeIconColor: materialCloseIconColor,
          clipBehavior: materialClipBehavior,
          duration: materialDuration,
          persist: materialPersist,
          animation: materialAnimation,
          onVisible: materialOnVisible,
          dismissDirection: materialDismissDirection,
        ),
      )
      .closed,
  cupertino: () => showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: Text(message),
      actions: [
        PlatformAlertDialogActionButton(
          child: Text(cupertinoOkLabel),
          onPressed: (context) => Navigator.of(context).pop(),
        ),
      ],
    ),
    anchorPoint: cupertinoDialogData?.anchorPoint,
    barrierColor: cupertinoDialogData?.barrierColor,
    barrierDismissible: cupertinoDialogData?.barrierDismissible ?? kCupertinoBarrierDismissible,
    barrierLabel: cupertinoDialogData?.barrierLabel,
    routeSettings: cupertinoDialogData?.routeSettings,
    useRootNavigator: cupertinoDialogData?.useRootNavigator ?? kDefaultUseRootNavigator,
    requestFocus: cupertinoDialogData?.requestFocus,
  ),
);

const _snackBarDisplayDuration = Duration(seconds: 4);
