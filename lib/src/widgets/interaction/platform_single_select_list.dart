/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show RadioListTile;

import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/cupertino_checkmark_row.dart';
import '/src/widgets/interaction/select_list_section.dart';

const _kSelectedMissingMessage = 'Pass one of the options as selected, or nothing shows picked.';

/// [RadioListTile]s on Material, checkmark rows in an inset-grouped [CupertinoListSection] on Cupertino.
///
/// One option is always picked, so a tap on the picked row does nothing. Past 5 options, M3 suggests
/// a menu, so use [PlatformMenuPicker].
///
/// Guidelines: [M3 radio buttons](https://m3.material.io/components/radio-button/guidelines),
/// [HIG lists and tables](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables#Best-practices).
class const PlatformSingleSelectList<T extends Object>({
  /// Shown top to bottom in the set's order.
  required final Set<T> options,

  /// One of [options].
  required final T selected,

  required final String Function(T option) label,

  required final ValueChanged<T> onChanged,

  /// Names the group. Screen readers hear it as a heading.
  final String? header,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a list that picks one of its options.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    assert(options.contains(selected), _kSelectedMissingMessage);

    return RadioGroup<T>(
      groupValue: selected,
      // No row is toggleable, so a pick is never cleared to null.
      onChanged: (option) => onChanged(option!),
      child: MaterialSelectListSection(
        header: header,
        rows: [
          for (final option in options) RadioListTile<T>(value: option, title: Text(label(option))),
        ],
      ),
    );
  }

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    assert(options.contains(selected), _kSelectedMissingMessage);

    return CupertinoSelectListSection(
      header: header,
      rows: [
        for (final option in options)
          CupertinoCheckmarkRow(
            label: label(option),
            isPicked: option == selected,
            onTap: () {
              if (option != selected) onChanged(option);
            },
          ),
      ],
    );
  }
}
