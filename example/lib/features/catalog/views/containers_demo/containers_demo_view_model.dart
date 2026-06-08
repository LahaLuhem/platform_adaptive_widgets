import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// State for the Lists & containers demos — the expansion tile's controller and
/// the scrollbar's scroll controller, plus the list-tile / scrollbar / progress
/// playgrounds' editable shared and per-platform properties (flat fields mutated
/// via `notifyListeners()`; see `CODESTYLE.md`'s reactivity note on playground
/// view-models).
final class ContainersDemoViewModel extends ViewModel {
  final expansibleController = ExpansibleController()..expand();
  final scrollController = ScrollController();

  var _shouldEnableListTile = true;
  double _listTileLeadingWidth = 40;

  var _shouldShowScrollbarThumb = true;
  double _scrollbarThickness = 8;

  var _progressColor = const Color(0xFF2196F3);
  double _progressValue = 0;
  double _progressStrokeWidth = 4;
  var _shouldAnimateProgress = true;
  double _progressRadius = 10;

  bool get shouldEnableListTile => _shouldEnableListTile;

  double get listTileLeadingWidth => _listTileLeadingWidth;

  bool get shouldShowScrollbarThumb => _shouldShowScrollbarThumb;

  double get scrollbarThickness => _scrollbarThickness;

  Color get progressColor => _progressColor;

  double get progressValue => _progressValue;

  double get progressStrokeWidth => _progressStrokeWidth;

  bool get shouldAnimateProgress => _shouldAnimateProgress;

  double get progressRadius => _progressRadius;

  void onListTileEnabledToggled({required bool value}) {
    _shouldEnableListTile = value;
    notifyListeners();
  }

  void onListTileLeadingWidthChanged(double value) {
    _listTileLeadingWidth = value;
    notifyListeners();
  }

  void onScrollbarThumbToggled({required bool value}) {
    _shouldShowScrollbarThumb = value;
    notifyListeners();
  }

  void onScrollbarThicknessChanged(double value) {
    _scrollbarThickness = value;
    notifyListeners();
  }

  void onProgressColorSelected(Color color) {
    _progressColor = color;
    notifyListeners();
  }

  void onProgressValueChanged(double value) {
    _progressValue = value;
    notifyListeners();
  }

  void onProgressStrokeWidthChanged(double value) {
    _progressStrokeWidth = value;
    notifyListeners();
  }

  void onProgressAnimatingToggled({required bool value}) {
    _shouldAnimateProgress = value;
    notifyListeners();
  }

  void onProgressRadiusChanged(double value) {
    _progressRadius = value;
    notifyListeners();
  }

  @override
  void dispose() {
    expansibleController.dispose();
    scrollController.dispose();

    super.dispose();
  }
}
