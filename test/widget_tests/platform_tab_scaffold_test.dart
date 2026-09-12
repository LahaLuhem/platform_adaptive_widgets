import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _tab = TabDestination(inactiveIcon: SizedBox(), view: SizedBox());

void main() {
  feature('PlatformTabScaffold tab-count guard', () {
    scenarioOutlineWidgets<int>(
      'refuses fewer than two destinations',
      examples: {'no tabs': 0, 'one tab': 1},
      outline: (tester, tabCount) async {
        await pumpPlatformWidget(
          tester,
          PlatformTabScaffold(tabDestinations: List.filled(tabCount, _tab)),
        );

        // Material's NavigationBar is the half that needs two. Without this guard a single tab
        // renders fine on iOS and only blows up when someone runs it on Android.
        check(tester.takeException())
            .isA<AssertionError>()
            .has((error) => '${error.message}', 'message')
            .contains('at least 2 tab destinations');
      },
    );

    scenarioWidgets('builds with two destinations', (tester) async {
      await pumpPlatformWidget(tester, PlatformTabScaffold(tabDestinations: List.filled(2, _tab)));

      check(tester.takeException()).isNull();
    });
  });
}
