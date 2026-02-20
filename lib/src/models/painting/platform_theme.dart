import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTheme;
import 'package:material_ui/material_ui.dart';

import '/src/extensions/context_extensions.dart';

/// Provides access to platform-specific theme colors.
final class PlatformTheme {
  /// The build context to use for retrieving theme data.
  final BuildContext context;

  /// Creates a [PlatformTheme] with the given [context].
  const PlatformTheme.of(this.context);

  /// The background color of the app bar.
  Color get barBackgroundColor => context.platformLazyValue(
    material: () => Theme.of(context).appBarTheme.backgroundColor ?? const Color(0x00000000),
    cupertino: () => CupertinoTheme.of(context).barBackgroundColor,
  );

  /// The primary color of the theme.
  Color get primaryColor => context.platformLazyValue(
    material: () => Theme.of(context).primaryColor,
    cupertino: () => CupertinoTheme.of(context).primaryColor,
  );

  /// A color that contrasts with the primary color.
  Color get primaryContrastingColor => context.platformLazyValue(
    material: () => Theme.of(context).colorScheme.onPrimary,
    cupertino: () => CupertinoTheme.of(context).primaryContrastingColor,
  );

  /// The background color of the scaffold.
  Color get scaffoldBackgroundColor => context.platformLazyValue(
    material: () => Theme.of(context).scaffoldBackgroundColor,
    cupertino: () => CupertinoTheme.of(context).scaffoldBackgroundColor,
  );

  /// The color of the selection handles.
  Color get selectionHandleColor => context.platformLazyValue(
    material: () => Theme.of(context).colorScheme.onSurface,
    cupertino: () => CupertinoTheme.of(context).selectionHandleColor,
  );
}
