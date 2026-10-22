// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

enum DraftAction { save, delete }

class PlatformChoicesSnippet extends StatelessWidget {
  const PlatformChoicesSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _draftPressed(context), child: const Text('Draft'));

  Future<void> _draftPressed(BuildContext context) async {
    // #region platform_choices
    final draftAction = await showPlatformChoices(
      context: context,
      title: 'Unsent draft',
      choices: const [
        PlatformChoice(value: DraftAction.save, label: 'Save Draft', actionKind: .normal),
        PlatformChoice(value: DraftAction.delete, label: 'Delete Draft', actionKind: .delete),
      ],
    );
    // #endregion
    debugPrint('$draftAction'); // #hide
  }
}
