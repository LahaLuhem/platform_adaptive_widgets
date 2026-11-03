import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show DrawerButton;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _drawer = 'Drawer';

void main() {
  feature('PlatformScaffold', () {
    scenarioWidgets("opens its drawer through Material's own drawer button", (tester) async {
      await pumpPlatformWidget(
        tester,
        const PlatformScaffold(
          appBarData: PlatformAppBar(),
          materialScaffoldData: MaterialScaffoldData(drawer: Text(_drawer)),
          body: SizedBox(),
        ),
      );

      await tester.tap(find.byType(DrawerButton));
      await pumpTransition(tester);

      check(find.text(_drawer).evaluate()).isNotEmpty();
    }, variant: androidOnly);
  });
}
