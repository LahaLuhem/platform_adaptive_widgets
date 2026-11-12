import 'dart:async';
import 'dart:ui' show SemanticsAction;

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDatePicker;
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

void main() {
  final feature = BddFeature('Cupertino picker popup');

  // The time picker shares this popup.
  Bdd(feature)
      .scenario('lets a screen reader close it, as a tap outside can')
      .runWidgets((tester) async {
        final semantics = tester.ensureSemantics();
        final today = Date.now();
        unawaited(
          showPlatformDatePicker(
            context: await pumpForContext(tester),
            firstDate: today,
            lastDate: today.tryAddDays(30)!,
          ),
        );
        await pumpTransition(tester);
        check(find.byType(CupertinoDatePicker).evaluate()).isNotEmpty();

        check(find.semantics.byAction(SemanticsAction.dismiss).evaluate()).isNotEmpty();
        semantics.dispose();
      }, variant: iosOnly);
}
