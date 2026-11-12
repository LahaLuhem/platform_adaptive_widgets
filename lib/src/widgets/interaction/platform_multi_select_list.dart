import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListSection;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CheckboxListTile;

import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/internal/cupertino_checkmark_row.dart';
import '/src/widgets/interaction/internal/select_list_section.dart';

const _kSelectedOutsideMessage =
    'Pass only options as selected. The rest never shows, and drops out on the next tap.';

/// [CheckboxListTile]s on Material, checkmark rows in an inset-grouped [CupertinoListSection] on Cupertino.
///
/// A tap on a row adds its option or drops it.
///
/// Guidelines: [M3 checkboxes](https://m3.material.io/components/checkbox/guidelines),
/// [HIG lists and tables](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/interaction/platform_multi_select_list.dart#platform_multi_select_list}
class const PlatformMultiSelectList<T extends Object>({
  /// Shown top to bottom in the set's order.
  required final Set<T> options,

  /// Any of [options], or none.
  required final Set<T> selected,

  /// Turns an option into its row's text.
  required final String Function(T option) label,

  /// Gets the new set, in the options' order.
  required final ValueChanged<Set<T>> onChanged,

  /// Material greys the rows out. Cupertino can't yet ([flutter/flutter#195327](https://github.com/flutter/flutter/issues/195327)),
  /// but VoiceOver reads them as dimmed.
  final bool isEnabled = true,

  /// Names the group. Screen readers hear it as a heading.
  final String? header,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a list that picks any of its options.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    assert(options.containsAll(selected), _kSelectedOutsideMessage);

    return MaterialSelectListSection(
      key: widgetKey,
      header: header,
      rows: [
        for (final option in options)
          CheckboxListTile(
            value: selected.contains(option),
            onChanged: (_) => onChanged(_toggled(option)),
            enabled: isEnabled ? null : false,
            title: Text(label(option)),
            // Where the single list's radios sit, which the header lines up with.
            controlAffinity: .leading,
          ),
      ],
    );
  }

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    assert(options.containsAll(selected), _kSelectedOutsideMessage);
    final header = this.header;

    return CupertinoListSection.insetGrouped(
      key: widgetKey,
      header: header == null ? null : SelectListHeader(text: header),
      hasLeading: false,
      children: [
        for (final option in options)
          CupertinoCheckmarkRow(
            label: label(option),
            isPicked: selected.contains(option),
            onTap: () => onChanged(_toggled(option)),
            isEnabled: isEnabled,
          ),
      ],
    );
  }

  Set<T> _toggled(T option) {
    final picked = selected.contains(option)
        ? selected.difference({option})
        : selected.union({option});

    // Back in the options' order, whatever order the taps came in.
    return options.where(picked.contains).toSet();
  }
}
