import 'package:bdd_framework/bdd_framework.dart';
import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '../../support/on_platform.dart';

typedef _Pick = String? Function({required String material, required String cupertino});

typedef _LazyPick = void Function({
  required ValueGetter<Object> material,
  required ValueGetter<Object> cupertino,
});

// Keyed by the name each example row prints.
final _picks = <String, _Pick>{
  'platformValue': platformValue,
  'platformValueNullable': platformValueNullable,
};
final _lazyPicks = <String, _LazyPick>{
  'platformLazyValue': platformLazyValue,
  'platformLazyNullable': platformLazyNullable,
};

void main() {
  final platformValueFeature = BddFeature('Platform values');

  const helperKey = 'helper';
  const platformKey = 'platform';
  const pickedKey = 'picked';

  Bdd(platformValueFeature)
      .scenario('picks the value for the look the platform draws')
      .given('the app runs on <$platformKey>')
      .when('<$helperKey> picks from a Material and a Cupertino value')
      .then('it is the <$pickedKey> one')
      .example(
        val(helperKey, 'platformValue'),
        val(platformKey, TargetPlatform.android),
        val(pickedKey, 'material'),
      )
      .example(
        val(helperKey, 'platformValue'),
        val(platformKey, TargetPlatform.iOS),
        val(pickedKey, 'cupertino'),
      )
      .example(
        val(helperKey, 'platformValueNullable'),
        val(platformKey, TargetPlatform.android),
        val(pickedKey, 'material'),
      )
      .example(
        val(helperKey, 'platformValueNullable'),
        val(platformKey, TargetPlatform.iOS),
        val(pickedKey, 'cupertino'),
      )
      .run(
        (context) => onPlatform(
          context.example.val(platformKey) as TargetPlatform,
          () => check(
            _picks[context.example.val(helperKey)]!(material: 'material', cupertino: 'cupertino'),
          ).equals(context.example.val(pickedKey) as String),
        ),
      );

  Bdd(platformValueFeature)
      .scenario('calls only the getter for the look the platform draws')
      .given('the app runs on <$platformKey>')
      .when('<$helperKey> picks from a Material and a Cupertino getter')
      .then('only the <$pickedKey> getter runs')
      .example(
        val(helperKey, 'platformLazyValue'),
        val(platformKey, TargetPlatform.android),
        val(pickedKey, 'material'),
      )
      .example(
        val(helperKey, 'platformLazyValue'),
        val(platformKey, TargetPlatform.iOS),
        val(pickedKey, 'cupertino'),
      )
      .example(
        val(helperKey, 'platformLazyNullable'),
        val(platformKey, TargetPlatform.android),
        val(pickedKey, 'material'),
      )
      .example(
        val(helperKey, 'platformLazyNullable'),
        val(platformKey, TargetPlatform.iOS),
        val(pickedKey, 'cupertino'),
      )
      .run(
        (context) => onPlatform(context.example.val(platformKey) as TargetPlatform, () {
          final ran = <String>[];
          _lazyPicks[context.example.val(helperKey)]!(
            material: () => ran..add('material'),
            cupertino: () => ran..add('cupertino'),
          );
          check(ran).deepEquals([context.example.val(pickedKey)]);
        }),
      );
}
