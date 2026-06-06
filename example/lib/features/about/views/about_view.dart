import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart' show Icons, ThemeMode;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';

import '/app/platform_scope.dart';
import '/app/theme_scope.dart';
import '/features/about/widgets/labeled_section.dart';
import '/features/core/data/models/app_args.dart';

/// The About tab — what the library is, the appearance control (dogfooding
/// [PlatformSegmentButton] for the theme mode), and a readout of how this build
/// is wired (navigation mode + which platform surface is rendering).
///
/// View-only: its only observable state is the app-wide theme mode, which lives
/// in [ThemeScope], not on a view model.
class AboutView extends StatelessWidget {
  /// Host args — used to report the active navigation mode.
  final AppArgs args;

  const AboutView({required this.args, super.key});

  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = ThemeScope.of(context);
    final platformNotifier = PlatformScope.of(context);
    final primaryColor = PlatformTheme.of(context).primaryColor;

    return PlatformScaffold(
      appBarData: const PlatformAppBar(title: Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const .all(16),
          children: [
            Column(
              spacing: 8,
              children: [
                Icon(
                  context.platformIcon(
                    material: Icons.layers,
                    cupertino: CupertinoIcons.square_stack_3d_up_fill,
                  ),
                  size: 56,
                  color: primaryColor,
                ),
                const Text(
                  'platform_adaptive_widgets',
                  textAlign: .center,
                  style: TextStyle(fontSize: 20, fontWeight: .bold),
                ),
                const Text(
                  'One widget tree. Material on Android, Cupertino on iOS — no app-code branching.',
                  textAlign: .center,
                ),
              ],
            ),
            const Gap(32),
            LabeledSection(
              title: 'Appearance',
              child: ValueListenableBuilder(
                valueListenable: themeModeNotifier,
                builder: (_, themeMode, _) => PlatformSegmentButton(
                  choices: ThemeMode.values,
                  selectedChoice: themeMode,
                  segmentBuilder: (mode) => Text(_themeModeLabel(mode)),
                  onSelectionChanged: (mode) => themeModeNotifier.value = mode!,
                ),
              ),
            ),
            const Gap(24),
            LabeledSection(
              title: 'Platform',
              child: Column(
                crossAxisAlignment: .start,
                spacing: 8,
                children: [
                  ValueListenableBuilder(
                    valueListenable: platformNotifier,
                    builder: (_, platformOverride, _) => PlatformSegmentButton(
                      choices: const [TargetPlatform.android, TargetPlatform.iOS],
                      // null = follow the device; show the effective platform.
                      selectedChoice: platformOverride ?? defaultTargetPlatform,
                      segmentBuilder: (platform) => Text(platform.name),
                      onSelectionChanged: (platform) => platformNotifier.value = platform,
                    ),
                  ),
                  const Text('Preview the other platform without its device. Debug builds only.'),
                ],
              ),
            ),
            const Gap(24),
            LabeledSection(
              title: 'This build',
              child: Column(
                children: [
                  PlatformListTile(
                    leading: Icon(
                      context.platformIcon(
                        material: Icons.alt_route,
                        cupertino: CupertinoIcons.arrow_branch,
                      ),
                    ),
                    title: const Text('Navigation'),
                    subtitle: Text(
                      args.isUsingGoRouter
                          ? 'go_router · StatefulShellRoute'
                          : 'Navigator · scaffold-managed tabs',
                    ),
                  ),
                  PlatformListTile(
                    leading: Icon(
                      context.platformIcon(
                        material: Icons.phone_android,
                        cupertino: CupertinoIcons.device_phone_portrait,
                      ),
                    ),
                    title: const Text('Rendering'),
                    subtitle: Text(_platformLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) => switch (mode) {
    .system => 'System',
    .light => 'Light',
    .dark => 'Dark',
  };

  String get _platformLabel => switch (defaultTargetPlatform) {
    .iOS => 'Cupertino widgets (iOS)',
    .android => 'Material widgets (Android)',
    _ => 'Unsupported platform',
  };
}
