import 'package:flutter/widgets.dart';

import '/models/platform_widget_base.dart';

class PlatformWidget extends PlatformWidgetBase {
  @protected
  final WidgetBuilder materialBuilder;
  @protected
  final WidgetBuilder cupertinoBuilder;

  const PlatformWidget({required this.materialBuilder, required this.cupertinoBuilder, super.key});

  @override
  Widget buildMaterial(BuildContext context) => materialBuilder(context);

  @override
  Widget buildCupertino(BuildContext context) => cupertinoBuilder(context);
}

class PlatformWidgetBuilder extends PlatformWidgetBase {
  @protected
  final Widget Function(BuildContext context, Widget child) materialWidgetBuilder;
  @protected
  final Widget Function(BuildContext context, Widget child) cupertinoWidgetBuilder;

  final Widget child;

  const PlatformWidgetBuilder({
    required this.materialWidgetBuilder,
    required this.cupertinoWidgetBuilder,
    required this.child,
    super.key,
  });
  @override
  Widget buildMaterial(BuildContext context) => materialWidgetBuilder(context, child);
  @override
  Widget buildCupertino(BuildContext context) => cupertinoWidgetBuilder(context, child);
}
