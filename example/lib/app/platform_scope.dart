import 'package:flutter/widgets.dart';

/// Exposes the app-wide platform-override notifier to descendants.
///
/// The value is the [TargetPlatform] to force, or `null` to follow the real
/// device (no override). The root app widget owns the `ValueNotifier`, mirrors
/// it into `debugDefaultTargetPlatformOverride` and rebuilds `PlatformApp` when
/// it ticks, and publishes it through this scope via the app's `builder`. The
/// About tab reads it with [PlatformScope.of] and writes a new value to flip
/// which platform the whole app renders as — handy for previewing the other
/// platform without its hardware.
class PlatformScope extends InheritedNotifier<ValueNotifier<TargetPlatform?>> {
  /// Creates a [PlatformScope] publishing [notifier] to [child]'s subtree.
  const PlatformScope({required super.notifier, required super.child, super.key});

  /// The nearest platform-override notifier (`null` = follow the device).
  /// Asserts a [PlatformScope] is in scope.
  static ValueNotifier<TargetPlatform?> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PlatformScope>();
    assert(scope?.notifier != null, 'No PlatformScope found in the widget tree.');

    return scope!.notifier!;
  }
}
