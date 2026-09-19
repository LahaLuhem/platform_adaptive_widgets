import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../support/support.dart';

typedef _Show = Future<void> Function(
  BuildContext context, {
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
});

// All 5 share one guard, so they share one examples table. A new showPlatformXxx belongs here.
final _entryPoints = <String, _Show>{
  'showPlatformDialog': (context, {builder, materialBuilder, cupertinoBuilder}) =>
      showPlatformDialog<void>(
        context: context,
        builder: builder,
        materialBuilder: materialBuilder,
        cupertinoBuilder: cupertinoBuilder,
      ),
  'showPlatformFullscreenDialog': (context, {builder, materialBuilder, cupertinoBuilder}) =>
      showPlatformFullscreenDialog<void>(
        context: context,
        builder: builder,
        materialBuilder: materialBuilder,
        cupertinoBuilder: cupertinoBuilder,
      ),
  'showPlatformRawDialog': (context, {builder, materialBuilder, cupertinoBuilder}) =>
      showPlatformRawDialog<void>(
        context: context,
        builder: builder,
        materialBuilder: materialBuilder,
        cupertinoBuilder: cupertinoBuilder,
      ),
  'showPlatformModalBottomSheet': (context, {builder, materialBuilder, cupertinoBuilder}) =>
      showPlatformModalBottomSheet<void>(
        context: context,
        builder: builder,
        materialBuilder: materialBuilder,
        cupertinoBuilder: cupertinoBuilder,
      ),
  'showPlatformRawModalBottomSheet': (context, {builder, materialBuilder, cupertinoBuilder}) =>
      showPlatformRawModalBottomSheet<void>(
        context: context,
        builder: builder,
        materialBuilder: materialBuilder,
        cupertinoBuilder: cupertinoBuilder,
      ),
};

void main() {
  feature('showPlatformXxx builder invariant', () {
    scenarioOutlineWidgets<_Show>(
      'refuses no builder at all',
      examples: _entryPoints,
      outline: (tester, show) async {
        final context = await pumpForContext(tester);

        check(() => show(context)).throws<AssertionError>();
      },
    );

    scenarioOutlineWidgets<_Show>(
      'refuses a shared builder next to a platform one',
      examples: _entryPoints,
      outline: (tester, show) async {
        final context = await pumpForContext(tester);

        check(
          () => show(
            context,
            builder: (_) => const SizedBox(),
            materialBuilder: (_) => const SizedBox(),
          ),
        ).throws<AssertionError>();
      },
    );
  });
}
