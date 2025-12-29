import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

final class HomeViewModel extends ViewModel {
  final _checkboxValueNotifier = ValueNotifier<bool?>(true);
  final _directionalityNotifier = ValueNotifier(AxisDirection.left);
  final _sliderValueNotifier = ValueNotifier<double>(0);
  final _isSwitchEnabledNotifier = ValueNotifier(false);

  final expansibleController = ExpansibleController();
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final textFieldController = TextEditingController();

  ValueListenable<bool?> get checkboxValueListenable => _checkboxValueNotifier;
  ValueListenable<AxisDirection> get directionalityListenable => _directionalityNotifier;
  ValueListenable<double> get sliderValueListenable => _sliderValueNotifier;
  ValueListenable<bool> get isSwitchEnabledListenable => _isSwitchEnabledNotifier;

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
    _directionalityNotifier.dispose();
    _sliderValueNotifier.dispose();
    _isSwitchEnabledNotifier.dispose();

    expansibleController.dispose();
    searchController.dispose();
    scrollController.dispose();
    textFieldController.dispose();

    super.dispose();
  }
}
