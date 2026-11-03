/// What the entry point tells the feature tree about itself, which is only ever the navigation mode.
/// That lets router-only affordances branch at runtime instead of forking the code.
final class const AppArgs({
  /// `false` from `main.dart`, `true` from `main_go_router.dart`.
  final bool isUsingGoRouter = false,
});
