import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

/// A throwaway destination for the "native page transitions" and "large titles"
/// proofs in the Under-the-hood tab.
///
/// Pushed via `pushPlatformRoute`, so it arrives with a `CupertinoPageRoute`
/// (swipe-back) on iOS or a `MaterialPageRoute` on Android. With [large], its
/// nav bar opts into the iOS large, collapse-on-scroll title — a no-op styling
/// difference on Android, where there is no such bar.
class PushedDemoPage extends StatelessWidget {
  /// Whether the nav bar uses the iOS large-title variant.
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
                      'collapses as you scroll; on Android the same PlatformAppBar '
                      'is a standard bar.'
                : 'Pushed with pushPlatformRoute — a CupertinoPageRoute on iOS '
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
