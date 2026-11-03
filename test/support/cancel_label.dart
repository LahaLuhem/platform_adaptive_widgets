import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialLocalizations;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart' show designLanguage;

/// Cancel in the app's language, as the drawn look labels it.
String cancelLabel(BuildContext context) => switch (designLanguage) {
  .material => MaterialLocalizations.of(context).cancelButtonLabel,
  .cupertino => CupertinoLocalizations.of(context).cancelButtonLabel,
};
