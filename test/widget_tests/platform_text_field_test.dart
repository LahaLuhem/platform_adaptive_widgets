import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoTextField;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

BoxDecoration? _drawnDecoration(WidgetTester tester) =>
    tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).decoration;

void main() {
  feature('PlatformTextField', () {
    scenarioWidgets("draws a plain CupertinoTextField's outline when given none", (tester) async {
      await pumpPlatformWidget(tester, const PlatformTextField());

      // Measured against upstream rather than the package's copy, so a drift between the two shows too.
      check(_drawnDecoration(tester)).equals(const CupertinoTextField().decoration);
    }, variant: iosOnly);

    scenarioWidgets('draws a decoration it was given instead', (tester) async {
      const decoration = BoxDecoration(color: Color(0xFF123456));
      await pumpPlatformWidget(
        tester,
        const PlatformTextField(
          cupertinoTextFieldData: CupertinoTextFieldData(decoration: decoration),
        ),
      );

      check(_drawnDecoration(tester)).equals(decoration);
    }, variant: iosOnly);
  });
}
