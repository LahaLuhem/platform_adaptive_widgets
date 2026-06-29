# AGENTS.md — `platform_adaptive_widgets`

Tool-agnostic brief for any coding agent (Copilot, Cursor, Codex, Claude Code, …) working
in this package. Claude-Code-specific guidance lives in [CLAUDE.md](./CLAUDE.md).

## Project goal
A Flutter package providing **platform-adaptive widgets** — a spiritual continuation of
[`flutter_platform_widgets`](https://pub.dev/packages/flutter_platform_widgets). Each
`PlatformXxx` widget automatically renders **Material** on Android and **Cupertino** on
iOS, so app code never needs explicit `Platform.isAndroid` / `Platform.isIOS` branching.

Public API in v1.x is stable: `PlatformXxx` widgets + per-platform `MaterialXxxData` /
`CupertinoXxxData` tuning records + cross-platform `PlatformXxxData` unified params. See
README for the full widget catalogue; APPENDIX for design rationale.

## Stack
- **Flutter ≥ 3.38**, **Dart ≥ 3.10** (both pinned in `pubspec.yaml`). Dart 3.10 is the
  floor because of the static dot-shorthand feature; bump only when a new language
  feature is actually consumed. `.fvmrc` pins the Flutter channel to `stable` for local
  use — whatever toolchain manager serves it (FVM, asdf, plain `flutter`) is a local
  implementation detail.
- **`flutter analyze`** (or `dart analyze` for the pure-Dart subset) for pedantic static
  analysis. The lint posture is deliberately strict — see `analysis_options.yaml` for
  `strict-casts`, `strict-inference`, `strict-raw-types`, plus the
  `errors:`-promoted rules. Pedantic mode is intentional, not negotiable.
- **`flutter_test`** for widget / unit tests.
- **CLI linting via the [linterpol](https://github.com/LahaLuhem/linterpol) Docker image.**
  Shell scripts (`shellcheck`) and GitHub workflows (`actionlint`) are linted by running
  the public, multi-arch `ghcr.io/lahaluhem/linterpol:latest` image
  (`docker run --rm -v "$PWD:/work:ro" "$LINTERPOL_IMAGE" <tool>`), not hand-installed
  tools. CI jobs live in `.github/workflows/repo.yml`; `scripts/release.sh` runs
  `shellcheck` the same way (image-only, so Docker must be running). Don't reintroduce
  `brew` / `pip` / `uv` linter installs; the image ref is one `LINTERPOL_IMAGE` var per
  file (swap to a digest there to pin).
- **Android + iOS only.** `platforms:` in `pubspec.yaml` declares the supported set; the
  `PlatformWidgetBase.build` switch throws `UnsupportedError` for anything else.
- **Published to pub.dev.** `.pubignore` controls what ships in the tarball. The
  `.github/workflows/publish.yml` workflow fires on a pushed semver tag
  (`{{version}}`) and publishes via OIDC (configured by `dart-lang/setup-dart`). The
  job is inlined — not the reusable
  `dart-lang/setup-dart/.github/workflows/publish.yml@v1` — so it can run
  `flutter pub get --no-example`, which keeps `example/pubspec.lock` byte-identical
  through the publish dry-run. No manual `flutter pub publish` invocation.
- **`CHANGELOG.md`, the `version:` field in `pubspec.yaml`, and the release tag** are
  the three things that must move in lockstep for a release. CHANGELOG entries are
  appended automatically by `.github/workflows/changelog.yml` on every merged PR
  (driven by the PR's `sem-*` label and the `cider:` block in `pubspec.yaml`); no
  manual append is needed during routine PR work. Cutting a release is one command:
  `scripts/release.sh [patch|minor|major]` — full mechanics, preflight, and
  pipeline-owned-files rules in [`scripts/README.md`](../scripts/README.md).

## Repo layout
```
platform_adaptive_widgets/
├── lib/
│   ├── platform_adaptive_widgets.dart         Public entry; `export 'src/…'` only
│   └── src/
│       ├── extensions/                         BuildContext / DateTime / TimeOfDay
│       ├── models/                             Value types + per-widget *Data records
│       │   ├── platform_widget_base.dart       Abstract base hierarchy (see APPENDIX)
│       │   ├── platform_adaptive_icons.dart    Icon mapping helper
│       │   ├── date.dart                       Calendar-date value type
│       │   ├── dialogs/                        Per-dialog *Data classes + consts
│       │   ├── interaction/                    Per-interaction-widget *Data classes
│       │   ├── layout/                         Per-layout-widget *Data classes
│       │   └── painting/                       Per-painting-widget *Data classes
│       │       └── platform_theme.dart         Cross-platform theme accessor
│       ├── utils/
│       │   └── target_platform.dart            `defaultTargetPlatform` shim
│       └── widgets/                            Concrete widget impls (mirrors models/)
│           ├── platform_widget.dart            Standalone `PlatformWidget` helper
│           ├── dialogs/                        `showPlatformXxx` + `PlatformXxx` dialogs
│           ├── interaction/                    `PlatformButton`/`Switch`/`Slider`/…
│           ├── layout/                         `PlatformApp` / `Scaffold` / `AppBar` / …
│           └── painting/                       `PlatformListTile` / `ProgressIndicator`
├── example/                                    Runnable Flutter demo (see example/.ai/AGENTS.md)
├── analysis_options.yaml                       Strict-mode + opinionated lints
├── pubspec.yaml                                Deps + platforms + topics
├── .pubignore                                  Files excluded from `flutter pub publish`
├── .fvmrc                                      FVM channel pin (`stable`)
├── .github/workflows/                          CI: pr-conventions, changelog, package,
│                                                example, repo, publish (tag-triggered)
├── CHANGELOG.md                                Release log (bot-appended on merge,
│                                                hand-finalised at release)
├── README.md                                   pub.dev landing page (widget catalogue)
├── APPENDIX.md                                 Design rationale (anchor-keyed)
├── CODESTYLE.md                                Library-package code style
└── .ai/                                        This file + CLAUDE.md (symlinked)
```

**`models/` and `widgets/` mirror each other.** Every concrete widget under
`lib/src/widgets/<category>/platform_xxx.dart` has a matching data class (or family of
data classes) under `lib/src/models/<category>/platform_xxx_data.dart`. The same
sub-categories — `dialogs/`, `interaction/`, `layout/`, `painting/` — appear in both
trees. When adding a new widget, add its `*Data` siblings under the same category in
`models/` (see [`APPENDIX.md#models-widgets-mirror-layout`](../APPENDIX.md#models-widgets-mirror-layout)).

**The widget pattern (every `PlatformXxx`):**
1. Extends one of `PlatformWidgetBase` / `PlatformWidgetKeyedBase` /
   `PlatformWidgetBuilderBase` / `PlatformWidgetKeyedBuilderBase` from
   [`lib/src/models/platform_widget_base.dart`](../lib/src/models/platform_widget_base.dart).
2. Overrides `buildMaterial(context)` and `buildCupertino(context)`. The abstract base's
   `build` is `@nonVirtual` — it switches on `defaultTargetPlatform` and delegates. Don't
   override `build` directly.
3. Constructor shape — every field falls into one of three buckets:
   - **Functional + shared visual**: flat `const` params on the widget itself
     (callbacks, value, controllers, state-gating, plus visual fields that
     exist on both platforms with possible per-platform override).
   - **Material-only visual**: pass via `materialXxxData: MaterialXxxData(…)`.
   - **Cupertino-only visual**: pass via `cupertinoXxxData: CupertinoXxxData(…)`.

   Per-platform records carry **only** visual fields — never callbacks,
   controllers, value, or state-gating. The legacy v1.x shape (public
   `PlatformXxxData` taking functional fields) is being migrated out
   widget-by-widget as part of the v2 restructure. See
   [`APPENDIX.md#field-classification`](../APPENDIX.md#field-classification)
   for the full rule and
   [`APPENDIX.md#cross-platform-field-mappings`](../APPENDIX.md#cross-platform-field-mappings)
   for shared-visual fields whose native names or types diverge.

   A new shared-visual field must be added in **both** places — flat on the
   widget *and* on the `_PlatformXxxData` base — and merged with `?? ` in both
   `buildMaterial` and `buildCupertino`. The
   [data ↔ widget parity guard](../test/data_widget_parity_test.dart) fails the
   PR if either edge drifts (these two edges are the ones the Dart compiler does
   not catch; `super.x` forwarding base → records, it does). See
   [`APPENDIX.md#field-classification`](../APPENDIX.md#field-classification)
   (*Enforcement*).

## Hard rules
1. **The public API lives only in `lib/platform_adaptive_widgets.dart`.** That file
   re-exports from `lib/src/`. Don't make users import from
   `package:platform_adaptive_widgets/src/…` — the `src/` subtree is private by
   convention. Anything callers need goes through an explicit `export`. See
   [`APPENDIX.md#public-api-via-single-export-file`](../APPENDIX.md#public-api-via-single-export-file).
2. **No `print()` in library code.** Diagnostic output is the caller's responsibility
   (loggers, callbacks, the example app). `avoid_print` is already a warning in
   `analysis_options.yaml`.
3. **No `dynamic` escape hatches.** `strict-casts`, `strict-inference`, and
   `strict-raw-types` are all on in `analysis_options.yaml`. If you reach for `dynamic`
   or unconstrained `Object?`, stop and reconsider.
4. **Public symbols carry dartdoc.** Every public class / widget / function / getter /
   extension needs a `///` comment that explains *why*, not *what* — types already carry
   the *what*.
5. **Semver, strictly.** Breaking changes only on a major bump. Any change to a public
   widget's constructor signature, a public `*Data` field, a deletion, or a behavioural
   change of a documented contract is breaking. Surface the implication before the diff
   lands.
6. **Android + iOS only.** Don't add `web`, `linux`, `macos`, or `windows` platform
   support without an explicit conversation — the `PlatformWidgetBase` dispatcher throws
   on unsupported platforms by design (see
   [`APPENDIX.md#android-ios-only`](../APPENDIX.md#android-ios-only)).
7. **Subclass `PlatformWidgetBase` (or one of its `Keyed` / `Builder` variants) for
   every new `PlatformXxx` widget.** Do not override `build`; override `buildMaterial`
   and `buildCupertino`. The base hierarchy enforces the dispatch invariant — see
   [`APPENDIX.md#platform-widget-base-hierarchy`](../APPENDIX.md#platform-widget-base-hierarchy).
8. **Inline `switch (defaultTargetPlatform)` for platform dispatch outside
   `PlatformWidgetBase`.** For top-level helpers like `showPlatformXxx`, route the
   switch directly at the construction site and call only the matching-platform
   private helper from each arm — do not pass both platforms' values/closures into
   `platformLazyValue(material: …, cupertino: …)` or any other
   argument-taking helper from internal code. Closure args are evaluated at the
   call site before the helper's switch runs, which defeats AOT pruning of the
   unused-platform branch (verified empirically — recovering pruning shaved
   ~192 KB from the example's Android `libapp.so` on 2026-05-30). The public
   `platform*` value selectors stay around for callers who knowingly accept
   the size cost; internally we always inline. See
   [`APPENDIX.md#aot-pruning-rules`](../APPENDIX.md#aot-pruning-rules).
   **Enforced on every PR** by two CI guards:
   [`test/aot_pruning_regression_test.dart`](../test/aot_pruning_regression_test.dart)
   (static AST lint over `lib/src/`) and
   [`tool/check_size_regression.dart`](../tool/check_size_regression.dart)
   (size benchmark over an Android build of `tool/size_harness/`). A regression
   trips at least one of them. Don't disable or weaken either without an
   explicit conversation.
8. **`CHANGELOG.md` and `version:` move together with the release tag.** Routine
   CHANGELOG appends are bot-driven (`changelog.yml` + `cider`), but cutting a
   release — bumping `version:`, finalising the `[Unreleased]` section, committing,
   and pushing the matching `X.Y.Z` tag — is still hand-driven. If you edit
   `version:` or finalise `## [Unreleased]` without the other two moving in the same
   commit, the publish workflow's tag push will mismatch the in-tree state. Do not
   edit either file without an explicit user instruction to cut a release; see
   [*Forbidden / confirm-first actions* in CLAUDE.md](./CLAUDE.md#forbidden-confirm-first-actions).

## PR conventions
The `.github/workflows/pr-conventions.yml` workflow enforces branch-name, PR-label,
and commit-subject rules on every PR. On merge, `.github/workflows/changelog.yml`
auto-appends to `CHANGELOG.md` based on the PR's `sem-*` label (via `cider log`).
**PRs that don't comply will be blocked by CI.** The conventions:

- **Branch name** — `<type>/#<issue>-<slug>`, where `<type>` is one of
  `feature`, `bugfix`, `chore`, `refactor`, `hotfix`. Example: `chore/#12-tidy-readme`.
- **Exactly one `sem-*` label per PR**, mapped to a CHANGELOG section:

  | Label           | CHANGELOG section | When to use                                    |
  |-----------------|-------------------|------------------------------------------------|
  | `sem-add`       | `### Added`       | New public widget / `*Data` field / feature    |
  | `sem-change`    | `### Changed`     | Behavioural or signature change                |
  | `sem-deprecate` | `### Deprecated`  | Public symbol marked for future removal        |
  | `sem-remove`    | `### Removed`     | Previously-public symbol dropped               |
  | `sem-bugfix`    | `### Fixed`       | Defect repair, no signature change             |
  | `sem-security`  | `### Security`    | Security-relevant fix                          |
  | `sem-skip`      | (skip)            | Internal-only change (CI, docs, tests, …)      |

  The PR title becomes the CHANGELOG line verbatim — write it as a release-note
  bullet.
- **PR body must not be empty**, **no merge commits in the PR range** (rebase to
  integrate `master`), and **commit subjects ≤ 82 characters**.

Cutting a release is one command: `scripts/release.sh [patch|minor|major]` — see
[`scripts/README.md`](../scripts/README.md) for usage, preflight, flags, and the
pipeline-owned-files contract.

## Style
Full guide: [`../CODESTYLE.md`](../CODESTYLE.md). The lint posture is deliberately strict
(see `analysis_options.yaml`); the explicit `errors:` block promotes a long list of
lints to errors. Top-level rules to keep in working memory:

- Type-annotate every public symbol; `final` by default for fields and locals.
- Nullability is explicit (no `as T` on `T?`).
- 100-column line width (`formatter.page_width: 100` in `analysis_options.yaml`).
- No magic numbers in `lib/` code — pull to named `static const`s.
- Public symbols carry `///` dartdoc explaining *why*, not *what*.
- Prefer Dart 3.10 static dot shorthands (`.android`, `.iOS`, `.all(16)`,
  `.symmetric(...)`, `.start`, `.min`) — the codebase relies on them heavily.

For everything else — naming, idioms, class structure, DCM rules, markdown conventions
— go to [`../CODESTYLE.md`](../CODESTYLE.md).

## Guidelines for any AI agent
- **Always ask before making technical choices.** When the task admits more than one
  reasonable approach (which platform-specific widget to wrap on the Cupertino side,
  whether to add a new `*Data` field vs reuse an existing one, whether to expose a
  helper as a top-level function or a class member, whether to introduce a dependency,
  etc.), stop and ask. Present the options with trade-offs, say which you'd pick and
  why, then wait. Don't silently pick one and build. This applies even when a choice
  feels small — small choices compound.
- **Mark recommendations with `★`.** Prefix your preferred option in every set with `★`
  — in tables, bullet lists, headings, inline — so the user can scan and reply by
  echoing or overriding (e.g. "★ for 1–4, change 5 to B"). Exactly one star per option
  set in most cases; occasionally a combined choice warrants more.
- **Refactor first when the change needs it.** Before building a feature, check whether
  the current structure fits it. If you catch yourself adding a special case, threading a
  flag through layers, duplicating a block, or working around an abstraction, do the
  enabling refactor *first* as its own behaviour-preserving step (separate commit,
  verified green), then build the new behaviour on the clean shape. Long-term
  maintainability of the package outranks shipping the immediate change faster. Two
  repo-specific teeth: a preparatory refactor that touches the public surface (a
  re-export, a `PlatformXxx` constructor, a `*Data` field) is itself a semver event, so
  classify it (patch / minor / major) and surface that before doing it, like any
  public-API change; and because the package is published and breakage is slow to walk
  back, baking a feature onto a mismatched structure is expensive here, which lowers the
  bar for restructuring first. The in-flight v2 `*Data` restructure (migrating the legacy
  public `PlatformXxxData` shape out widget-by-widget before new per-platform-record
  features land) is the worked example. Keep the refactor minimal and tied to a change
  you can actually see coming, not speculative architecture.
- **Document new public widgets in the README's widget catalogue.** Any new
  `PlatformXxx` widget, `showPlatformXxx` function, or public `*Data` class must be
  added to the appropriate table in `README.md` in the same change. Rationale + design
  trade-offs still belong in `APPENDIX.md`; the README is the user-facing entry point
  and must reflect what the package actually offers.
- **Read `analysis_options.yaml` before writing code.** The `errors:` block promotes
  many lints to errors; the lint posture is far stricter than the Dart default — code
  that fails lint won't pass review.
- **Surface semver implications loudly.** If a change touches anything re-exported from
  `lib/platform_adaptive_widgets.dart`, call out whether it's patch / minor / major
  before the diff lands.
- **Test changes in `example/` when feasible.** The demo app under `example/` is the
  living usage reference — running it (`cd example && flutter run`) and watching the
  feature work on both an Android emulator and an iOS simulator is the most reliable
  verification path for any widget change. The two entry points
  (`lib/main.dart` and `lib/main_go_router.dart`) exercise different navigation
  strategies; touch both when a change could affect either (see
  [`APPENDIX.md#two-entry-point-example`](../APPENDIX.md#two-entry-point-example)).
