import 'package:flutter/widgets.dart';

import '/src/models/dialogs/const_values.dart';
import '/src/models/dialogs/platform_choice.dart';
import '/src/utils/design_language.dart';
import 'cupertino_choices_sheet.dart';
import 'platform_confirm_alert.dart';

/// Asks once more before a destructive action, and answers true only on a confirm. Cupertino gets the
/// one-choice action sheet the HIG asks for after a destructive menu item
/// ([HIG pull-down buttons](https://developer.apple.com/design/human-interface-guidelines/pull-down-buttons#Best-practices)),
/// Material a basic dialog.
Future<bool> showPlatformDestructiveConfirm({
  required BuildContext context,
  required String message,
  required String confirmLabel,
}) => switch (designLanguage) {
  // Delete and discard look the same in both, so .delete stands in for either.
  .material => showPlatformConfirmAlert(
    context: context,
    // Its one sentence is the alert's title, which Material shows as the text.
    title: message,
    confirmLabel: confirmLabel,
    actionKind: .delete,
  ),
  .cupertino => showCupertinoChoicesSheet(
    context: context,
    choices: {PlatformChoice(value: true, label: confirmLabel, actionKind: .delete)},
    title: null,
    message: message,
    scrollController: null,
    cupertinoModalPopupData: null,
    anchorPoint: null,
    barrierColor: null,
    routeSettings: null,
    useRootNavigator: kDefaultUseRootNavigator,
    requestFocus: null,
  ).then((isConfirmed) => isConfirmed ?? false),
};
