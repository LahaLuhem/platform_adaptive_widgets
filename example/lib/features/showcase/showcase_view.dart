import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart' show FloatingActionButton, Icons;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:platform_icons/platform_icons.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/core/widgets/labeled_section.dart';
import 'activity_level.dart';
import 'showcase_view_model.dart';

/// The Showcase tab — one cohesive profile/settings screen composed entirely
/// from the library's widgets, the same code rendering Material on Android and
/// Cupertino on iOS.
///
/// The Save action is the showcase's headline: a primary action is a *FAB* on
/// Material (a Material-only scaffold slot) and a *nav-bar trailing* button on
/// iOS (Cupertino has no FAB). Both route through the same view-model method —
/// the per-platform split lives only in which `*Data` slot each is handed to,
/// exactly the platform-only-capability pattern the package is built around.
class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) => MVVM.builder(
    viewModel: ShowcaseViewModel(),
    viewBuilder: (context, viewModel) => PlatformScaffold(
      appBarData: PlatformAppBar(
        title: const Text('Profile'),
        // iOS has no FAB — its primary action sits in the nav-bar trailing
        // slot. Material's equivalent is the FAB on materialScaffoldData below.
        cupertinoNavigationBarData: CupertinoNavigationBarData(
          trailing: PlatformButton(
            onPressed: () => viewModel.onSavePressed(),
            child: const Text('Save'),
          ),
        ),
      ),
      materialScaffoldData: MaterialScaffoldData(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'showcase',
          onPressed: () => viewModel.onSavePressed(),
          icon: const Icon(Icons.check),
          label: const Text('Save'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const .all(16),
          children: [
            _ProfileHeader(nameController: viewModel.displayNameController),
            const Gap(24),
            LabeledSection(
              title: 'Profile',
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 16,
                children: [
                  PlatformTextField(
                    controller: viewModel.displayNameController,
                    hintText: 'Display name',
                  ),
                  PlatformTextField(controller: viewModel.bioController, hintText: 'Short bio'),
                ],
              ),
            ),
            const Gap(24),
            LabeledSection(
              title: 'Notifications',
              child: ValueListenableBuilder(
                valueListenable: viewModel.allowNotificationsListenable,
                builder: (_, allowNotifications, _) => Column(
                  children: [
                    PlatformListTile(
                      title: const Text('Allow notifications'),
                      subtitle: const Text('Master toggle for the two below'),
                      trailing: PlatformSwitch(
                        value: allowNotifications,
                        onChanged: (value) => viewModel.onAllowNotificationsToggled(value: value),
                      ),
                    ),
                    // Gated, not nulled: the library disables a switch via
                    // isEnabled — APPENDIX.md#callback-nullability.
                    PlatformListTile(
                      title: const Text('Sound'),
                      trailing: ValueListenableBuilder(
                        valueListenable: viewModel.soundListenable,
                        builder: (_, sound, _) => PlatformSwitch(
                          value: sound,
                          isEnabled: allowNotifications,
                          onChanged: (value) => viewModel.onSoundToggled(value: value),
                        ),
                      ),
                    ),
                    PlatformListTile(
                      title: const Text('Show previews'),
                      trailing: ValueListenableBuilder(
                        valueListenable: viewModel.showPreviewsListenable,
                        builder: (_, showPreviews, _) => PlatformSwitch(
                          value: showPreviews,
                          isEnabled: allowNotifications,
                          onChanged: (value) => viewModel.onShowPreviewsToggled(value: value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            LabeledSection(
              title: 'Activity level',
              child: ValueListenableBuilder(
                valueListenable: viewModel.activityLevelListenable,
                builder: (_, activityLevel, _) => PlatformSegmentButton(
                  choices: ActivityLevel.values,
                  selectedChoice: activityLevel,
                  segmentBuilder: (level) => Text(level.label),
                  onSelectionChanged: viewModel.onActivityLevelChanged,
                ),
              ),
            ),
            const Gap(24),
            LabeledSection(
              title: 'Daily goal',
              child: ValueListenableBuilder(
                valueListenable: viewModel.stepGoalListenable,
                builder: (_, stepGoal, _) => Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text('${(stepGoal * 15).round()}k steps'),
                    PlatformSlider(
                      value: stepGoal,
                      onChanged: (value) => viewModel.onStepGoalChanged(value: value),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            LabeledSection(
              title: 'Account',
              child: Column(
                children: [
                  PlatformListTile(
                    leading: Icon(
                      context.platformIcon(
                        material: Icons.lock_outline,
                        cupertino: CupertinoIcons.lock,
                      ),
                    ),
                    title: const Text('Privacy & security'),
                    trailing: const PlatformIcon(.forward),
                    onTap: viewModel.onPrivacyPressed,
                  ),
                  PlatformListTile(
                    leading: Icon(
                      context.platformIcon(
                        material: Icons.logout,
                        cupertino: CupertinoIcons.square_arrow_right,
                      ),
                    ),
                    title: const Text('Sign out'),
                    trailing: const PlatformIcon(.forward),
                    onTap: viewModel.onSignOutPressed,
                  ),
                ],
              ),
            ),
            // Clears the Material FAB so the last tile stays tappable; just
            // bottom breathing room on iOS, which has no FAB.
            const Gap(72),
          ],
        ),
      ),
    ),
  );
}

/// The profile header — a themed avatar, the display name (live-bound to the
/// edit field), and a static handle.
final class _ProfileHeader extends StatelessWidget {
  final TextEditingController nameController;

  const _ProfileHeader({required this.nameController});

  @override
  Widget build(BuildContext context) {
    final primaryColor = PlatformTheme.of(context).primaryColor;

    return Column(
      spacing: 8,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(shape: .circle, color: primaryColor.withValues(alpha: 0.15)),
          child: Icon(
            context.platformIcon(material: Icons.person, cupertino: CupertinoIcons.person_fill),
            size: 36,
            color: primaryColor,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: nameController,
          builder: (_, value, _) => Text(
            value.text.isEmpty ? 'Your name' : value.text,
            style: const TextStyle(fontSize: 20, fontWeight: .bold),
          ),
        ),
        const Text('alex.morgan@example.com'),
      ],
    );
  }
}
