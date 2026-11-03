// Named after what it reads, not after its visitor interface.
// ignore_for_file: prefer-match-file-name

/// `lib/`, read for the guards and for the tests that check their coverage against it. Deliberately
/// kept out of `support.dart`.
library;

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:collection/collection.dart' show IterableExtension;

/// A `lib/src` file's syntax tree, with its path from the package root.
typedef LibSrcUnit = ({String path, String basename, CompilationUnit ast});

/// The 2 halves a `PlatformWidgetBase` builds its looks in.
const lookHalves = (material: 'buildMaterial', cupertino: 'buildCupertino');

/// Every Dart file under [root], a folder from the package root.
Iterable<File> dartFilesUnder(String root) =>
    Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

/// `lib/src`, parsed: the syntax alone, at once.
final List<LibSrcUnit> parsedLibSrc = dartFilesUnder('lib/src')
    .map((file) => _libSrcUnit(file.path, _parse(file.path)))
    .toList(growable: false);

/// `lib/`, analyzed: the syntax with its types. It takes seconds, so the guards share one run from
/// `test/guards/guards_test.dart`.
final Future<List<ResolvedUnitResult>> analyzedLib = _analyzeLib();

/// [analyzedLib]'s `lib/src` files.
final Future<List<LibSrcUnit>> analyzedLibSrc = analyzedLib.then(
  (results) => [
    for (final result in results)
      if (_fromRoot(result.path).startsWith('lib/src/')) _libSrcUnit(result.path, result.unit),
  ],
);

/// Whether the barrel exports [name] from the `lib/` file at [path], through nested exports and past
/// every `show` and `hide` on the way.
bool isExported(String path, String name) =>
    !name.startsWith('_') &&
    (_routes[_fromRoot(path)]?.any((route) => route.letsOut(name)) ?? false);

/// `path:line` for [offset] in the file at [path], the path from the package root.
String pathLine(String path, LineInfo lineInfo, int offset) =>
    '${_fromRoot(path)}:${lineInfo.getLocation(offset).lineNumber}';

/// Where a node sits in a [LibSrcUnit].
extension LibSrcLocation on LibSrcUnit {
  /// `path:line` of [node], a declaration's own line rather than its doc comment's.
  String locate(AstNode node) => pathLine(
    path,
    ast.lineInfo,
    node is AnnotatedNode ? node.firstTokenAfterCommentAndMetadata.offset : node.offset,
  );
}

/// What the barrel lets out of a [LibSrcUnit].
extension LibSrcExports on LibSrcUnit {
  /// Whether the barrel exports [member] under one of its names.
  bool barrelExports(CompilationUnitMember member) =>
      declaredNames(member).any((name) => isExported(path, name));
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

/// The `DesignLanguage` look [pattern] alone matches, by its constant's value on an analyzed unit,
/// whatever the spelling. `null` for a `_`, an `||`, a `when`, or a constant that isn't a look.
String? lookOf(GuardedPattern pattern) => switch (pattern) {
  GuardedPattern(whenClause: null, pattern: ConstantPattern(:final expression)) =>
    switch (expression.computeConstantValue()?.value) {
      final value?
          when value.type?.element?.name == 'DesignLanguage' && isOurs(value.type?.element) =>
        value.getField('_name')?.toStringValue(),
      _ => null,
    },
  _ => null,
};

/// Whether [type] is one of the package's per-look records, a `Material…Data` or `Cupertino…Data`.
bool isLookRecord(DartType? type) => switch (type) {
  InterfaceType(:final element) =>
    isOurs(element) &&
        (element.name ?? '').startsWith(RegExp('Material|Cupertino')) &&
        (element.name ?? '').endsWith('Data'),
  _ => false,
};

/// Whether [element] is the package's own, not a dependency's.
bool isOurs(Element? element) => element?.library?.uri.pathSegments.firstOrNull == _package;

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
      unit.ast.accept(visitor);

      return visitor;
    })
    .toList(growable: false);

/// Everything a fresh [visitorFor] finds wrong in each of [units].
Iterable<String> offendersIn(
  Iterable<LibSrcUnit> units,
  OffenderVisitor Function(LibSrcUnit unit) visitorFor,
) => visitAll(units, visitorFor).expand((visitor) => visitor.offenders);

/// Narrows a list of [LibSrcUnit]s.
extension LibSrcUnits on Iterable<LibSrcUnit> {
  /// These but the files named [basenames], each a rule's own home.
  Iterable<LibSrcUnit> except(Set<String> basenames) =>
      where((unit) => !basenames.contains(unit.basename));
}

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

LibSrcUnit _libSrcUnit(String path, CompilationUnit ast) {
  final fromRoot = _fromRoot(path);

  return (path: fromRoot, basename: fromRoot.split('/').last, ast: ast);
}

String _fromRoot(String path) => path.replaceFirst('${Directory.current.path}/', '');

CompilationUnit _parse(String path) =>
    parseFile(path: File(path).absolute.path, featureSet: FeatureSet.latestLanguageVersion()).unit;

const _package = 'platform_adaptive_widgets';

const _barrel = 'lib/$_package.dart';

typedef _Route = ({String path, bool Function(String name) letsOut});

/// Each way out through the barrel, by the file it leaves.
final Map<String, List<_Route>> _routes = _routesFrom(_barrel, (_) => true, const {
  _barrel,
}).groupListsBy((route) => route.path);

final Map<String, CompilationUnit> _parsedByPath = {
  for (final unit in parsedLibSrc) unit.path: unit.ast,
};

/// Every file [path] exports, nested ones included, each letting out what [letsOut] and its own
/// `show` and `hide` do. [chain] stops an export cycle.
Iterable<_Route> _routesFrom(
  String path,
  bool Function(String name) letsOut,
  Set<String> chain,
) sync* {
  final ast = _parsedByPath[path] ?? _parse(path);
  for (final export in ast.directives.whereType<ExportDirective>()) {
    final target = _ownFile(path, export.uri.stringValue ?? '');
    if (target == null || chain.contains(target)) continue;
    bool through(String name) =>
        letsOut(name) && export.combinators.every((combinator) => _lets(combinator, name));
    yield (path: target, letsOut: through);
    yield* _routesFrom(target, through, {...chain, target});
  }
}

/// The `lib/` file [uri] points at from the one at [from], resolved as the compiler does, or `null`
/// for another package's.
String? _ownFile(String from, String uri) =>
    switch (Uri.parse('package:$_package/${from.replaceFirst('lib/', '')}').resolve(uri)) {
      Uri(scheme: 'package', pathSegments: [_package, ...final rest]) => 'lib/${rest.join('/')}',
      _ => null,
    };

bool _lets(Combinator combinator, String name) => switch (combinator) {
  ShowCombinator(:final shownNames) => shownNames.any((shown) => shown.name == name),
  HideCombinator(:final hiddenNames) => hiddenNames.every((hidden) => hidden.name != name),
};

Future<List<ResolvedUnitResult>> _analyzeLib() async {
  final collection = AnalysisContextCollection(
    includedPaths: [Directory('lib').absolute.path],
    // `flutter test` runs on flutter_tester, which the analyzer can't take for a Dart SDK.
    sdkPath: '${Platform.environment['FLUTTER_ROOT']}/bin/cache/dart-sdk',
  );

  return (await collection.contexts
          .expand(
            (context) => context.contextRoot
                .analyzedFiles()
                .where((path) => path.endsWith('.dart'))
                .map(context.currentSession.getResolvedUnit),
          )
          .wait)
      .whereType<ResolvedUnitResult>()
      .toList(growable: false);
}
