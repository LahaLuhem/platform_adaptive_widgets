/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoListSection;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show RadioListTile, Theme;

import '/src/models/platform_widget_base.dart';
import '/src/widgets/interaction/cupertino_checkmark_row.dart';

/// Lines the header up with the rows' titles, which start past the radio.
const _kMaterialHeaderPadding = EdgeInsetsDirectional.fromSTEB(72, 16, 24, 8);

/// The list sits in a page, whose own title is the level 1 heading.
const _kHeaderHeadingLevel = 2;

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
    final header = this.header;
    final themeData = Theme.of(context);

    return RadioGroup<T>(
      groupValue: selected,
      // No row is toggleable, so a pick is never cleared to null.
      onChanged: (option) => onChanged(option!),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          if (header != null)
            Padding(
              padding: _kMaterialHeaderPadding,
              child: _ListHeader(
                text: header,
                style: themeData.textTheme.titleSmall?.copyWith(
                  color: themeData.colorScheme.primary,
                ),
              ),
            ),
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
    final header = this.header;

    return CupertinoListSection.insetGrouped(
      header: header == null ? null : _ListHeader(text: header),
      hasLeading: false,
      children: [
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

final class const _ListHeader({required final String text, final TextStyle? style})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    // iOS and Android take a heading from its level, not from `header`.
    headingLevel: _kHeaderHeadingLevel,
    child: Text(text, style: style),
  );
}
