import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// One expandable section of the Catalog tab. Declaration order is display order.
enum WidgetCategory({
  /// Shown on the section header.
  required final String label,
}) {
  /// Filled, tonal, outlined, text, icon and disabled buttons.
  buttons(label: 'Buttons'),

  /// Multi-select list, switch, slider, segmented button, single-select list, menu picker.
  selection(label: 'Selection controls'),

  /// Text field and search bar.
  text(label: 'Text & search'),

  /// List tile, expansion tile, scrollbar, progress indicator.
  containers(label: 'Lists & containers'),

  /// Dialogs, alerts, toast, bottom sheet, choices, actions menu, date & time pickers.
  dialogs(label: 'Dialogs & pickers');

  /// Adapted per platform.
  Icon icon(BuildContext context) => Icon(_iconData(context));

  IconData _iconData(BuildContext context) => switch (this) {
    .buttons => context.platformIcon(
      material: Icons.smart_button,
      cupertino: CupertinoIcons.hand_draw,
    ),
    .selection => context.platformIcon(
      material: Icons.tune,
      cupertino: CupertinoIcons.slider_horizontal_3,
    ),
    .text => context.platformIcon(
      material: Icons.text_fields,
      cupertino: CupertinoIcons.textformat,
    ),
    .containers => context.platformIcon(
      material: Icons.view_list,
      cupertino: CupertinoIcons.square_list,
    ),
    .dialogs => context.platformIcon(
      material: Icons.chat_bubble_outline,
      cupertino: CupertinoIcons.chat_bubble_2,
    ),
  };
}
