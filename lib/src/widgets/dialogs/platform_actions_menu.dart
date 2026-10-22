import 'dart:async' show unawaited;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoMenuAnchor, CupertinoMenuItem;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MenuAnchor, MenuItemButton;

import '/src/models/dialogs/platform_menu_action.dart';
import '/src/models/platform_widget_base.dart';
import 'platform_destructive_confirm.dart';

/// A short list of actions behind a button: a pull-down menu on Cupertino, an M3 menu on Material.
/// A delete or discard asks first, in an action sheet on Cupertino and a dialog on Material.
///
/// Known Flutter gaps:
///
/// - Screen readers don't hear the actions as menu items or buttons
///   ([flutter/flutter#165682](https://github.com/flutter/flutter/issues/165682)).
/// - The page behind an open menu stays reachable by keyboard
///   ([flutter/flutter#171548](https://github.com/flutter/flutter/issues/171548)).
///
/// Guidelines: [M3 menus](https://m3.material.io/components/menus/guidelines),
/// [HIG pull-down buttons](https://developer.apple.com/design/human-interface-guidelines/pull-down-buttons#Best-practices).
///
/// Example:
/// {@example /example/lib/snippets/dialogs/platform_actions_menu.dart#platform_actions_menu}
class const PlatformActionsMenu({
  /// Builds the button. Give it the `onPressed` passed in, which opens the menu or closes an open one.
  required final Widget Function(BuildContext context, VoidCallback onPressed) builder,

  /// Shows in the set's order. Give every action an icon, or none.
  required final Set<PlatformMenuAction> actions,
  super.widgetKey,
  super.key,
}) extends PlatformWidgetKeyedBase {
  /// Creates a platform-adaptive actions menu.
  this;

  @override
  @protected
  @visibleForOverriding
  Widget buildMaterial(BuildContext context) {
    _debugAssertUsage();
    // M3 starts focus on the first item. It also lets Escape close a menu opened by a tap
    // (https://github.com/flutter/flutter/issues/195059).
    final firstEnabledAction = actions.where((action) => action.isEnabled).firstOrNull;

    return MenuAnchor(
      key: widgetKey,
      // A tap outside only closes the menu, as iOS and PopupMenuButton's menu do.
      consumeOutsideTap: true,
      menuChildren: [
        for (final action in actions)
          MenuItemButton(
            autofocus: action == firstEnabledAction,
            leadingIcon: action.iconData == null ? null : Icon(action.iconData),
            onPressed: !action.isEnabled ? null : () => unawaited(_run(context, action)),
            child: Text(action.label),
          ),
      ],
      builder: (context, controller, _) => builder(context, () => _toggle(controller)),
    );
  }

  @override
  @protected
  @visibleForOverriding
  Widget buildCupertino(BuildContext context) {
    _debugAssertUsage();

    return CupertinoMenuAnchor(
      key: widgetKey,
      // A tap outside only closes the menu, as on iOS.
      consumeOutsideTaps: true,
      menuChildren: [
        for (final action in actions)
          CupertinoMenuItem(
            isDestructiveAction: action.actionKind != .normal,
            // iOS 18's slot, which hides at accessibility text sizes as iOS does.
            trailing: action.iconData == null ? null : Icon(action.iconData),
            onPressed: !action.isEnabled ? null : () => unawaited(_run(context, action)),
            child: Text(action.label),
          ),
      ],
      builder: (context, controller, _) => builder(context, () => _toggle(controller)),
    );
  }

  static void _toggle(MenuController controller) =>
      controller.isOpen ? controller.close() : controller.open();

  // The HIG asks to confirm a destructive pull-down item.
  static Future<void> _run(BuildContext context, PlatformMenuAction action) async {
    final confirmMessage = action.confirmMessage;
    if (confirmMessage != null &&
        !await showPlatformDestructiveConfirm(
          context: context,
          message: confirmMessage,
          confirmLabel: action.label,
        )) {
      return;
    }

    action.onPressed();
  }

  // Per build rather than in a constructor assert, so callers keep their `const`.
  void _debugAssertUsage() {
    assert(actions.isNotEmpty, 'Pass at least 1 action.');
    assert(
      actions.map((action) => action.iconData != null).toSet().length == 1,
      'Give every action an icon, or none, as the HIG asks.',
    );
    assert(
      actions.map((action) => action.label).toSet().length == actions.length,
      'Give each action its own label, or the person cannot tell them apart.',
    );
  }
}
