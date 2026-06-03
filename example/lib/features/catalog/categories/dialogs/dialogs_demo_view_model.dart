import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// Triggers for the dialog / sheet / picker showcase, plus the last-picked date
/// and time the buttons display.
final class DialogsDemoViewModel extends ViewModel {
  final _selectedDateNotifier = ValueNotifier<Date?>(null);
  final _selectedTimeNotifier = ValueNotifier<TimeOfDay?>(null);

  ValueListenable<Date?> get selectedDateListenable => _selectedDateNotifier;

  ValueListenable<TimeOfDay?> get selectedTimeListenable => _selectedTimeNotifier;

  Future<void> onShowDialogPressed() => showPlatformDialog(
    context: context,
    builder: (_) => const Center(child: Text('A centered platform dialog.')),
  );

  Future<void> onShowAlertDialogPressed() => showPlatformAlertDialog(
    context: context,
    title: const Text('Alert'),
    content: const Text('Actions adapt their layout and styling to the platform.'),
    actions: [
      PlatformDialogAction(
        onPressed: (context) => Navigator.maybeOf(context)?.pop(),
        child: const Text('Cancel'),
      ),
      PlatformDialogAction(
        isDefaultAction: true,
        onPressed: (context) => Navigator.maybeOf(context)?.pop(),
        child: const Text('OK'),
      ),
      PlatformDialogAction(
        isDestructiveAction: true,
        onPressed: (context) => Navigator.maybeOf(context)?.pop(),
        child: const Text('Delete'),
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

  Future<void> onShowDatePickerPressed() async {
    _selectedDateNotifier.value = await showPlatformDatePicker(
      context: context,
      firstDate: const Date(year: 1900),
      lastDate: Date.now().add(const Duration(days: 365)),
    );
  }

  Future<void> onShowTimePickerPressed() async {
    _selectedTimeNotifier.value = await showPlatformTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  @override
  void dispose() {
    _selectedDateNotifier.dispose();
    _selectedTimeNotifier.dispose();

    super.dispose();
  }
}
