// Named after the widget file it mirrors, not after its first host class.
// ignore_for_file: prefer-match-file-name

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeData;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class const PlatformAppSnippet({
  required final ThemeData myLightTheme,
  required final ThemeData myDarkTheme,
  required final CupertinoThemeData myCupertinoTheme,
  super.key,
}) extends StatelessWidget {
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

// Stands in for the app's first screen.
class const MyHomePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const PlatformScaffold(body: Center(child: Text('Home')));
}
