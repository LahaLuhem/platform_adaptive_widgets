// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformSliderSnippet extends StatefulWidget {
  const PlatformSliderSnippet({super.key});

  @override
  State<PlatformSliderSnippet> createState() => _PlatformSliderSnippetState();
}

class _PlatformSliderSnippetState extends State<PlatformSliderSnippet> {
  var _value = 0.5;

  @override
  Widget build(BuildContext context) =>
      // #region platform_slider
      PlatformSlider(value: _value, onChanged: (value) => setState(() => _value = value));
  // #endregion
}
