import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// The demo's top-level tabs. Both shells read this, so labels and icons are written once.
enum RootTab {
  /// Browse the widget catalog by category.
  catalog(label: 'Catalog'),

  /// The deliberate, easy-to-get-wrong details the library handles for you.
  showcase(label: 'Under the hood'),

  /// Library info and the appearance (theme-mode) control.
  about(label: 'About');

  /// Shown under the icon.
  final String label;

  const RootTab({required this.label});

  /// While selected.
  Icon activeIcon(BuildContext context) => Icon(_iconData(context, isActive: true));

  /// The rest of the time.
  Icon inactiveIcon(BuildContext context) => Icon(_iconData(context, isActive: false));

  IconData _iconData(BuildContext context, {required bool isActive}) => switch (this) {
    .catalog => context.platformIcon(
      material: isActive ? Icons.widgets : Icons.widgets_outlined,
      cupertino: CupertinoIcons.square_grid_2x2,
    ),
    .showcase => context.platformIcon(
      material: isActive ? Icons.engineering : Icons.engineering_outlined,
      cupertino: CupertinoIcons.gear,
    ),
    .about => context.platformIcon(
      material: isActive ? Icons.info : Icons.info_outline,
      cupertino: CupertinoIcons.info_circle,
    ),
  };
}
