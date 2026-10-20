import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/alert_actions.dart';

/// Triggers for the dialog, sheet and picker showcase, plus the args their knobs set. The full-screen
/// dialog, toast, date and time buttons keep the last result they got, so it can be shown on them.
final class DialogsDemoViewModel extends ViewModel {
  var _alertTitle = 'Alert';
  var _alertMessage = 'Actions adapt their layout and styling to the platform.';
  var _alertActions = AlertActions.destructive;
  var _isDialogRaw = false;
  var _shouldDismissDialogOnBarrierTap = true;
  var _isSheetRaw = false;
  var _shouldOfferUndo = true;
  var _isUndone = false;
  String? _savedEvent;
  Date? _selectedDate;
  TimeOfDay? _selectedTime;

  String get alertTitle => _alertTitle;

  String get alertMessage => _alertMessage;

  AlertActions get alertActions => _alertActions;

  bool get isDialogRaw => _isDialogRaw;

  bool get shouldDismissDialogOnBarrierTap => _shouldDismissDialogOnBarrierTap;

  bool get isSheetRaw => _isSheetRaw;

  bool get shouldOfferUndo => _shouldOfferUndo;

  bool get isUndone => _isUndone;

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

  void onAlertActionsChanged(AlertActions value) {
    _alertActions = value;
    notifyListeners();
  }

  void onDialogRawToggled({required bool value}) {
    _isDialogRaw = value;
    notifyListeners();
  }

  void onBarrierDismissibleToggled({required bool value}) {
    _shouldDismissDialogOnBarrierTap = value;
    notifyListeners();
  }

  void onSheetRawToggled({required bool value}) {
    _isSheetRaw = value;
    notifyListeners();
  }

  void onUndoToggled({required bool value}) {
    _shouldOfferUndo = value;
    notifyListeners();
  }

  Future<void> onShowDialogPressed() => _isDialogRaw
      ? showPlatformRawDialog(
          context: context,
          barrierDismissible: _shouldDismissDialogOnBarrierTap,
          builder: (_) => const Center(child: Text('A raw dialog, the package adds no card here.')),
        )
      : showPlatformDialog(
          context: context,
          barrierDismissible: _shouldDismissDialogOnBarrierTap,
          // On Cupertino, custom content needs its own way out: by default tapping outside doesn't close a
          // centred dialog (HIG), and there's no back button.
          builder: (context) => Padding(
            padding: const .all(24),
            child: Column(
              mainAxisSize: .min,
              spacing: 16,
              children: [
                const Text('A centered platform dialog.'),
                if (designLanguage == .cupertino)
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

  Future<void> onShowAlertDialogPressed() => switch (_alertActions) {
    .acknowledge => showPlatformAcknowledge(
      context: context,
      title: _alertTitle,
      message: _alertMessage,
    ),
    .confirm || .destructive => showPlatformAlertDialog(
      context: context,
      title: Text(_alertTitle),
      content: Text(_alertMessage),
      actions: [
        PlatformDialogAction(
          isDefaultAction: true,
          onPressed: (context) => Navigator.maybeOf(context)?.pop(),
          child: const Text('OK'),
        ),
        if (_alertActions == .destructive)
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
    ),
  };

  Future<void> onShowToastPressed() {
    _isUndone = false;
    notifyListeners();

    return showPlatformToast(
      context: context,
      message: 'Draft deleted',
      action: _shouldOfferUndo
          ? PlatformToastAction(label: 'Undo', onPressed: _onUndoPressed)
          : null,
    );
  }

  void _onUndoPressed() {
    _isUndone = true;
    notifyListeners();
  }

  Future<void> onShowBottomSheetPressed() => _isSheetRaw
      ? showPlatformRawModalBottomSheet(
          context: context,
          builder: (_) => const SafeArea(
            child: Padding(
              padding: .all(24),
              child: Text('A raw bottom sheet, the package adds no surface on Cupertino.'),
            ),
          ),
        )
      : showPlatformModalBottomSheet(
          context: context,
          builder: (_) => const SafeArea(
            child: Padding(
              padding: .all(24),
              child: Text(
                'A modal bottom sheet, a Material sheet, or an action-sheet-style '
                'popup on Cupertino.',
              ),
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
