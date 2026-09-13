// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformAcknowledgeSnippet extends StatelessWidget {
  const PlatformAcknowledgeSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _notifyPressed(context), child: const Text('Notify'));

  Future<void> _notifyPressed(BuildContext context) async {
    // #region platform_acknowledge
    await showPlatformAcknowledge(
      context: context,
      title: 'Upload failed',
      message: 'Check your connection and try again.',
    );
    // #endregion
  }
}
