// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:io';

/// Budget for Cupertino-pathed bytes in the harness's Android build.
///
/// The harness measured ~107 KB on 2026-06-08, nearly all of it SDK-internal Cupertino nothing outside
/// the SDK can prune. This sits ~33 KB above that, which is the point: one leaked `CupertinoDatePicker`
/// costs ~61 KB and so trips it, where the old 200 KB budget had enough headroom to swallow that
/// silently. The remaining margin covers SDK drift about threefold. Raise it only for SDK growth, never
/// for a leak: APPENDIX.md#aot-pruning-rules.
const int _maxCupertinoBytes = 140 * 1024;

/// Number of top offenders to print on failure.
const _maxOffendersShown = 30;

/// `flutter build apk --analyze-size` writes its report here, and keeps the earlier ones.
final _reportsDir = Directory('${Platform.environment['HOME']!}/.flutter-devtools');
final _reportName = RegExp(r'^apk-code-size-analysis_.*\.json$');

Future<void> main(List<String> args) async {
  if (args.length > 1) {
    stderr.writeln('Usage: dart tool/check_size_regression.dart [path-to-app-size-analysis.json]');
    exit(64);
  }
  final file = args.isEmpty ? _newestReport() : File(args.single);
  if (file == null) {
    stderr.writeln('No size report in ${_reportsDir.path} to check.');
    exit(66);
  }
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

File? _newestReport() {
  if (!_reportsDir.existsSync()) return null;

  final reports =
      _reportsDir
          .listSync()
          .whereType<File>()
          .where((file) => _reportName.hasMatch(file.uri.pathSegments.last))
          .toList(growable: false)
        ..sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));

  return reports.lastOrNull;
}

/// Every leaf in the `--analyze-size` tree whose path mentions cupertino, case-insensitively. Lazy.
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

class _Symbol(final String path, final int bytes);
