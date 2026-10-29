import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pmvvm/pmvvm.dart';

import '/features/catalog/data/enums/widget_category.dart';

/// One [ExpansibleController] per [WidgetCategory], so the whole accordion can open or close at once,
/// and one enabled state every demo follows.
///
/// Sections start open, set through the controller rather than `initiallyExpanded`, which is Material's
/// alone.
final class CatalogViewModel extends ViewModel {
  final _sectionControllers = {
    for (final category in WidgetCategory.values) category: ExpansibleController()..expand(),
  };
  late final _sectionsListenable = Listenable.merge(_sectionControllers.values);
  final _shouldEnableNotifier = ValueNotifier(true);

  Listenable get sectionsListenable => _sectionsListenable;

  ValueListenable<bool> get shouldEnableListenable => _shouldEnableNotifier;

  bool get isAnySectionExpanded =>
      _sectionControllers.values.any((controller) => controller.isExpanded);

  /// The controller for [category]'s section.
  ExpansibleController controllerFor(WidgetCategory category) => _sectionControllers[category]!;

  void onEnableTogglePressed() => _shouldEnableNotifier.value = !_shouldEnableNotifier.value;

  void onExpandAllPressed() => _sectionControllers.values
      .where((controller) => !controller.isExpanded)
      .forEach((collapsedController) => collapsedController.expand());

  void onCollapseAllPressed() => _sectionControllers.values
      .where((controller) => controller.isExpanded)
      .forEach((expandedController) => expandedController.collapse());

  @override
  void dispose() {
    for (final controller in _sectionControllers.values) {
      controller.dispose();
    }
    _shouldEnableNotifier.dispose();

    super.dispose();
  }
}
