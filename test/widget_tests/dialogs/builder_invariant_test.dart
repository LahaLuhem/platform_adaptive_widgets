import 'package:bdd_framework/flutter_widget_test.dart' show Bdd, BddFeature;
import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/support.dart';

typedef _Show = Future<void> Function(
  BuildContext context, {
  WidgetBuilder? builder,
  WidgetBuilder? materialBuilder,
  WidgetBuilder? cupertinoBuilder,
});

// Every showPlatformXxx taking the builder trio shares one guard, so they share one examples table.
final _entryPoints = <String, _Show>{
  'showPlatformRawDialog': (context, {builder, materialBuilder, cupertinoBuilder}) =>
      showPlatformRawDialog<void>(
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
  final feature = BddFeature('showPlatformXxx builder invariant');

  Bdd(feature)
      .scenario('refuses no builder at all')
      .runOutlineWidgets<_Show>(
        examples: _entryPoints,
        outline: (tester, show) async {
          final context = await pumpForContext(tester);

          check(() => show(context)).throws<AssertionError>();
        },
      );

  Bdd(feature)
      .scenario('refuses one platform builder alone')
      .runOutlineWidgets<_Show>(
        examples: _entryPoints,
        outline: (tester, show) async {
          final context = await pumpForContext(tester);

          check(
            because: 'Material',
            () => show(context, materialBuilder: (_) => const SizedBox()),
          ).throws<AssertionError>();
          check(
            because: 'Cupertino',
            () => show(context, cupertinoBuilder: (_) => const SizedBox()),
          ).throws<AssertionError>();
        },
      );

  Bdd(feature)
      .scenario('refuses a shared builder next to a platform one')
      .runOutlineWidgets<_Show>(
        examples: _entryPoints,
        outline: (tester, show) async {
          final context = await pumpForContext(tester);

          check(
            because: 'Material',
            () => show(
              context,
              builder: (_) => const SizedBox(),
              materialBuilder: (_) => const SizedBox(),
            ),
          ).throws<AssertionError>();
          check(
            because: 'Cupertino',
            () => show(
              context,
              builder: (_) => const SizedBox(),
              cupertinoBuilder: (_) => const SizedBox(),
            ),
          ).throws<AssertionError>();
        },
      );

  // The refusals above all pass on an assert that refuses every call.
  Bdd(feature)
      .scenario('takes a shared builder alone, or both platform builders')
      .runOutlineWidgets<_Show>(
        examples: _entryPoints,
        outline: (tester, show) async {
          final context = await pumpForContext(tester);

          check(
            because: 'shared builder',
            () => show(context, builder: (_) => const SizedBox()),
          ).returnsNormally();
          check(
            because: 'both platform builders',
            () => show(
              context,
              materialBuilder: (_) => const SizedBox(),
              cupertinoBuilder: (_) => const SizedBox(),
            ),
          ).returnsNormally();
        },
      );
}
