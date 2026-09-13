// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class PlatformMenuPickerSnippet extends StatefulWidget {
  const PlatformMenuPickerSnippet({super.key});

  @override
  State<PlatformMenuPickerSnippet> createState() => _PlatformMenuPickerSnippetState();
}

class _PlatformMenuPickerSnippetState extends State<PlatformMenuPickerSnippet> {
  var _view = 'Day';

  @override
  Widget build(BuildContext context) =>
      // #region platform_menu_picker
      PlatformMenuPicker<String>(
        items: const ['Day', 'Week', 'Month'],
        currentValue: _view,
        labelText: 'View',
        onSelected: (value) => setState(() => _view = value),
        menuPickerItemTransformer: (value) => MenuPickerItem(label: value),
      );
  // #endregion
}
