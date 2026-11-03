// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton, CupertinoListTile;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Card, ElevatedButton;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformWidgetSnippet({required final VoidCallback onSavePressed, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_widget
      PlatformWidget(
        materialBuilder: (_) =>
            ElevatedButton(onPressed: onSavePressed, child: const Text('Material Button')),
        cupertinoBuilder: (_) =>
            CupertinoButton(onPressed: onSavePressed, child: const Text('Cupertino Button')),
      );
  // #endregion
}

class const PlatformWidgetBuilderSnippet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_widget_builder
      PlatformWidgetBuilder(
        materialWidgetBuilder: (context, child) => Card(child: child),
        cupertinoWidgetBuilder: (context, child) => CupertinoListTile(title: child),
        child: const Text('Content'),
      );
  // #endregion
}
