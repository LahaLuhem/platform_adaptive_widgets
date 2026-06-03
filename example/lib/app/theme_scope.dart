import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;

/// Exposes the app-wide [ThemeMode] notifier to descendants.
///
/// The root app widget owns a `ValueNotifier<ThemeMode>`, rebuilds the
/// `PlatformApp` when it ticks, and publishes it through this scope via the
/// app's `builder`. Any screen (e.g. the About tab) reads it with
/// [ThemeScope.of] and writes a new mode to flip the whole app's appearance —
/// works identically under both the Navigator and go_router entry points.
class ThemeScope extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  /// Creates a [ThemeScope] publishing [notifier] to [child]'s subtree.
  const ThemeScope({required super.notifier, required super.child, super.key});

  /// The nearest theme-mode notifier. Asserts a [ThemeScope] is in scope.
  static ValueNotifier<ThemeMode> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope?.notifier != null, 'No ThemeScope found in the widget tree.');

    return scope!.notifier!;
  }
}
