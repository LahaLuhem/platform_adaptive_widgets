import 'dart:async';

import 'package:checks/checks.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _choices = {
  PlatformChoice(value: 1, label: 'Save Draft', actionKind: .normal),
  PlatformChoice(value: 2, label: 'Delete Draft', actionKind: .delete),
};

void main() {
  feature('Cupertino choices sheet', () {
    // The HIG keeps the bold look off destructive choices too.
    scenarioWidgets('bolds only Cancel', (tester) async {
      unawaited(showPlatformChoices(context: await pumpForContext(tester), choices: _choices));
      await pumpTransition(tester);

      final cancelWeight = weightOf(labelStyle(tester, 'Cancel'));
      for (final choice in _choices) {
        check(
          because: choice.label,
          weightOf(labelStyle(tester, choice.label)),
        ).isLessThan(cancelWeight);
      }
    }, variant: iosOnly);
  });
}
