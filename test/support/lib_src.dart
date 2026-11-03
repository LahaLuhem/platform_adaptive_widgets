// Named after what it parses, not after its visitor interface.
// ignore_for_file: prefer-match-file-name

/// `lib/src`, parsed once for the static guards. Deliberately kept out of `support.dart`.
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

/// A parsed `lib/src` file, with its path from the package root.
typedef LibSrcUnit = ({String path, String basename, ParseStringResult parsed});

/// The 2 halves a `PlatformWidgetBase` builds its looks in.
const lookHalves = (material: 'buildMaterial', cupertino: 'buildCupertino');

/// Every Dart file under [root], a folder from the package root.
Iterable<File> dartFilesUnder(String root) =>
    Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

/// Every Dart file under `lib/src`.
final List<LibSrcUnit> libSrcUnits = dartFilesUnder('lib/src')
    .map(
      (dartFile) => (
        path: dartFile.path,
        basename: dartFile.uri.pathSegments.last,
        parsed: parseFile(
          path: dartFile.absolute.path,
          featureSet: FeatureSet.latestLanguageVersion(),
        ),
      ),
    )
    .toList(growable: false);

/// The paths the barrel exports, in the same form as [LibSrcUnit]'s.
final Set<String> exportedPaths =
    parseFile(
          path: File('lib/platform_adaptive_widgets.dart').absolute.path,
          featureSet: FeatureSet.latestLanguageVersion(),
        ).unit.directives
        .whereType<ExportDirective>()
        .map((export) => 'lib/${export.uri.stringValue}')
        .toSet();

/// `path:line` for [offset] in the file at [path], the path from the package root.
String pathLine(String path, LineInfo lineInfo, int offset) =>
    '${path.replaceFirst('${Directory.current.path}/', '')}:'
    '${lineInfo.getLocation(offset).lineNumber}';

/// Where a node sits in a [LibSrcUnit].
extension LibSrcLocation on LibSrcUnit {
  /// `path:line` of [node], a declaration's own line rather than its doc comment's.
  String locate(AstNode node) => pathLine(
    path,
    parsed.lineInfo,
    node is AnnotatedNode ? node.firstTokenAfterCommentAndMetadata.offset : node.offset,
  );
}

/// The names [member] declares, none for an unnamed extension.
Iterable<String> declaredNames(CompilationUnitMember member) => switch (member) {
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
  _ => throw UnsupportedError('No names known for ${member.runtimeType}'),
};

/// Whether [node] reads [name] in code, not in a doc comment that names it.
bool readsInCode(SimpleIdentifier node, String name) =>
    node.name == name && node.thisOrAncestorOfType<Comment>() == null;

/// A visitor that notes each thing it finds wrong, as one line.
abstract interface class OffenderVisitor() implements AstVisitor<void> {
  /// What it found, one line each.
  List<String> get offenders;
}

/// A fresh [visitorFor] run over each of [units], for a guard that also counts what it saw.
List<V> visitAll<V extends AstVisitor<void>>(
  Iterable<LibSrcUnit> units,
  V Function(LibSrcUnit unit) visitorFor,
) => units
    .map((unit) {
      final visitor = visitorFor(unit);
      unit.parsed.unit.accept(visitor);

      return visitor;
    })
    .toList(growable: false);

/// Everything a fresh [visitorFor] finds wrong in each of [units].
Iterable<String> offendersIn(
  Iterable<LibSrcUnit> units,
  OffenderVisitor Function(LibSrcUnit unit) visitorFor,
) => visitAll(units, visitorFor).expand((visitor) => visitor.offenders);

/// [libSrcUnits] but the files named [basenames], each a rule's own home.
Iterable<LibSrcUnit> libSrcUnitsExcept(Set<String> basenames) =>
    libSrcUnits.where((unit) => !basenames.contains(unit.basename));

/// The instance fields [node] declares, in its body or its primary constructor.
Set<String> instanceFieldNames(ClassDeclaration node) => {
  ...node.body.members
      .whereType<FieldDeclaration>()
      .where((member) => !member.isStatic)
      .expand((member) => member.fields.variables)
      .map((variable) => variable.name.lexeme),
  // A primary constructor declares a field for each of its `final` or `var` parameters.
  if (node.namePart case PrimaryConstructorDeclaration(:final formalParameters))
    ...formalParameters.parameters
        .where(
          (parameter) => const {'final', 'var'}.contains(parameter.constFinalOrVarKeyword?.lexeme),
        )
        .map((parameter) => parameter.name!.lexeme),
};
