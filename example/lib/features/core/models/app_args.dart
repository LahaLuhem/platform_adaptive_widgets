/// Cross-cutting args threaded from the entry point into the feature tree.
///
/// The only thing a feature needs to know about the host is which navigation
/// mode is running, so router-only affordances (sub-route pushes) can branch
/// without compile-time forking. `main.dart` passes the default
/// (`isUsingGoRouter: false`); `main_go_router.dart` passes `true`.
final class AppArgs {
  /// Whether the app is running through `go_router` (vs the Navigator entry
  /// point).
  final bool isUsingGoRouter;

  /// Creates [AppArgs].
  const AppArgs({this.isUsingGoRouter = false});
}
