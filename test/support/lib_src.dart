/// `lib/src`, parsed once for the static guards. Kept out of `support.dart`, which the widget tests
/// import.
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// A parsed `lib/src` file, with its path from the package root.
typedef LibSrcUnit = ({String path, String basename, ParseStringResult parsed});

/// Every Dart file under `lib/src`.
final List<LibSrcUnit> libSrcUnits = Directory('lib/src')
    .listSync(recursive: true)
    .whereType<File>()
    .where((file) => file.path.endsWith('.dart'))
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
