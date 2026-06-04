import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_adaptive_widgets/platform_adaptive_widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// State for the text & search demos — the field controllers the views bind to,
/// and the live search query echoed back under the search bar.
final class TextDemoViewModel extends ViewModel {
  final searchController = TextEditingController();
  final textFieldController = TextEditingController();
  final _searchQueryNotifier = ValueNotifier('');

  ValueListenable<String> get searchQueryListenable => _searchQueryNotifier;

  void onSearchChanged(String query) => _searchQueryNotifier.value = query;

  Future<void> onTextSubmitted(String value) =>
      showPlatformToast(context: context, message: 'Submitted: $value');

  @override
  void dispose() {
    searchController.dispose();
    textFieldController.dispose();
    _searchQueryNotifier.dispose();

    super.dispose();
  }
}
