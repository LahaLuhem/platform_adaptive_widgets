// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformSheetSnippet extends StatefulWidget {
  const PlatformSheetSnippet({super.key});

  @override
  State<PlatformSheetSnippet> createState() => _PlatformSheetSnippetState();
}

class _PlatformSheetSnippetState extends State<PlatformSheetSnippet> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: _openPressed, emphasis: .medium, child: const Text('New list'));

  Future<void> _openPressed() async {
    // #region platform_sheet
    _nameController.clear();
    final name = await showPlatformSheet<String>(
      context: context,
      appBarBuilder: (context) => PlatformAppBar(
        title: const Text('New list'),
        primaryAction: PlatformBarAction(
          label: 'Save',
          onPressed: () => Navigator.maybeOf(context)?.pop(_nameController.text),
        ),
      ),
      // Closing with a name typed in asks first.
      unsavedChanges: PlatformUnsavedChanges(
        hasChanges: () => _nameController.text.isNotEmpty,
        message: 'Discard this list?',
        discardLabel: 'Discard List',
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: PlatformTextField(controller: _nameController, hintText: 'Name'),
      ),
    );
    // #endregion
    debugPrint('$name'); // #hide
  }
}
