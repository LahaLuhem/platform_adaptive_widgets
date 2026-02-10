import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

final class HomeViewModel extends ViewModel {
  final _checkboxValueNotifier = ValueNotifier<bool?>(true);
  final _selectedDateNotifier = ValueNotifier<Date?>(null);
  final _directionalityNotifier = ValueNotifier(AxisDirection.left);
  final _sliderValueNotifier = ValueNotifier<double>(0);
  final _isSwitchEnabledNotifier = ValueNotifier(false);
  final _selectedTimeNotifier = ValueNotifier<TimeOfDay?>(null);

  final expansibleController = ExpansibleController()..expand();
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final textFieldController = TextEditingController();

  ValueListenable<bool?> get checkboxValueListenable => _checkboxValueNotifier;

  ValueListenable<Date?> get selectedDateListenable => _selectedDateNotifier;

  ValueListenable<AxisDirection> get directionalityListenable => _directionalityNotifier;

  ValueListenable<double> get sliderValueListenable => _sliderValueNotifier;

  ValueListenable<bool> get isSwitchEnabledListenable => _isSwitchEnabledNotifier;

  ValueListenable<TimeOfDay?> get selectedTimeListenable => _selectedTimeNotifier;

  Future<void> onShowGeneralDialogPressed() {
    debugPrint('General dialog pressed');

    return showPlatformDialog(
      context: context,
      builder: (_) => const Center(child: Text('General dialog content')),
    );
  }

  Future<void> onShowAlertDialogPressed() {
    debugPrint('Alert dialog pressed');

    return showPlatformAlertDialog(
      context: context,
      title: const Text('Example alert dialog'),
      content: const Text('Change the number of actions to see how the layout changes'),
      actions: [
        PlatformAlertDialogActionButton(
          child: const Text('Normal'),
          onPressed: (context) => Navigator.of(context).pop(),
        ),
        PlatformAlertDialogActionButton(
          isDefaultAction: true,
          onPressed: (context) => Navigator.of(context).pop(),
          child: const Text('Default'),
        ),
        PlatformAlertDialogActionButton(
          isDestructiveAction: true,
          onPressed: (context) => Navigator.of(context).pop(),
          child: const Text('Destructive'),
        ),
        PlatformAlertDialogActionButton(
          isDefaultAction: true,
          isDestructiveAction: true,
          onPressed: (context) => Navigator.of(context).pop(),
          child: const Text('Default & Destructive'),
        ),
      ],
    );
  }

  Future<void> onShowSimpleAlertPressed() {
    debugPrint('Simple alert pressed');

    return showPlatformSimpleAlert(
      context: context,
      message: 'Simple alert message',
      cupertinoOkLabel: 'Ok',
    );
  }

  Future<void> onShowGeneralBottomSheetPressed() {
    debugPrint('General bottom sheet pressed');

    return showPlatformModalBottomSheet(
      context: context,
      builder: (_) => const Center(child: Text('General bottom sheet content')),
    );
  }

  Future<void> onShowDatePickerPressed() async {
    _selectedDateNotifier.value = await showPlatformDatePicker(
      context: context,
      firstDate: const Date(year: 1900),
      lastDate: Date.now().add(const Duration(days: 365)),
    );
    debugPrint('Date picker selected: ${selectedDateListenable.value}');
  }

  Future<void> onShowTimePickerPressed() async {
    _selectedTimeNotifier.value = await showPlatformTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    debugPrint('Time picker selected: ${selectedTimeListenable.value}');
  }

  // Tear-off signature
  //ignore: avoid_positional_boolean_parameters
  void onCheckboxChanged(bool? value) {
    _checkboxValueNotifier.value = value;
    debugPrint('Checkbox changed to $value');
  }

  void onDirectionalityChanged(AxisDirection? value) {
    _directionalityNotifier.value = value!;
    debugPrint('Directionality changed to $value');
  }

  void onSearchChanged(String query) => debugPrint("Searching for '$query'...");

  void onSliderChanged(double value) {
    _sliderValueNotifier.value = value;
    debugPrint('Slider changed to $value');
  }

  // Tear-off signature
  //ignore: avoid_positional_boolean_parameters
  void onSwitchChanged(bool value) {
    _isSwitchEnabledNotifier.value = value;
    debugPrint('Switch changed to $value');
  }

  void onTextSubmitted(String value) => debugPrint('Text-field submitted: $value');

  void onAddPressed() => debugPrint('FAB pressed');

  @override
  void dispose() {
    _checkboxValueNotifier.dispose();
    _selectedDateNotifier.dispose();
    _directionalityNotifier.dispose();
    _sliderValueNotifier.dispose();
    _isSwitchEnabledNotifier.dispose();
    _selectedTimeNotifier.dispose();

    expansibleController.dispose();
    searchController.dispose();
    scrollController.dispose();
    textFieldController.dispose();

    super.dispose();
  }
}
