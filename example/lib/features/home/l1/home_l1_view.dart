import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class HomeL1View extends StatelessWidget {
  const HomeL1View({super.key});

  @override
  Widget build(BuildContext context) => const PlatformScaffold(
    appBarData: PlatformAppBar(title: Text('Home L1 title')),
    body: Center(child: Text('Home L1')),
  );
}
