# APPENDIX — `platform_adaptive_widgets`

Consolidated source of truth for design decisions, rejected paths, and non-obvious
technical trade-offs.

READMEs and `.ai/AGENTS.md` reference sections here by anchor (e.g.
`APPENDIX.md#platform-widget-base-hierarchy`). **Headings below are load-bearing** —
each carries an explicit `<a id="…">` anchor immediately above it. When renaming a
heading, keep the anchor stable or grep-and-update every caller.

---

<a id="ai-files-symlinked"></a>
## `AGENTS.md` and `CLAUDE.md` are symlinks into `.ai/`

- **Decision:** the canonical text for both files lives under `.ai/`. The repo root
  holds symlinks (`AGENTS.md → .ai/AGENTS.md`, `CLAUDE.md → .ai/CLAUDE.md`). The
  example subdirectory follows the same pattern
  (`example/AGENTS.md → example/.ai/AGENTS.md`).
- **Why:** Claude Code (and most other coding agents) auto-discover `CLAUDE.md` /
  `AGENTS.md` at the project root, but two more loose Markdown files at the root add
  visual noise to the file tree. Scoping the agent-guidance files under `.ai/` keeps
  them together; the root symlinks preserve auto-discovery.
- **Cross-platform note:** symlinks survive `git clone` on macOS/Linux. On Windows
  hosts without symlink support enabled, the file may show up as a small text file
  containing the link target. If that ever bites a contributor, the fallback is to
  drop the symlinks and keep real files at root, hand-syncing the content (or to
  delete the duplicates under `.ai/`).

---

<a id="public-api-via-single-export-file"></a>
## Public API funnelled through `lib/platform_adaptive_widgets.dart`

- **Chosen:** `lib/platform_adaptive_widgets.dart` is the only file callers import.
  Implementation lives in `lib/src/`; nothing in `src/` is intended to be imported
  directly. The entry file consists entirely of `export 'src/…';` lines.
- **Why:** Dart doesn't have a hard public/private boundary between library files —
  anything under `lib/` is importable. The single-entry + `lib/src/` convention is how
  the ecosystem signals private intent. It also gives one place to audit the public
  surface when planning a release, and one place to control re-exports.
- **Implication for refactors:** moving code *within* `lib/src/` is free (private), as
  long as the matching `export 'src/…';` line in `lib/platform_adaptive_widgets.dart`
  is updated to the new path. Moving anything *into or out of* the re-export list is a
  semver-visible change — minor for additions, major for removals or signature
  changes.
- **No `show` / `hide` lists today.** The current re-exports are bare
  `export 'src/<path>';` lines. If a partial-export ever becomes necessary, prefer
  `show` over `hide` — `show` enumerates the public surface explicitly, `hide`
  silently re-exposes anything added in the source file. Adding any `show` clause is
  itself a public-API change (anything currently exported but not in the `show` list
  becomes a removal).

---

<a id="platform-widget-base-hierarchy"></a>
## `PlatformWidgetBase` is an abstract base, not a function or mixin

- **Chosen:** every `PlatformXxx` widget subclasses one of four abstract base classes
  in [`lib/src/models/platform_widget_base.dart`](./lib/src/models/platform_widget_base.dart):
  `PlatformWidgetBase`, `PlatformWidgetKeyedBase` (adds an inner-widget `widgetKey`),
  `PlatformWidgetBuilderBase` (adds a required `child`),
  `PlatformWidgetKeyedBuilderBase` (both). The base's `build` is `@nonVirtual` —
  subclasses override `buildMaterial(context)` and `buildCupertino(context)`.
- **Why an abstract base?** The dispatch (`switch (defaultTargetPlatform) { .android => …,
  .iOS => …, _ => throw UnsupportedError(…) }`) is a load-bearing invariant — every
  platform-adaptive widget in the package must use exactly the same dispatch logic,
  or the package's promise ("write app code that doesn't branch on platform")
  silently degrades. An abstract base with `@nonVirtual` `build` makes that
  impossible-to-fork at the type system: subclasses *cannot* override `build`, only
  the two builders. The throw-on-unsupported is centralised in one place.
