import 'package:checks/checks.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/src/widgets/interaction/cupertino_checkmark_row.dart';

import '../../support/support.dart';

const _picked = 'Pear';
const _other = 'Plum';

// A picked row over an unpicked one, for contrast.
Future<void> _pumpRows(WidgetTester tester, {VoidCallback onOtherTap = noop}) =>
    pumpInPlatformScaffold(
      tester,
      Column(
        children: [
          const CupertinoCheckmarkRow(label: _picked, isPicked: true, onTap: noop),
          CupertinoCheckmarkRow(label: _other, isPicked: false, onTap: onOtherTap),
        ],
      ),
    );

Finder _row(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(CupertinoCheckmarkRow));

int _checkmarksIn(String label) => find
    .descendant(of: _row(label), matching: find.byIcon(CupertinoIcons.check_mark))
    .evaluate()
    .length;

void main() {
  feature('CupertinoCheckmarkRow', () {
    scenarioWidgets('checks only the picked row', (tester) async {
      await _pumpRows(tester);

      check(_checkmarksIn(_picked)).equals(1);
      check(_checkmarksIn(_other)).equals(0);
    }, variant: iosOnly);

    scenarioWidgets('tells a screen reader which row is picked', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pumpRows(tester);

      final picked = tester.getSemantics(find.text(_picked)).getSemanticsData();
      final other = tester.getSemantics(find.text(_other)).getSemanticsData();
      semantics.dispose();

      check(readsAsPicked(picked)).isTrue();
      check(readsAsPicked(other)).isFalse();
    }, variant: iosOnly);

    scenarioWidgets("takes a tap at the row's far end, away from its label", (tester) async {
      var taps = 0;
      await _pumpRows(tester, onOtherTap: () => taps++);

      await tester.tapAt(tester.getRect(_row(_other)).centerRight - const Offset(8, 0));
      await tester.pump();

      check(taps).equals(1);
    }, variant: iosOnly);
  });
}
