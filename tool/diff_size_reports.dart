// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:io';

const _usage = 'Usage: dart tool/diff_size_reports.dart <before.json> <after.json> [path filter]';

const _rows = 25;

/// Name salts (`_build@123`), which differ between 2 builds of the same code.
final _nameSalt = RegExp(r'@\d+');

/// Lists what moved between 2 `--analyze-size` reports, biggest first. A filter keeps only the paths
/// that mention it.
void main(List<String> args) {
  if (args.length < 2 || args.length > 3) {
    stderr.writeln(_usage);
    exit(64);
  }
  final filter = args.length == 3 ? args[2].toLowerCase() : '';
  final before = _leafBytes(File(args.first), filter);
  final after = _leafBytes(File(args[1]), filter);
  int moved(String path) => (after[path] ?? 0) - (before[path] ?? 0);
  final movedPaths =
      {...before.keys, ...after.keys}.where((path) => moved(path) != 0).toList(growable: false)
        ..sort((a, b) => moved(b).abs().compareTo(moved(a).abs()));

  stdout
    ..writeln(
      'total ${_total(before)} B -> ${_total(after)} B: ${_total(after) - _total(before)} B',
    )
    ..writeln('${movedPaths.length} leaves moved');
  for (final path in movedPaths.take(_rows)) {
    stdout.writeln('${moved(path).toString().padLeft(8)} B  $path');
  }
}

int _total(Map<String, int> leafBytes) => leafBytes.values.fold(0, (sum, bytes) => sum + bytes);

Map<String, int> _leafBytes(File report, String filter) {
  final leafBytes = <String, int>{};
  void walk(_Node node, String path) {
    if (node.children.isEmpty) {
      if (node.bytes case final bytes? when path.toLowerCase().contains(filter)) {
        leafBytes.update(path, (sum) => sum + bytes, ifAbsent: () => bytes);
      }

      return;
    }
    for (final child in node.children) {
      walk(child, '$path/${child.name.replaceAll(_nameSalt, '')}');
    }
  }

  final root = _Node(jsonDecode(report.readAsStringSync()) as Map<String, dynamic>);
  walk(root, root.name);

  return leafBytes;
}

/// A node of the `--analyze-size` tree.
extension type const _Node(Map<String, dynamic> _json) {
  String get name => _json['n']?.toString() ?? '';

  Iterable<_Node> get children =>
      (_json['children'] as List?)?.cast<Map<String, dynamic>>().map(_Node.new) ?? const [];

  int? get bytes => (_json['value'] as num?)?.toInt();
}
