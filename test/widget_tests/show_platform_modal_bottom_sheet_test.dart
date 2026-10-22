import 'dart:async';

import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

const _content = 'Sheet';
const _tint = Color(0xFF123456);

typedef _Show = Future<void> Function(
  BuildContext context, {
  required Color? barrierColor,
  required bool barrierDismissible,
});

final _entryPoints = <String, _Show>{
  'showPlatformModalBottomSheet': (context, {required barrierColor, required barrierDismissible}) =>
      showPlatformModalBottomSheet<void>(
        context: context,
        builder: (_) => const Text(_content),
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
      ),
  'showPlatformRawModalBottomSheet':
      (context, {required barrierColor, required barrierDismissible}) =>
          showPlatformRawModalBottomSheet<void>(
            context: context,
            builder: (_) => const Text(_content),
            barrierColor: barrierColor,
            barrierDismissible: barrierDismissible,
          ),
};

void main() {
  feature('showPlatformModalBottomSheet', () {
    scenarioOutlineWidgets<({_Show show, bool barrierDismissible})>(
      'closes on a tap outside only when barrierDismissible allows it',
      examples: {
        for (final MapEntry(key: name, value: show) in _entryPoints.entries) ...{
          '$name, dismissible': (show: show, barrierDismissible: true),
          '$name, not dismissible': (show: show, barrierDismissible: false),
        },
      },
      outline: (tester, row) async {
        final context = await pumpForContext(tester);
        unawaited(
          row.show(context, barrierColor: null, barrierDismissible: row.barrierDismissible),
        );
        await tester.pumpAndSettle();
        check(tester.any(find.text(_content))).isTrue();

        await tester.tapAt(const Offset(4, 4));
        await tester.pumpAndSettle();

        check(tester.any(find.text(_content))).equals(!row.barrierDismissible);
      },
    );

    scenarioOutlineWidgets<_Show>(
      'tints the barrier with barrierColor',
      examples: _entryPoints,
      outline: (tester, show) async {
        final context = await pumpForContext(tester);
        unawaited(show(context, barrierColor: _tint, barrierDismissible: true));
        await tester.pumpAndSettle();

        check(tester.widget<ModalBarrier>(find.byType(ModalBarrier).last).color).equals(_tint);
      },
    );
  });
}
