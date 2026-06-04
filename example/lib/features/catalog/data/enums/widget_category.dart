import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A group of related widgets shown as one expandable section in the Catalog
/// tab. Drives the accordion: the section header ([label] + [icon]) and the
/// iteration order.
enum WidgetCategory {
  /// Filled, tonal, outlined, text, icon and disabled buttons.
  buttons(label: 'Buttons'),

  /// Checkbox, switch, slider, segmented button, radios, menu picker.
  selection(label: 'Selection controls'),

  /// Text field and search bar.
  text(label: 'Text & search'),

  /// List tile, expansion tile, scrollbar, progress indicator.
  containers(label: 'Lists & containers'),

  /// Dialogs, alerts, toast, bottom sheet, date & time pickers.
  dialogs(label: 'Dialogs & pickers');

  /// Accordion section header label.
  final String label;

  const WidgetCategory({required this.label});

  /// The category's header icon, adapted per platform.
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
