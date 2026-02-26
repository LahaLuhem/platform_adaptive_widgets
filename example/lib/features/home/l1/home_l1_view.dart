import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '/app/router/app_route.dart';
import '../home_view.dart';

class HomeL1View extends StatelessWidget {
  final HomeViewArgs homeViewArgs;

  const HomeL1View({required this.homeViewArgs, super.key});

  @override
  Widget build(BuildContext context) => PlatformScaffold(
    appBarData: const PlatformAppBar(title: Text('Home L1 title')),
    body: Center(
      child: !homeViewArgs.isUsingGoRouter
          ? const Text('Home L1')
          : PlatformButton(
              onPressed: () {
                debugPrint('Go to Settings pressed');
                context.goNamed(AppRoute.settings.name);
              },
              child: const Text('Go to Settings'),
            ),
    ),
  );
}
