import 'package:flutter/material.dart' show ThemeData;

abstract final class ConstTheme {
  static final materialLightThemeData = ThemeData.light(useMaterial3: true);
  static final materialDarkThemeData = ThemeData.dark(useMaterial3: true);
}
