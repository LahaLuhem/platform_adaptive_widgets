/// The AST guards, run from one file so they share one analysis of `lib/`.
@TestOn('vm')
// Analyzing lib/ with material_ui and cupertino_ui takes seconds, more on a CI runner.
@Timeout(Duration(minutes: 1))
library;

import 'package:flutter_test/flutter_test.dart';

import 'aot_pruning.dart';
import 'data_widget_parity.dart';
import 'internal_lock.dart';
import 'look_picking.dart';
import 'upstream_defaults.dart';

void main() {
  aotPruningGuard();
  dataWidgetParityGuard();
  internalLockGuard();
  lookPickingGuard();
  upstreamDefaultsGuard();
}
