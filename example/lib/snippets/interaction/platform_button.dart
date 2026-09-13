// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformButtonSnippet extends StatelessWidget {
  const PlatformButtonSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      // #region platform_button
      PlatformButton(
        onPressed: () => Navigator.maybeOf(context)?.pop(),
        child: const Text('Dismiss'),
      );
  // #endregion
}

class PlatformButtonIconSnippet extends StatelessWidget {
  const PlatformButtonIconSnippet({required this.onAddPressed, super.key});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) =>
      // #region platform_button_icon
      PlatformButton.icon(
        onPressed: onAddPressed,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        materialButtonVariant: .filled,
        cupertinoButtonVariant: .filled,
      );
  // #endregion
}
