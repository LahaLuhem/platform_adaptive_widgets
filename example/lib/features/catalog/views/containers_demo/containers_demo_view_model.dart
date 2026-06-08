import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTileTitleAlignment;
import 'package:pmvvm/pmvvm.dart';

/// State for the Lists & containers demos — the expansion tile's controller and
/// the scrollbar's scroll controller, plus the list-tile / scrollbar / progress /
/// expansion playgrounds' editable shared and per-platform properties (flat
/// fields mutated via `notifyListeners()`; see `CODESTYLE.md`'s reactivity note
/// on playground view-models).
final class ContainersDemoViewModel extends ViewModel {
  final expansibleController = ExpansibleController()..expand();
  final scrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  var _shouldEnableListTile = true;
  double _listTileLeadingWidth = 40;
  var _listTileColor = const Color(0xFFFFFFFF);
  var _listTileIconColor = const Color(0xFF2196F3);
  var _listTileTextColor = const Color(0xFF000000);
  var _listTileTitleAlignment = ListTileTitleAlignment.threeLine;

  var _shouldShowScrollbarThumb = true;
  double _scrollbarThickness = 8;
  var _shouldShowScrollbarTrack = false;
  var _isScrollbarInteractive = true;
  var _scrollbarOrientation = ScrollbarOrientation.right;
  var _horizontalScrollbarOrientation = ScrollbarOrientation.bottom;

  var _progressColor = const Color(0xFF2196F3);
  double _progressValue = 0;
  double _progressStrokeWidth = 4;
  var _shouldAnimateProgress = true;
  double _progressRadius = 10;

  var _shouldShowExpansionTrailingIcon = true;
  var _expansionTextColor = const Color(0xFF000000);
  var _expansionIconColor = const Color(0xFF2196F3);

  bool get shouldEnableListTile => _shouldEnableListTile;

  double get listTileLeadingWidth => _listTileLeadingWidth;

  Color get listTileColor => _listTileColor;

  Color get listTileIconColor => _listTileIconColor;

  Color get listTileTextColor => _listTileTextColor;

  ListTileTitleAlignment get listTileTitleAlignment => _listTileTitleAlignment;

  bool get shouldShowScrollbarThumb => _shouldShowScrollbarThumb;

  double get scrollbarThickness => _scrollbarThickness;

  bool get shouldShowScrollbarTrack => _shouldShowScrollbarTrack;

  bool get isScrollbarInteractive => _isScrollbarInteractive;

  ScrollbarOrientation get scrollbarOrientation => _scrollbarOrientation;

  ScrollbarOrientation get horizontalScrollbarOrientation => _horizontalScrollbarOrientation;

  Color get progressColor => _progressColor;

  double get progressValue => _progressValue;

  double get progressStrokeWidth => _progressStrokeWidth;

  bool get shouldAnimateProgress => _shouldAnimateProgress;

  double get progressRadius => _progressRadius;

  bool get shouldShowExpansionTrailingIcon => _shouldShowExpansionTrailingIcon;

  Color get expansionTextColor => _expansionTextColor;

  Color get expansionIconColor => _expansionIconColor;

  void onListTileEnabledToggled({required bool value}) {
    _shouldEnableListTile = value;
    notifyListeners();
  }

  void onListTileLeadingWidthChanged(double value) {
    _listTileLeadingWidth = value;
    notifyListeners();
  }

  void onListTileColorSelected(Color color) {
    _listTileColor = color;
    notifyListeners();
  }

  void onListTileIconColorSelected(Color color) {
    _listTileIconColor = color;
    notifyListeners();
  }

  void onListTileTextColorSelected(Color color) {
    _listTileTextColor = color;
    notifyListeners();
  }

  void onListTileTitleAlignmentSelected(ListTileTitleAlignment alignment) {
    _listTileTitleAlignment = alignment;
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

  void onScrollbarTrackToggled({required bool value}) {
    _shouldShowScrollbarTrack = value;
    notifyListeners();
  }

  void onScrollbarInteractiveToggled({required bool value}) {
    _isScrollbarInteractive = value;
    notifyListeners();
  }

  void onScrollbarOrientationSelected(ScrollbarOrientation orientation) {
    _scrollbarOrientation = orientation;
    notifyListeners();
  }

  void onHorizontalScrollbarOrientationSelected(ScrollbarOrientation orientation) {
    _horizontalScrollbarOrientation = orientation;
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

  void onExpansionTrailingIconToggled({required bool value}) {
    _shouldShowExpansionTrailingIcon = value;
    notifyListeners();
  }

  void onExpansionTextColorSelected(Color color) {
    _expansionTextColor = color;
    notifyListeners();
  }

  void onExpansionIconColorSelected(Color color) {
    _expansionIconColor = color;
    notifyListeners();
  }

  @override
  void dispose() {
    expansibleController.dispose();
    scrollController.dispose();
    horizontalScrollController.dispose();

    super.dispose();
  }
}
