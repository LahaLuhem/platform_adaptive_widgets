import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import 'activity_level.dart';

/// State for the Showcase profile screen: the editable display-name and bio
/// fields, the notification master/sub toggles (the two subs are gated on the
/// master), the activity-level segment, the daily step-goal slider, and the
/// Save action that every primary affordance routes through.
final class ShowcaseViewModel extends ViewModel {
  /// Seeds the header name and the Profile section's first field; the header
  /// binds to this controller directly so it reflects edits live.
  final displayNameController = TextEditingController(text: 'Alex Morgan');
  final bioController = TextEditingController(text: 'Building adaptive Flutter apps.');

  final _allowNotificationsNotifier = ValueNotifier(true);
  final _soundNotifier = ValueNotifier(true);
  final _showPreviewsNotifier = ValueNotifier(false);
  final _activityLevelNotifier = ValueNotifier(ActivityLevel.regular);
  final _stepGoalNotifier = ValueNotifier(0.5);

  /// Master toggle — gates [soundListenable] and [showPreviewsListenable].
  ValueListenable<bool> get allowNotificationsListenable => _allowNotificationsNotifier;

  ValueListenable<bool> get soundListenable => _soundNotifier;

  ValueListenable<bool> get showPreviewsListenable => _showPreviewsNotifier;

  ValueListenable<ActivityLevel> get activityLevelListenable => _activityLevelNotifier;

  ValueListenable<double> get stepGoalListenable => _stepGoalNotifier;

  void onAllowNotificationsToggled({required bool value}) =>
      _allowNotificationsNotifier.value = value;

  void onSoundToggled({required bool value}) => _soundNotifier.value = value;

  void onShowPreviewsToggled({required bool value}) => _showPreviewsNotifier.value = value;

  void onActivityLevelChanged(ActivityLevel? level) => _activityLevelNotifier.value = level!;

  void onStepGoalChanged({required double value}) => _stepGoalNotifier.value = value;

  Future<void> onSavePressed() => showPlatformToast(context: context, message: 'Profile saved');

  Future<void> onPrivacyPressed() =>
      showPlatformToast(context: context, message: 'Privacy & security');

  Future<void> onSignOutPressed() => showPlatformToast(context: context, message: 'Signed out');

  @override
  void dispose() {
    displayNameController.dispose();
    bioController.dispose();
    _allowNotificationsNotifier.dispose();
    _soundNotifier.dispose();
    _showPreviewsNotifier.dispose();
    _activityLevelNotifier.dispose();
    _stepGoalNotifier.dispose();

    super.dispose();
  }
}
