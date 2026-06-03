import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import 'app/const_theme.dart';
import 'app/theme_scope.dart';
import 'features/root/root_tabs_view.dart';

void main() => runApp(const _ExampleApp());

/// Navigator entry point: `PlatformApp` + a scaffold-managed [RootTabsView].
/// Owns the app-wide theme mode and publishes it via [ThemeScope] so the About
/// tab can flip light/dark/system.
class _ExampleApp extends StatefulWidget {
  const _ExampleApp();

  @override
  State<_ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<_ExampleApp> {
  final _themeModeNotifier = ValueNotifier(ThemeMode.system);

  @override
  void dispose() {
    _themeModeNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _themeModeNotifier,
    builder: (_, themeMode, _) => PlatformApp(
      title: 'Platform Adaptive Widgets',
      materialAppData: MaterialAppData(
        theme: ConstTheme.materialLightThemeData,
        darkTheme: ConstTheme.materialDarkThemeData,
        themeMode: themeMode,
      ),
      cupertinoAppData: CupertinoAppData(
        theme: ConstTheme.cupertinoThemeData(_cupertinoBrightnessFor(themeMode)),
      ),
      builder: (_, child) => ThemeScope(notifier: _themeModeNotifier, child: child!),
      home: const RootTabsView(),
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
