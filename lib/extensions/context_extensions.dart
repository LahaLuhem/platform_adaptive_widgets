import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension ContextExtensions on BuildContext {
  IconData platformIcon({required IconData material, required IconData cupertino}) =>
      platformValue(material: material, cupertino: cupertino);
  T platformValue<T>({required T material, required T cupertino}) =>
      switch (defaultTargetPlatform) {
        TargetPlatform.android => material,
        TargetPlatform.iOS => cupertino,
        _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
      };

  T? platformValueOrNull<T>({T? material, T? cupertino}) => switch (defaultTargetPlatform) {
    TargetPlatform.android => material,
    TargetPlatform.iOS => cupertino,
    _ => throw UnsupportedError('This platform is not supported: $defaultTargetPlatform'),
  };
}
