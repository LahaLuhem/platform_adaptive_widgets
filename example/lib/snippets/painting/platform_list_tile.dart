// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformListTileSnippet extends StatelessWidget {
  const PlatformListTileSnippet({required this.onSettingsPressed, super.key});

  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) =>
      // #region platform_list_tile
      PlatformListTile(
        title: const Text('Settings'),
        leading: const Icon(Icons.settings),
        onTap: onSettingsPressed,
      );
  // #endregion
}
