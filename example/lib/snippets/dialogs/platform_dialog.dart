// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [showPlatformFullscreenDialog]'s doc example.
class FullscreenDialogSnippet extends StatelessWidget {
  /// Creates the host.
  const FullscreenDialogSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _openPressed(context), child: const Text('Open'));

  Future<void> _openPressed(BuildContext context) async {
    // #region fullscreen_dialog
    final choice = await showPlatformFullscreenDialog<String>(
      context: context,
      // iOS's barrier is not tap-to-dismiss, so the content carries its own way out.
      builder: (context) => PlatformButton(
        onPressed: () => Navigator.maybeOf(context)?.pop('chosen'),
        child: const Text('Done'),
      ),
    );
    // #endregion
    debugPrint('$choice'); // #hide
  }
}
