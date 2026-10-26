// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformAppBarSnippet extends StatelessWidget {
  const PlatformAppBarSnippet({
    required this.onSharePressed,
    required this.onSavePressed,
    super.key,
  });

  final VoidCallback onSharePressed;

  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) =>
      PlatformScaffold(appBarData: _appBar(context), body: const SizedBox.shrink());

  PlatformAppBar _appBar(BuildContext context) =>
      // #region platform_app_bar
      PlatformAppBar(
        title: const Text('Note'),
        actions: [
          PlatformBarAction(
            label: 'Share',
            icon: Icon(
              context.platformIcon(material: Icons.share, cupertino: CupertinoIcons.share),
            ),
            onPressed: onSharePressed,
          ),
        ],
        primaryAction: PlatformBarAction(label: 'Save', onPressed: onSavePressed),
      );
  // #endregion
}
