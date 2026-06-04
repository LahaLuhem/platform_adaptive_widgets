import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

/// Holds the controllers the Lists & containers demos bind to — the expansion
/// tile's expand/collapse controller and the scrollbar's scroll controller.
final class ContainersDemoViewModel extends ViewModel {
  final expansibleController = ExpansibleController()..expand();
  final scrollController = ScrollController();

  @override
  void dispose() {
    expansibleController.dispose();
    scrollController.dispose();

    super.dispose();
  }
}
