// Named for the guard, not for its one private helper class.
// ignore_for_file: prefer-match-file-name

@TestOn('vm')
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

final _docFence = RegExp(r'^\s*///\s*```dart\s*$');
final _directive = RegExp(r'\{@example\s+(\S+?)#(\S+?)\}');

void main() {
  group('Doc example guard', () {
    test('no hand-written ```dart fence remains in lib/', () {
      final offenders = _dartFiles('lib').expand(
        (file) => file
            .readAsLinesSync()
            .indexed
            .where((entry) => _docFence.hasMatch(entry.$2))
            .map((entry) => '${file.path}:${entry.$1 + 1}'),
      );

      check(
        because:
            'Fence code is never compiled, so it rots silently. Move the example to '
            'example/lib/snippets/ (mirroring its lib/src/widgets/ path) and reference '
            'it with {@example <path>#<region>}.',
        offenders,
      ).isEmpty();
    });

    test('every {@example} reference resolves to a real file and region', () {
      final broken = _directives()
          .where((ref) => !ref.resolves)
          .map((ref) => '${ref.origin} -> ${ref.path}#${ref.region}');

      check(
        because:
            'dart doc only warns on a broken ref and still exits 0, so the example '
            'just vanishes from the rendered page. Nothing else catches this.',
        broken,
      ).isEmpty();
    });

    test('finds the directives at all (guards against a vacuous pass)', () {
      check(
        because:
            'No {@example} found under lib/. Either the examples are gone, or this '
            'guard is scanning the wrong place and the checks above are passing on an '
            'empty set.',
        _directives().length,
      ).isGreaterThan(20);
    });
  });
}

Iterable<_ExampleRef> _directives() => _dartFiles('lib').expand(
  (file) => file.readAsLinesSync().indexed.expand(
    (entry) => _directive
        .allMatches(entry.$2)
        .map(
          (match) => _ExampleRef(
            origin: '${file.path}:${entry.$1 + 1}',
            path: match.group(1)!,
            region: match.group(2)!,
          ),
        ),
  ),
);

Iterable<File> _dartFiles(String root) =>
    Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

final class const _ExampleRef({
  required final String origin,
  required final String path,
  required final String region,
}) {
  bool get resolves {
    // dartdoc writes the path from the package root, so the leading slash is not a mount point.
    final target = File(path.replaceFirst(RegExp('^/'), ''));
    if (!target.existsSync()) return false;

    return target.readAsLinesSync().any(
      (line) => RegExp('^\\s*//\\s*#region\\s+${RegExp.escape(region)}\\s*\$').hasMatch(line),
    );
  }
}