- **Why not a function or mixin?**
  - A free function (`Widget platformWidget({material, cupertino})`) loses the
    `StatelessWidget` identity — the resulting widget can't be a const-constructed,
    keyed, named widget that shows up in the widget tree as its own type. Devtools
    would see `Builder` everywhere instead of `PlatformButton`.
  - A mixin can't enforce non-virtuality the same way; it also couldn't carry the
    `@protected` / `@visibleForOverriding` annotations that signal intent to readers
    of `lib/src/widgets/`.
- **Four base classes, not one with optional fields.** `widgetKey` and `child` are
  positional in the inheritance chain — making them optional on a single base would
  mean every subclass declares both even when it uses neither, and would forfeit the
  `super.key` / `super.widgetKey` / `super.child` shorthand at construction. The four
  bases each pin exactly the shape their leaf needs.
- **What this rules out:** declaring a new `PlatformXxx` widget that extends
  `StatelessWidget` directly. If you find yourself reaching for that, the dispatch
  invariant has been forked — go back through the four base classes and pick the
  right one.

---

<a id="data-classes-per-widget-pattern"></a>
## Three-way `*Data` class split: `Platform` / `Material` / `Cupertino`

- **Chosen:** most widgets accept up to three configuration records:
  `PlatformXxxData` for cross-platform parameters (the things app code always cares
  about), and the optional `MaterialXxxData` / `CupertinoXxxData` for per-platform
  tuning that callers opt into.
- **Why three records, not one merged record with per-platform optional fields?**
  - The merged shape would put `materialColor` and `cupertinoActiveColor` on the same
    type. Most callers want neither — they're tuning one platform or the other, never
    both at once. The merged record is mostly null at every call site.
  - The three-record split makes the *audience* of each field explicit at the type
    level: `PlatformSwitchData.value` is required, `MaterialSwitchData.thumbColor` is
    "I'm tuning Material only". A reader of a `PlatformSwitch(…)` call site knows
    immediately what stripe of customisation each argument applies to.
- **Why three records, not direct passthrough to `Switch` / `CupertinoSwitch`?**
  - Direct passthrough leaks the underlying widget's signature into the public API —
    every upstream signature change ripples into a breaking change here.
  - Direct passthrough also can't express the cross-platform fields (`value`,
    `onChanged`) once. With the three-record split, `PlatformSwitchData.value` is
    written once and read on both branches.
- **Rule of thumb for new fields:** if the concept is defined identically on both
  platforms, the field belongs on `PlatformXxxData`. If the concept exists on one
  side and the other side has nothing equivalent (or has it under a different name /
  type), the field belongs on the per-platform record. **Don't invent a unifying
  abstraction** for fields that are only superficially similar — the record split is
  there precisely so we don't have to.
- **Cross-platform tuning that needs a unified concept** (e.g. button variants —
  Material has `text`/`elevated`/`outlined`/`filled`, Cupertino has plain / filled /
  tinted) is the legitimate exception: the package exposes its own enums
  (`MaterialButtonVariant`, `CupertinoButtonVariant`) on each per-platform record, so
  callers pick a variant per platform without re-importing the underlying frameworks.

---

<a id="models-widgets-mirror-layout"></a>
## `lib/src/models/` mirrors `lib/src/widgets/`

- **Chosen:** the `models/` and `widgets/` trees use the same sub-categories
  (`dialogs/`, `interaction/`, `layout/`, `painting/`). Every `*_data.dart` lives in
  `models/<category>/` and every widget impl lives in `widgets/<category>/` — paired
  by name (`platform_button.dart` in `widgets/interaction/`,
  `platform_button_data.dart` in `models/interaction/`).
