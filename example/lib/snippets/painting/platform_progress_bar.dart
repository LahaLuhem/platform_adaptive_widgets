// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformProgressBarSnippet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_progress_bar
      const PlatformProgressBar(value: 0.3, semanticsLabel: 'Downloading episode');
  // #endregion
}
