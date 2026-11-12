// Named after the library it tests, reached through a list.
// ignore_for_file: prefer-match-file-name

import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

enum _Fruit() {
  apple,
  pear,
}

void main() {
  final feature = BddFeature('Select list section');

  Bdd(feature).scenario('makes the header a heading for screen readers').runWidgets((tester) async {
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

    // Its own node, so the rows aren't read as part of it.
    check(header.label).equals('Fruit');
    check(header.headingLevel).isGreaterThan(0);
  });
}
