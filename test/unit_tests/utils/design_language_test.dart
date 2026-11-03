import 'package:bdd_framework/bdd_framework.dart';
import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

void main() {
  final designLanguageFeature = BddFeature('Design language');

  const platformKey = 'platform';
  const lookKey = 'look';

  // Spelled out, not read off the package, so a wrong mapping can't pass.
  Bdd(designLanguageFeature)
      .scenario('Apple platforms get Cupertino, the rest Material')
      .given('the app runs on <$platformKey>')
      .when('a widget picks its look')
      .then('it draws <$lookKey>')
      .example(val(platformKey, TargetPlatform.iOS), val(lookKey, DesignLanguage.cupertino))
      .example(val(platformKey, TargetPlatform.macOS), val(lookKey, DesignLanguage.cupertino))
      .example(val(platformKey, TargetPlatform.android), val(lookKey, DesignLanguage.material))
      .example(val(platformKey, TargetPlatform.fuchsia), val(lookKey, DesignLanguage.material))
      .example(val(platformKey, TargetPlatform.linux), val(lookKey, DesignLanguage.material))
      .example(val(platformKey, TargetPlatform.windows), val(lookKey, DesignLanguage.material))
      .run((context) {
        debugDefaultTargetPlatformOverride = context.example.val(platformKey) as TargetPlatform;
        try {
          check(designLanguage).equals(context.example.val(lookKey) as DesignLanguage);
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      });
}
