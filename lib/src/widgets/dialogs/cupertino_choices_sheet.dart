/// @docImport '/src/widgets/dialogs/platform_choices.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoActionSheet, CupertinoActionSheetAction, CupertinoLocalizations;
import 'package:flutter/widgets.dart';

import '/src/models/dialogs/platform_choice.dart';
import '/src/models/dialogs/platform_modal_bottom_sheet_data.dart';
import 'sheet_routes.dart';

/// [showPlatformChoices]'s action sheet, in a file of its own so the destructive confirm can share it.
Future<T?> showCupertinoChoicesSheet<T extends Object>({
  required BuildContext context,
  required Set<PlatformChoice<T>> choices,
  required String? title,
  required String? message,
  required ScrollController? scrollController,
  required CupertinoModalPopupData? cupertinoModalPopupData,
  required Offset? anchorPoint,
  required Color? barrierColor,
  required RouteSettings? routeSettings,
  required bool useRootNavigator,
  required bool? requestFocus,
}) => showCupertinoPopupRoute(
  context: context,
  builder: (context) => CupertinoActionSheet(
    title: title == null ? null : Text(title),
    message: message == null ? null : Text(message),
    actions: [
      // The HIG puts destructive choices on top.
      for (final choice in [
        ...choices.where((choice) => choice.actionKind != .normal),
        ...choices.where((choice) => choice.actionKind == .normal),
      ])
        CupertinoActionSheetAction(
          isDestructiveAction: choice.actionKind != .normal,
          onPressed: () => Navigator.maybeOf(context)?.pop(choice.value),
          child: Text(choice.label),
        ),
    ],
    actionScrollController: scrollController,
    cancelButton: CupertinoActionSheetAction(
      // iOS bolds its own Cancel, cupertino_ui doesn't unless asked.
      isDefaultAction: true,
      onPressed: () => Navigator.maybeOf(context)?.pop(),
      child: Text(CupertinoLocalizations.of(context).cancelButtonLabel),
    ),
  ),
  cupertinoModalPopupData: cupertinoModalPopupData,
  anchorPoint: anchorPoint,
  barrierColor: barrierColor,
  barrierDismissible: true,
  routeSettings: routeSettings,
  useRootNavigator: useRootNavigator,
  requestFocus: requestFocus,
);
