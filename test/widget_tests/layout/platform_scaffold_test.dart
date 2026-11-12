import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show DrawerButton;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _drawer = 'Drawer';

void main() {
  final feature = BddFeature('PlatformScaffold');

  Bdd(feature)
      .scenario("opens its drawer through Material's own drawer button")
      .runWidgets((tester) async {
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
}
