// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [showPlatformDatePicker]'s doc example.
class PlatformDatePickerSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformDatePickerSnippet({super.key});

  @override
  Widget build(BuildContext context) =>
      PlatformButton(onPressed: () => _pickPressed(context), child: const Text('Pick a date'));

  Future<void> _pickPressed(BuildContext context) async {
    // #region platform_date_picker
    final picked = await showPlatformDatePicker(
      context: context,
      firstDate: Date.of(2020).getOrThrow(),
      lastDate: Date.now().tryAddDays(365)!,
      initialDate: Date.now(),
    );
    // #endregion
    debugPrint('$picked'); // #hide
  }
}
