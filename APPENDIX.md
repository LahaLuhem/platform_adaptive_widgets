# APPENDIX, `platform_adaptive_widgets`

Consolidated source of truth for design decisions, rejected paths, and non-obvious technical
trade-offs.

READMEs and `.ai/AGENTS.md` reference sections here by anchor (e.g.
`APPENDIX.md#platform-widget-base-hierarchy`). **Headings below are load-bearing**, each carries an
explicit `<a id="…">` anchor immediately above it. When renaming a heading, keep the anchor stable
or grep-and-update every caller.

---

<a id="ai-files-symlinked"></a>
## `AGENTS.md` and `CLAUDE.md` are symlinks into `.ai/`

- **Decision:** the canonical text for both files lives under `.ai/`. The repo root holds symlinks
  (`AGENTS.md → .ai/AGENTS.md`, `CLAUDE.md → .ai/CLAUDE.md`). The example subdirectory follows the
  same pattern (`example/AGENTS.md → example/.ai/AGENTS.md`).
- **Why:** Claude Code (and most other coding agents) auto-discover `CLAUDE.md` / `AGENTS.md` at the
  project root, but 2 more loose Markdown files at the root add visual noise to the file tree.
  Scoping the agent-guidance files under `.ai/` keeps them together. The root symlinks preserve
  auto-discovery.
- **Cross-platform note:** symlinks survive `git clone` on macOS/Linux. On Windows hosts without
  symlink support enabled, the file may show up as a small text file containing the link target. If
  that ever bites a contributor, the fallback is to drop the symlinks and keep real files at root,
  hand-syncing the content (or to delete the duplicates under `.ai/`).

---

<a id="public-api-via-single-export-file"></a>
## Public API funnelled through `lib/platform_adaptive_widgets.dart`

- **Chosen:** `lib/platform_adaptive_widgets.dart` is the only file callers import. Implementation
  lives in `lib/src/`. Nothing in `src/` is intended to be imported directly. The entry file
  consists entirely of `export 'src/…';` lines.
- **Why:** Dart doesn't have a hard public/private boundary between library files, anything under
  `lib/` is importable. The single-entry + `lib/src/` convention is how the ecosystem signals
  private intent. It also gives one place to audit the public surface when planning a release, and
  one place to control re-exports.
- **Locked with `@internal`.** Anything public in a `src/` file the entry file doesn't export, like
  a route helper or a row 2 widgets share, carries `@internal`. Another package that imports it
  anyway gets a warning, and so does an `export` of it here.
  [`test/internal_lock_guard_test.dart`](./test/internal_lock_guard_test.dart) fails on one that
  misses it.
- **Implication for refactors:** moving code *within* `lib/src/` is free (private), as long as the
  matching `export 'src/…';` line in `lib/platform_adaptive_widgets.dart` is updated to the new
  path. Moving anything *into or out of* the re-export list is a semver-visible change, minor for
  additions, major for removals or signature changes.
- **No `show` / `hide` lists today.** The current re-exports are bare `export 'src/<path>';` lines.
  If a partial-export ever becomes necessary, prefer `show` over `hide`: `show` enumerates the
  public surface explicitly, `hide` silently re-exposes anything added in the source file. Adding
  any `show` clause is itself a public-API change (anything currently exported but not in the `show`
  list becomes a removal).

---

<a id="platform-widget-base-hierarchy"></a>
## `PlatformWidgetBase` is an abstract base, not a function or mixin

- **Chosen:** every `PlatformXxx` extends one of the 4 bases in
  [`platform_widget_base.dart`](./lib/src/models/platform_widget_base.dart). Their `build` is
  `@nonVirtual` and switches on `designLanguage`, so subclasses only fill in `buildMaterial` and
  `buildCupertino`.
- **Why?** Every widget has to pick its look the same way, or "app code doesn't branch on platform"
  quietly stops being true. A non-virtual `build` makes forking that a compile error.
- **Locked from outside.** The bases are `@internal`, and every half repeats the base's
  `@protected @visibleForOverriding`, since the analyzer doesn't carry them to overrides. Otherwise
  a caller could build one half directly and skip `designLanguage`.
  [`test/look_picking_guard_test.dart`](./test/look_picking_guard_test.dart) catches a half that
  drops them.
- **Not a function:** it'd lose the widget's own type, so it can't be const or keyed, and DevTools
  shows `Builder` instead of `PlatformButton`.
- **Not a mixin:** it can't enforce `@nonVirtual` the same way.
- **4 bases, not 1 with optional fields:** each pins exactly the `widgetKey` / `child` shape its
  widgets need, and keeps the `super.widgetKey` / `super.child` shorthand.

