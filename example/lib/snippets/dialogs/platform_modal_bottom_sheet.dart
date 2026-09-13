// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [showPlatformModalBottomSheet]'s doc example.
class PlatformModalBottomSheetSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformModalBottomSheetSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _openPressed(context), child: const Text('Open sheet'));

  Future<void> _openPressed(BuildContext context) async {
    // #region platform_modal_bottom_sheet
    await showPlatformModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: const [Text('Share'), Text('Duplicate'), Text('Delete')],
        ),
      ),
    );
    // #endregion
  }
}
