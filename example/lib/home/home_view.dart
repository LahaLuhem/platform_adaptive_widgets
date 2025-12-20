import 'package:flutter/material.dart' show FloatingActionButton;
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => const PlatformScaffold(
    appBarData: PlatformAppBar(title: Text('Home page')),
    materialScaffoldData: MaterialScaffoldData(
      // No nested FABs
      // ignore: prefer-define-hero-tag
      floatingActionButton: FloatingActionButton(onPressed: _onAddPressed, child: Text('FAB')),
    ),
    body: Center(child: Text('Hello')),
  );
}

void _onAddPressed() => debugPrint('FAB pressed');
