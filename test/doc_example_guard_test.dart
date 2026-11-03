@TestOn('vm')
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

final _docFence = RegExp(r'^\s*///\s*```dart\s*$');

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

    test('finds the Dart files at all (guards against a vacuous pass)', () {
      check(
        because:
            'No Dart file found under lib/, so this guard is scanning the wrong place and the '
            'check above is passing on an empty set.',
        _dartFiles('lib'),
      ).isNotEmpty();
    });
  });
}

Iterable<File> _dartFiles(String root) =>
    Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
