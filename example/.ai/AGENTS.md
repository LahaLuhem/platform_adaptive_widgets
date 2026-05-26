# AGENTS.md — `example/`

Tool-agnostic brief for the runnable demo app under `example/`. Library-package
conventions live in the parent [`AGENTS.md`](../../.ai/AGENTS.md);
example-specific code style (MVVM, naming, widget composition, …) lives in
[`CODESTYLE.md`](../CODESTYLE.md). Read both before working in this subdirectory.

## Scope
- Runnable demo of `platform_adaptive_widgets` — showcases the public widgets on both
  Android and iOS and demonstrates the recommended usage patterns (MVVM, ValueNotifier
  reactivity, go_router integration).
- Not published to pub.dev (`publish_to: 'none'` in `pubspec.yaml`). No semver
  discipline. Freely depends on Flutter and ecosystem packages.
- **Two `main` entry points:**
  - [`lib/main.dart`](../lib/main.dart) — boots `PlatformApp` with a router-less
    `PlatformTabScaffold` (the scaffold owns tab selection state).
  - [`lib/main_go_router.dart`](../lib/main_go_router.dart) — boots
    `PlatformApp.router` with `go_router`'s `StatefulNavigationShell` (the router
    owns tab selection state).

  Both entry points share the feature tree under `lib/features/`. Run them with
  `flutter run -t lib/main.dart` or `flutter run -t lib/main_go_router.dart`. See
  [`APPENDIX.md#two-entry-point-example`](../../APPENDIX.md#two-entry-point-example).
- **Layout:** each feature is a pair under `lib/features/<feature>/` —
  `<feature>_view.dart` + `<feature>_view_model.dart`. Features that have no
  observable state (e.g. `settings/`) may ship a view-only file. The MVVM scaffold
  uses [pmvvm](https://pub.dev/packages/pmvvm); see
  [`CODESTYLE.md#mvvm-architecture`](../CODESTYLE.md#mvvm-architecture) for the
  conventions that govern how the pair is wired. Shared widgets and consts live under
  `lib/features/core/`; router config lives under `lib/app/router/`.
