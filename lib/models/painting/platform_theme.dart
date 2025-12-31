import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

final class PlatformTheme {
  final BuildContext context;

  const PlatformTheme.of(this.context);

  Color get barBackgroundColor => context.platformValue(
    material: Theme.of(context).appBarTheme.backgroundColor ?? const Color(0x00000000),
    cupertino: CupertinoTheme.of(context).barBackgroundColor,
  );

  Color get primaryColor => context.platformValue(
    material: Theme.of(context).primaryColor,
    cupertino: CupertinoTheme.of(context).primaryColor,
  );

  Color get primaryContrastingColor => context.platformValue(
    material: Theme.of(context).colorScheme.onPrimary,
    cupertino: CupertinoTheme.of(context).primaryContrastingColor,
  );

  Color get scaffoldBackgroundColor => context.platformValue(
    material: Theme.of(context).scaffoldBackgroundColor,
    cupertino: CupertinoTheme.of(context).scaffoldBackgroundColor,
  );

  Color get selectionHandleColor => context.platformValue(
    material: Theme.of(context).colorScheme.onSurface,
    cupertino: CupertinoTheme.of(context).selectionHandleColor,
  );
}
