// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformActionsMenuSnippet({
  required final VoidCallback onShareListPressed,
  required final VoidCallback onPrintPressed,
  required final VoidCallback onDeleteListPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_actions_menu
      PlatformActionsMenu(
        builder: (_, onPressed) =>
            PlatformButton(onPressed: onPressed, emphasis: .medium, child: const Text('More')),
        actions: {
          PlatformMenuAction.normal(label: 'Share List', onPressed: onShareListPressed),
          PlatformMenuAction.normal(label: 'Print', onPressed: onPrintPressed),
          PlatformMenuAction.delete(
            label: 'Delete List',
            confirmMessage: 'This deletes the list and its reminders.',
            onPressed: onDeleteListPressed,
          ),
        },
      );
  // #endregion
}
