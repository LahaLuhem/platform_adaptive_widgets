// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformConfirmSnippet extends StatelessWidget {
  const PlatformConfirmSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _closePressed(context), child: const Text('Close'));

  Future<void> _closePressed(BuildContext context) async {
    // #region platform_confirm
    final shouldDiscard = await showPlatformConfirm(
      context: context,
      title: 'Discard changes?',
      message: 'Your edits will be lost.',
      confirmLabel: 'Discard',
      actionKind: .discard,
    );
    // #endregion
    debugPrint('$shouldDiscard'); // #hide
  }
}
