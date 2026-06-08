import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// Triggers for the dialog / sheet / picker showcase. The alert dialog and raw
/// dialog are configure-then-trigger playgrounds — knobs set their args (held as
/// flat fields, mutated via `notifyListeners()`; see `CODESTYLE.md`'s reactivity
/// note on playground view-models), and the button fires the dialog. The date /
/// time buttons display the last-picked value.
final class DialogsDemoViewModel extends ViewModel {
  var _alertTitle = 'Alert';
  var _alertMessage = 'Actions adapt their layout and styling to the platform.';
  var _shouldIncludeDestructiveAction = true;
  var _shouldDismissRawDialogOnBarrierTap = true;
  Date? _selectedDate;
  TimeOfDay? _selectedTime;

  String get alertTitle => _alertTitle;

  String get alertMessage => _alertMessage;

  bool get shouldIncludeDestructiveAction => _shouldIncludeDestructiveAction;

  bool get shouldDismissRawDialogOnBarrierTap => _shouldDismissRawDialogOnBarrierTap;

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
    // Custom content must carry its own dismiss affordance: iOS doesn't dismiss
    // a centered dialog by tapping the barrier (HIG), and has no back button.
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

  Future<void> onShowRawDialogPressed() => showPlatformRawDialog(
    context: context,
    // Raw: no Dialog / CupertinoPopupSurface wrap.
    barrierDismissible: _shouldDismissRawDialogOnBarrierTap,
    builder: (_) => const Center(child: Text('A raw dialog — the package adds no card here.')),
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
    await showPlatformToast(context: context, message: 'Transient toast — auto-dismisses');
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
          'A modal bottom sheet — a Material sheet on Android, an action-sheet-style '
          'popup on iOS.',
        ),
      ),
    ),
  );

  Future<void> onShowRawBottomSheetPressed() => showPlatformRawModalBottomSheet(
    context: context,
    // Raw: no CupertinoPopupSurface wrap — the content floats on iOS (Android
    // keeps showModalBottomSheet's own native Material sheet).
    builder: (_) => const SafeArea(
      child: Padding(
        padding: .all(24),
        child: Text('A raw bottom sheet — the package adds no surface on iOS.'),
      ),
    ),
  );

  Future<void> onShowDatePickerPressed() async {
    final picked = await showPlatformDatePicker(
      context: context,
      firstDate: const Date(year: 1900),
      lastDate: Date.now().add(const Duration(days: 365)),
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
