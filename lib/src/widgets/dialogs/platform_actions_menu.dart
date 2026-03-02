import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoActionSheet, CupertinoActionSheetAction, showCupertinoModalPopup;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MenuAnchor, MenuItemButton;
import 'package:pull_down_button/pull_down_button.dart';

import '/src/models/dialogs/platform_actions_menu_item.dart';
import '/src/models/platform_widget_base.dart';
import 'const_values.dart';

class PlatformActionsMenu extends PlatformWidgetBase {
  final Widget Function(BuildContext context, VoidCallback onTap) anchorBuilder;
  final List<PlatformActionsMenuItem> items;

  const PlatformActionsMenu({required this.anchorBuilder, required this.items, super.key})
    : assert(
        items.length >= ConstValues.minNumCupertinoPullDownButtonItems,
        'Must use minimum 3 items for this widget. Consider alternative design elements '
        'for the elements instead',
      );

  static const _kCupertinoDefaultActionFontWeight = FontWeight.w600;

  @override
  Widget buildMaterial(BuildContext context) => MenuAnchor(
    menuChildren: [
      for (final item in items) MenuItemButton(onPressed: item.onPressed, child: Text(item.label)),
    ],
    builder: (context, menuController, _) => anchorBuilder.call(
      context,
      menuController.isOpen ? menuController.close : menuController.open,
    ),
  );

  @override
  Widget buildCupertino(BuildContext context) => items.length > ConstValues.smallItemCountThreshold
      ? anchorBuilder.call(context, () => _showCupertinoModalPopup(context))
      : PullDownButton(
          buttonBuilder: anchorBuilder.call,
          itemBuilder: (_) => [
            for (final item in items)
              PullDownMenuItem(
                onTap: item.onPressed,
                title: item.label,
                isDestructive: item.cupertinoIsDestructive,
                itemTheme: !item.cupertinoIsDefault
                    ? null
                    : const PullDownMenuItemTheme(
                        textStyle: TextStyle(fontWeight: _kCupertinoDefaultActionFontWeight),
                      ),
              ),
          ],
        );

  Future<void> _showCupertinoModalPopup(BuildContext context) => showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        for (final item in items)
          CupertinoActionSheetAction(
            onPressed: () {
              item.onPressed.call();
              Navigator.of(context).pop();
            },
            isDefaultAction: item.cupertinoIsDefault,
            isDestructiveAction: item.cupertinoIsDestructive,
            child: Text(item.label),
          ),
      ],
    ),
  );
}
