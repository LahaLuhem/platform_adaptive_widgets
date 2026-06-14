// AOT-pruning size-regression guard for the size-harness Android build.
//
// Walks the JSON snapshot produced by `flutter build apk --analyze-size`,
// sums the bytes of every symbol whose path contains "cupertino"
// (case-insensitive), and fails if the total exceeds a budget.
//
// Why a threshold and not "zero":
//
//   - Some Cupertino code is pulled into every Material-only Android build by
//     Flutter SDK internals (e.g. text-selection toolbars). We can't drive
//     that to zero from outside the SDK.
//   - The pruning contract we care about: a refactor that re-introduces
//     deferred-dispatch (closures-as-args passed into a sub-helper instead of
//     dispatched inline at the public entry point) drags in entire Cupertino
//     widget implementations — `CupertinoAlertDialog`, `CupertinoDatePicker`,
//     etc. — adding ~150–200 KB. The threshold is calibrated so the current
//     correctly-pruned build passes with comfortable headroom, while a full
//     deferred-dispatch regression fails loudly.
//
// When the threshold needs raising: a Flutter SDK update genuinely grew the
// baseline. Re-run the build locally, read the printed "actual" number, and
// raise [_maxCupertinoBytes] above it by a small buffer. Don't raise it to
// silence an actual leak — investigate first against
// APPENDIX.md#aot-pruning-rules.
//
// Usage: dart tool/check_size_regression.dart <path-to-app-size-analysis.json>

// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:io';

/// Budget for total Cupertino-pathed bytes in the size-harness Android build.
///
/// Baseline (2026-06-08, current SDK): ~107 KB — all six `showPlatformXxx`,
/// PlatformButton, `context.platformIcon`, and the `isAndroid`/`isIOS` getters
/// exercised; dominated by SDK-internal Cupertino (text-selection toolbars
/// etc.) that can't be driven to zero from outside the SDK.
///
/// Threshold sits ~33 KB above baseline — deliberately *below* the empirically
/// measured cost of the dominant regression, so that regression trips it. A
/// leaked `CupertinoDatePicker` adds ~61 KB cupertino-pathed (`tool/size_harness`
/// experiment, 2026-06-08), pushing the build to ~166 KB — well over this
/// 140 KB budget. The prior 200 KB budget (~93 KB headroom) sat *above* that
/// 61 KB leak and would have missed a single-widget pruning regression. The
/// ~33 KB margin still absorbs SDK drift (the baseline fell ~11 KB since the
/// last reading) roughly threefold.
const int _maxCupertinoBytes = 140 * 1024;

/// Number of top offenders to print on failure.
const _maxOffendersShown = 30;

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart tool/check_size_regression.dart <path-to-app-size-analysis.json>');
    exit(64);
  }
  final file = File(args.single);
  if (!file.existsSync()) {
    stderr.writeln('File not found: ${file.path}');
    exit(66);
  }

  final root = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  // Read more than once (sort, sum, slice), so materialise the lazy walk once.
  final hits = _cupertinoSymbols(root).toList(growable: false)
    ..sort((a, b) => b.bytes.compareTo(a.bytes));
  final total = hits.fold<int>(0, (sum, hit) => sum + hit.bytes);

  stdout
    ..writeln('AOT-pruning size-regression check')
    ..writeln('  source: ${file.path}')
    ..writeln('  cupertino-pathed symbols: ${hits.length}')
    ..writeln('  cupertino-pathed bytes:   $total (budget: $_maxCupertinoBytes)');

  if (total <= _maxCupertinoBytes) return stdout.writeln('  PASS');

  stderr
    ..writeln('\nFAIL: cupertino-pathed bytes ($total) exceed budget ($_maxCupertinoBytes).')
    ..writeln(
      'A refactor likely re-introduced deferred-dispatch into a public '
      '`showPlatformXxx` helper, defeating AOT pruning of the Cupertino arm. '
      'See APPENDIX.md#aot-pruning-rules and test/aot_pruning_regression_test.dart.',
    )
    ..writeln('\nTop $_maxOffendersShown by size:');
  for (final hit in hits.take(_maxOffendersShown)) {
    stderr.writeln('  ${hit.bytes.toString().padLeft(8)} B  ${hit.path}');
  }
  if (hits.length > _maxOffendersShown) {
    stderr.writeln('  ... and ${hits.length - _maxOffendersShown} more.');
  }

  exit(1);
}

/// Lazily flattens the `--analyze-size` JSON tree to every leaf symbol whose
/// full `/`-joined path contains "cupertino" (case-insensitive). A leaf is a
/// node with a numeric `value` and no children.
Iterable<_Symbol> _cupertinoSymbols(
  Map<String, dynamic> node, [
  List<String> ancestors = const [],
]) {
  final path = [...ancestors, node['n']?.toString() ?? ''];
  final children = node['children'];
  if (children is List && children.isNotEmpty) {
    return children.expand((child) => _cupertinoSymbols(child as Map<String, dynamic>, path));
  }

  final value = node['value'];
  if (value is! num) return const [];
  final full = path.join('/');

  return full.toLowerCase().contains('cupertino') ? [_Symbol(full, value.toInt())] : const [];
}

class _Symbol {
  _Symbol(this.path, this.bytes);
  final String path;
  final int bytes;
}
