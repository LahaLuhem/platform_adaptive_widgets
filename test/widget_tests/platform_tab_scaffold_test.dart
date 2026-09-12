import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _tab = TabDestination(inactiveIcon: SizedBox(), view: SizedBox());
const _viewlessTab = TabDestination(inactiveIcon: SizedBox());

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

  feature('PlatformTabScaffold mode guard', () {
    // Managed means every destination carries its own view. Controlled means a tabBodyBuilder
    // builds them instead. Doing both, or neither, leaves it ambiguous which one owns the body.
    scenarioWidgets('refuses a tabBodyBuilder next to per-destination views', (tester) async {
      await pumpPlatformWidget(
        tester,
        PlatformTabScaffold(
          tabDestinations: List.filled(2, _tab),
          tabBodyBuilder: (_, _) => const SizedBox(),
        ),
      );

      check(tester.takeException()).isA<AssertionError>();
    });

    scenarioWidgets('refuses destinations with neither a view nor a builder', (tester) async {
      await pumpPlatformWidget(
        tester,
        PlatformTabScaffold(tabDestinations: List.filled(2, _viewlessTab)),
      );

      check(tester.takeException()).isA<AssertionError>();
    });

    scenarioWidgets('accepts a tabBodyBuilder with viewless destinations', (tester) async {
      await pumpPlatformWidget(
        tester,
        PlatformTabScaffold(
          tabDestinations: List.filled(2, _viewlessTab),
          tabBodyBuilder: (_, _) => const SizedBox(),
        ),
      );

      check(tester.takeException()).isNull();
    });
  });
}
