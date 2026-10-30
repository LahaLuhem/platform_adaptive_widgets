// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:io';

const _usage = 'Usage: dart tool/diff_size_reports.dart <before.json> <after.json> [rows]';

const _defaultRows = 25;

/// Name salts (`_build@123`), which differ between 2 builds of the same code.
final _nameSalt = RegExp(r'@\d+');

/// Lists what moved between 2 `--analyze-size` reports, biggest first.
void main(List<String> args) {
  final rows = args.length == 3 ? int.tryParse(args[2]) : _defaultRows;
  if (args.length < 2 || args.length > 3 || rows == null) {
    stderr.writeln(_usage);
    exit(64);
  }
  final before = _leafBytes(File(args.first));
  final after = _leafBytes(File(args[1]));
  int moved(String path) => (after[path] ?? 0) - (before[path] ?? 0);
  final movedPaths =
      {...before.keys, ...after.keys}.where((path) => moved(path) != 0).toList(growable: false)
        ..sort((a, b) => moved(b).abs().compareTo(moved(a).abs()));

  stdout
    ..writeln(
      'total ${_total(before)} B -> ${_total(after)} B: ${_total(after) - _total(before)} B',
    )
    ..writeln('${movedPaths.length} leaves moved');
  for (final path in movedPaths.take(rows)) {
    stdout.writeln('${moved(path).toString().padLeft(8)} B  $path');
  }
}

int _total(Map<String, int> leafBytes) => leafBytes.values.fold(0, (sum, bytes) => sum + bytes);

Map<String, int> _leafBytes(File report) {
  final leafBytes = <String, int>{};
  void walk(_Node node, String path) {
    if (node.children.isEmpty) {
      if (node.bytes case final bytes?) {
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
