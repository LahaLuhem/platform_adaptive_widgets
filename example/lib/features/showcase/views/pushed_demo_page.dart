import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// Somewhere to push to, for the page-transition and large-title proofs in the Under-the-hood tab.
///
/// Arrives on a `CupertinoPageRoute` on iOS, so it swipes back, and a `MaterialPageRoute` on Android.
class PushedDemoPage extends StatelessWidget {
  /// Opts into iOS's large, collapse-on-scroll title. Android has no such bar and ignores it.
  final bool large;

  const PushedDemoPage({required this.large, super.key});

  @override
  Widget build(BuildContext context) => PlatformScaffold(
    appBarData: PlatformAppBar(
      title: const Text('Pushed page'),
      cupertinoNavigationBarData: large ? const CupertinoNavigationBarData(large: true) : null,
    ),
    body: SafeArea(
      child: ListView(
        padding: const .all(16),
        children: [
          Text(
            large
                ? 'This nav bar sets large: true. On iOS the title is large and '
                      'collapses as you scroll. On Android the same PlatformAppBar '
                      'is a standard bar.'
                : 'Pushed with pushPlatformRoute, a CupertinoPageRoute on iOS '
                      '(swipe from the left edge to go back), a MaterialPageRoute '
                      'on Android.',
          ),
          const Gap(16),
          for (var line = 1; line <= 20; line++)
            Padding(padding: const .symmetric(vertical: 8), child: Text('Scrollable line $line')),
        ],
      ),
    ),
  );
}
