import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/widget_category.dart';

/// One [ExpansibleController] per [WidgetCategory], so the whole accordion can open or close at once.
///
/// Sections start open, set through the controller rather than `initiallyExpanded`, which is Material's
/// alone.
final class CatalogViewModel extends ViewModel {
  final _sectionControllers = {
    for (final category in WidgetCategory.values) category: ExpansibleController()..expand(),
  };

  /// The controller for [category]'s section.
  ExpansibleController controllerFor(WidgetCategory category) => _sectionControllers[category]!;

  void onExpandAllPressed() {
    for (final controller in _sectionControllers.values) {
      if (!controller.isExpanded) controller.expand();
    }
  }

  void onCollapseAllPressed() {
    for (final controller in _sectionControllers.values) {
      if (controller.isExpanded) controller.collapse();
    }
  }

  @override
  void dispose() {
    for (final controller in _sectionControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }
}
