import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/alert_actions.dart';

/// Triggers for the dialog, sheet and picker showcase, plus the args their knobs set. The toast, choices,
/// date and time buttons keep the last result they got, so it can be shown on them.
final class DialogsDemoViewModel extends ViewModel {
  var _alertTitle = 'Discard changes?';
  var _alertMessage = 'Your edits will be lost.';
  var _alertActions = AlertActions.confirm;
  var _confirmLabel = 'Discard';
  var _confirmActionKind = PlatformActionKind.discard;
  var _shouldDismissDialogOnBarrierTap = true;
  var _shouldOfferUndo = true;
  var _isUndone = false;
  String? _draftOutcome;
  Date? _selectedDate;
  TimeOfDay? _selectedTime;
  final _listNameController = TextEditingController();

  String get alertTitle => _alertTitle;

  String get alertMessage => _alertMessage;

  AlertActions get alertActions => _alertActions;

  String get confirmLabel => _confirmLabel;

  PlatformActionKind get confirmActionKind => _confirmActionKind;

  bool get shouldDismissDialogOnBarrierTap => _shouldDismissDialogOnBarrierTap;

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

  void onBarrierDismissibleToggled({required bool value}) {
    _shouldDismissDialogOnBarrierTap = value;
    notifyListeners();
  }

  void onUndoToggled({required bool value}) {
    _shouldOfferUndo = value;
    notifyListeners();
  }

  Future<void> onShowSheetPressed() async {
    _listNameController.clear();
    final saved = await showPlatformSheet<String>(
      context: context,
      appBarBuilder: (context) => PlatformAppBar(
        title: const Text('New list'),
        primaryAction: PlatformBarAction(
          label: 'Save',
          onPressed: () => Navigator.maybeOf(context)?.pop(_listNameController.text),
        ),
      ),
      unsavedChanges: PlatformUnsavedChanges(
        hasChanges: () => _listNameController.text.isNotEmpty,
        message: 'Discard this list?',
        discardLabel: 'Discard List',
      ),
      builder: (_) => Padding(
        padding: const .all(16),
        child: PlatformTextField(
          controller: _listNameController,
          hintText: 'Name',
          autofocus: true,
        ),
      ),
    );
    // Every way out but Save returns null, so only Save gets a toast.
    if (saved == null || !context.mounted) return;
    await showPlatformToast(context: context, message: 'Saved: $saved');
  }

  Future<void> onShowRawDialogPressed() => showPlatformRawDialog(
    context: context,
    barrierDismissible: _shouldDismissDialogOnBarrierTap,
    builder: (context) => Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          const Text('A raw dialog. The package adds no card here.'),
          // Cupertino has no back button, so with barrierDismissible off this is the only way out.
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

  Future<void> onShowRawBottomSheetPressed() => showPlatformRawModalBottomSheet(
    context: context,
    builder: (_) => const SafeArea(
      child: Padding(
        padding: .all(24),
        child: Text('A raw bottom sheet. The package adds no surface on Cupertino.'),
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

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }
}
