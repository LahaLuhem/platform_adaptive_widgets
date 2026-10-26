// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformDialogSnippet extends StatelessWidget {
  const PlatformDialogSnippet({super.key});

  @override
  Widget build(BuildContext context) => PlatformButton(
    onPressed: () => _openPressed(context),
    emphasis: .medium,
    child: const Text('Open'),
  );

  Future<void> _openPressed(BuildContext context) async {
    // #region platform_dialog
    final result = await showPlatformDialog<String>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pick one'),
            PlatformButton(
              onPressed: () => Navigator.maybeOf(context)?.pop('chosen'),
              emphasis: .low,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
    // #endregion
    debugPrint('$result'); // #hide
  }
}

class FullscreenDialogSnippet extends StatelessWidget {
  const FullscreenDialogSnippet({super.key});

  @override
  Widget build(BuildContext context) => PlatformButton(
    onPressed: () => _openPressed(context),
    emphasis: .medium,
    child: const Text('Open'),
  );

  Future<void> _openPressed(BuildContext context) async {
    // #region fullscreen_dialog
    final choice = await showPlatformFullscreenDialog<String>(
      context: context,
      // The bar brings the close button. Its context is the dialog's, so Done closes this dialog.
      appBarBuilder: (context) => PlatformAppBar(
        title: const Text('Pick one'),
        primaryAction: PlatformBarAction(
          label: 'Done',
          onPressed: () => Navigator.maybeOf(context)?.pop('chosen'),
        ),
      ),
      builder: (_) => const Center(child: Text('The choices go here.')),
    );
    // #endregion
    debugPrint('$choice'); // #hide
  }
}
