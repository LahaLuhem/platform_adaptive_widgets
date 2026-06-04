import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/widget_category.dart';

/// Owns one [ExpansibleController] per [WidgetCategory] so the Catalog accordion
/// can expand or collapse every section at once — letting the reader flip
/// between an everything-open flat scroll and a compact, scannable list. Each
/// section starts expanded (via the controller, the only cross-platform way —
/// `initiallyExpanded` is Material-only) so the widgets are immediately
/// hands-on.
final class CatalogViewModel extends ViewModel {
  final _sectionControllers = {
    for (final category in WidgetCategory.values) category: ExpansibleController()..expand(),
  };

  /// The expansion controller bound to [category]'s section.
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
