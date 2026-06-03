import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A group of widgets shown as one entry in the Catalog tab and as one detail
/// page. Drives the catalog list (label, description, icon) and the navigation
/// to each detail page ([name] is the go_router route name, [routeAddress] the
/// sub-path under `/catalog`).
enum WidgetCategory {
  /// Filled, tonal, outlined, text, icon and disabled buttons.
  buttons(
    label: 'Buttons',
    description: 'Filled, tonal, outlined, text, icon and disabled buttons',
    routeAddress: 'buttons',
  ),

  /// Checkbox, switch, slider, segmented button, radios, menu picker.
  selection(
    label: 'Selection controls',
    description: 'Checkbox, switch, slider, segmented button, radios, menu picker',
    routeAddress: 'selection',
  ),

  /// Text field and search bar.
  text(label: 'Text & search', description: 'Text field and search bar', routeAddress: 'text'),

  /// List tile, expansion tile, scrollbar, progress indicator.
  containers(
    label: 'Lists & containers',
    description: 'List tile, expansion tile, scrollbar, progress indicator',
    routeAddress: 'containers',
  ),

  /// Dialogs, alerts, toast, bottom sheet, date & time pickers.
  dialogs(
    label: 'Dialogs & pickers',
    description: 'Dialogs, alerts, toast, bottom sheet, date & time pickers',
    routeAddress: 'dialogs',
  );

  /// Catalog row title.
  final String label;

  /// Catalog row subtitle.
  final String description;

  /// Sub-path under the Catalog branch.
  final String routeAddress;

  const WidgetCategory({
    required this.label,
    required this.description,
    required this.routeAddress,
  });

  /// The category's leading icon, adapted per platform.
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
