import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

const _label = 'Loading inbox';

void main() {
  feature('PlatformProgressIndicator', () {
    scenarioWidgets('tells screen readers what is loading', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpPlatformWidget(
        tester,
        const Center(child: PlatformProgressIndicator(semanticsLabel: _label)),
      );
      final isNamed = find.semantics.byLabel(_label).evaluate().isNotEmpty;
      semantics.dispose();

      check(isNamed).isTrue();
    });
  });
}
