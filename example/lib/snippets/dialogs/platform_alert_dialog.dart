// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformAlertDialogSnippet extends StatelessWidget {
  const PlatformAlertDialogSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _deletePressed(context), child: const Text('Delete'));

  Future<void> _deletePressed(BuildContext context) async {
    // #region platform_alert_dialog
    final confirmed = await showPlatformAlertDialog<bool>(
      context: context,
      title: const Text('Delete?'),
      content: const Text('This cannot be undone.'),
      actions: [
        PlatformDialogAction(
          onPressed: (context) => Navigator.maybeOf(context)?.pop(false),
          child: const Text('Cancel'),
        ),
        PlatformDialogAction(
          isDestructiveAction: true,
          onPressed: (context) => Navigator.maybeOf(context)?.pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
    // #endregion
    debugPrint('$confirmed'); // #hide
  }
}
