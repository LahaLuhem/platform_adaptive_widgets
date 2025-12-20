import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => const PlatformScaffold(
    appBarData: PlatformAppBar(title: Text('Settings Page')),
    body: Center(child: Text('World!')),
  );
}
