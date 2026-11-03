// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Colors;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformProgressIndicatorSnippet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_progress_indicator
      const PlatformProgressIndicator(color: Colors.blue);
  // #endregion
}
