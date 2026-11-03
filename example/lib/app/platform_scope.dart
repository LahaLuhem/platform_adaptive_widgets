import 'package:flutter/widgets.dart';

/// Carries the platform override down the tree: a [TargetPlatform] to pretend to be, or `null` to go
/// with the real device.
///
/// The root widget owns the notifier, mirrors it into `debugDefaultTargetPlatformOverride` and rebuilds
/// on every tick. The About tab writes to it, which is how you preview the other platform without its
/// hardware.
class const PlatformScope({required super.notifier, required super.child, super.key})
    extends InheritedNotifier<ValueNotifier<TargetPlatform?>> {
  /// Asserts a [PlatformScope] is above you.
  static ValueNotifier<TargetPlatform?> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PlatformScope>();
    assert(scope?.notifier != null, 'No PlatformScope found in the widget tree.');

    return scope!.notifier!;
  }
}
