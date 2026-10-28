// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformSingleSelectListSnippet extends StatefulWidget {
  const PlatformSingleSelectListSnippet({super.key});

  @override
  State<PlatformSingleSelectListSnippet> createState() => _PlatformSingleSelectListSnippetState();
}

class _PlatformSingleSelectListSnippetState extends State<PlatformSingleSelectListSnippet> {
  var _size = 'Medium';

  @override
  Widget build(BuildContext context) =>
      // #region platform_single_select_list
      PlatformSingleSelectList<String>(
        options: const {'Small', 'Medium', 'Large'},
        selected: _size,
        label: (size) => size,
        onChanged: (size) => setState(() => _size = size),
        header: 'Size',
      );
  // #endregion
}
