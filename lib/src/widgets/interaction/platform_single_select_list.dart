/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListSection;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show RadioListTile;

import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/internal/cupertino_checkmark_row.dart';
import '/src/widgets/interaction/internal/select_list_section.dart';

const _kSelectedMissingMessage = 'Pass one of the options as selected, or nothing shows picked.';

/// [RadioListTile]s on Material, checkmark rows in an inset-grouped [CupertinoListSection] on Cupertino.
///
/// One option is always picked, so a tap on the picked row does nothing. Past 5 options, M3 suggests
/// a menu, so use [PlatformMenuPicker].
///
/// Guidelines: [M3 radio buttons](https://m3.material.io/components/radio-button/guidelines),
/// [HIG lists and tables](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_single_select_list.dart#platform_single_select_list}
class const PlatformSingleSelectList<T extends Object>({
  /// Shown top to bottom in the set's order.
  required final Set<T> options,

  /// One of [options].
  required final T selected,

  /// Turns an option into its row's text.
  required final String Function(T option) label,

  /// Gets the option just picked.
  required final ValueChanged<T> onChanged,

  /// Material greys the rows out. Cupertino can't yet ([flutter/flutter#195327](https://github.com/flutter/flutter/issues/195327)),
  /// but VoiceOver reads them as dimmed.
  final bool isEnabled = true,

  /// Names the group. Screen readers hear it as a heading.
  final String? header,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a list that picks one of its options.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    assert(options.contains(selected), _kSelectedMissingMessage);

    return RadioGroup<T>(
      key: widgetKey,
      groupValue: selected,
      // No row is toggleable, so a pick is never cleared to null.
      onChanged: (option) => onChanged(option!),
      child: MaterialSelectListSection(
        header: header,
        rows: [
          for (final option in options)
            RadioListTile<T>(
              value: option,
              title: Text(label(option)),
              enabled: isEnabled ? null : false,
            ),
        ],
      ),
    );
  }

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    assert(options.contains(selected), _kSelectedMissingMessage);
    final header = this.header;

    return CupertinoListSection.insetGrouped(
      key: widgetKey,
      header: header == null ? null : SelectListHeader(text: header),
      hasLeading: false,
      children: [
        for (final option in options)
          CupertinoCheckmarkRow(
            label: label(option),
            isPicked: option == selected,
            onTap: () {
              if (option != selected) onChanged(option);
            },
            isEnabled: isEnabled,
          ),
      ],
    );
  }
}
