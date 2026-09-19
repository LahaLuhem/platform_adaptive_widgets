/// @docImport '/app/router/app_router.dart';
library;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '/app/router/app_route.dart';

/// The `errorBuilder` target for [AppRouter]. Not a route, so it has no [AppRoute] case: unmatched locations
/// land here instead of the framework's red error page.
class ErrorView extends StatelessWidget {
  /// What go_router tripped on, when it says.
  final GoException? error;

  const ErrorView({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    final routingError = error;

    return PlatformScaffold(
      appBarData: const PlatformAppBar(title: Text('Not found')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              spacing: 16,
              children: [
                Icon(
                  context.platformIcon(
                    material: Icons.error_outline,
                    cupertino: CupertinoIcons.exclamationmark_triangle,
                  ),
                  size: 56,
                  color: PlatformTheme.of(context).primaryColor,
                ),
                const Text(
                  "That route doesn't exist",
                  textAlign: .center,
                  style: TextStyle(fontSize: 20, fontWeight: .bold),
                ),
                if (routingError != null) Text(routingError.message, textAlign: .center),
                PlatformButton(
                  onPressed: () => context.goNamed(AppRoute.catalog.name),
                  child: const Text('Back to Catalog'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
