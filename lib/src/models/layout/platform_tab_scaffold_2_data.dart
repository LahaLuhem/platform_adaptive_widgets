// ignore_for_file: prefer-match-file-name

import 'package:flutter/cupertino.dart' show CupertinoTabController;
import 'package:flutter/widgets.dart';

import 'platform_scaffold_data.dart';
import 'platform_tab_scaffold_data.dart';

/// Cupertino-specific data for a tab-based scaffold.
final class CupertinoTabScaffoldData2 extends CupertinoScaffoldData {
  /// A list of destinations to display in the tab bar.
  final List<TabDestinationData>? tabDestinationsData;

  /// A controller for the tab bar.
  final CupertinoTabController? controller;

  /// A builder for the content of each tab.
  final IndexedWidgetBuilder? tabBuilder;

  /// A restoration ID for the tab scaffold.
  final String? restorationId;

  /// Creates a [CupertinoTabScaffoldData2].
  const CupertinoTabScaffoldData2({
    super.widgetKey,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    this.tabDestinationsData,
    this.controller,
    this.tabBuilder,
    this.restorationId,
  }) : super(body: null, navigationBar: null);
}
