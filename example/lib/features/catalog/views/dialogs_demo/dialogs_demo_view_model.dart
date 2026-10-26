import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/alert_actions.dart';

/// Triggers for the dialog, sheet and picker showcase, plus the args their knobs set. The full-screen
/// dialog, toast, choices, date and time buttons keep the last result they got, so it can be shown on them.
final class DialogsDemoViewModel extends ViewModel {
  var _alertTitle = 'Discard changes?';
  var _alertMessage = 'Your edits will be lost.';
  var _alertActions = AlertActions.confirm;
  var _confirmLabel = 'Discard';
  var _confirmActionKind = PlatformActionKind.discard;
  var _isDialogRaw = false;
  var _shouldDismissDialogOnBarrierTap = true;
  var _isSheetRaw = false;
  var _shouldOfferUndo = true;
  var _isUndone = false;
  String? _draftOutcome;
  Date? _selectedDate;
  TimeOfDay? _selectedTime;

  String get alertTitle => _alertTitle;

  String get alertMessage => _alertMessage;

  AlertActions get alertActions => _alertActions;

  String get confirmLabel => _confirmLabel;

  PlatformActionKind get confirmActionKind => _confirmActionKind;

  bool get isDialogRaw => _isDialogRaw;

  bool get shouldDismissDialogOnBarrierTap => _shouldDismissDialogOnBarrierTap;

  bool get isSheetRaw => _isSheetRaw;

  bool get shouldOfferUndo => _shouldOfferUndo;

  bool get isUndone => _isUndone;

  String? get draftOutcome => _draftOutcome;

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

  void onConfirmLabelChanged(String value) {
    _confirmLabel = value;
    notifyListeners();
  }

  void onConfirmActionKindChanged(PlatformActionKind value) {
    _confirmActionKind = value;
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
                    emphasis: .low,
                    child: const Text('Done'),
                  ),
              ],
            ),
          ),
        );

  Future<void> onShowFullscreenDialogPressed() async {
    final saved = await showPlatformFullscreenDialog<String>(
      context: context,
      appBarBuilder: (context) => PlatformAppBar(
        title: const Text('New event'),
        primaryAction: PlatformBarAction(
          label: 'Save',
          onPressed: () => Navigator.maybeOf(context)?.pop('Team lunch'),
        ),
      ),
      builder: (_) => const Center(child: Text('Team lunch')),
    );
    // The bar's close button returns null, so only Save gets a toast.
    if (saved == null || !context.mounted) return;
    await showPlatformToast(context: context, message: 'Saved: $saved');
  }

  Future<void> onShowAlertDialogPressed() => switch (_alertActions) {
    .acknowledge => showPlatformAcknowledge(
      context: context,
      title: _alertTitle,
      message: _alertMessage.isEmpty ? null : _alertMessage,
    ),
    .confirm => showPlatformConfirm(
      context: context,
      title: _alertTitle,
      message: _alertMessage,
      confirmLabel: _confirmLabel,
      actionKind: _confirmActionKind,
    ),
  };

  Future<void> onShowToastPressed() {
    _isUndone = false;
    notifyListeners();

    return showPlatformToast(
      context: context,
      message: 'Draft deleted',
      action: _shouldOfferUndo
          ? PlatformToastAction(
              label: 'Undo',
              onPressed: () {
                _isUndone = true;
                notifyListeners();
              },
            )
          : null,
    );
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

  Future<void> onShowChoicesPressed() async {
    _draftOutcome = await showPlatformChoices(
      context: context,
      title: 'Unsent draft',
      choices: const {
        PlatformChoice(value: 'saved', label: 'Save Draft', actionKind: .normal),
        PlatformChoice(value: 'deleted', label: 'Delete Draft', actionKind: .delete),
      },
    );
    notifyListeners();
  }

  Future<void> onShareListPressed() => showPlatformToast(context: context, message: 'List shared');

  Future<void> onPrintPressed() => showPlatformToast(context: context, message: 'List printed');

  Future<void> onDeleteListPressed() =>
      showPlatformToast(context: context, message: 'List deleted');

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
