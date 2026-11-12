import 'dart:async';

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _choices = {
  PlatformChoice(value: 1, label: 'Save Draft', actionKind: .normal),
  PlatformChoice(value: 2, label: 'Delete Draft', actionKind: .delete),
};

void main() {
  final feature = BddFeature('Cupertino choices sheet');

  // The HIG keeps the bold look off destructive choices too.
  Bdd(feature).scenario('bolds only Cancel').runWidgets((tester) async {
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
}
