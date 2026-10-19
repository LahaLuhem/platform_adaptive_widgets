import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// Triggers for the dialog, sheet and picker showcase, plus the args their knobs set. The full-screen
/// dialog, date and time buttons keep the last value they got back, so it can be shown on them.
final class DialogsDemoViewModel extends ViewModel {
  var _alertTitle = 'Alert';
  var _alertMessage = 'Actions adapt their layout and styling to the platform.';
  var _shouldIncludeDestructiveAction = true;
  var _shouldDismissRawDialogOnBarrierTap = true;
  String? _savedEvent;
  Date? _selectedDate;
  TimeOfDay? _selectedTime;

  String get alertTitle => _alertTitle;

  String get alertMessage => _alertMessage;

  bool get shouldIncludeDestructiveAction => _shouldIncludeDestructiveAction;

  bool get shouldDismissRawDialogOnBarrierTap => _shouldDismissRawDialogOnBarrierTap;

  String? get savedEvent => _savedEvent;

  Date? get selectedDate => _selectedDate;

  TimeOfDay? get selectedTime => _selectedTime;

  void onAlertTitleChanged(String value) {
    _alertTitle = value;
    notifyListeners();
  }

  void onAlertMessageChanged(String value) {
    _alertMessage = value;
    notifyListeners();
  }

  void onDestructiveActionToggled({required bool value}) {
    _shouldIncludeDestructiveAction = value;
    notifyListeners();
  }

  void onBarrierDismissibleToggled({required bool value}) {
    _shouldDismissRawDialogOnBarrierTap = value;
    notifyListeners();
  }

  Future<void> onShowDialogPressed() => showPlatformDialog(
    context: context,
    // On iOS, custom content needs its own way out: tapping outside doesn't close a centred dialog
    // (HIG), and there's no back button.
    builder: (context) => Padding(
      padding: const .all(24),
      child: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          const Text('A centered platform dialog.'),
          if (isIOS)
            PlatformButton(
              onPressed: () => Navigator.maybeOf(context)?.pop(),
              materialButtonVariant: .text,
              child: const Text('Done'),
            ),
        ],
      ),
    ),
  );

  Future<void> onShowFullscreenDialogPressed() async {
    _savedEvent = await showPlatformFullscreenDialog<String>(
      context: context,
      appBarData: const PlatformAppBar(title: Text('New event')),
      // Save sits in the body for now, since the bar's trailing actions are still per platform.
      builder: (context) => Center(
        child: PlatformButton(
          onPressed: () => Navigator.maybeOf(context)?.pop('Team lunch'),
          child: const Text('Save "Team lunch"'),
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> onShowRawDialogPressed() => showPlatformRawDialog(
    context: context,
    barrierDismissible: _shouldDismissRawDialogOnBarrierTap,
    builder: (_) => const Center(child: Text('A raw dialog, the package adds no card here.')),
  );

  Future<void> onShowAlertDialogPressed() => showPlatformAlertDialog(
    context: context,
    title: Text(_alertTitle),
    content: Text(_alertMessage),
    actions: [
      PlatformDialogAction(
        isDefaultAction: true,
        onPressed: (context) => Navigator.maybeOf(context)?.pop(),
        child: const Text('OK'),
      ),
      if (_shouldIncludeDestructiveAction)
        PlatformDialogAction(
          isDestructiveAction: true,
          onPressed: (context) => Navigator.maybeOf(context)?.pop(),
          child: const Text('Delete'),
        ),
      PlatformDialogAction(
        onPressed: (context) => Navigator.maybeOf(context)?.pop(),
        child: const Text('Cancel'),
      ),
    ],
  );

  Future<void> onShowToastAndAcknowledgePressed() async {
    await showPlatformToast(context: context, message: 'Transient toast, auto-dismisses');
    if (!context.mounted) return;

    await showPlatformAcknowledge(
      context: context,
      title: 'Acknowledgement required',
      message: 'This alert blocks until you tap OK.',
    );
  }

  Future<void> onShowBottomSheetPressed() => showPlatformModalBottomSheet(
    context: context,
    builder: (_) => const SafeArea(
      child: Padding(
        padding: .all(24),
        child: Text(
          'A modal bottom sheet, a Material sheet on Android, an action-sheet-style '
          'popup on iOS.',
        ),
      ),
    ),
  );

  Future<void> onShowRawBottomSheetPressed() => showPlatformRawModalBottomSheet(
    context: context,
    builder: (_) => const SafeArea(
      child: Padding(
        padding: .all(24),
        child: Text('A raw bottom sheet, the package adds no surface on iOS.'),
      ),
    ),
  );

  Future<void> onShowDatePickerPressed() async {
    final picked = await showPlatformDatePicker(
      context: context,
      firstDate: Date.of(1900).getOrThrow(),
      lastDate: Date.now().tryAddDays(365)!,
    );
    _selectedDate = picked;
    notifyListeners();
  }

  Future<void> onShowTimePickerPressed() async {
    final picked = await showPlatformTimePicker(context: context, initialTime: TimeOfDay.now());
    _selectedTime = picked;
    notifyListeners();
  }
}
