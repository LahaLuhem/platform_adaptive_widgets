// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [showPlatformTimePicker]'s doc example.
class PlatformTimePickerSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformTimePickerSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _pickPressed(context), child: const Text('Pick a time'));

  Future<void> _pickPressed(BuildContext context) async {
    // #region platform_time_picker
    // TimeOfDay here is material_ui's, not the one in flutter/material.
    final picked = await showPlatformTimePicker(context: context, initialTime: TimeOfDay.now());
    // #endregion
    debugPrint('$picked'); // #hide
  }
}
