// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [PlatformScaffold]'s doc example.
class PlatformScaffoldSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformScaffoldSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      // #region platform_scaffold
      const PlatformScaffold(
        appBarData: PlatformAppBar(title: Text('My App')),
        body: Center(child: Text('Hello World')),
      );
  // #endregion
}
