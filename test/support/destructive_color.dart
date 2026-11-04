import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Theme;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

int destructiveArgbOf(BuildContext context) => switch (designLanguage) {
  .material => Theme.of(context).colorScheme.error.toARGB32(),
  .cupertino => CupertinoColors.systemRed.color.toARGB32(),
};
