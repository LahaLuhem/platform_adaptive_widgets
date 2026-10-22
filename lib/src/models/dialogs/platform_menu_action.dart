/// @docImport '/src/widgets/dialogs/platform_actions_menu.dart';
library;

import 'package:flutter/widgets.dart';

import '/src/models/dialogs/platform_action_kind.dart';

/// One action in a [PlatformActionsMenu]. Its constructor says what it does, so a delete or discard
/// can't ship without the message its confirm asks.
final class PlatformMenuAction {
  /// Names what it does, like Delete List.
  final String label;

  /// Sits after the label on Cupertino and before it on Material.
  final IconData? iconData;

  /// The way to disable it, which greys it out on both.
  final bool isEnabled;

  /// Runs once picked, and only after a confirm for a delete or discard.
  final VoidCallback onPressed;

  /// Set by the constructor.
  final PlatformActionKind actionKind;

  /// Asked before a delete or discard runs. Null on a normal action.
  final String? confirmMessage;

  /// Something harmless, like Share. Runs at once.
  const new normal({
    required this.label,
    required this.onPressed,
    this.iconData,
    this.isEnabled = true,
  }) : actionKind = .normal,
       confirmMessage = null;

  /// Destroys what the person picked, like Delete List.
  const new delete({
    required this.label,
    required String this.confirmMessage,
    required this.onPressed,
    this.iconData,
    this.isEnabled = true,
  }) : actionKind = .delete;

  /// Loses what the person didn't pick, like Discard Changes.
  const new discard({
    required this.label,
    required String this.confirmMessage,
    required this.onPressed,
    this.iconData,
    this.isEnabled = true,
  }) : actionKind = .discard;
}
