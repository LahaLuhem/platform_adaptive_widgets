// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformMultiSelectListSnippet extends StatefulWidget {
  const PlatformMultiSelectListSnippet({super.key});

  @override
  State<PlatformMultiSelectListSnippet> createState() => _PlatformMultiSelectListSnippetState();
}

class _PlatformMultiSelectListSnippetState extends State<PlatformMultiSelectListSnippet> {
  var _days = {Weekday.saturday, Weekday.sunday};

  @override
  Widget build(BuildContext context) =>
      // #region platform_multi_select_list
      PlatformMultiSelectList<Weekday>(
        options: Weekday.values.toSet(),
        selected: _days,
        label: (day) => day.name,
        onChanged: (days) => setState(() => _days = days),
        header: 'Repeat',
      );
  // #endregion
}
