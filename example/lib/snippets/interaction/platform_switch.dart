// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformSwitchSnippet extends StatefulWidget {
  const PlatformSwitchSnippet({super.key});

  @override
  State<PlatformSwitchSnippet> createState() => _PlatformSwitchSnippetState();
}

class _PlatformSwitchSnippetState extends State<PlatformSwitchSnippet> {
  var _isOn = false;

  @override
  Widget build(BuildContext context) =>
      // #region platform_switch
      PlatformSwitch(value: _isOn, onChanged: (value) => setState(() => _isOn = value));
  // #endregion
}
