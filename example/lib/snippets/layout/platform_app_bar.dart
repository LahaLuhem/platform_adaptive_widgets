// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show IconButton, Icons, Scaffold;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [PlatformAppBar]'s doc example.
class PlatformAppBarSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformAppBarSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformScaffold(appBarData: _appBar(context), body: const SizedBox.shrink());

  PlatformAppBar _appBar(BuildContext context) =>
      // #region platform_app_bar
      PlatformAppBar(
        title: const Text('My App'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      );
  // #endregion
}
