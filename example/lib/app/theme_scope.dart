import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;

/// Carries the app's [ThemeMode] down the tree.
///
/// The root widget owns the notifier and rebuilds on every tick. The About tab writes to it to flip
/// the whole app light or dark, and it behaves the same under either entry point.
class ThemeScope extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  const ThemeScope({required super.notifier, required super.child, super.key});

  /// Asserts a [ThemeScope] is above you.
  static ValueNotifier<ThemeMode> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope?.notifier != null, 'No ThemeScope found in the widget tree.');

    return scope!.notifier!;
  }
}
