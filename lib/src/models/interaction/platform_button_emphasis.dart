/// @docImport 'package:cupertino_ui/cupertino_ui.dart';
/// @docImport 'package:material_ui/material_ui.dart';
/// @docImport '/src/widgets/interaction/platform_button.dart';
library;

/// How much attention a [PlatformButton] asks for. Both platforms read the one value, so a button
/// ranks the same on each.
enum PlatformButtonEmphasis() {
  /// The action people are most likely to take, ideally one per screen. A [FilledButton] on Material,
  /// a [CupertinoButton.filled] on Cupertino.
  high,

  /// An important action that isn't the main one. A [FilledButton.tonal] on Material, a
  /// [CupertinoButton.tinted] on Cupertino.
  medium,

  /// [medium] without the accent color. An [OutlinedButton] on Material, and on Cupertino a
  /// [CupertinoButton.tinted] in [CupertinoColors.systemGrey], cupertino_ui's take on iOS's gray button.
  mediumNeutral,

  /// The least important, like an action inside a dialog. A [TextButton] on Material, a plain
  /// [CupertinoButton] on Cupertino.
  low,
}
