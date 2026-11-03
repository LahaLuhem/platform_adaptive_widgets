// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformButtonSnippet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_button
      PlatformButton(
        onPressed: () => Navigator.maybeOf(context)?.pop(),
        emphasis: .low,
        child: const Text('Dismiss'),
      );
  // #endregion
}

class const PlatformButtonIconSnippet({required final VoidCallback onAddPressed, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_button_icon
      PlatformButton.icon(
        onPressed: onAddPressed,
        emphasis: .high,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      );
  // #endregion
}

class const PlatformButtonIconOnlySnippet({required final VoidCallback onSharePressed, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_button_icon_only
      PlatformButton.iconOnly(
        onPressed: onSharePressed,
        emphasis: .low,
        icon: Icon(context.platformIcon(material: Icons.share, cupertino: CupertinoIcons.share)),
        label: 'Share',
      );
  // #endregion
}
