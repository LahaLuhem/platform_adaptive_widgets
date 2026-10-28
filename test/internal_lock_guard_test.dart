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
      check(declarations).isNotEmpty();
      check(
        because:
            'Another package can import anything in lib/src, and `@internal` makes that a warning.',
        declarations
            .where(
              (declaration) => !declaration.member.metadata.any(
                (annotation) => annotation.name.name == 'internal',
              ),
            )
            .map((declaration) {
              final loc = declaration.unit.parsed.lineInfo.getLocation(
                declaration.member.firstTokenAfterCommentAndMetadata.offset,
              );

              return '${declaration.unit.path}:${loc.lineNumber}: '
                  '${_publicNames(declaration.member).join(', ')}';
            }),
      ).isEmpty();
    });
  });
}

Iterable<String> _publicNames(CompilationUnitMember member) => switch (member) {
  ClassDeclaration(:final namePart) ||
  EnumDeclaration(:final namePart) ||
  ExtensionTypeDeclaration(:final namePart) => [namePart.typeName.lexeme],
  MixinDeclaration(:final name) ||
  FunctionDeclaration(:final name) ||
  TypeAlias(:final name) => [name.lexeme],
  ExtensionDeclaration(:final name) => [?name?.lexeme],
  TopLevelVariableDeclaration(:final variables) => [
    for (final variable in variables.variables) variable.name.lexeme,
  ],
  // Loud, so a new kind of declaration can't slip past unchecked.
  _ => throw UnsupportedError('No public names known for ${member.runtimeType}'),
}.where((name) => !name.startsWith('_'));
