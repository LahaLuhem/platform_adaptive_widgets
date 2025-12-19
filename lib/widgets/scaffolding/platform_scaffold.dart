import 'package:flutter/widgets.dart';

import '/models/platform_widget_base.dart';

class PlatformScaffold extends PlatformWidgetBase {
  const PlatformScaffold({super.key});

  @override
  Widget buildMaterial(BuildContext context) => const Placeholder();

  @override
  Widget buildCupertino(BuildContext context) => const Placeholder();
}
