import 'package:flutter/material.dart' show FloatingActionButton;
import 'package:flutter/widgets.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => PlatformScaffold(
    appBarData: const PlatformAppBar(title: Text('Home page')),
    materialScaffoldData: const MaterialScaffoldData(
      // No nested FABs
      // ignore: prefer-define-hero-tag
      floatingActionButton: FloatingActionButton(onPressed: _onAddPressed, child: Text('FAB')),
    ),
    body: SafeArea(
      child: Padding(
        padding: const .all(16),
        child: CustomScrollView(
          slivers: [
            const _SectionHeader(title: 'Painting'),
            SliverList.list(children: const [Center(child: PlatformProgressIndicator())]),
          ],
        ),
      ),
    ),
  );
}

final class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => AdaptiveHeightSliverPersistentHeader(
    initialHeight: 24,
    floating: true,
    needRepaint: true,
    child: Text(title),
  );
}

void _onAddPressed() => debugPrint('FAB pressed');
