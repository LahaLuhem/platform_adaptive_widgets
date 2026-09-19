/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import 'platform_dialog.dart';

/// Default value for [showPlatformAcknowledge]'s `okLabel`. Override it to localise.
const kDefaultPlatformAcknowledgeOkLabel = 'OK';

/// Shows an alert with one OK button, [AlertDialog] on Android and [CupertinoAlertDialog] on iOS. The
/// returned future completes once it's dismissed.
///
/// For anything the app shouldn't continue past until it's been seen: errors, irreversible confirmations.
/// Routine feedback that can fade on its own wants `showPlatformToast` instead, which follows each platform's
/// own idiom for that.
///
/// A thin wrapper over [showPlatformAlertDialog], so the same data classes and flat args apply.
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_acknowledge.dart#platform_acknowledge}
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
