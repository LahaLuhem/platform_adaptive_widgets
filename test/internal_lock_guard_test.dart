// Internal-lock guard for APPENDIX.md#public-api-via-single-export-file.

@TestOn('vm')
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/lib_src.dart';

void main() {
  group('Internal-lock guard', () {
    test("every public declaration in a lib/src file the barrel doesn't export is @internal", () {
      final declarations = libSrcUnits
          .where((unit) => !exportedPaths.contains(unit.path))
          .expand(
            (unit) => unit.parsed.unit.declarations
                .where((member) => _publicNames(member).isNotEmpty)
                .map((member) => (unit: unit, member: member)),
          )
          .toList(growable: false);
      check(
        because: 'Found no unexported declaration at all, so the check below passes on nothing.',
        declarations,
      ).isNotEmpty();
      check(
        because:
            'Another package can import anything in lib/src, and `@internal` makes that a warning.',
        declarations
            .where(
              (declaration) => !declaration.member.metadata.any(
                (annotation) => annotation.name.name == 'internal',
              ),
            )
            .map(
              (declaration) =>
                  '${declaration.unit.locate(declaration.member)}: '
                  '${_publicNames(declaration.member).join(', ')}',
            ),
      ).isEmpty();
    });
  });
}

Iterable<String> _publicNames(CompilationUnitMember member) =>
    declaredNames(member).where((name) => !name.startsWith('_'));
