# CLAUDE.md — `platform_adaptive_widgets`

Claude-Code-specific guidance. Project facts, stack, hard rules, and AI-agent
guidelines live in [AGENTS.md](./AGENTS.md); the full code-style guide lives in
[`../CODESTYLE.md`](../CODESTYLE.md); design rationale lives in
[`../APPENDIX.md`](../APPENDIX.md). Read AGENTS.md and CODESTYLE.md first.

## Role & context
You're assisting with **platform_adaptive_widgets**: a Flutter package that exposes
`PlatformXxx` widgets which render Material on Android and Cupertino on iOS without app
code branching. Treat the user as technical and direct. The package is published on
pub.dev — changes are visible to every downstream user, so breakage is expensive and
slow to walk back (unpublished versions stay reserved for 7 days, and a tag push
triggers an automated publish).

## Communication
- **Concise.** No "here's what I just did" recap; the diff speaks.
- **Explain the *why*** when recommending. The *what* is in the diff.
- Reference code as `file.dart:42` (markdown links if you can).
- Flag breaking-API or lint-violation implications loudly and early.

## Technical choices — always ask first
- **Do not silently pick between reasonable alternatives.** Whenever a task admits more
  than one defensible approach (which Cupertino primitive to wrap, whether a new field
  is functional / shared-visual / platform-only per
  [`APPENDIX.md#field-classification`](../APPENDIX.md#field-classification), whether a
  symbol belongs in the public re-exports or stays under `lib/src/`, function-vs-class
  API shape, whether to add a dependency, etc.), **stop and ask**. Recommendations in
  the question are expected — list the options with trade-offs, say which you'd pick
  and why, then wait.
- **"Small" choices count.** The bar isn't "is this architecturally significant" — it's
  "could a reasonable maintainer disagree with my pick". If yes, ask.
- **Mark your recommendation with `★`.** When presenting options, prefix your preferred
  pick(s) with `★` so the user can scan and reply by echoing or overriding (e.g. "go
  with ★ for 1–4, change 5 to B").
- **Exception:** obvious single-answer fixes (typo, clear bug with one correct patch,
  lint error) — just do them.

## Tool preferences
- **Read / Edit / Grep / Glob** over `cat` / `sed` / `grep` / `find`. Always.
- **Bash** only for things without a dedicated tool: `flutter`, `dart`, `git`. The
  user's shell aliases `flutter` / `dart` to whatever toolchain manager serves the
  `.fvmrc`-pinned channel — invoke plain `flutter` / `dart`, not the manager directly.
- **Lint with `flutter analyze`** (or `dart analyze` for the pure-Dart subset under
  `lib/src/extensions/` etc.). The project promotes many lints to `error:` in
  `analysis_options.yaml` — those are the contract, not suggestions.
- **Agent tool** for wide / open-ended searches or to keep large outputs out of main
  context. Not for trivial lookups.

## Scope awareness
- **Public-API edits** (anything in `lib/platform_adaptive_widgets.dart`, or anything
  re-exported from it — every `PlatformXxx` widget, every `*Data` class, every
  extension, every typedef) are pub.dev-visible. Treat them with care; flag whether the
  change is patch / minor / major under semver before landing.
- **`lib/src/` edits** are private. Refactor freely as long as the public re-exports
  stay stable. Moving a file *within* `lib/src/` requires updating the export path in
  `lib/platform_adaptive_widgets.dart`.
- **`example/` edits** are local — no publish impact. The demo app is the living usage
  reference; keep it building and runnable on both Android and iOS. See
  [`example/.ai/AGENTS.md`](../example/.ai/AGENTS.md) for sub-scope conventions.
- **`analysis_options.yaml` edits** affect every file. Surface lint-posture changes
  loudly and add a written reason in `APPENDIX.md`.
- **`pubspec.yaml` edits** that touch `dependencies` add to every downstream user's
  transitive closure — treat as public-API-class. Adding or removing `topics:` or
  `platforms:` entries is also pub.dev-visible.

## Auto-memory conventions for this project
- **`project` memories** — scope/constraints the user states aloud (e.g. "we're cutting
  v1.1 before Friday", "minimum Flutter bumps to 3.40 on date Y", "Y feature is on hold
  until Z lands upstream"). Convert relative dates to absolute.
- **`feedback` memories** — corrections AND validated non-obvious choices. Include
  **Why** and **How to apply** lines.
- **`reference` memories** — external pointers (the pub.dev page, related upstream
  issues in `flutter/flutter`, `material_ui` / `cupertino_ui` / `pull_down_button`
  upstream discussions). Not internal code paths — those live in AGENTS.md or are
  derivable from the repo.
- **Do NOT save** Dart file paths, lint-rule lists, widget catalogue, or API surface —
  all derivable from the repo or APPENDIX.md. Re-deriving is safer than acting on a
  stale memory.
- **Before acting on a memory**, verify the named file / widget / symbol still exists.

## Plan before editing when
- The change touches the public API (anything re-exported from
  `lib/platform_adaptive_widgets.dart`). Even adding a new public widget or `*Data`
  field affects semver and downstream users.
- You're adding or removing a dependency in `pubspec.yaml`. Each dep expands the
  user-facing surface area and constrains downstream resolution.
- You're changing `analysis_options.yaml`. Lint posture is project-wide; any toggle
  deserves a written reason in APPENDIX.
- You're adding a new `PlatformXxx` widget. The pattern is load-bearing
  (`PlatformWidgetBase` subclass + paired `*Data` classes + matching `models/` ↔
  `widgets/` location); plan the shape against the existing pattern before writing
  code.
- You're touching anything in `lib/src/models/platform_widget_base.dart`. The abstract
  base hierarchy is the dispatch invariant for every widget in the package — see
  [`../APPENDIX.md#platform-widget-base-hierarchy`](../APPENDIX.md#platform-widget-base-hierarchy).

For single-file, single-concern fixes inside `lib/src/`: just do it.

The release flow — `CHANGELOG.md`, `version:` in `pubspec.yaml`, and the matching git
tag — is **not** in the routine-edit list. All three move together only when the user
explicitly says "cut a release"; see *Forbidden / confirm-first actions* below.

## Commit / PR etiquette
- **Never commit without being asked.** Not after a fix, not as a "checkpoint".
- **Never push without being asked.** Especially not to `master`, and especially not a
  semver tag (which triggers pub.dev publish via
  `.github/workflows/publish.yml`).
- **Never `--amend`** unless the user asked — create a new commit instead.
- **Never `--no-verify`**, **never `git add -A`** — stage named paths.
- Match existing commit style (short imperative subject, lowercase, no Claude-authored
  footer unless asked). Recent examples from `git log`: "Remove unnecessary assertion",
  "remove unnecessary type info for MenuPickerItem", "Force-inject CupertinoTabControlle
  (current) index for correct update".
- When asked for a commit: show `git status` + `git diff`, draft the message, wait for
  approval.

## Forbidden / confirm-first actions
- **Never** `flutter pub publish` or `dart pub publish`. Publishing is effectively
  one-way — pub.dev reserves the version for 7 days after retraction. Releases happen
  through the tag-triggered workflow at `.github/workflows/publish.yml`; pushing a
  matching `X.Y.Z` git tag is the trigger and is itself a confirm-first action.
- **Never** push a semver tag (`git push origin <tag>` or `git push --tags`) without
  explicit instruction. The tag triggers `.github/workflows/publish.yml`, which
  authenticates to pub.dev via OIDC (configured by `dart-lang/setup-dart`) — there is
  no manual confirmation step on the pub.dev side.
- **Never** edit `CHANGELOG.md`, the `version:` field in `pubspec.yaml`, or
  `example/pubspec.lock` without an explicit user instruction to cut a release —
  the three are pipeline-owned and move in lockstep. Routine CHANGELOG appends are
  handled by the `changelog.yml` bot on PR merge. When the user authorises a
  release, run [`scripts/release.sh`](../scripts/release.sh); full mechanics in
  [`scripts/README.md`](../scripts/README.md).
- **Never** edit `pubspec.lock` directly (root or `example/`). It's `flutter pub get`'s
  output.
- **Never** delete files under `.fvm/`, `.dart_tool/`, or `pubspec.lock` without
  approval. These are tooling state; deleting them forces a re-resolve.
- **Destructive git** (`reset --hard`, `push --force`, `branch -D`, `clean -fd`) → ask
  first.

## Definition of done
- `flutter analyze` clean (the project's `errors:` block promotes many lints to errors
  — non-negotiable).
- `dart format --output=none --set-exit-if-changed .` clean (100-column width matches
  `analysis_options.yaml`'s `formatter.page_width`).
- `flutter test` green (where tests exist).
- `flutter pub publish --dry-run` clean if the change is publish-relevant. Do **not**
  bump the version or add a CHANGELOG entry to make the dry-run happy — those are
  release-time edits.
- Public widget / `*Data` additions documented with `///` dartdoc, reflected in the
  appropriate `README.md` widget-catalogue table, and exported from
  `lib/platform_adaptive_widgets.dart`.
- When a widget change could affect both navigation styles, verified by running
  `example/lib/main.dart` *and* `example/lib/main_go_router.dart` on both Android and
  iOS — or, if you can't, explicitly call out what you did NOT verify (e.g. "didn't
  exercise on iOS — only ran the Android emulator").
