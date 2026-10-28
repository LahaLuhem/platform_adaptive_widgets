/// @docImport '/src/widgets/dialogs/platform_menu_picker.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons, CupertinoListTile;
import 'package:flutter/widgets.dart';

/// [PlatformMenuPicker]'s page row, in a file of its own so other lists of options can share it: the
/// option's title, a checkmark once it's picked, and a tap anywhere on the row.
final class const CupertinoCheckmarkRow({
  required final String label,
  required final bool isPicked,
  required final VoidCallback onTap,
  final IconData? iconData,
  super.key,
}) extends StatelessWidget {
  /// Creates a row for one option.
  this;

  @override
  Widget build(BuildContext context) => Semantics(
    // CupertinoListTile has no selected state of its own
    // (https://github.com/flutter/flutter/issues/124425), so VoiceOver wouldn't hear which row is picked.
    selected: isPicked,
    child: CupertinoListTile(
      leading: iconData == null ? null : Icon(iconData),
      title: Text(label),
      trailing: isPicked ? const Icon(CupertinoIcons.check_mark) : null,
      onTap: onTap,
    ),
  );
}