- **Why?** Each `*Data` record is conceptually a *parameter* of its widget — they
  ship together, version together, and break together. Co-locating them by category
  means a reader can navigate from a widget to its config classes (and vice versa)
  without grepping. The duplication of category names is intentional: it's the
  navigational handle.
- **Why two trees instead of one folder per widget?** Some categories
  (`dialogs/`) carry cross-cutting consts (`const_values.dart`) and standalone
  helpers that don't fit under a single widget. Keeping models and widgets in
  separate trees lets these helpers sit in `models/<category>/` where they belong
  (next to the data classes that consume them) without polluting the widget tree.
- **What this rules out:** dropping new widgets at the top of `lib/src/widgets/` or
  `lib/src/models/` (everything goes under a category), and inventing new
  category names for one-off widgets (pick the closest existing category, or open the
  question before introducing a new one — `interaction/` vs. `painting/` is not
  always obvious for visual-feedback widgets).

---

<a id="android-ios-only"></a>
## Android + iOS only (`platforms:` restriction)

- **Chosen:** `pubspec.yaml`'s `platforms:` block declares only `android` and `ios`.
  The `PlatformWidgetBase.build` switch falls through to
  `throw UnsupportedError('This platform is not supported: $defaultTargetPlatform')` for
  anything else.
- **Why?** The package's value proposition is "Material on Android, Cupertino on iOS,
  zero app-code branching". Web / Linux / macOS / Windows do not have a single
  authoritative design language to map onto — `defaultTargetPlatform` falls through
  to `TargetPlatform.fuchsia` / `linux` / `macOS` / `windows` and the dispatch would
  have to invent a third (and fourth, …) builder per widget. The current dispatch is
  load-bearing precisely because it's binary; expanding it would compound the surface
  area of every widget in the package.
