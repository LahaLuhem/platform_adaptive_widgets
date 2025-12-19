/// @docImport 'platform_app_bar.dart';
library;

import 'package:flutter/cupertino.dart' show CupertinoPageScaffold;
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';

import '/models/platform_widget_base.dart';
import '/models/scaffolding/platform_app_bar_data.dart';

class PlatformScaffold extends PlatformWidgetBase {
  final PlatformAppBarData? appBarData;
  final Widget body;

  /// [appBarData] has a premade implementation of [PlatformAppBar]
  const PlatformScaffold({required this.body, this.appBarData, super.key});

  @override
  Widget buildMaterial(BuildContext context) =>
      Scaffold(appBar: appBarData?.materialBuilder(context), body: body);

  @override
  Widget buildCupertino(BuildContext context) =>
      CupertinoPageScaffold(navigationBar: appBarData?.cupertinoBuilder(context), child: body);
}
