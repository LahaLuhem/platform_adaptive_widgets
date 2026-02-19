import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => PlatformScaffold(
    appBarData: const PlatformAppBar(title: Text('Settings Page')),
    body: Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const Text('This can be used to check for any rebuilds'),
          Text('${DateTime.now().hashCode}'),
        ],
      ),
    ),
  );
}
