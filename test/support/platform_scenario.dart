import 'package:bdd_framework/flutter_widget_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'platform_harness.dart';

const _platformColumn = 'platform';
const _exampleColumn = 'example';

/// Runs a bdd_framework scenario as widget tests, an example row per platform, since its runner takes
/// no `variant:`. The scenario's text doubles as its Then.
extension PlatformScenario on BddScenario {
  /// Runs [body] on each platform in [variant].
  void runWidgets(WidgetTesterCallback body, {TargetPlatformVariant variant = bothPlatforms}) =>
      _platformRows(variant).run((context, tester) => _onRowPlatform(context, () => body(tester)));

  /// Runs [outline] once per entry of [examples] on each platform in [variant], so a failure names
  /// the row that broke.
  void runOutlineWidgets<T>({
    required Map<String, T> examples,
    required Future<void> Function(WidgetTester tester, T example) outline,
    TargetPlatformVariant variant = bothPlatforms,
  }) => _platformRows(variant, exampleNames: examples.keys).run(
    (context, tester) => _onRowPlatform(
      context,
      () => outline(tester, examples[context.example.val(_exampleColumn)] as T),
    ),
  );

  BddExample _platformRows(TargetPlatformVariant variant, {Iterable<String>? exampleNames}) {
    // As under a plain testWidgets. The runner only prints an overflow by default.
    BddFlutter.ignoreOverflow = false;
    final rows = [
      for (final platform in variant.values)
        if (exampleNames == null)
          (val(_platformColumn, platform), null)
        else
          for (final name in exampleNames)
            (val(_platformColumn, platform), val(_exampleColumn, name)),
    ];

    return rows
        .skip(1)
        .fold(
          given('the app runs on <$_platformColumn>')
              .then(text)
              .example(rows.first.$1, rows.first.$2),
          (examples, next) => examples.example(next.$1, next.$2),
        );
  }
}

/// The runner clears the override after each test.
Future<void> _onRowPlatform(BddContext context, Future<void> Function() body) {
  debugDefaultTargetPlatformOverride = context.example.val(_platformColumn) as TargetPlatform;

  return body();
}
