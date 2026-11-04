// The swap reads the scheme's own error roles into the roles they stand in for.
// ignore_for_file: avoid-passing-self-as-argument

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Theme;

import '/src/models/dialogs/platform_action_kind.dart';

/// Draws a delete or discard in M3's error colours: each role Material's buttons, menu items and rows
/// read gives way to its error twin. Cupertino's buttons swap their accent for system red instead.
///
/// Kept in the tree while disabled, so enabling doesn't rebuild [child] and lose its state.
@internal
final class const MaterialDestructiveTheme({
  required final PlatformActionKind actionKind,
  required final bool isEnabled,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  /// Wraps [child] in the error colours when it destroys something.
  this;

  @override
  Widget build(BuildContext context) {
    switch (actionKind) {
      case .normal:
        return child;
      case .delete || .discard:
        final theme = Theme.of(context);
        final scheme = theme.colorScheme;

        return Theme(
          // Disabled, it greys out like any other control.
          data: !isEnabled
              ? theme
              : theme.copyWith(
                  colorScheme: scheme.copyWith(
                    primary: scheme.error,
                    onPrimary: scheme.onError,
                    secondaryContainer: scheme.errorContainer,
                    onSecondaryContainer: scheme.onErrorContainer,
                    onSurface: scheme.error,
                    onSurfaceVariant: scheme.error,
                  ),
                ),
          child: child,
        );
    }
  }
}
