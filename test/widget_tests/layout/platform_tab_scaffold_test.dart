import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _tab = TabDestination(inactiveIcon: SizedBox(), view: SizedBox());
const _viewlessTab = TabDestination(inactiveIcon: SizedBox());

void main() {
  feature('PlatformTabScaffold tab-count guard', () {
    // Material's NavigationBar refuses a single tab by itself, and Cupertino's would draw it.
    scenarioWidgets('refuses fewer than 2 destinations', (tester) async {
      await pumpPlatformWidget(tester, const PlatformTabScaffold(tabDestinations: [_tab]));

      check(tester.takeException()).isA<AssertionError>();
    }, variant: iosOnly);

    scenarioWidgets('builds with 2 destinations', (tester) async {
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
