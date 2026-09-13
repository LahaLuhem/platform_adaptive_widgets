// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Colors;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [PlatformProgressIndicator]'s doc example.
class PlatformProgressIndicatorSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformProgressIndicatorSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      // #region platform_progress_indicator
      const PlatformProgressIndicator(color: Colors.blue);
  // #endregion
}
