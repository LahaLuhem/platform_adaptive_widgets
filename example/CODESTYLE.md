Example-app code style.
Library-package style lives in [`../CODESTYLE.md`](../CODESTYLE.md);
project facts and scope live in [`.ai/AGENTS.md`](./.ai/AGENTS.md).

Each heading below carries an explicit `<a id="…">` anchor. Link by anchor, not by
heading text, so renames don't break callers.

<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [MVVM architecture](#mvvm-architecture)
- [Reactivity (ValueNotifier-first)](#reactivity-valuenotifier-first)
- [Naming](#naming)
    * [Boolean fields — modal verbs](#boolean-fields-modal-verbs)
    * [Callback methods — view-event suffix](#callback-methods-view-event-suffix)
- [ViewModel member ordering](#viewmodel-member-ordering)
- [Separation of concerns](#separation-of-concerns)
- [Widget composition](#widget-composition)
    * [Native widget parameters](#native-widget-parameters)
    * [Spacing — rule of 8](#spacing-rule-of-8)
- [Async-action buttons](#async-action-buttons)
- [Routing — `go_router` integration](#routing-go-router-integration)

<!-- TOC end -->

> **Note on rule vs. current state.** Some conventions below are aspirational — the
> demo code under `lib/features/` does not yet follow them in every place. The rules
> are still the contract; new code should comply, and refactors are welcome.

<a id="mvvm-architecture"></a>
## MVVM architecture

The example uses [pmvvm](https://pub.dev/packages/pmvvm) —
`MVVM.builder(viewModel: …, viewBuilder: …)` binds a `ViewModel` to a
`StatelessWidget` view. Each feature is a pair:
`lib/features/<feature>/<feature>_view.dart` +
`lib/features/<feature>/<feature>_view_model.dart`.

Features without observable state (e.g. `settings/`) may ship a view-only file. When
in doubt, add the VM — the cost is small and the symmetry pays off when the feature
grows.

---

<a id="reactivity-valuenotifier-first"></a>
## Reactivity (ValueNotifier-first)

All observable VM state is exposed as `ValueListenable<T>`, backed by a private
`ValueNotifier<T>`. Views subscribe via `ValueListenableBuilder`.

- **No `notifyListeners()`.** Every state-mutating method writes
  `_xNotifier.value = …` on the relevant notifier. `MVVM.builder`'s outer
  `viewBuilder` becomes a static frame; pmvvm earns its keep as DI + lifecycle, not as
  a rebuild trigger.
- **Naming: `_xNotifier` for the private field, `xListenable` for the public getter.**

  ```dart
  final _checkboxValueNotifier = ValueNotifier<bool?>(true);

  ValueListenable<bool?> get checkboxValueListenable => _checkboxValueNotifier;
  ```

  The suffixes make it unambiguous which side reads vs. writes, and prevent the
  bare-noun field from colliding with the getter name. The view binds the getter; it
  cannot mutate.
- **Omit the obvious `<T>` on `ValueNotifier(…)`.** When the initial value pins the
  type, drop the explicit type argument (`ValueNotifier(false)`,
  `ValueNotifier(AxisDirection.left)`). Keep it only when the initial value is
  `null` and inference cannot recover the type (`ValueNotifier<Date?>(null)`,
  `ValueNotifier<TimeOfDay?>(null)`).
- **Group co-updated fields into one notifier with a record type.** Fields that are
  always written together share one `ValueNotifier<({…})?>`. One write per logical
  update, one tick per rebuild. Splitting them costs extra notifier ceremony and
  extra ticks for zero gain when they always move in lockstep. Promote the record to
  a top-level `typedef` so the public listenable's type does not fail the
  `library_private_types_in_public_api` lint.
- **Dispose every notifier in `dispose()`** before `super.dispose()`. The
  [`selection_demo_view_model.dart`](./lib/features/catalog/views/selection_demo/selection_demo_view_model.dart)
  models the pattern.
- **VM-internal state stays plain.** Fields no widget observes (controllers held by
  the VM, subscriptions, thresholds) are plain Dart fields — no notifier ceremony.
  Widget controllers the view binds to *are* notifier-shaped already
  (`TextEditingController`, `ScrollController`, `ExpansibleController`); they're
  passed straight through. See
  [*Separation of concerns*](#separation-of-concerns) for what belongs on the VM
  vs. the view.

> **Exception — property-editor / playground view-models.** A view-model whose
> job is to drive one rebuildable preview from many independent "knobs" (the
> catalog playgrounds under `catalog/widgets/property_editor/`) may instead
> expose its editable props as **flat private fields + a getter**, mutated by
> `on<Event>` methods that call `notifyListeners()`. `MVVM.builder` wraps the
> `viewBuilder` in a `Consumer`, so a notify rebuilds that demo's small, scoped
> subtree — which is what pmvvm is built for; the ValueNotifier-first rule was
> the initial reference point, not a ban. This trades surgical rebuilds for far
> less ceremony (no `ValueNotifier` / `Listenable.merge` / `ValueListenableBuilder`,
> no notifier disposal) exactly where a whole-subtree rebuild is free. Keep the
> getter + private-field split (never a public mutable field) so the view still
> can't mutate state without a notifying `on<Event>` method, and keep the knobs
> themselves dumb controlled widgets (`value` + `onChanged`). Ordinary feature
> view-models stay ValueNotifier-first.

---

<a id="naming"></a>
## Naming

<a id="boolean-fields-modal-verbs"></a>
### Boolean fields — modal verbs

For boolean values and their derivatives (notifiers, listenables, getters), prefix
the identifier with a **modal verb** — `should`, `can`, `may`, `would`, `must` — to
make the read-site speak plain English. The bare-noun form (`acceptAny`,
`includeBogusTarget`) reads as a noun and forces the reader to mentally add the verb.

- ★ Default to `should` for user preferences and UI toggle state — declarative,
  expresses the intent the user is encoding.
- Reach for `can` when the bool gates a capability rather than a preference, `may`
  when it gates permission, `would` for hypothetical intent in unrun branches.

| Bad                  | Good                                                                      |
|----------------------|---------------------------------------------------------------------------|
| `acceptAny`          | `shouldAcceptAny`                                                         |
| `includeBogusTarget` | `shouldIncludeBogusTarget`                                                |
| `isRunning`          | (removed — view-local; [Async-action buttons](#async-action-buttons))     |

**`is` prefix is allowed for true state-of-being predicates** that are not user
toggles — `AppArgs.isUsingGoRouter` (the navigation mode the host chose) reads
as a fact, not a preference, so `is` stays. The `should` form is for what the user
*wants*; the `is` form is for what the world *is*.

This applies to the field, its notifier, and its listenable getter together — they
refer to the same concept, so the modal-prefix stays consistent across the trio.
Callback method names (e.g. `onAcceptAnyToggled`) describe the **event** and
continue to match the UI label, so they keep the bare-noun form even when they mutate
a `shouldXxx` field — the event and the state describe different things.

<a id="callback-methods-view-event-suffix"></a>
### Callback methods — view-event suffix

VM methods invoked from the view are named **from the view's perspective**: what the
user did, not what the VM does in response. Pattern: `on<Event>` with a suffix
matching the widget kind that produced the event.

| Widget                | Suffix     | Example                              |
|-----------------------|------------|--------------------------------------|
| Button (`onPressed`)  | `Pressed`  | `onShowGeneralDialogPressed`         |
| `SwitchListTile`      | `Toggled`  | `onAcceptAnyToggled`                 |
| `Slider.onChanged`    | `Changed`  | `onSliderChanged`                    |
| `Slider.onChangeEnd`  | `Released` | `onSliderReleased`                   |
| `DropdownButton` / `PlatformMenuPicker` | `Selected` / `Changed` | `onMethodSelected`, `onDirectionalityChanged` |
| `TextField.onChanged` | `Changed`  | `onSearchChanged`                    |
| `TextField.onSubmitted` | `Submitted` | `onTextSubmitted`                  |

Avoid VM-leaking names like `setX`, `runX`, `commitX`, `forceX` — those describe what
the VM does internally. The VM is still free to do whatever it likes inside the
method body (mutate notifiers, rebuild a connection, show a snackbar); only the
method *name* must reflect the view event.

**Named-arg style** — keep the parameter name on the call site when the type is
bare-`bool` (and elsewhere where `avoid_positional_boolean_parameters` would fire on
the VM signature):

```dart
// VM
void onAcceptAnyToggled({required bool value}) =>
    _shouldAcceptAnyNotifier.value = value;

// View
onChanged: (value) => viewModel.onAcceptAnyToggled(value: value),
```

The current example uses positional-bool callbacks in a few places
(`onCheckboxChanged(bool? value)`, `onSwitchChanged(bool value)`) with an
`// ignore: avoid_positional_boolean_parameters` directive because the widget's
callback signature is positional. New VM methods should prefer the named-arg form;
keep the positional form only when it directly matches a third-party widget's
tear-off signature.

---

<a id="viewmodel-member-ordering"></a>
## ViewModel member ordering

Apply this ordering to every `ViewModel` subclass. It lets a reader scan dependencies
→ construction → state → lifecycle entry → reads → writes → teardown without
backtracking.

1. **External-ref fields** — DI / services held by reference (the example has none
   today, but `AppArgs`-style args land here if introduced).
2. **Constructors** — unnamed first, then factories. Constructors assign to the
   external-ref fields.
3. **State fields** — notifiers, controllers, `late` connections, subscriptions.
   Static class-level constants live with this group at the top.
4. **`init()`** — pmvvm lifecycle entry; sets up streams / triggers. Optional.
5. **Getters** — the `xListenable` getters and any other pure reads.
6. **Getter-like methods** — pure / near-pure reads expressed as methods (rare).
7. **Logic methods** — `on<Event>` handlers and complex orchestration. Simplest
   first if you can rank them; otherwise grouped by feature.
8. **Private helpers** — anything `_` -prefixed, including static helpers at the end
   of this group.
9. **`dispose()`** — teardown, last; dispose every notifier and every controller the
   VM owns, then call `super.dispose()`.

---

<a id="separation-of-concerns"></a>
## Separation of concerns

- **The view is agnostic to the VM's inner workings.** It reads VM state, invokes VM
  callbacks, renders widgets. It does NOT know *how* the VM implements an action —
  only *what event* it is reporting.
- **Widget-state holding domain input belongs on the VM.** `TextEditingController`,
  `ScrollController`, `FocusNode`, `ExpansibleController` — these carry user input
  the VM operates on (validates a URL, scrolls to an offset on save, expands /
  collapses on demand). The VM owns construction and disposal; the view binds
  directly (`controller: viewModel.searchController`). They ARE the state, not
  implementation that should be hidden.
- **Widget-state describing pure UI presentation belongs on the view.** "This button
  is mid-async, show a spinner" is purely visual — no VM logic and no other widget
  consume it. Use `tap_debouncer` (via a shared async-button widget; see
  [*Async-action buttons*](#async-action-buttons)) so the view tracks its own
  in-flight gate. Do NOT add an `isRunning` field on the VM for this — that's a
  regression of the past pattern.

---

<a id="widget-composition"></a>
## Widget composition

<a id="native-widget-parameters"></a>
### Native widget parameters

When a widget exposes a native parameter for what you need, use it. Do not reinvent
it with extra children, padding wrappers, or string tricks.

- **`Row(spacing:)` / `Column(spacing:)` over interleaved `Gap` / `SizedBox`.** Use
  whenever the gap should be uniform between every adjacent child pair — including
  cases where some pairs are currently flush; lean toward making the rhythm
  consistent.
- **`spacing:` over trailing whitespace in label strings.** A `Text('Label:  ')`
  with magic trailing spaces is a hack;
  `Row(spacing: 8, children: [Text('Label:'), …])` is the intended primitive.
- **`Gap` stays for `ListView` children** (no `spacing` parameter available) and for
  genuinely non-uniform sequences (e.g. a `Column` that interleaves `Divider`s where
  the spacing-around-divider differs from spacing-between-other-children).

```dart
// Prefer:
Column(
  crossAxisAlignment: .start,
  spacing: 8,
  children: [Text(...), PlatformProgressIndicator(), _Detail(...)],
)

// Over:
Column(
  crossAxisAlignment: .start,
  children: [
    Text(...),
    const Gap(8),
    PlatformProgressIndicator(),
    const Gap(8),
    _Detail(...),
  ],
)
```

<a id="spacing-rule-of-8"></a>
### Spacing — rule of 8

All spacing values (`Gap`, `spacing:`, `Padding`, `EdgeInsets`, margins) follow an
8-pixel grid. This keeps the UI visually consistent and stops ad-hoc values from
drifting in.

- **Default ladder: `8 → 16 → 24 → 32 …`** — multiples of 8 for any spacing ≥ 8.
- **Sub-8 escape hatch: `2`, `4`, `8`.** Used only when an 8-grid value would be too
  generous (tight typography, internal row padding, list-card vertical margin).
  Other sub-8 values (3, 5, 6, 7) are effectively never right.
- **`12` is rare** and almost always a sign of someone splitting the difference
  between 8 and 16. Convert to 8 or 16 unless there is a concrete reason 12 is
  required (a third-party widget pinning a specific dimension, alignment to an
  external mockup that itself is on a non-8 grid). When you keep a 12, drop a
  one-line `//` comment explaining why.
- **Card content `Padding`: `.all(16)`** by default — matches Material 3's standard
  content padding.
- **Card vertical margin in a list: `4`** is fine (8 total between cards).
  Horizontal margin: `16` for screen-edge inset.

When in doubt, prefer the smaller 8-grid neighbour over the larger sub-8 value. `8`
over `4` for breathing room; `16` over `12` for section separation.

---

<a id="async-action-buttons"></a>
## Async-action buttons

Every async button in the example should wrap `tap_debouncer` (with
`cooldown: Duration.zero`) in a shared widget under
`lib/features/core/widgets/async_icon_action_button.dart`. The wrapper:

- Removes the need for an `isRunning` field on the VM.
- Locks the button while the async work is in flight and re-arms immediately on
  completion (no post-completion cooldown).
- Standardises the busy state (spinner + busy label) across every feature.

```dart
AsyncIconActionButton(
  onPressed: viewModel.onRunCheckPressed,
  idleIcon: Icons.send,
  idleLabel: 'Run check',
  busyLabel: 'Running…',
)
```

**Status today:** the wrapper widget does not yet exist in this project — async
callbacks like those in
[`buttons_demo_view_model.dart`](./lib/features/catalog/views/buttons_demo/buttons_demo_view_model.dart)
return raw `Future<void>` and the view binds them directly to
`PlatformButton.onPressed`. When introducing the first feature that genuinely needs
busy-state UI (a network call, a long-running platform action), create the wrapper
under `lib/features/core/widgets/` and migrate existing async buttons over.

Add a flexible (builder-based) variant only when a real non-icon caller appears.

---

<a id="routing-go-router-integration"></a>
## Routing — `go_router` integration

The router-flavoured entry point lives in
[`lib/main_go_router.dart`](./lib/main_go_router.dart) and binds to
`PlatformApp.router`. Router configuration lives under `lib/app/router/`:

- [`app_router.dart`](./lib/app/router/app_router.dart) — the `GoRouter` instance,
  branches, and `StatefulShellRoute.indexedStack` wiring.
- [`app_route.dart`](./lib/app/router/app_route.dart) — the enum / typed route
  registry. **Always reference routes by `AppRoute.<name>.name`**, never by string
  literal. Adding a new screen is a two-line change (add the enum case + add the
  route to `app_router.dart`), and the enum is the grep-handle for "where do we go
  here from".
- **`StatefulNavigationShell` owns tab selection** when running through go_router.
  `PlatformTabScaffold` binds to `navigationShell.currentIndex` and routes the tap
  through `navigationShell.goBranch`. Do not call `setState` on a parent or push a
  new route to switch tabs in this mode — go_router's branch-switching is the
  contract.
- **Features that demonstrate router-only flows** (sub-routes, deep links) gate
  their UI on `AppArgs.isUsingGoRouter`. The router-less `main.dart` passes
  `isUsingGoRouter: false`; `main_go_router.dart` passes `true`. The pattern keeps
  both entry points runnable without compile-time forking.
