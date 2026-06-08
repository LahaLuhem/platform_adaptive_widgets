import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// State for the text & search demos — the field controllers the views bind to,
/// the live search query, and the text-field playground's editable shared-visual
/// properties. The query and playground props are flat fields mutated via
/// `notifyListeners()` (see `CODESTYLE.md`'s reactivity note on playground
/// view-models).
final class TextDemoViewModel extends ViewModel {
  final searchController = TextEditingController();
  final textFieldController = TextEditingController();
  var _searchQuery = '';

  final playgroundController = TextEditingController(text: 'Sample text');
  var _hintText = 'Placeholder';
  var _cursorColor = const Color(0xFF2196F3);
  double _cursorWidth = 2;
  var _shouldObscure = false;
  var _textAlign = TextAlign.start;

  String get searchQuery => _searchQuery;

  String get hintText => _hintText;

  Color get cursorColor => _cursorColor;

  double get cursorWidth => _cursorWidth;

  bool get shouldObscure => _shouldObscure;

  TextAlign get textAlign => _textAlign;

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> onTextSubmitted(String value) =>
      showPlatformToast(context: context, message: 'Submitted: $value');

  void onHintTextChanged(String value) {
    _hintText = value;
    notifyListeners();
  }

  void onCursorColorSelected(Color color) {
    _cursorColor = color;
    notifyListeners();
  }

  void onCursorWidthChanged(double value) {
    _cursorWidth = value;
    notifyListeners();
  }

  void onObscureToggled({required bool value}) {
    _shouldObscure = value;
    notifyListeners();
  }

  void onTextAlignSelected(TextAlign align) {
    _textAlign = align;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    textFieldController.dispose();
    playgroundController.dispose();

    super.dispose();
  }
}
