import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

extension PlatformAdaptiveIconsExtension on PlatformAdaptiveIcons {
  IconData get arrowUpward =>
      context.platformIcon(material: Icons.arrow_upward, cupertino: CupertinoIcons.chevron_up);

  IconData get arrowDownward =>
      context.platformIcon(material: Icons.arrow_downward, cupertino: CupertinoIcons.chevron_down);

  IconData get collapseAll => context.platformIcon(
    material: Icons.unfold_less_outlined,
    cupertino: CupertinoIcons.rectangle_compress_vertical,
  );

  IconData get expandAll => context.platformIcon(
    material: Icons.unfold_more_outlined,
    cupertino: CupertinoIcons.rectangle_expand_vertical,
  );

  IconData get disable => context.platformIcon(
    material: Icons.do_not_touch_outlined,
    cupertino: CupertinoIcons.hand_raised_slash,
  );

  IconData get enable => context.platformIcon(
    material: Icons.touch_app_outlined,
    cupertino: CupertinoIcons.hand_raised,
  );
}
