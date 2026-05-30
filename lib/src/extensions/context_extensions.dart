import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/platform_adaptive_icons.dart';

/// Extensions on [BuildContext] for resolving platform-specific values.
///
/// Provides convenience methods to select between Material (Android) and
/// Cupertino (iOS) values based on [defaultTargetPlatform].
///
/// {@template platform_adaptive_widgets.pruning_size_cost}
/// **Size-cost warning.** These helpers accept both Material and Cupertino
/// values (or value-getters) as parameters. The Dart AOT compiler folds the
/// inner `switch (defaultTargetPlatform)` to a single branch in release
/// builds, but the unused argument is still a value expression at the call
/// site — any lexical reference to platform-specific widgets / classes /
/// closures it carries stays reachable. For values that drag platform
/// widgets (e.g. constructing a `CupertinoXxx` widget for the `cupertino:`
/// arg), prefer an inline `switch (defaultTargetPlatform) { .android => …,
/// .iOS => …, _ => throw … }` at the call site instead — that lets the
/// unused arm become dead code and the AOT compiler can prune the
/// unused-platform widget bodies entirely. The helpers remain useful for
/// cheap values (colors, enums, primitives) that do not pull in
/// significant platform-specific code.
/// {@endtemplate}
// Purely for name-spacing collisions
// ignore: prefer-match-file-name
extension PlatformAdaptiveContextExtensions on BuildContext {
  /// Render either a Material or Cupertino icon based on the platform
  PlatformAdaptiveIcons get platformAdaptiveIcons => PlatformAdaptiveIcons(this);

  /// Returns the platform-appropriate [IconData].
  ///
  /// Selects [material] on Android and [cupertino] on iOS.
  IconData platformIcon({required IconData material, required IconData cupertino}) =>
      platformValue(material: material, cupertino: cupertino);

  /// Returns the platform-appropriate value of type [T].
  ///
  /// Selects [material] on Android and [cupertino] on iOS.
  /// Both values are required and eagerly evaluated.
  ///
  /// {@macro platform_adaptive_widgets.pruning_size_cost}
  T platformValue<T>({required T material, required T cupertino}) =>
      _valueProvider(material: material, cupertino: cupertino);

  /// Returns the platform-appropriate nullable value of type [T].
  ///
  /// Selects [material] on Android and [cupertino] on iOS.
  /// Both values are optional and may be `null`.
  ///
  /// {@macro platform_adaptive_widgets.pruning_size_cost}
  T? platformValueNullable<T>({T? material, T? cupertino}) =>
      _valueProviderNullable(material: material, cupertino: cupertino);

  /// Returns the platform-appropriate value of type [T], lazily evaluated.
  ///
  /// Only the getter for the current platform is invoked, avoiding
  /// unnecessary computation for the other platform.
  ///
  /// {@macro platform_adaptive_widgets.pruning_size_cost}
  T platformLazyValue<T>({required ValueGetter<T> material, required ValueGetter<T> cupertino}) =>
      _valueProvider(material: material, cupertino: cupertino).call();

  /// Returns the platform-appropriate nullable value of type [T], lazily evaluated.
  ///
  /// Only the getter for the current platform is invoked. Returns `null` if
  /// the getter for the current platform is `null`.
  ///
  /// {@macro platform_adaptive_widgets.pruning_size_cost}
  T? platformLazyNullable<T>({ValueGetter<T>? material, ValueGetter<T>? cupertino}) =>
      _valueProviderNullable(material: material, cupertino: cupertino)?.call();

  T _valueProvider<T>({required T material, required T cupertino}) =>
      switch (defaultTargetPlatform) {
        .android => material,
        .iOS => cupertino,
        _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
      };

  T? _valueProviderNullable<T>({T? material, T? cupertino}) => switch (defaultTargetPlatform) {
    .android => material,
    .iOS => cupertino,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}
