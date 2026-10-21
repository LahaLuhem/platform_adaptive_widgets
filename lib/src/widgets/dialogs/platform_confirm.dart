/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialLocalizations;

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_alert_dialog_data.dart';
import '/src/models/dialogs/platform_confirm_kind.dart';
import '/src/utils/design_language.dart';
import 'platform_dialog.dart';

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
  required PlatformConfirmKind kind,
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
    content: Text(message),
    // Cancel first: it leads a row, and ends a Material stack.
    actions: [
      PlatformDialogAction(
        onPressed: (context) => Navigator.maybeOf(context)?.pop(false),
        child: Text(cancelLabel),
      ),
      PlatformDialogAction(
        isDefaultAction: kind == .proceed,
        isDestructiveAction: kind == .discard,
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
