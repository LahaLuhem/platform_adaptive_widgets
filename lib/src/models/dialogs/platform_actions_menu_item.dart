import 'package:flutter/widgets.dart';

//TODO(lahaluhem): Consolidate with MenuPickerItem?.
final class PlatformActionsMenuItem {
  final String label;
  final VoidCallback onPressed;

  final bool cupertinoIsDefault;
  final bool cupertinoIsDestructive;

  const PlatformActionsMenuItem({
    required this.label,
    required this.onPressed,
    this.cupertinoIsDefault = false,
    this.cupertinoIsDestructive = false,
  });
}
