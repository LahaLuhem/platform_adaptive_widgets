import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:multi_value_listenable_builder_typed/multi_value_listenable_builder_typed.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import 'app/platform_scope.dart';
import 'app/theme_scope.dart';
import 'features/core/data/constants/const_theme.dart';
import 'features/root/views/root_tabs_view.dart';

void main() => runApp(const _ExampleApp());

/// Navigator entry point: `PlatformApp` + a scaffold-managed [RootTabsView].
/// Owns the app-wide theme mode and platform override, publishing them via
/// [ThemeScope] / [PlatformScope] so the About tab can flip the appearance and
/// the rendered platform.
class _ExampleApp extends StatefulWidget {
  const _ExampleApp();

  @override
  State<_ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<_ExampleApp> {
  final _themeModeNotifier = ValueNotifier(ThemeMode.system);
  final _platformNotifier = ValueNotifier<TargetPlatform?>(null);

  @override
  void dispose() {
    debugDefaultTargetPlatformOverride = null;
    _themeModeNotifier.dispose();
    _platformNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DualValueListenableBuilder<ThemeMode, TargetPlatform?>(
    firstListenable: _themeModeNotifier,
    secondListenable: _platformNotifier,
    builder: (_, themeMode, platformOverride, _) {
      // Flip the whole app's rendered platform above PlatformApp. Debug/JIT
      // only — const-folded (ignored) in AOT release builds.
      debugDefaultTargetPlatformOverride = platformOverride;

      return PlatformApp(
        title: 'Platform Adaptive Widgets',
        materialAppData: MaterialAppData(
          theme: ConstTheme.materialLightThemeData,
          darkTheme: ConstTheme.materialDarkThemeData,
          themeMode: themeMode,
        ),
        cupertinoAppData: CupertinoAppData(
          theme: ConstTheme.cupertinoThemeData(_cupertinoBrightnessFor(themeMode)),
        ),
        builder: (_, child) => ThemeScope(
          notifier: _themeModeNotifier,
          child: PlatformScope(notifier: _platformNotifier, child: child!),
        ),
        home: const RootTabsView(),
      );
    },
  );

  /// Cupertino has no `themeMode`; map it to an explicit brightness, or `null`
  /// to follow the device (the `system` case).
  Brightness? _cupertinoBrightnessFor(ThemeMode themeMode) => switch (themeMode) {
    ThemeMode.system => null,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}
