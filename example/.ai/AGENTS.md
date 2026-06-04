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
- **Layout — strict, per-feature.** Every feature under `lib/features/<feature>/`
  follows the same shape; do **not** scatter "relaxed" placements:
  - `data/models/`, `data/enums/`, `data/extensions/` — the feature's models, enums,
    and extensions.
  - `widgets/` — widgets used **only** by this feature. A widget (or helper/extension)
    used by more than one feature is genuinely shared and lives under
    `lib/features/core/`; if only one feature uses it, it belongs in that feature.
  - `views/` — the screens: the feature's own `<feature>_view.dart` +
    `<feature>_view_model.dart` at the top, and each sub-screen in its own folder
    (e.g. `views/buttons_demo/buttons_demo_view.dart` + `…_view_model.dart`).

  A view-only feature (no observable state, e.g. `about/`, `root/`) omits the
  view-model. `core/` holds only what is genuinely cross-feature (currently just
  `data/models/app_args.dart`); router config lives under `lib/app/router/`. The MVVM
  scaffold uses [pmvvm](https://pub.dev/packages/pmvvm); see
  [`CODESTYLE.md#mvvm-architecture`](../CODESTYLE.md#mvvm-architecture) for how the
  view/view-model pair is wired.
