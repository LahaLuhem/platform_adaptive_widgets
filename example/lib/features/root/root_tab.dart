import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// The top-level tabs of the demo, shared by both shells (the managed
/// `RootTabsView` and the go_router-driven `RootTabsRouterView`) so the tab
/// bar's labels and icons are defined once.
enum RootTab {
  /// Browse the widget catalog by category.
  catalog(label: 'Catalog'),

  /// A realistic screen composed from the library's widgets.
  showcase(label: 'Showcase'),

  /// Library info and the appearance (theme-mode) control.
  about(label: 'About');

  /// The tab bar label.
  final String label;

  const RootTab({required this.label});

  /// The icon shown when this tab is selected.
  Icon activeIcon(BuildContext context) => Icon(_iconData(context, isActive: true));

  /// The icon shown when this tab is not selected.
  Icon inactiveIcon(BuildContext context) => Icon(_iconData(context, isActive: false));

  IconData _iconData(BuildContext context, {required bool isActive}) => switch (this) {
    .catalog => context.platformIcon(
      material: isActive ? Icons.widgets : Icons.widgets_outlined,
      cupertino: CupertinoIcons.square_grid_2x2,
    ),
    .showcase => context.platformIcon(
      material: isActive ? Icons.auto_awesome : Icons.auto_awesome_outlined,
      cupertino: CupertinoIcons.sparkles,
    ),
    .about => context.platformIcon(
      material: isActive ? Icons.info : Icons.info_outline,
      cupertino: CupertinoIcons.info_circle,
    ),
  };
}
