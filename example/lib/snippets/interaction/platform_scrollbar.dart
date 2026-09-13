// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformScrollbarSnippet extends StatefulWidget {
  const PlatformScrollbarSnippet({super.key});

  @override
  State<PlatformScrollbarSnippet> createState() => _PlatformScrollbarSnippetState();
}

class _PlatformScrollbarSnippetState extends State<PlatformScrollbarSnippet> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      // #region platform_scrollbar
      PlatformScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: const Text('Scrollable content'),
        ),
      );
  // #endregion
}
