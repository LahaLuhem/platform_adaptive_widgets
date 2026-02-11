import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Extensions on [BuildContext] for resolving platform-specific values.
///
/// Provides convenience methods to select between Material (Android) and
/// Cupertino (iOS) values based on [defaultTargetPlatform].
// Purely for name-spacing collisions
// ignore: prefer-match-file-name
extension PlatformAdaptiveContextExtensions on BuildContext {
  /// Returns the platform-appropriate [IconData].
  ///
  /// Selects [material] on Android and [cupertino] on iOS.
  IconData platformIcon({required IconData material, required IconData cupertino}) =>
      platformValue(material: material, cupertino: cupertino);

  /// Returns the platform-appropriate value of type [T].
  ///
  /// Selects [material] on Android and [cupertino] on iOS.
  /// Both values are required and eagerly evaluated.
  T platformValue<T>({required T material, required T cupertino}) =>
      _valueProvider(material: material, cupertino: cupertino);

  /// Returns the platform-appropriate nullable value of type [T].
  ///
  /// Selects [material] on Android and [cupertino] on iOS.
  /// Both values are optional and may be `null`.
  T? platformValueNullable<T>({T? material, T? cupertino}) =>
      _valueProviderNullable(material: material, cupertino: cupertino);

  /// Returns the platform-appropriate value of type [T], lazily evaluated.
  ///
  /// Only the getter for the current platform is invoked, avoiding
  /// unnecessary computation for the other platform.
  T platformLazyValue<T>({required ValueGetter<T> material, required ValueGetter<T> cupertino}) =>
      _valueProvider(material: material, cupertino: cupertino).call();

  /// Returns the platform-appropriate nullable value of type [T], lazily evaluated.
  ///
  /// Only the getter for the current platform is invoked. Returns `null` if
  /// the getter for the current platform is `null`.
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
