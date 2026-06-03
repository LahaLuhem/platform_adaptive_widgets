// ignore_for_file: prefer-match-file-name

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import 'app/const_theme.dart';
import 'app/router/app_router.dart';
import 'app/theme_scope.dart';

void main() => runApp(const _ExampleGoRouterApp());

/// go_router entry point: `PlatformApp.router` driven by [AppRouter]. Same
/// theming + [ThemeScope] wiring as the Navigator entry point — only the
/// navigation backend differs.
class _ExampleGoRouterApp extends StatefulWidget {
  const _ExampleGoRouterApp();

  @override
  State<_ExampleGoRouterApp> createState() => _ExampleGoRouterAppState();
}

class _ExampleGoRouterAppState extends State<_ExampleGoRouterApp> {
  final _themeModeNotifier = ValueNotifier(ThemeMode.system);

  @override
  void dispose() {
    _themeModeNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _themeModeNotifier,
    builder: (_, themeMode, _) => PlatformApp.router(
      title: 'Platform Adaptive Widgets (go_router)',
      routerConfig: AppRouter.router,
      materialAppData: MaterialAppData(
        theme: ConstTheme.materialLightThemeData,
        darkTheme: ConstTheme.materialDarkThemeData,
        themeMode: themeMode,
      ),
      cupertinoAppData: CupertinoAppData(
        theme: ConstTheme.cupertinoThemeData(_cupertinoBrightnessFor(themeMode)),
      ),
      builder: (_, child) => ThemeScope(notifier: _themeModeNotifier, child: child!),
    ),
  );

  /// Cupertino has no `themeMode`; map it to an explicit brightness, or `null`
  /// to follow the device (the `system` case).
  Brightness? _cupertinoBrightnessFor(ThemeMode themeMode) => switch (themeMode) {
    ThemeMode.system => null,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}
