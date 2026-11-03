import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

void main() {
  feature('PlatformListTile', () {
    // Material's ListTile leaves it working by itself.
    scenarioWidgets('leaves a control inside a disabled row working', (tester) async {
      var toggles = 0;
      await pumpInPlatformScaffold(
        tester,
        PlatformListTile(
          title: const Text('Wi-Fi'),
          isEnabled: false,
          trailing: PlatformSwitch(value: true, onChanged: (_) => toggles++),
        ),
      );
      await tester.tap(find.byType(PlatformSwitch));
      await tester.pump();

      check(toggles).equals(1);
    }, variant: iosOnly);
  });
}
