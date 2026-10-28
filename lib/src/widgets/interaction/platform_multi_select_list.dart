/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show CheckboxListTile;

import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/cupertino_checkmark_row.dart';
import '/src/widgets/interaction/select_list_section.dart';

const _kSelectedOutsideMessage =
    'Pass only options as selected. The rest never shows, and drops out on the next tap.';

/// [CheckboxListTile]s on Material, checkmark rows in an inset-grouped [CupertinoListSection] on Cupertino.
///
/// A tap on a row adds its option or drops it.
///
/// Guidelines: [M3 checkboxes](https://m3.material.io/components/checkbox/guidelines),
/// [HIG lists and tables](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables#Best-practices).
class const PlatformMultiSelectList<T extends Object>({
  /// Shown top to bottom in the set's order.
  required final Set<T> options,

  /// Any of [options], or none.
  required final Set<T> selected,

  required final String Function(T option) label,

  /// Gets the new set, in the options' order.
  required final ValueChanged<Set<T>> onChanged,

  /// Names the group. Screen readers hear it as a heading.
  final String? header,
  super.key,
}) extends PlatformWidgetBase {
  /// Creates a list that picks any of its options.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    assert(options.containsAll(selected), _kSelectedOutsideMessage);

    return MaterialSelectListSection(
      header: header,
      rows: [
        for (final option in options)
          CheckboxListTile(
            value: selected.contains(option),
            onChanged: (_) => onChanged(_toggled(option)),
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

    return CupertinoSelectListSection(
      header: header,
      rows: [
        for (final option in options)
          CupertinoCheckmarkRow(
            label: label(option),
            isPicked: selected.contains(option),
            onTap: () => onChanged(_toggled(option)),
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
