import 'package:checks/checks.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

List<int> _items(int count) => List.generate(count, (index) => index);

void main() {
  feature('PlatformMenuPicker small-item threshold', () {
    // Apple's HIG wants at least 3 choices before a pull-down menu earns its place, so the
    // Cupertino small-item path guards it. Material has no such rule.
    scenarioOutlineWidgets<int>(
      'iOS refuses fewer than 3 items',
      examples: {'1 item': 1, '2 items': 2},
      outline: (tester, itemCount) async {
        await pumpInPlatformScaffold(tester, PlatformMenuPicker<int>(items: _items(itemCount)));

        check(tester.takeException())
            .isA<AssertionError>()
            .has((error) => '${error.message}', 'message')
            .contains('at least 3 items');
      },
      variant: iosOnly,
    );

    scenarioOutlineWidgets<int>(
      'Android takes any count',
      examples: {'1 item': 1, '2 items': 2},
      outline: (tester, itemCount) async {
        await pumpInPlatformScaffold(tester, PlatformMenuPicker<int>(items: _items(itemCount)));

        check(tester.takeException()).isNull();
      },
      variant: androidOnly,
    );

    scenarioWidgets('3 items build on both', (tester) async {
      await pumpInPlatformScaffold(tester, PlatformMenuPicker<int>(items: _items(3)));

      check(tester.takeException()).isNull();
    });
  });
}
