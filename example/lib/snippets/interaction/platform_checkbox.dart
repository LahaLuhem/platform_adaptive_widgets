// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformCheckboxSnippet extends StatefulWidget {
  const PlatformCheckboxSnippet({super.key});

  @override
  State<PlatformCheckboxSnippet> createState() => _PlatformCheckboxSnippetState();
}

class _PlatformCheckboxSnippetState extends State<PlatformCheckboxSnippet> {
  var _isChecked = false;

  @override
  Widget build(BuildContext context) =>
      // #region platform_checkbox
      PlatformCheckbox(value: _isChecked, onChanged: (value) => setState(() => _isChecked = value));
  // #endregion
}
