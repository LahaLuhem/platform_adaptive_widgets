import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show NavigationDestination;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _tab = TabDestination(inactiveIcon: SizedBox(), view: SizedBox());
const _viewlessTab = TabDestination(inactiveIcon: SizedBox());

void main() {
  final tabCount = BddFeature('PlatformTabScaffold tab-count guard');

  // Material's NavigationBar refuses it by itself.
  Bdd(tabCount).scenario('refuses fewer than 2 destinations').runWidgets((tester) async {
    await pumpPlatformWidget(tester, const PlatformTabScaffold(tabDestinations: [_tab]));

    check(tester.takeException()).isA<AssertionError>();
  }, variant: iosOnly);

  Bdd(tabCount).scenario('builds with 2 destinations').runWidgets((tester) async {
    await pumpPlatformWidget(tester, PlatformTabScaffold(tabDestinations: List.filled(2, _tab)));

    check(tester.takeException()).isNull();
  });

  final modeGuard = BddFeature('PlatformTabScaffold mode guard');

  // Managed means every destination carries its own view. Controlled means a tabBodyBuilder
  // builds them instead. Doing both, or neither, leaves it ambiguous which one owns the body.
  Bdd(modeGuard)
      .scenario('refuses a tabBodyBuilder next to per-destination views')
      .runWidgets((tester) async {
        await pumpPlatformWidget(
          tester,
          PlatformTabScaffold(
            tabDestinations: List.filled(2, _tab),
            tabBodyBuilder: (_, _) => const SizedBox(),
          ),
        );

        check(tester.takeException()).isA<AssertionError>();
      });

  Bdd(modeGuard)
      .scenario('refuses destinations with neither a view nor a builder')
      .runWidgets((tester) async {
        await pumpPlatformWidget(
          tester,
          PlatformTabScaffold(tabDestinations: List.filled(2, _viewlessTab)),
        );

        check(tester.takeException()).isA<AssertionError>();
      });

  Bdd(modeGuard)
      .scenario('accepts a tabBodyBuilder with viewless destinations')
      .runWidgets((tester) async {
        await pumpPlatformWidget(
          tester,
          PlatformTabScaffold(
            tabDestinations: List.filled(2, _viewlessTab),
            tabBodyBuilder: (_, _) => const SizedBox(),
          ),
        );

        check(tester.takeException()).isNull();
      });

  final destinationKey = BddFeature('PlatformTabScaffold destination key');

  // Cupertino's BottomNavigationBarItem takes no key, so only Material has a widget to put it on.
  Bdd(destinationKey)
      .scenario("a tab's key reaches its Material destination")
      .runWidgets((tester) async {
        const key = Key('second tab');
        await pumpPlatformWidget(
          tester,
          const PlatformTabScaffold(
            tabDestinations: [
              _tab,
              TabDestination(inactiveIcon: SizedBox(), view: SizedBox(), key: key),
            ],
          ),
        );

        check(tester.widget(find.byKey(key))).isA<NavigationDestination>();
      }, variant: androidOnly);
}
