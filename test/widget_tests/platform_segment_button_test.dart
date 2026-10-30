import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

void main() {
  feature('PlatformSegmentButton', () {
    scenarioOutlineWidgets<({Set<String> choices, String? selectedChoice})>(
      "flags choices it can't show",
      examples: {
        'with only 1 choice': (choices: {'Day'}, selectedChoice: 'Day'),
        "with a selected choice that isn't one of them": (
          choices: {'Day', 'Week'},
          selectedChoice: 'Month',
        ),
      },
      outline: (tester, row) async {
        await pumpInPlatformScaffold(
          tester,
          PlatformSegmentButton<String>(
            choices: row.choices,
            segmentBuilder: Text.new,
            selectedChoice: row.selectedChoice,
            onSelectionChanged: (_) => noop(),
          ),
        );

        check(tester.takeException()).isA<AssertionError>();
      },
      // cupertino_ui asserts both on iOS too, so a run there would test it instead of the package.
      variant: androidOnly,
    );
  });
}
