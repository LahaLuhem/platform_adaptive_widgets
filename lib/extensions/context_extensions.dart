import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Purely for name-spacing collisions
// ignore: prefer-match-file-name
extension PlatformAdaptiveContextExtensions on BuildContext {
  IconData platformIcon({required IconData material, required IconData cupertino}) =>
      platformValue(material: material, cupertino: cupertino);

  T platformValue<T>({required T material, required T cupertino}) =>
      _valueProvider(material: material, cupertino: cupertino);

  T? platformValueNullable<T>({T? material, T? cupertino}) =>
      _valueProviderNullable(material: material, cupertino: cupertino);

  T platformLazyValue<T>({required ValueGetter<T> material, required ValueGetter<T> cupertino}) =>
      _valueProvider(material: material, cupertino: cupertino).call();

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
