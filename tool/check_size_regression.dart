// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:io';

/// Budget for Cupertino-pathed bytes in the harness's Android build.
///
/// The harness keeps only the Cupertino that the SDK's own Material widgets hold, so this sits just above
/// that: a leaked sheet trips it, SDK drift doesn't. Raise it only for SDK growth, never for a leak:
/// APPENDIX.md#aot-pruning-rules. A whole file one of those widgets holds goes in [_excludedFiles].
const _maxCupertinoBytes = 100 * 1024;

/// Cupertino files a Material widget the package builds holds whole, left out of the count.
const _excludedFiles = {
  'package:cupertino_ui/src/radio.dart', // material_ui's Radio keeps its `.adaptive` arm: https://github.com/flutter/flutter/issues/195489
  'package:cupertino_ui/src/checkbox.dart', // material_ui's Checkbox, keeps its `.adaptive` arm: https://github.com/flutter/flutter/issues/195489
};

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

  final root = _Node(jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
  final symbols = _cupertinoSymbols(root, root.name);
  final hits = symbols.where((symbol) => !_isExcluded(symbol)).toList(growable: false)
    ..sort((a, b) => b.bytes.compareTo(a.bytes));
  final total = hits.fold<int>(0, (sum, hit) => sum + hit.bytes);
  final excluded = symbols.where(_isExcluded).fold<int>(0, (sum, symbol) => sum + symbol.bytes);

  const reportIndent = '  ';
  stdout
    ..writeln('AOT-pruning size-regression check')
    ..writeln('${reportIndent}source: ${file.path}')
    ..writeln('${reportIndent}cupertino-pathed symbols: ${hits.length}')
    ..writeln('${reportIndent}cupertino-pathed bytes:   $total (budget: $_maxCupertinoBytes)')
    ..writeln('${reportIndent}left out, held by Material widgets: $excluded');

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
    stderr.writeln('$reportIndent${hit.bytes.toString().padLeft(8)} B  ${hit.path}');
  }
  if (hits.length > _maxOffendersShown) {
    stderr.writeln('$reportIndent... and ${hits.length - _maxOffendersShown} more.');
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

/// The leaves under [node], at [path], whose path mentions cupertino.
List<_Symbol> _cupertinoSymbols(_Node node, String path) =>
    node.name.toLowerCase().contains('cupertino')
    ? _leaves(node, path)
    : [for (final child in node.children) ..._cupertinoSymbols(child, '$path/${child.name}')];

/// Every leaf under [node], at [path].
List<_Symbol> _leaves(_Node node, String path) => node.children.isEmpty
    ? [if (node.bytes case final bytes?) _Symbol(path, bytes)]
    : [for (final child in node.children) ..._leaves(child, '$path/${child.name}')];

bool _isExcluded(_Symbol symbol) => _excludedFiles.any((file) => symbol.path.contains('$file/'));

class _Symbol(final String path, final int bytes);

/// A node of the `--analyze-size` tree.
extension type const _Node(Map<String, dynamic> _json) {
  String get name => _json['n']?.toString() ?? '';

  /// Whether [name] mentions cupertino, case-insensitively. `cupertino` holds no `/`, so a path mentions
  /// it exactly when one of its names does.
  bool get isCupertino => name.toLowerCase().contains('cupertino');

  Iterable<_Node> get children =>
      (_json['children'] as List?)?.cast<Map<String, dynamic>>().map(_Node.new) ?? const [];

  int? get bytes => (_json['value'] as num?)?.toInt();
}
