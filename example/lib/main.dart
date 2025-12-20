import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Drawer, Icons;
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import 'home/home_view.dart';
import 'settings/settings_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const PlatformApp(
    appData: AppData(title: 'Flutter Demo', home: MyHomePage()),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) => PlatformTabScaffold(
    materialTabScaffoldData: const MaterialTabScaffoldData(drawer: Drawer(child: Text('Drawer'))),
    tabDestinationsData: [
      TabDestinationData(
        view: const HomeView(),
        inactiveIcon: Icon(
          context.platformIcon(material: Icons.home, cupertino: CupertinoIcons.home),
        ),
        label: 'Home',
      ),
      TabDestinationData(
        view: const SettingsView(),
        inactiveIcon: Icon(
          context.platformIcon(material: Icons.settings, cupertino: CupertinoIcons.settings),
        ),
        label: 'Settings',
      ),
    ],
  );
}