- **Throw, don't silently render Material as a fallback.** A silent Material fallback
  would mask the unsupported case at the type system (`PlatformSwitch` looks like it
  works on web, until the user notices it doesn't follow Cupertino on iOS Safari).
  The throw surfaces the limit at runtime, the first time a desktop / web build is
  attempted. Callers who want a web-capable adaptive widget should compose
  `PlatformWidget` (the standalone helper) with their own web branch — explicit
  rather than implicit.
- **If platform support ever expands**, the change is breaking by definition: every
  subclass of `PlatformWidgetBase` must grow its dispatch, and the package's promise
  shifts. Don't add a platform to `pubspec.yaml`'s `platforms:` block without a
  matching major-version bump.

---

<a id="aot-pruning-rules"></a>
## AOT pruning: which patterns prune, which leak

The package's value proposition includes shipping a smaller Android binary by
keeping Cupertino code out of Android builds (and vice-versa). Flutter's
`defaultTargetPlatform` is annotated with `@pragma('vm:platform-const-if',
!kDebugMode)`, which lets the AOT compiler const-fold `switch
(defaultTargetPlatform) { … }` in release builds. Whether the unused branch's
lexical references actually get pruned depends on **how** the dispatch is shaped:

| Pattern | Prunes? | Why |
|---|---|---|
| Inline `switch (defaultTargetPlatform)` at the construction site | ✓ | The unused arm becomes dead code; its lexical refs are unreachable. |
| `PlatformWidgetBase.build` virtual dispatch to `buildMaterial` / `buildCupertino` (small subclass count) | ✓ | Const-folded switch in the base's `build`; subclass methods are devirtualized when the compiler can prove monomorphic call sites. |
| `PlatformWidgetBase.build` with many concrete subclasses in the binary | partial | Vtable entries for `buildCupertino` remain on each class; method bodies are usually pruned, but class names linger as strings (~30 bytes/class). Real code shrinks; symbol lists do not. |
| Helper that takes both platform values/closures as args (`platformValue`, `platformLazyValue`, `context.platformLazyValue(material: …, cupertino: …)`) | ✗ | Both args are evaluated at the call site, *before* the helper's internal switch picks one. The unused arg's expression — including any closure construction with lexical refs — stays compiled. |
| `cupertinoBuilder: (ctx) => CupertinoXxx(...)` passed as an argument | ✗ | Same as above — the closure literal is constructed at the call site regardless of whether the receiving function ever invokes it. |

### Internal rules the package follows
1. **All `showPlatformXxx` functions switch on `defaultTargetPlatform` *first*,
   then construct only the matching-platform builder closure / call only the
   matching-platform private helper.** See
   [`platform_dialog.dart`](./lib/src/widgets/dialogs/platform_dialog.dart),
   [`platform_alert_dialog.dart`](./lib/src/widgets/dialogs/platform_alert_dialog.dart),
   [`platform_date_picker.dart`](./lib/src/widgets/dialogs/platform_date_picker.dart),
   etc. — each ends with a top-level `switch (defaultTargetPlatform) { .android
   => _runMaterialXxx(…), .iOS => _runCupertinoXxx(…), _ => throw … }`. The
   per-platform helpers (`_runMaterialDialog`, `_showCupertinoDatePicker`, …)
   are private top-level functions so the unused one becomes unreachable on the
   other platform and is tree-shaken.
2. **`PlatformXxx` widgets keep using `PlatformWidgetBase`'s virtual `buildMaterial`
   / `buildCupertino` dispatch.** It prunes correctly for the per-class code
   bodies; the residual symbol-table entries are negligible. The base class
   remains the dispatch invariant — see
   [`#platform-widget-base-hierarchy`](#platform-widget-base-hierarchy).
3. **`*Data` classes' `static const` defaults referencing Cupertino types do
   not leak code** — verified empirically; the AOT compiler treats them as
   metadata and prunes when unreferenced.

### Public helpers in [`context_extensions.dart`](./lib/src/extensions/context_extensions.dart)
`platformValue`, `platformValueNullable`, `platformLazyValue`, `platformLazyNullable`
are deliberately kept for ergonomic use, but their dartdoc warns about the
size-cost. The package itself does not use the lazy variants internally; the
eager `platformValue` is used only for cheap primitives like `IconData`. If you
need the helpers internally for new code, ask whether an inline switch would do
the same job — usually it does.

### Why the `targetPlatform` shim was removed (v2.0.0 breaking change)
The old `lib/src/utils/target_platform.dart` used to provide a `targetPlatform`
re-export *plus* `isAndroid` / `isIOS` boolean getters. The original rationale
for `targetPlatform` (test seams, search affordance, forward-compat) turned out
not to be load-bearing in practice, and the indirection added one layer between
callers and the platform-const-folding pragma. Empirical builds (2026-05-30)
confirmed direct `defaultTargetPlatform` usage produced byte-identical Android
`libapp.so` to the shim version, so the `targetPlatform` final was deleted and
all internal dispatch sites switched to `defaultTargetPlatform` directly.

The `isAndroid` and `isIOS` getters were preserved (moved to
[`lib/src/utils/is_platform.dart`](./lib/src/utils/is_platform.dart) and
rewritten to `defaultTargetPlatform == .android` / `.iOS` directly). Empirical
verification confirmed `if (isAndroid) { … } else { … }` const-folds and prunes
identically to an inline `switch (defaultTargetPlatform)` (byte-identical AOT
output) — the trivial getter body inlines and propagates the pragma's
const-ness.

Callers who relied on the public `targetPlatform` symbol should import
`defaultTargetPlatform` from `package:flutter/foundation.dart`. `isAndroid` /
`isIOS` continue to be exported from
`package:platform_adaptive_widgets/platform_adaptive_widgets.dart`.

---

<a id="two-entry-point-example"></a>
## Two entry points in `example/`: `main.dart` and `main_go_router.dart`

- **Chosen:** the demo app under `example/lib/` ships two `main()` functions:
  - [`example/lib/main.dart`](./example/lib/main.dart) — boots `PlatformApp` with a
    nested `Home → Settings` tab structure managed by `PlatformTabScaffold`'s
    own selected-index state.
  - [`example/lib/main_go_router.dart`](./example/lib/main_go_router.dart) — boots
    `PlatformApp.router` with `go_router`'s `StatefulNavigationShell`, where tab
    selection is driven by the router rather than the scaffold.
- **Why two entry points instead of one?** `PlatformApp` and `PlatformApp.router`
  are *both* part of the public API, and they exercise meaningfully different
  navigation invariants. A single entry point would force a choice between the
  router-less ergonomic demo and the router-integrated showcase; shipping both as
  separate `main` files keeps the example honest about both modes. `flutter run -t
  lib/main.dart` and `flutter run -t lib/main_go_router.dart` pick between them.
- **What stays shared.** The `features/` tree, the `app/const_theme.dart`, and the
  feature view-models are reused across both entry points. Only the bootstrap and
  the `app/router/` subtree are router-specific. New features added to the example
  should aim to work under both entry points where the navigation shape allows;
  router-only demos (sub-route push, deep-linking) live in branches that the
  non-router entry point either hides or shows in a "GoRouter only" affordance —
  see `HomeViewArgs.isUsingGoRouter` in
  [`example/lib/features/home/home_view.dart`](./example/lib/features/home/home_view.dart)
  for the pattern.
- **Verification implication.** When changing anything that touches
  `PlatformApp`, `PlatformTabScaffold`, or navigation state more broadly, run *both*
  entry points on both Android and iOS before claiming the change is done.

---

<a id="release-pipeline-not-yet-wired"></a>
## Release pipeline is not yet wired (planned)

- **Today:** the release flow is hand-driven. `CHANGELOG.md` is edited by hand under
  manually-written `## X.Y.Z - YYYY-MM-DD` headers with
  `### Added / Changed / Fixed / Removed` subheads. The `version:` field in
  `pubspec.yaml` is bumped by hand. A `git tag X.Y.Z && git push origin X.Y.Z`
  triggers [`.github/workflows/publish.yml`](./.github/workflows/publish.yml), which
  delegates to `dart-lang/setup-dart/.github/workflows/publish.yml@v1` via OIDC.
- **Why this is fragile.** The three things that must match — `CHANGELOG.md`
  top-section, `pubspec.yaml`'s `version:`, and the pushed tag — have no automated
  cross-check. A typo in any one of them either ships a wrong-version package, or
  surfaces a mismatch on pub.dev that's slow to walk back.
- **Planned direction.** Mirror the reference package's pipeline:
  - A `scripts/release.sh` that runs `cider bump <kind>`, finalises the CHANGELOG
    `## [Unreleased]` section, regenerates `example/pubspec.lock`, commits, tags,
    and pushes — in one atomic operation.
  - A `.github/workflows/changelog.yml` that appends merged-PR titles under
    `## [Unreleased]` based on the PR's `sem-*` label, so the CHANGELOG is built
    incrementally rather than hand-written at release time.
  - A `.github/workflows/pr-conventions.yml` that enforces branch-name format,
    exactly-one `sem-*` label, non-empty PR body, no merge commits, and commit
    subjects ≤ 82 characters.
- **Until those land**, the discipline lives in
  [`.ai/AGENTS.md`'s *PR conventions (planned, not yet wired)*](./.ai/AGENTS.md#pr-conventions-planned-not-yet-wired)
  and the *Forbidden / confirm-first actions* block in
  [`.ai/CLAUDE.md`](./.ai/CLAUDE.md#forbidden-confirm-first-actions): no agent edits
  `CHANGELOG.md`, `version:`, or pushes a semver tag without an explicit instruction
  to cut a release.
