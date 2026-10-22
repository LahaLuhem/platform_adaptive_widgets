/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_action_kind.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import 'platform_confirm_alert.dart';

/// Asks before an action and answers whether the person confirmed. Closing it any other way answers
/// `false`. [AlertDialog] on Material, [CupertinoAlertDialog] on Cupertino.
///
/// Cancel comes translated and placed per platform. Name the action in [confirmLabel], like Delete,
/// not OK.
///
/// Guidelines: [M3 dialogs](https://m3.material.io/components/dialogs/guidelines),
/// [HIG alerts](https://developer.apple.com/design/human-interface-guidelines/alerts).
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_confirm.dart#platform_confirm}
Future<bool> showPlatformConfirm({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required PlatformActionKind actionKind,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialAlertDialogData? materialAlertDialogData,
  CupertinoAlertDialogData? cupertinoAlertDialogData,
}) => showPlatformConfirmAlert(
  context: context,
  title: title,
  message: message,
  confirmLabel: confirmLabel,
  actionKind: actionKind,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: barrierDismissible,
  barrierLabel: barrierLabel,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
  materialAlertDialogData: materialAlertDialogData,
  cupertinoAlertDialogData: cupertinoAlertDialogData,
);
