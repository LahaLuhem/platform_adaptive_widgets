// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformSegmentButtonSnippet extends StatefulWidget {
  const PlatformSegmentButtonSnippet({super.key});

  @override
  State<PlatformSegmentButtonSnippet> createState() => _PlatformSegmentButtonSnippetState();
}

class _PlatformSegmentButtonSnippetState extends State<PlatformSegmentButtonSnippet> {
  String? _selectedView = 'Day';

  @override
  Widget build(BuildContext context) =>
      // #region platform_segment_button
      PlatformSegmentButton<String>(
        choices: const ['Day', 'Week', 'Month'],
        segmentBuilder: Text.new,
        selectedChoice: _selectedView,
        onSelectionChanged: (choice) => setState(() => _selectedView = choice),
      );
  // #endregion
}
