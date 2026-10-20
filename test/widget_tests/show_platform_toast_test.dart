import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _page = SizedBox.expand(key: Key('page'));
const _message = 'Deleted';
const _duration = Duration(seconds: 2);

Future<BuildContext> _pumpPage(WidgetTester tester) async {
  await pumpInPlatformScaffold(tester, _page);

  return tester.element(find.byWidget(_page));
}

void _show(BuildContext context, {VoidCallback? onUndo}) => unawaited(
  showPlatformToast(
    context: context,
    message: _message,
    duration: _duration,
    action: onUndo == null ? null : PlatformToastAction(label: 'Undo', onPressed: onUndo),
  ),
);

bool _isShowing(WidgetTester tester) => tester.any(find.text(_message));

void main() {
  feature('showPlatformToast', () {
    scenarioWidgets('runs its action and closes when the action is tapped', (tester) async {
      var isUndone = false;
      final context = await _pumpPage(tester);

      _show(context, onUndo: () => isUndone = true);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      check(isUndone).isTrue();
      check(_isShowing(tester)).isFalse();
    });

    scenarioWidgets('runs its action once, however fast it is tapped', (tester) async {
      var undoCount = 0;
      final context = await _pumpPage(tester);

      _show(context, onUndo: () => undoCount++);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Undo'));
      await tester.pump();
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      check(undoCount).equals(1);
    });

    scenarioWidgets('stays up past its duration while it has an action', (tester) async {
      final context = await _pumpPage(tester);

      // ignore: no-empty-block, only having an action matters here, not what it does.
      _show(context, onUndo: () {});
      await tester.pumpAndSettle();
      await tester.pump(_duration * 3);
      await tester.pumpAndSettle();

      check(_isShowing(tester)).isTrue();
    });

    scenarioWidgets('leaves after its duration without an action', (tester) async {
      final context = await _pumpPage(tester);

      _show(context);
      await tester.pumpAndSettle();
      check(_isShowing(tester)).isTrue();
      await tester.pump(_duration * 3);
      await tester.pumpAndSettle();

      check(_isShowing(tester)).isFalse();
    });

    scenarioWidgets('is read out by screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      final context = await _pumpPage(tester);

      _show(context);
      await tester.pumpAndSettle();
      // The read-out happens in the engine, so the flag that triggers it is all a test can see.
      SemanticsNode? node = tester.getSemantics(find.text(_message));
      while (node != null && !node.getSemanticsData().flagsCollection.isLiveRegion) {
        node = node.parent;
      }
      final isReadOut = node != null;
      semantics.dispose();

      check(isReadOut).isTrue();
    });
  });
}
