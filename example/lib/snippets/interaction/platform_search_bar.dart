// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformSearchBarSnippet({super.key}) extends StatefulWidget {
  @override
  State<PlatformSearchBarSnippet> createState() => _PlatformSearchBarSnippetState();
}

class _PlatformSearchBarSnippetState() extends State<PlatformSearchBarSnippet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      // #region platform_search_bar
      PlatformSearchBar(hintText: 'Search', controller: _controller, onChanged: _runSearch);
  // #endregion

  void _runSearch(String query) => debugPrint(query);
}
