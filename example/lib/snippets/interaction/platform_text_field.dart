// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformTextFieldSnippet extends StatefulWidget {
  const PlatformTextFieldSnippet({super.key});

  @override
  State<PlatformTextFieldSnippet> createState() => _PlatformTextFieldSnippetState();
}

class _PlatformTextFieldSnippetState extends State<PlatformTextFieldSnippet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      // #region platform_text_field
      PlatformTextField(
        controller: _controller,
        hintText: 'Search',
        prefix: const Icon(Icons.search),
        onSubmitted: _runSearch,
      );
  // #endregion

  void _runSearch(String query) => debugPrint(query);
}
