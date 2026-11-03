import 'package:bdd_framework/bdd_framework.dart';
import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

void main() {
  final platformValueFeature = BddFeature('Platform values');

  const platformKey = 'platform';
  const pickedKey = 'picked';

  Bdd(platformValueFeature)
      .scenario('picks the value for the look the platform draws')
      .given('the app runs on <$platformKey>')
      .when('a value is picked from a Material and a Cupertino one')
      .then('it is the <$pickedKey> one')
      .example(val(platformKey, TargetPlatform.android), val(pickedKey, 'material'))
      .example(val(platformKey, TargetPlatform.iOS), val(pickedKey, 'cupertino'))
      .run((context) {
        debugDefaultTargetPlatformOverride = context.example.val(platformKey) as TargetPlatform;
        try {
          check(platformValue(material: 'material', cupertino: 'cupertino'))
              .equals(context.example.val(pickedKey) as String);
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      });
}
