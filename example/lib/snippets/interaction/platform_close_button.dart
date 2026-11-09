// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformCloseButtonSnippet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // #region platform_close_button
      const Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          // Top-leading, as the HIG asks.
          PlatformCloseButton(),
          Text('The sheet or dialog content goes here.'),
        ],
      );
  // #endregion
}
