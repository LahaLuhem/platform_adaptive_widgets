// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:io';

/// A harness build, and the look its platform doesn't draw, which the check counts.
enum _Build({
  /// The report's `type`, which also starts its file name.
  required final String reportType,
  required final String otherLook,

  /// Sits just above what the build can't help keeping, so a leaked sheet trips it and SDK drift doesn't.
  /// Raise it only for SDK growth, never for a leak: APPENDIX.md#aot-pruning-rules.
  required final int budget,

  /// Whole files a widget of the drawn look holds, left out of the count.
  final Set<String> excludedFiles = const {},
}) {
  /// Keeps the Cupertino the SDK's own Material widgets hold.
  android(
    reportType: 'apk',
    otherLook: 'Cupertino',
    budget: 94 * 1024,
    excludedFiles: {
      'package:cupertino_ui/src/radio.dart', // material_ui's Radio keeps its `.adaptive` arm: https://github.com/flutter/flutter/issues/195489
      'package:cupertino_ui/src/checkbox.dart', // material_ui's Checkbox, keeps its `.adaptive` arm: https://github.com/flutter/flutter/issues/195489
    },
  ),

  /// Keeps material_ui's bundled assets and the `TimeOfDay` the time picker takes. Matching by name
  /// also catches Flutter's `FrameAwaitingMaterialization`, a few stray bytes.
  ios(reportType: 'ios', otherLook: 'Material', budget: 16 * 1024);

  bool excludes(_Symbol symbol) => excludedFiles.any((file) => symbol.path.contains('$file/'));
}

/// Number of top offenders to print on failure.
const _maxOffendersShown = 30;

/// `flutter build --analyze-size` writes its report here, named for its type, and keeps the earlier ones.
final _reportsDir = Directory('${Platform.environment['HOME']!}/.flutter-devtools');
final _reportName = RegExp(
  '^(${_Build.values.map((build) => build.reportType).join('|')})-code-size-analysis_.*\\.json\$',
);

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

  final rootNode = _Node(jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
  final build = _Build.values.where((build) => build.reportType == rootNode.type).firstOrNull;
  if (build == null) {
    stderr.writeln('No budget for "${rootNode.type}" reports: ${file.path}');
    exit(65);
  }

  final lookName = build.otherLook.toLowerCase();
  final symbols = _symbolsMentioning(lookName, rootNode, rootNode.name);
  final countedSymbols = symbols.where((symbol) => !build.excludes(symbol)).toList(growable: false)
    ..sort((a, b) => b.bytes.compareTo(a.bytes));
  final countedBytes = countedSymbols.fold<int>(0, (sum, symbol) => sum + symbol.bytes);
  final excludedBytes = symbols
      .where(build.excludes)
      .fold<int>(0, (sum, symbol) => sum + symbol.bytes);

  const reportIndent = '  ';
  stdout
    ..writeln('AOT-pruning size-regression check, ${build.name}')
    ..writeln('${reportIndent}source: ${file.path}')
    ..writeln('$reportIndent$lookName-pathed symbols: ${countedSymbols.length}')
    ..writeln('$reportIndent$lookName-pathed bytes:   $countedBytes (budget: ${build.budget})')
    ..writeln('${reportIndent}left out, held whole by the drawn look: $excludedBytes');

  if (countedBytes <= build.budget) return stdout.writeln('  PASS');

  stderr
    ..writeln('\nFAIL: $lookName-pathed bytes ($countedBytes) exceed budget (${build.budget}).')
    ..writeln(
      'Likely a public `showPlatformXxx` helper takes both looks again, or `designLanguage` lost its '
      'pragma, so the ${build.otherLook} arm no longer drops out. '
      'See APPENDIX.md#aot-pruning-rules and test/aot_pruning_regression_test.dart.',
    )
    ..writeln('\nTop $_maxOffendersShown by size:');
  countedSymbols
      .take(_maxOffendersShown)
      .forEach(
        (symbol) =>
            stderr.writeln('$reportIndent${symbol.bytes.toString().padLeft(8)} B  ${symbol.path}'),
      );
  if (countedSymbols.length > _maxOffendersShown) {
    stderr.writeln('$reportIndent... and ${countedSymbols.length - _maxOffendersShown} more.');
  }

  exit(1);
}

File? _newestReport() {
  if (!_reportsDir.existsSync()) return null;

  final reportFiles =
      _reportsDir
          .listSync()
          .whereType<File>()
          .where((file) => _reportName.hasMatch(file.uri.pathSegments.last))
          .toList(growable: false)
        ..sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));

  return reportFiles.lastOrNull;
}

/// The leaves under [node], at [path], whose path mentions [lookName]. A look's name holds no `/`, so
/// a path mentions it exactly when one of its names does.
List<_Symbol> _symbolsMentioning(String lookName, _Node node, String path) =>
    node.name.toLowerCase().contains(lookName)
    ? _leaves(node, path)
    : [
        // Spreads here and in `_leaves`, not `expand`: AOT walks a big report a little faster.
        for (final child in node.children)
          ..._symbolsMentioning(lookName, child, '$path/${child.name}'),
      ];

/// Every leaf under [node], at [path].
List<_Symbol> _leaves(_Node node, String path) => node.children.isEmpty
    ? [if (node.bytes case final bytes?) _Symbol(path, bytes)]
    : [for (final child in node.children) ..._leaves(child, '$path/${child.name}')];

class _Symbol(final String path, final int bytes);

/// A node of the `--analyze-size` tree.
extension type const _Node(Map<String, dynamic> _json) {
  String get name => _json['n']?.toString() ?? '';

  /// The report's platform, set on the root only.
  String? get type => _json['type']?.toString();

  Iterable<_Node> get children =>
      (_json['children'] as List?)?.cast<Map<String, dynamic>>().map(_Node.new) ?? const [];

  int? get bytes => (_json['value'] as num?)?.toInt();
}