---

<a id="sdk-widgets-not-adaptive"></a>
## Real SDK widgets, not Flutter's `.adaptive` constructors

- **Chosen:** each `PlatformXxx` builds the actual Material widget on Android and the actual
  Cupertino widget on iOS. Nothing goes through `Switch.adaptive`, `AlertDialog.adaptive` and
  friends.
- **Why:** an `.adaptive` constructor bolts iOS onto a Material widget. It keeps the whole Material
  parameter list, so plenty of params quietly do nothing on iOS and nothing tells you which.
  Building the real widget per platform keeps every param meaningful where it's offered, see
  [field classification](#field-classification).

---

<a id="field-classification"></a>
## Field classification: functional vs visual

Every parameter on a `PlatformXxx` widget (or `showPlatformXxx` helper) falls into exactly one of 3
buckets. The bucket determines where the field lives and whether per-platform override is possible.

### Buckets

- **Functional**: identity, control, callbacks, state-gating, input data, behavioral tuning. Things
  that should never differ by platform, the library's value proposition is "same behavior, different
  look".
  - Identity / control: `widgetKey`, `key`, `focusNode`, `controller`, `undoController`,
    `scrollController`, `restorationId`, `groupId`.
  - Callbacks: `onPressed`, `onChanged`, `onTap`, `onFocusChange`, `onSubmitted`,
    `onEditingComplete`, `onLongPress`.
  - State-gating: `isEnabled`, `enabled`, `readOnly`, `autofocus`.
  - Input data: `value`, `child`, `placeholder`, `text`.
  - Behavioral tuning: `autocorrect`, `enableSuggestions`, `dragStartBehavior`, `maxLines`,
    `maxLength`, `keyboardType`, `textInputAction`, `textCapitalization`.
- **Visual, shared across platforms**: visual concept that exists on both platforms' underlying
  widgets (possibly under different parameter names or types. See
  [`#cross-platform-field-mappings`](#cross-platform-field-mappings)). E.g. `activeThumbColor`,
  `activeTrackColor`, `padding`, `cursorColor`. Per-platform override is possible, callers may want
  different shades on iOS vs Android.
- **Platform-only**: concept (visual or functional) exists on one platform's underlying widget with
  no equivalent on the other. Visual examples: Material's `ButtonStyle`, `MaterialTapTargetSize`,
  `splashRadius`. Cupertino's `applyTheme`, `onLabelColor`, `crossAxisAlignment`,
  `CupertinoButtonSize`. Functional example: `CupertinoProgressIndicatorData.animating` (toggle for
  Cupertino's spinner, no Material equivalent). When a concept has no equivalent on the other
  platform, there's nothing to keep in sync, it belongs on the per-platform record regardless of
  whether it would otherwise be visual or functional.

### Where each bucket lives

| Bucket         | Lives on                                                                                                                                 | Override possible?                                |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| Functional     | `PlatformXxx` widget, flat `const` constructor param                                                                                     | No, single source of truth                        |
| Visual, shared | `PlatformXxx` widget (flat default) **and** private `_PlatformXxxData` abstract base inherited by `MaterialXxxData` / `CupertinoXxxData` | Yes, per-platform record overrides widget default |
| Platform-only  | `MaterialXxxData` or `CupertinoXxxData` (whichever platform exposes the concept)                                                         | N/A, only one place to set it                     |

Build-method resolution:

- **Functional**: `this.field` directly.
- **Shared visual**: `materialXxxData?.field ?? this.field` on Material branch,
  `cupertinoXxxData?.field ?? this.field` on Cupertino branch.
- **Platform-only visual**: read only on its own branch.

### Why this shape

- **Functional flat on the widget.** Callers write `PlatformSwitch(value: …, onChanged: …)`: reads
  like a normal Flutter widget. There is no public `PlatformXxxData` class to construct at call
  sites. The type system forbids passing actions through per-platform records.
- **Shared visual flat + overridable.** Default reads ergonomically
  (`activeThumbColor: Colors.green` once), and callers wanting different shades per platform reach
  for `materialXxxData` / `cupertinoXxxData`.
- **Private `_PlatformXxxData` base, not public.** Exists only so per-platform records inherit
  shared-visual fields via `super.x` forwarding, compile-time-checked, no codegen needed for that
  edge. (The other 2 edges, the widget mirroring the base's fields, and the `??` build-method
  wiring, are *not* compiler-checked. They're held by the parity guard, see
  [*Enforcement*](#field-classification) below.) Never exported from
  [`lib/platform_adaptive_widgets.dart`](./lib/platform_adaptive_widgets.dart), so callers never see
  it.

### Rule of thumb for new fields

1. Does the concept exist on both platforms' underlying widgets (possibly under different parameter
   names or types. See [`#cross-platform-field-mappings`](#cross-platform-field-mappings))?
   - **No** → platform-only, lives on `MaterialXxxData` or `CupertinoXxxData` (whichever platform
     exposes the concept). Visual or functional doesn't matter, there's no cross-platform sync to
     enforce. Skip to #3.
   - **Yes** → continue to #2.
2. Could this field's value reasonably differ by platform on the same caller's app screen?
   - **No** → functional, flat `const` param on the widget.
   - **Yes** → shared visual, on `_PlatformXxxData` base + flat widget param.
3. **Don't invent a unifying abstraction** for fields that are only superficially similar. If
   `MaterialFoo.color` paints fill and `CupertinoFoo.tint` paints border, they're 2 platform-only
   fields, not a shared visual.

<a id="callback-nullability"></a>
### Callback nullability

For function-typed fields (callbacks, listeners), the functional-bucket rule forks based on whether
the callback is essential to the widget:

- **Essential callbacks**: the widget is meaningless without them (`PlatformSwitch.onChanged`,
  `PlatformButton.onPressed`). Declared as `required ValueChanged<T>` / `required VoidCallback`:
  non-null. The caller must provide one.
- **Optional observation callbacks**: the widget works without them. The caller opts in to be
  notified (`onFocusChange`, `onHover`, image error listeners). Declared as `ValueChanged<T>?` /
  `VoidCallback?`: nullable, no `required`.

**Never** use callback nullability to encode "disabled" state. `isEnabled: bool` is the only
disabling mechanism, the underlying platform widget receives a `null` callback when
`isEnabled: false`, but the package's public API keeps the 2 concerns separate.

This is a deliberate deviation from Flutter's `Widget.onChanged: null = disabled` convention. The
trade-off, more explicit at call sites, no nullability dance, no ambiguity between "no callback
registered" and "widget disabled", is worth the divergence for a package whose value proposition is
explicit, behavior-stable adaptation.

When a widget is fundamentally interactive but a caller wants a display-only variant, the right
answer is to use a different widget (e.g. `Text` instead of `PlatformButton` with a no-op callback),
not to make the callback nullable.

<a id="checkbox-tristate-split"></a>
### Tristate checkbox split

`PlatformCheckbox`'s default constructor exposes non-null `value: bool` /
`onChanged: ValueChanged<bool>`: the common 2-state case. The indeterminate (third) state, supported
natively on both platforms, is a second constructor, `PlatformCheckbox.tristate`, whose `value` /
`onChanged` are nullable (`bool?`).

**Why not one `tristate`-flagged widget with nullable `value` / `onChanged` (Flutter's own shape).**
That forces the nullability dance (`v!`, `v ?? false`, `bool?`-typed state) onto the *common*
2-state caller, contradicting [#callback-nullability](#callback-nullability): the package's
interactive widgets give callers non-null callbacks, with `PlatformSwitch` as the model. The
checkbox is the one control with a genuine third state, so the third state gets its own constructor
and the default stays non-null. Dropping tristate entirely was rejected, both platforms support the
indeterminate state natively (Cupertino renders `null` as a dash, like Material), and it's
demonstrated in the example.

**Why 2 constructors on one class can't share a single `onChanged` field.** `buildMaterial` /
`buildCupertino` hand `onChanged` to `Checkbox` / `CupertinoCheckbox`, both of which type it
`ValueChanged<bool?>?`, so a stored callback must be `ValueChanged<bool?>`. `value` *can* be one
shared `bool?` field (the default constructor narrows it with a `required bool this.value` formal,
`bool` is a subtype of `bool?`), but `onChanged` cannot: function parameters are contravariant, so
`ValueChanged<bool>` is a *supertype* of `ValueChanged<bool?>`, and storing the default's
`ValueChanged<bool>` into a `ValueChanged<bool?>` field needs an adapter closure, which can't run in
a `const` constructor.

**How.** 2 **private** callback fields, `_onChanged` (`ValueChanged<bool>?`) and
`_onChangedTristate` (`ValueChanged<bool?>?`), exactly one non-null per instance. Keep both
constructors `const`. The default ctor binds its callback as a `this._onChanged` initializing formal
*typed* `ValueChanged<bool>`: Dart drops the leading underscore, so callers still pass a non-null
`onChanged:` and no `prefer_initializing_formals` ignore is needed. Private fields as named
initializing formals need a recent Dart, which the `pubspec.yaml` floor already guarantees. (Omit
the type and the formal inherits the field's nullable type, silently re-opening `onChanged` to
`null`: the bug to avoid.) The `.tristate` ctor assigns in the initializer list instead, it can't
use the formal because its field `_onChangedTristate` would surface as `onChangedTristate`, while
its public parameter must also be `onChanged` (the lint leaves that assignment alone for the same
reason). Widening to the underlying `ValueChanged<bool?>?` happens at *build* time, not construction
(so both ctors stay `const`): build uses `_onChangedTristate ?? _adaptedOnChanged`, with
`_adaptedOnChanged` = `(v) => _onChanged!(v!)`: safe, reached only in 2-state mode where
`tristate: false` never yields null. `_isTristate` is `_onChangedTristate != null`.

**Chosen over 2 sibling classes** (`PlatformCheckbox` + `PlatformTristateCheckbox`) for the single
discoverable name plus a `.tristate` constructor. The costs are minor and accepted:

- One extra null pointer-slot per instance (the unused callback field). Not a heap allocation,
  `null` doesn't allocate, and object layout is per-class, so it isn't elided, ~8 bytes on an
  immutable widget.
- `value` is one `bool?` field, so `widget.value` reads back as `bool?` even on the 2-state path
  (the default constructor still rejects `null` at the call site via the narrowing formal).

### Carve-outs

- **Callbacks tightly coupled to a single visual field** (e.g. `onActiveThumbImageError` for
  `activeThumbImage`) follow that visual field's bucket, not the general "callbacks are functional"
  rule. They're a parameter of the visual field, not an independent action.
- **Emphasis and action kind** (`PlatformButton.emphasis`, `.actionKind`) change the look, yet live
  flat on the widget with no per-platform override, like functional fields. Both platforms read the
  one value, so a button can't rank differently on each, or turn destructive on one only.
- **Bar content is shared as data, raw widgets per platform.** `PlatformAppBar.actions` and
  `.primaryAction` take `PlatformBarAction`s, which the bar builds into each platform's own bar
  button, so none can misfit the bar. A raw widget goes only in a per-platform slot
  (`MaterialAppBarData.leading` and `.actions`, `CupertinoNavigationBarData.leading` and `.trailing`),
  which replaces that side's own. The leading has no shared slot, since both bars fill it themselves:
  back, a full-screen dialog's or a sheet's close or Cancel, Material's drawer button.
- **`showPlatformXxx` helpers** apply the same rule: functional params flat on the function
  signature. Visual via per-platform records.
- **Platform-only *capabilities*, not just fields.** A whole feature can exist on one platform and
  be disallowed on the other, then it's a platform-only field with no shared/common form.
  `MaterialTabScaffoldData.appBar` is the worked example: Material permits a persistent top app bar
  above tab content (a `Scaffold` with *both* `appBar` and `bottomNavigationBar`), but iOS's HIG
  structures each tab as its own navigation stack with its own nav bar and `CupertinoTabScaffold`
  has no top-bar slot, so the unified tab app bar is Material-only by design, never a shared param.
  (Contrast `bottomNavigationBar`, which `PlatformTabScaffold` *owns*, it builds the tab bar, so
  that slot is exposed on neither record.)

### What this rules out

- A public `PlatformXxxData` class, the shared-visual base is private.
- **Cross-platform** functional fields (callbacks, controllers, value, state-gating that exist on
  both platforms) on `MaterialXxxData` or `CupertinoXxxData`. If the concept exists on both, it must
  be flat on the widget, never in a per-platform record. (Platform-only functional fields, e.g.
  `MaterialProgressIndicatorData.value`, are the exception: they have no other home since the
  concept doesn't exist on the other side.)
- Direct passthrough to `Switch` / `CupertinoSwitch` constructor signatures. The widget still owns
  its public API. Per-platform records do not leak the underlying widget's full surface.

### Enforcement: the data ↔ widget parity guard

The 2 halves of this contract the Dart compiler does **not** check are guarded by a static AST test
that runs on every PR (in CI's Tests job, `ci / Tests`, from
[dartender's `ci.yml`](https://github.com/LahaLuhem/dartender/blob/main/.github/workflows/ci.yml)):
[`test/data_widget_parity_test.dart`](./test/data_widget_parity_test.dart). For every canonical
widget, those whose shared-visual fields live on a private `_PlatformXxxData` base, it asserts:

1. **Field-set parity**: every field on the `_PlatformXxxData` base also exists as a flat field on
   the matching `PlatformXxx` widget. Dart already checks `super.x` forwarding (base → records) and
   constructor-params → field declarations, but nothing forces the widget to mirror the base: a base
   field with no flat twin compiles, yet can never be set at the call site.
2. **Build-method wiring**: every base field is merged via `materialXxxData?.field ?? field` in
   `buildMaterial` *and* `cupertinoXxxData?.field ?? field` in `buildCupertino` (the resolution
   idiom from [*Where each bucket lives*](#field-classification)). A forgotten or misdirected
   fallback compiles, type-checks, and silently drops the per-platform override, the more dangerous
   edge, and the one the compiler is blindest to.

A third check asserts the guard actually discovered the known canonical widgets, so a future
analyzer-AST change or a `lib/src/models/` move can't quietly reduce it to a vacuous pass. A
fourth asserts it finds fields on every base, since a new way of declaring them hides them all: the
move to primary constructors did, and both checks passed on nothing until this one. Bases
that exist only to DRY a single field across their 2 records with no flat widget twin by design,
`_PlatformScaffoldData` and `_PlatformAppBarData`, whose lone `backgroundColor` is read straight off
the record, are listed in the test's `_basesWithoutFlatMirror` and skipped.

The guard catches the 2 *mechanical* drift modes (a new shared field left unmirrored, or wired in
only one builder). It does not adjudicate whether a field *belongs* on the shared base vs a
per-platform record. That's the human judgement the buckets above describe.

---

<a id="cross-platform-field-mappings"></a>
## Cross-platform field mappings

Shared-visual fields where the package's unified surface diverges from the underlying widget
parameter on one or both platforms, either by **name** (e.g. `activeThumbColor` ↔ `thumbColor`) or
by **type / nullability** (e.g. the package's `Color?` passed to a `Color` non-null Cupertino
parameter). Each row maps a single package field to its native counterparts.

| Widget                  | Package field      | Material maps to                                                       | Cupertino maps to                                                                                  | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|-------------------------|--------------------|------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `PlatformSwitch`        | `activeThumbColor` | `Switch.activeThumbColor`                                              | `CupertinoSwitch.thumbColor`                                                                       | Cupertino's `thumbColor` represents the active-state thumb color (no inactive equivalent on Cupertino's single-thumb design). The package's `active` prefix disambiguates.                                                                                                                                                                                                                                                               |
| `PlatformSwitch`        | `mouseCursor`      | `Switch.mouseCursor` (`MouseCursor?`)                                  | `CupertinoSwitch.mouseCursor` (`WidgetStateProperty<MouseCursor>?`)                                | Package unifies as `WidgetStateProperty<MouseCursor>?`. Material branch resolves to a single `MouseCursor` via `.resolve({.selected, .hovered, .focused, .disabled})` at build time.                                                                                                                                                                                                                                                     |
| `PlatformSlider`        | `thumbColor`       | `Slider.thumbColor` (`Color?`)                                         | `CupertinoSlider.thumbColor` (`Color`, non-null, default `CupertinoColors.white`)                  | Package exposes `Color?`. Material branch passes through (theme fallback intact when null). Cupertino branch falls back to `kDefaultCupertinoSliderThumbColor = CupertinoColors.white` when null.                                                                                                                                                                                                                                        |
| `PlatformListTile`      | `title`            | `ListTile.title` (`Widget?`)                                           | `CupertinoListTile.title` (`Widget`, required non-null)                                            | Package requires `Widget title` non-null to satisfy Cupertino's stricter contract. The previous package crashed at runtime when both `title` and `materialListTileData?.title` were null on iOS.                                                                                                                                                                                                                                         |
| `PlatformListTile`      | `leadingWidth`     | `ListTile.minLeadingWidth` (`double?`)                                 | `CupertinoListTile.leadingSize` (`double`, non-null, default `28.0` for base / `30.0` for notched) | Package exposes `double?`. Material passes through. Cupertino branch substitutes `kDefaultCupertinoListTileLeadingSize` for the base variant or `kDefaultCupertinoNotchedListTileLeadingSize` for the notched variant when null.                                                                                                                                                                                                         |
| `PlatformListTile`      | `color`            | `ListTile.tileColor` (`Color?`)                                        | `CupertinoListTile.backgroundColor` (`Color?`)                                                     | Same `Color?` nullability on both, differ only by parameter name. Package's `color` chosen for brevity.                                                                                                                                                                                                                                                                                                                                  |
| `PlatformListTile`      | `padding`          | `ListTile.contentPadding` (`EdgeInsetsGeometry?`)                      | `CupertinoListTile.padding` (`EdgeInsetsGeometry?`)                                                | Same `EdgeInsetsGeometry?` nullability on both, differ only by parameter name.                                                                                                                                                                                                                                                                                                                                                           |
| `PlatformRadio`         | `fillColor`        | `Radio.fillColor` (`WidgetStateProperty<Color?>?`)                     | `CupertinoRadio.fillColor` (`Color?`)                                                              | Package exposes the richer `WidgetStateProperty<Color?>?`. Material passes through. Cupertino branch resolves to a single `Color?` via `.resolve({.selected, if (!isEnabled) .disabled})`: radios primarily render the fill colour when selected. The build-time-known `isEnabled` flag drives the disabled-state branch.                                                                                                                |
| `PlatformExpansionTile` | `child`            | `ExpansionTile.children` (`List<Widget>`, default `<Widget>[]`)        | `CupertinoExpansionTile.child` (`Widget`, required non-null)                                       | Package exposes a single `Widget child` (required non-null) since Cupertino requires it. Material branch wraps as `[child]`. Callers wanting multiple Material children wrap with `Column` at the call site.                                                                                                                                                                                                                             |
| `PlatformSearchBar`     | `hintText`         | `SearchBar.hintText` (`String?`)                                       | `CupertinoSearchTextField.placeholder` (`String?`)                                                 | Same `String?` nullability on both, differ only by parameter name. Package's `hintText` chosen to mirror Material's term and the package's own `PlatformTextField.hintText`.                                                                                                                                                                                                                                                             |
| `PlatformSearchBar`     | `leading`          | `SearchBar.leading` (`Widget?`)                                        | `CupertinoSearchTextField.prefixIcon` (`Widget`, non-null, default `Icon(CupertinoIcons.search)`)  | Package exposes `Widget?`. Material passes through. Cupertino branch substitutes `kDefaultCupertinoSearchBarLeading` when null.                                                                                                                                                                                                                                                                                                          |
| `PlatformSearchBar`     | `autoFocus`        | `SearchBar.autoFocus` (`bool`, default `false`)                        | `CupertinoSearchTextField.autofocus` (`bool`, default `false`). Note lower-`f`                     | Same `bool` default `false` on both, differ only by `F`/`f` case. Package picks Material's `autoFocus` (camelCase) as the canonical spelling.                                                                                                                                                                                                                                                                                            |
| `PlatformSearchBar`     | `isEnabled`        | `SearchBar.enabled` (`bool`, default `true`)                           | `CupertinoSearchTextField.enabled` (`bool?`, `null` means enabled)                                 | Package collapses both to a single non-null `bool` named `isEnabled` per the package convention (see `#callback-nullability`). Cupertino's tri-state is reduced to the same boolean.                                                                                                                                                                                                                                                     |
| `PlatformTextField`     | `hintText`         | `TextField.decoration.hintText` (`String?` inside `InputDecoration`)   | `CupertinoTextField.placeholder` (`String?`, top-level)                                            | Material has no top-level placeholder, it lives inside the [InputDecoration] blob. The package surfaces a flat `hintText: String?` on the widget, merged into Material's decoration via `decoration.copyWith(hintText: …)` at build time (data-class `decoration.hintText` wins when set, flat fills the gap), and passed directly to Cupertino's top-level `placeholder` (with `cupertinoTextFieldData.placeholder` override when set). |
| `PlatformTextField`     | `prefix`           | `TextField.decoration.prefixIcon` (`Widget?` inside `InputDecoration`) | `CupertinoTextField.prefix` (`Widget?`, top-level, visibility via `prefixMode`)                    | Maps to Material's `prefixIcon` (always-visible icon slot), *not* `decoration.prefix` (focus-dependent visibility). The flat slot is merged into Material's decoration the same way as `hintText`. Same data-class-wins precedence on each side.                                                                                                                                                                                         |
| `PlatformTextField`     | `suffix`           | `TextField.decoration.suffixIcon` (`Widget?` inside `InputDecoration`) | `CupertinoTextField.suffix` (`Widget?`, top-level, visibility via `suffixMode`)                    | Symmetric to `prefix`: maps to Material's `suffixIcon`.                                                                                                                                                                                                                                                                                                                                                                                  |
| `PlatformTextField`     | `isEnabled`        | `TextField.enabled` (`bool?`, `null` means enabled)                    | `CupertinoTextField.enabled` (`bool`, default `true`)                                              | Package collapses both to a single non-null `bool` named `isEnabled` per the package convention. Material's nullable accepts the non-null `bool` straight through.                                                                                                                                                                                                                                                                       |

### When to add an entry

During a widget's review phase, every shared-visual field where the underlying parameter diverges
from the package's chosen unified surface, either by name or by type / nullability, gets a row here.
**Same fact, 3 places to repeat it**: this table, the dartdoc on the widget's flat field, and the
dartdoc on `_PlatformXxxData`'s field. All 3 say "maps to `UnderlyingWidget.nativeParam` on iOS /
Android", and where the type diverges, name the conversion the build method performs.

### Choosing the unified surface

When the 2 underlying parameters diverge:

- **Names differ.** Prefer the less ambiguous name, `activeThumbColor` beats `thumbColor` because
  the latter silently raises "active or inactive?".
- **Names match, types / nullability differ.** Prefer the looser type so neither platform's full
  surface is lost: Material `Color?` + Cupertino `Color` → package exposes `Color?` and the
  Cupertino branch supplies a default when null. Material `MouseCursor?` + Cupertino
  `WidgetStateProperty<MouseCursor>?` → package exposes the richer
  `WidgetStateProperty<MouseCursor>?` and the Material branch resolves at build time.
- Don't invent a third name unless both native names are bad. Pick one, document the mapping for the
  other side.
- If the 2 native parameters agree on both name and type (e.g. `activeTrackColor: Color?` on both
  sides), no mapping is needed and no row goes here.

### Why centralise

Per-field dartdoc handles the dev writing one `PlatformSwitch(activeThumbColor: …)` call. The table
is for the **maintainer**: when a Flutter SDK update renames a parameter, this is the canonical list
of fields whose mapping could silently break. Without it, a renamed underlying parameter slips
through as a runtime mismatch.

---

<a id="models-widgets-mirror-layout"></a>
## `lib/src/models/` mirrors `lib/src/widgets/`

- **Chosen:** the `models/` and `widgets/` trees use the same sub-categories (`dialogs/`,
  `interaction/`, `layout/`, `painting/`). Every `*_data.dart` lives in `models/<category>/` and
  every widget impl lives in `widgets/<category>/`: paired by name (`platform_button.dart` in
  `widgets/interaction/`, `platform_button_data.dart` in `models/interaction/`).
- **Why?** Each `*Data` record is conceptually a *parameter* of its widget, they ship together,
  version together, and break together. Co-locating them by category means a reader can navigate
  from a widget to its config classes (and vice versa) without grepping. The duplication of category
  names is intentional: it's the navigational handle.
- **Why 2 trees instead of one folder per widget?** Some categories (`dialogs/`) carry cross-cutting
  consts (`const_values.dart`) and standalone helpers that don't fit under a single widget. Keeping
  models and widgets in separate trees lets these helpers sit in `models/<category>/` where they
  belong (next to the data classes that consume them) without polluting the widget tree.
- **What this rules out:** dropping new widgets at the top of `lib/src/widgets/` or
  `lib/src/models/` (everything goes under a category), and inventing new category names for one-off
  widgets (pick the closest existing category, or open the question before introducing a new one,
  `interaction/` vs. `painting/` is not always obvious for visual-feedback widgets).

---

<a id="android-ios-only"></a>
## Cupertino on iOS and macOS, Material everywhere else

- **Chosen:** [`designLanguage`](./lib/src/utils/design_language.dart) makes the call, and a guard
  fails any other read of `defaultTargetPlatform` in `lib/src/`. On the web it goes by the browser's
  OS.
- **Why?** It's the split Flutter's own `.adaptive` widgets use. Cupertino is opt-in, so a platform
  Flutter adds later gets Material until someone moves it.
- **No runtime override.** One the app could set keeps both looks in every release build (42 KB more
  Cupertino on the Android harness, 2026-10-20). Debug builds already have Flutter's
  `debugDefaultTargetPlatformOverride` for previews.
- **No `platforms:` block** in `pubspec.yaml`, so pub.dev reads support off the code, which is every
  platform. A block would only take some away.
- **A third look** (`macos_ui`, `fluent_ui`) is a new enum value, and the compiler lists every
  switch that needs an arm.

---

<a id="aot-pruning-rules"></a>
## AOT pruning: which patterns prune, which leak

Release builds should carry only the look they show. `defaultTargetPlatform` is
`@pragma('vm:platform-const-if', !kDebugMode)`, so AOT folds a switch on it, or on `designLanguage`,
down to one arm. Whether the other arm's code drops out depends on the dispatch's shape:

| Pattern                                                               | Prunes? | Why                                                                                                                                                           |
|-----------------------------------------------------------------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Inline `switch (designLanguage)`                                      | ✓       | The other arm is dead code.                                                                                                                                   |
| `PlatformWidgetBase.build` calling `buildMaterial` / `buildCupertino` | ✓       | The base's switch folds and the halves devirtualize. With many subclasses, each keeps a `buildCupertino` vtable slot and its name (~30 B), but the bodies go. |
| Value selectors (`platformValue` and co)                              | ✗       | Both values are built at the call site, before the selector picks one.                                                                                        |
| A builder closure passed as an argument                               | ✗       | The closure exists whether or not it's called.                                                                                                                |

### Internal rules the package follows

1. **`showPlatformXxx` functions switch on `designLanguage` first**, and each arm calls an internal
   helper for one look, so the other helper is unreachable.
2. **Widgets dispatch through `PlatformWidgetBase`.** See
   [`#platform-widget-base-hierarchy`](#platform-widget-base-hierarchy).
3. **`static const` defaults in `*Data` classes that name Cupertino types don't leak code.** AOT
   keeps them as metadata and drops them when unused (measured).

### Public value selectors in [`platform_value.dart`](./lib/src/utils/platform_value.dart)

They're kept for cheap values (colours, enums, `IconData`), with the cost in their dartdoc, and
lint-banned inside `lib/src/`. On the harness, a `CupertinoDatePicker` routed through one stayed in
the Android build (≈342 KB with what it pulls in), where an inline switch dropped it. The lazy forms
ship the same bytes, since a closure keeps its body reachable too. `context.platformIcon` has its
own inline switch.

### Why the `targetPlatform` shim was removed (v2.0.0 breaking change)

It re-exported `defaultTargetPlatform` for test seams and forward-compat nobody used, and put a
layer between callers and the folding pragma. Direct use built a byte-identical Android `libapp.so`
(2026-05-30), so import `defaultTargetPlatform` from `package:flutter/foundation.dart` instead. Its
`isAndroid` / `isIOS` getters later went for [`designLanguage`](#android-ios-only), since app code
branches on the look, and `isIOS` picked the wrong one on macOS.

### Enforcement: regression guards on every PR

1. **AST lint**, [`test/aot_pruning_regression_test.dart`](./test/aot_pruning_regression_test.dart),
   in `ci / Tests`. Fails if `lib/src/` calls a value selector, or an internal helper (a `_` name,
   or anything in a file the barrel doesn't export) takes both a `material*` and a `cupertino*`
   builder, the two usual ways dispatch slips.
2. **Size benchmark**, [`tool/check_size_regression.dart`](./tool/check_size_regression.dart) over
   [`tool/size_harness/`](./tool/size_harness/), in `size-regression.yml`. Builds the harness for
   Android and fails once Cupertino-named bytes pass the budget at the top of the script. The
   harness touches every dispatch surface, so a leak the lint misses still trips it.

Raise the budget only when an SDK update grows the Cupertino baseline, never to quiet a leak.

---

<a id="two-entry-point-example"></a>
## Entry points in `example/`: `main.dart` and `main_go_router.dart`

- **Chosen:** the demo app under `example/lib/` ships 2 `main()` functions:
  - [`example/lib/main.dart`](./example/lib/main.dart), boots `PlatformApp` with a scaffold-managed
    tab structure (Catalog / Under the hood / About) where `PlatformTabScaffold` owns the
    selected-index state.
  - [`example/lib/main_go_router.dart`](./example/lib/main_go_router.dart), boots
    `PlatformApp.router` with `go_router`'s `StatefulNavigationShell`, where tab selection is driven
    by the router rather than the scaffold.
- **Why 2 entry points instead of one?** `PlatformApp` and `PlatformApp.router` are *both* part of
  the public API, and they exercise meaningfully different navigation invariants. A single entry
  point would force a choice between the router-less ergonomic demo and the router-integrated
  showcase. Shipping both as separate `main` files keeps the example honest about both modes.
  `flutter run -t lib/main.dart` and `flutter run -t lib/main_go_router.dart` pick between them.
- **What stays shared.** The `features/` tree, `features/core/data/constants/const_theme.dart`, and
  the feature view-models are reused across both entry points. Only the bootstrap and the
  `app/router/` subtree are router-specific. New features should work under both entry points where
  the navigation shape allows. `AppArgs.isUsingGoRouter`
  ([`example/lib/features/core/data/models/app_args.dart`](./example/lib/features/core/data/models/app_args.dart))
  carries which backend is active. The About tab surfaces it in its "This build" readout.
- **Verification implication.** When changing anything that touches `PlatformApp`,
  `PlatformTabScaffold`, or navigation state more broadly, run *both* entry points on both Android
  and iOS before claiming the change is done.
