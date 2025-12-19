import 'package:flutter/material.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const PlatformApp(
    appData: AppData(title: 'Flutter Demo', home: MyHomePage()),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}
