// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoButton, CupertinoListTile;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Card, ElevatedButton;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [PlatformWidget]'s doc example.
class PlatformWidgetSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformWidgetSnippet({required this.onSavePressed, super.key});

  /// Wired into both branches, so the example shows one callback serving both.
  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) =>
      // #region platform_widget
      PlatformWidget(
        materialBuilder: (_) =>
            ElevatedButton(onPressed: onSavePressed, child: const Text('Android Button')),
        cupertinoBuilder: (_) =>
            CupertinoButton(onPressed: onSavePressed, child: const Text('iOS Button')),
      );
  // #endregion
}

/// Host for [PlatformWidgetBuilder]'s doc example.
class PlatformWidgetBuilderSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformWidgetBuilderSnippet({super.key});

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
