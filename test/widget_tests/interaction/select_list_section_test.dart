// Named after the library it tests, which it reaches through a list that uses it.
// ignore_for_file: prefer-match-file-name

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

enum _Fruit() {
  apple,
  pear,
}

void main() {
  feature('Select list section', () {
    scenarioWidgets('makes the header a heading for screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpInPlatformScaffold(
        tester,
        PlatformSingleSelectList<_Fruit>(
          options: _Fruit.values.toSet(),
          selected: .apple,
          label: (fruit) => fruit.name,
          onChanged: (_) => noop(),
          header: 'Fruit',
        ),
      );

      final header = tester.getSemantics(find.text('Fruit')).getSemanticsData();
      semantics.dispose();

      // Its own node, so the rows aren't read out as part of the heading.
      check(header.label).equals('Fruit');
      check(header.headingLevel).isGreaterThan(0);
    });
  });
}
