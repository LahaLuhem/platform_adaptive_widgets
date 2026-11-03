@TestOn('vm')
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/lib_src.dart';

/// A doc comment's ``` fence, with its language as the group.
final _docFence = RegExp(r'^\s*///\s*```(\w*)\s*$');

void main() {
  group('Doc example guard', () {
    test('no hand-written ```dart or bare ``` fence remains in lib/', () {
      check(
        because:
            'Fence code is never compiled, so it rots silently. Move the example to '
            'example/lib/snippets/ (mirroring its lib/src/widgets/ path) and reference '
            'it with {@example <path>#<region>}.',
        dartFilesUnder('lib').expand(_dartFences),
      ).isEmpty();
    });

    test('finds the Dart files at all (guards against a vacuous pass)', () {
      check(
        because:
            'No Dart file found under lib/, so this guard is scanning the wrong place and the '
            'check above is passing on an empty set.',
        dartFilesUnder('lib'),
      ).isNotEmpty();
    });
  });
}

/// `path:line` of each fence in [file] that opens a block of Dart.
Iterable<String> _dartFences(File file) sync* {
  var isOpen = false;
  for (final (index, line) in file.readAsLinesSync().indexed) {
    final language = _docFence.firstMatch(line)?[1];
    if (language == null) continue;
    isOpen = !isOpen;
    // dartdoc reads an untagged fence as Dart.
    if (isOpen && (language.isEmpty || language == 'dart')) yield '${file.path}:${index + 1}';
  }
}
