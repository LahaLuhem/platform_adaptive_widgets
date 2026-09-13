// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeData;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Host for [PlatformApp]'s doc example.
class PlatformAppSnippet extends StatelessWidget {
  /// Creates the host.
  const PlatformAppSnippet({
    required this.myLightTheme,
    required this.myDarkTheme,
    required this.myCupertinoTheme,
    super.key,
  });

  /// Stand-ins for whatever themes the app defines.
  final ThemeData myLightTheme;

  /// Dark counterpart of [myLightTheme].
  final ThemeData myDarkTheme;

  /// Cupertino's theme is a disjoint type, so it is configured separately.
  final CupertinoThemeData myCupertinoTheme;

  @override
  Widget build(BuildContext context) =>
      // #region platform_app
      PlatformApp(
        title: 'My App',
        home: const MyHomePage(),
        materialAppData: MaterialAppData(theme: myLightTheme, darkTheme: myDarkTheme),
        cupertinoAppData: CupertinoAppData(theme: myCupertinoTheme),
      );
  // #endregion
}

/// Stands in for the app's first screen.
class MyHomePage extends StatelessWidget {
  /// Creates the screen.
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) => const PlatformScaffold(body: Center(child: Text('Home')));
}
