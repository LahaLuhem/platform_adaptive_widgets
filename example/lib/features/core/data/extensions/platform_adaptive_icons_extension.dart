import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

extension PlatformAdaptiveIconsExtension on PlatformAdaptiveIcons {
  IconData get arrowUpward =>
      context.platformIcon(material: Icons.arrow_upward, cupertino: CupertinoIcons.chevron_up);

  IconData get arrowDownward =>
      context.platformIcon(material: Icons.arrow_downward, cupertino: CupertinoIcons.chevron_down);
}
