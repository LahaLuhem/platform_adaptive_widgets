// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformExpansionTileSnippet extends StatelessWidget {
  const PlatformExpansionTileSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      // #region platform_expansion_tile
      const PlatformExpansionTile(title: Text('Settings'), child: Text('Settings content'));
  // #endregion
}
