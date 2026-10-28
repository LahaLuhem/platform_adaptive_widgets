/// @docImport '/src/widgets/dialogs/platform_confirm.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialLocalizations;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_action_kind.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import '/src/utils/design_language.dart';
import 'platform_alert_dialog.dart';

/// [showPlatformConfirm]'s alert, in a file of its own so the destructive confirm can share its
/// Material dialog.
@internal
Future<bool> showPlatformConfirmAlert({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required PlatformActionKind actionKind,
  String? message,
  Offset? anchorPoint,
  Color? barrierColor,
  bool? barrierDismissible,
  String? barrierLabel,
  RouteSettings? routeSettings,
  bool useRootNavigator = kDefaultUseRootNavigator,
  bool? requestFocus,
  MaterialAlertDialogData? materialAlertDialogData,
  CupertinoAlertDialogData? cupertinoAlertDialogData,
}) async {
  final cancelLabel = switch (designLanguage) {
    .material => MaterialLocalizations.of(context).cancelButtonLabel,
    .cupertino => CupertinoLocalizations.of(context).cancelButtonLabel,
  };
  final confirmed = await showPlatformAlertDialog<bool>(
    context: context,
    title: Text(title),
    content: message == null ? null : Text(message),
    // Cancel first: it leads a row, and ends a Material stack.
    actions: [
      PlatformDialogAction(
        onPressed: (context) => Navigator.maybeOf(context)?.pop(false),
        child: Text(cancelLabel),
      ),
      PlatformDialogAction(
        isDefaultAction: actionKind == .normal,
        // The person asked for the delete, so only a discard warns.
        isDestructiveAction: actionKind == .discard,
        onPressed: (context) => Navigator.maybeOf(context)?.pop(true),
        child: Text(confirmLabel),
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

  return confirmed ?? false;
}
