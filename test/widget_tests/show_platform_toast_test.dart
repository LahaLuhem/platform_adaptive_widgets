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

bool _inLiveRegion(SemanticsNode node) {
  for (SemanticsNode? current = node; current != null; current = current.parent) {
    if (current.getSemanticsData().flagsCollection.isLiveRegion) return true;
  }

  return false;
}

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

    scenarioWidgets('stays up past its duration while it has an action', (tester) async {
      final context = await _pumpPage(tester);

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
      final isReadOut = _inLiveRegion(tester.getSemantics(find.text(_message)));
      semantics.dispose();

      check(isReadOut).isTrue();
    });
  });
}
