import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show ListTileTitleAlignment;
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// State for the Lists & containers demos: the expansion tile's and scrollbar's controllers, plus every
/// playground's editable properties.
final class ContainersDemoViewModel extends ViewModel {
  final expansibleController = ExpansibleController()..expand();
  final scrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  double _listTileLeadingWidth = 40;
  Color? _listTileColor;
  Color? _listTileIconColor;
  Color? _listTileTextColor;
  var _listTileTitleAlignment = ListTileTitleAlignment.threeLine;

  var _shouldShowScrollbarThumb = true;
  double _scrollbarThickness = 8;
  var _shouldShowScrollbarTrack = false;
  var _isScrollbarInteractive = true;
  var _scrollAxis = Axis.vertical;
  var _scrollbarOrientation = ScrollbarOrientation.right;

  Color? _progressColor;
  var _progressValue = 0.3;
  double _progressStrokeWidth = 4;
  var _shouldAnimateProgress = true;
  double _progressRadius = 10;

  var _shouldShowExpansionTrailingIcon = true;
  Color? _expansionTextColor;
  Color? _expansionIconColor;

  double get listTileLeadingWidth => _listTileLeadingWidth;

  Color? get listTileColor => _listTileColor;

  Color? get listTileIconColor => _listTileIconColor;

  Color? get listTileTextColor => _listTileTextColor;

  ListTileTitleAlignment get listTileTitleAlignment => _listTileTitleAlignment;

  bool get shouldShowScrollbarThumb => _shouldShowScrollbarThumb;

  double get scrollbarThickness => _scrollbarThickness;

  bool get shouldShowScrollbarTrack => _shouldShowScrollbarTrack;

  bool get isScrollbarInteractive => _isScrollbarInteractive;

  ScrollbarOrientation get scrollbarOrientation => _scrollbarOrientation;

  Axis get scrollAxis => _scrollAxis;

  ScrollController get currentScrollController => switch (_scrollAxis) {
    .vertical => scrollController,
    .horizontal => horizontalScrollController,
  };

  /// The sides the scrollbar can sit on, which depend on which way the list scrolls.
  Set<ScrollbarOrientation> get scrollbarOrientations => switch (_scrollAxis) {
    .vertical => const {.left, .right},
    .horizontal => const {.top, .bottom},
  };

  Color? get progressColor => _progressColor;

  double get progressValue => _progressValue;

  double get progressStrokeWidth => _progressStrokeWidth;

  bool get shouldAnimateProgress => _shouldAnimateProgress;

  double get progressRadius => _progressRadius;

  bool get shouldShowExpansionTrailingIcon => _shouldShowExpansionTrailingIcon;

  Color? get expansionTextColor => _expansionTextColor;

  Color? get expansionIconColor => _expansionIconColor;

  Future<void> onListTileTapped() =>
      showPlatformToast(context: context, message: 'List tile tapped');

  void onListTileLeadingWidthChanged(double value) {
    _listTileLeadingWidth = value;
    notifyListeners();
  }

  void onListTileColorSelected(Color? color) {
    _listTileColor = color;
    notifyListeners();
  }

  void onListTileIconColorSelected(Color? color) {
    _listTileIconColor = color;
    notifyListeners();
  }

  void onListTileTextColorSelected(Color? color) {
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

  void onScrollAxisSelected(Axis axis) {
    _scrollAxis = axis;
    // The old side doesn't exist on the new axis.
    _scrollbarOrientation = scrollbarOrientations.last;
    notifyListeners();
  }

  void onProgressColorSelected(Color? color) {
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

  void onExpansionTextColorSelected(Color? color) {
    _expansionTextColor = color;
    notifyListeners();
  }

  void onExpansionIconColorSelected(Color? color) {
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
