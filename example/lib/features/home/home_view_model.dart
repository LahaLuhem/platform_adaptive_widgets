import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

final class HomeViewModel extends ViewModel {
  final _checkboxValueNotifier = ValueNotifier<bool?>(true);
  final _sliderValueNotifier = ValueNotifier<double>(0);
  final _isSwitchEnabledNotifier = ValueNotifier(false);

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  ValueListenable<bool?> get checkboxValueListenable => _checkboxValueNotifier;
  ValueListenable<double> get sliderValueListenable => _sliderValueNotifier;
  ValueListenable<bool> get isSwitchEnabledListenable => _isSwitchEnabledNotifier;

  // Tear-off signature
  //ignore: avoid_positional_boolean_parameters
  void onCheckboxChanged(bool? value) {
    _checkboxValueNotifier.value = value;
    debugPrint('Checkbox changed to $value');
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

  void onAddPressed() => debugPrint('FAB pressed');

  @override
  void dispose() {
    _sliderValueNotifier.dispose();
    _isSwitchEnabledNotifier.dispose();

    searchController.dispose();
    scrollController.dispose();

    super.dispose();
  }
}
