/// @docImport 'package:flutter/cupertino.dart';
/// @docImport 'package:flutter/material.dart';
library;

import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import 'platform_dialog.dart';

/// Default value for [showPlatformAcknowledge]'s `okLabel` — the text on the
/// single confirmation action. Override for localisation.
const kDefaultPlatformAcknowledgeOkLabel = 'OK';

/// Shows a must-acknowledge alert with a single confirmation action — Material
/// [AlertDialog] on Android, [CupertinoAlertDialog] on iOS. The user must tap
/// the OK button (or otherwise dismiss) before continuing.
///
/// **When to use.** Errors, irreversible confirmations, or any message where
/// the app shouldn't proceed until the user has seen and acknowledged the
/// content. For routine feedback that should fade on its own, use
/// `showPlatformToast` — that follows each platform's transient-feedback
/// idiom (Material `SnackBar`, iOS HUD banner).
///
/// Built on top of [showPlatformAlertDialog]; the per-platform alert-dialog
/// data classes ([materialAlertDialogData], [cupertinoAlertDialogData]) and
/// the shared show-function flat args are accepted as-is.
///
/// Returns a `Future<void>` that resolves once the user dismisses.
///
/// Example:
/// ```dart
/// await showPlatformAcknowledge(
///   context: context,
///   title: 'Upload failed',
///   message: 'Check your connection and try again.',
/// );
/// ```
Future<void> showPlatformAcknowledge({
  required BuildContext context,
  required String message,
  String? title,
  String okLabel = kDefaultPlatformAcknowledgeOkLabel,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialAlertDialogData? materialAlertDialogData,
  CupertinoAlertDialogData? cupertinoAlertDialogData,
}) => showPlatformAlertDialog(
  context: context,
  title: title == null ? null : Text(title),
  content: Text(message),
  actions: [
    PlatformDialogAction(
      isDefaultAction: true,
      onPressed: (context) => Navigator.maybeOf(context)?.pop(),
      child: Text(okLabel),
    ),
  ],
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
