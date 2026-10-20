import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTheme;
import 'package:material_ui/material_ui.dart';

import '/src/utils/design_language.dart';

/// Pulls colours off whichever theme the current platform is running, so you don't reach for [Theme]
/// or [CupertinoTheme] by hand.
final class const PlatformTheme.of(final BuildContext context) {
  /// Creates a [PlatformTheme] with the given [context].
  this;

  /// Falls back to transparent on Android, where the app bar theme may leave it unset.
  Color get barBackgroundColor => switch (designLanguage) {
    .material => Theme.of(context).appBarTheme.backgroundColor ?? const Color(0x00000000),
    .cupertino => CupertinoTheme.of(context).barBackgroundColor,
  };

  /// The theme's primary colour.
  Color get primaryColor => switch (designLanguage) {
    .material => Theme.of(context).primaryColor,
    .cupertino => CupertinoTheme.of(context).primaryColor,
  };

  /// Reads against [primaryColor].
  Color get primaryContrastingColor => switch (designLanguage) {
    .material => Theme.of(context).colorScheme.onPrimary,
    .cupertino => CupertinoTheme.of(context).primaryContrastingColor,
  };

  /// The background color of the scaffold.
  Color get scaffoldBackgroundColor => switch (designLanguage) {
    .material => Theme.of(context).scaffoldBackgroundColor,
    .cupertino => CupertinoTheme.of(context).scaffoldBackgroundColor,
  };

  /// The color of the selection handles.
  Color get selectionHandleColor => switch (designLanguage) {
    .material => Theme.of(context).colorScheme.onSurface,
    .cupertino => CupertinoTheme.of(context).selectionHandleColor,
  };
}
