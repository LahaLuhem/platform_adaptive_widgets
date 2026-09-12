/// A small Gherkin vocabulary over `flutter_test`, so a widget test reads as a spec rather than a
/// pile of pumps. Adapted from the same helper in `list_smith`.
///
/// `bdd_framework` can't drive these: it wraps `test`, so there is no `WidgetTester`.
library;

import 'package:flutter_test/flutter_test.dart';

import 'platform_harness.dart';

/// Groups the scenarios describing one widget. Reads as `Feature: <description>` in the output.
void feature(String description, void Function() body) => group('Feature: $description', body);

/// One behaviour, as a single `testWidgets` case with a Given/When/Then body. Runs on both
/// platforms unless [variant] says otherwise.
void scenarioWidgets(
  String description,
  WidgetTesterCallback body, {
  TestVariant<Object?> variant = bothPlatforms,
}) => testWidgets('Scenario: $description', body, variant: variant);

/// A scenario run once per row of an examples table, so the inputs stay grouped in one place
/// instead of scattered through the body. A failure names the row that broke.
void scenarioOutlineWidgets<Row>(
  String description, {
  required Map<String, Row> examples,
  required Future<void> Function(WidgetTester tester, Row example) outline,
  TestVariant<Object?> variant = bothPlatforms,
}) => group('Scenario Outline: $description', () {
  for (final MapEntry(key: name, value: row) in examples.entries) {
    testWidgets(name, (tester) => outline(tester, row), variant: variant);
  }
});
