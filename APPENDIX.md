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

<a id="field-classification"></a>
## Field classification: functional vs visual

Every parameter on a `PlatformXxx` widget (or `showPlatformXxx` helper) falls into
exactly one of three buckets. The bucket determines where the field lives and
whether per-platform override is possible.

### Buckets

- **Functional** — identity, control, callbacks, state-gating, input data,
  behavioral tuning. Things that should never differ by platform — the
  library's value proposition is "same behavior, different look".
  - Identity / control: `widgetKey`, `key`, `focusNode`, `controller`,
    `undoController`, `scrollController`, `restorationId`, `groupId`.
  - Callbacks: `onPressed`, `onChanged`, `onTap`, `onFocusChange`,
    `onSubmitted`, `onEditingComplete`, `onLongPress`.
  - State-gating: `isEnabled`, `enabled`, `readOnly`, `autofocus`.
  - Input data: `value`, `child`, `placeholder`, `text`.
  - Behavioral tuning: `autocorrect`, `enableSuggestions`, `dragStartBehavior`,
    `maxLines`, `maxLength`, `keyboardType`, `textInputAction`,
    `textCapitalization`.
- **Visual, shared across platforms** — visual concept that exists on both
  platforms' underlying widgets (possibly under different parameter names or
  types — see
  [`#cross-platform-field-mappings`](#cross-platform-field-mappings)). E.g.
  `activeThumbColor`, `activeTrackColor`, `padding`, `cursorColor`. Per-platform
  override is possible — callers may want different shades on iOS vs Android.
- **Platform-only** — concept (visual or functional) exists on one
  platform's underlying widget with no equivalent on the other. Visual
  examples: Material's `ButtonStyle`, `MaterialTapTargetSize`,
  `splashRadius`; Cupertino's `applyTheme`, `onLabelColor`,
  `crossAxisAlignment`, `CupertinoButtonSize`. Functional examples:
  `MaterialProgressIndicatorData.value` (Material has progress; Cupertino's
  activity indicator is always indeterminate);
  `CupertinoProgressIndicatorData.animating` (toggle for Cupertino's
  spinner, no Material equivalent). When a concept has no equivalent on the
  other platform, there's nothing to keep in sync — it belongs on the
  per-platform record regardless of whether it would otherwise be visual
  or functional.

### Where each bucket lives

| Bucket                | Lives on                                                                                                                                | Override possible?                                 |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|
| Functional            | `PlatformXxx` widget — flat `const` constructor param                                                                                   | No — single source of truth                        |
| Visual, shared        | `PlatformXxx` widget (flat default) **and** private `_PlatformXxxData` abstract base inherited by `MaterialXxxData` / `CupertinoXxxData` | Yes — per-platform record overrides widget default |
| Platform-only         | `MaterialXxxData` or `CupertinoXxxData` (whichever platform exposes the concept)                                                        | N/A — only one place to set it                     |

Build-method resolution:

- **Functional**: `this.field` directly.
- **Shared visual**: `materialXxxData?.field ?? this.field` on Material branch;
  `cupertinoXxxData?.field ?? this.field` on Cupertino branch.
- **Platform-only visual**: read only on its own branch.

### Why this shape

- **Functional flat on the widget.** Callers write `PlatformSwitch(value: …,
  onChanged: …)` — reads like a normal Flutter widget. There is no public
  `PlatformXxxData` class to construct at call sites; the type system forbids
  passing actions through per-platform records.
- **Shared visual flat + overridable.** Default reads ergonomically
  (`activeThumbColor: Colors.green` once), and callers wanting different shades
  per platform reach for `materialXxxData` / `cupertinoXxxData`.
- **Private `_PlatformXxxData` base, not public.** Exists only so per-platform
  records inherit shared-visual fields via `super.x` forwarding —
  compile-time-checked, no codegen needed for that edge. Never exported from
  [`lib/platform_adaptive_widgets.dart`](./lib/platform_adaptive_widgets.dart);
  callers never see it.

### Rule of thumb for new fields

1. Does the concept exist on both platforms' underlying widgets (possibly
   under different parameter names or types — see
   [`#cross-platform-field-mappings`](#cross-platform-field-mappings))?
   - **No** → platform-only, lives on `MaterialXxxData` or
     `CupertinoXxxData` (whichever platform exposes the concept). Visual or
     functional doesn't matter — there's no cross-platform sync to enforce.
     Skip to #3.
   - **Yes** → continue to #2.
2. Could this field's value reasonably differ by platform on the same
   caller's app screen?
   - **No** → functional, flat `const` param on the widget.
   - **Yes** → shared visual, on `_PlatformXxxData` base + flat widget param.
3. **Don't invent a unifying abstraction** for fields that are only
   superficially similar. If `MaterialFoo.color` paints fill and
   `CupertinoFoo.tint` paints border, they're two platform-only fields —
   not a shared visual.

<a id="callback-nullability"></a>
### Callback nullability

For function-typed fields (callbacks, listeners), the functional-bucket rule
forks based on whether the callback is essential to the widget:

- **Essential callbacks** — the widget is meaningless without them
  (`PlatformSwitch.onChanged`, `PlatformButton.onPressed`). Declared as
  `required ValueChanged<T>` / `required VoidCallback` — non-null. The caller
  must provide one.
- **Optional observation callbacks** — the widget works without them; the
  caller opts in to be notified (`onFocusChange`, `onHover`, image error
  listeners). Declared as `ValueChanged<T>?` / `VoidCallback?` — nullable, no
  `required`.

**Never** use callback nullability to encode "disabled" state. `isEnabled: bool`
is the only disabling mechanism — the underlying platform widget receives a
`null` callback when `isEnabled: false`, but the package's public API keeps the
two concerns separate.

This is a deliberate deviation from Flutter's `Widget.onChanged: null = disabled`
convention. The trade-off — more explicit at call sites, no nullability dance,
no ambiguity between "no callback registered" and "widget disabled" — is worth
the divergence for a package whose value proposition is explicit, behavior-stable
adaptation.

When a widget is fundamentally interactive but a caller wants a display-only
variant, the right answer is to use a different widget (e.g. `Text` instead of
`PlatformButton` with a no-op callback), not to make the callback nullable.

<a id="checkbox-tristate-split"></a>
### Tristate checkbox split

`PlatformCheckbox`'s default constructor exposes non-null `value: bool` /
`onChanged: ValueChanged<bool>` — the common two-state case. The indeterminate
(third) state — supported natively on both platforms — is a second constructor,
`PlatformCheckbox.tristate`, whose `value` / `onChanged` are nullable (`bool?`).

**Why not one `tristate`-flagged widget with nullable `value` / `onChanged`
(Flutter's own shape).** That forces the nullability dance (`v!`, `v ?? false`,
`bool?`-typed state) onto the *common* two-state caller, contradicting
[#callback-nullability](#callback-nullability): the package's interactive
widgets give callers non-null callbacks, with `PlatformSwitch` as the model.
The checkbox is the one control with a genuine third state, so the third state
gets its own constructor and the default stays non-null. Dropping tristate
entirely was rejected — both platforms support the indeterminate state natively
(Cupertino renders `null` as a dash, like Material), and it's demonstrated in
the example.

**Why two constructors on one class can't share a single `onChanged` field.**
`buildMaterial` / `buildCupertino` hand `onChanged` to `Checkbox` /
`CupertinoCheckbox`, both of which type it `ValueChanged<bool?>?`, so a stored
callback must be `ValueChanged<bool?>`. `value` *can* be one shared `bool?`
field (the default constructor narrows it with a `required bool this.value`
formal — `bool` is a subtype of `bool?`), but `onChanged` cannot: function
parameters are contravariant, so `ValueChanged<bool>` is a *supertype* of
`ValueChanged<bool?>`, and storing the default's `ValueChanged<bool>` into a
`ValueChanged<bool?>` field needs an adapter closure — which can't run in a
`const` constructor.

**How.** Two **private** callback fields — `_onChanged` (`ValueChanged<bool>?`)
and `_onChangedTristate` (`ValueChanged<bool?>?`), exactly one non-null per
instance — keep both constructors `const`. The default ctor binds its callback
as a `this._onChanged` initializing formal *typed* `ValueChanged<bool>`: Dart
drops the leading underscore, so callers still pass a non-null `onChanged:` and
no `prefer_initializing_formals` ignore is needed. Private fields as named
initializing formals is a Dart 3.12 feature, gated by the package's
`sdk: >=3.12.0` constraint. (Omit the type and the formal inherits the field's
nullable type, silently re-opening `onChanged` to `null` — the bug to avoid.) The `.tristate` ctor assigns in the initializer list instead;
it can't use the formal because its field `_onChangedTristate` would surface as
`onChangedTristate`, while its public parameter must also be `onChanged` (the
lint leaves that assignment alone for the same reason). Widening to the
underlying `ValueChanged<bool?>?` happens at *build* time, not construction (so
both ctors stay `const`): build uses `_onChangedTristate ?? _adaptedOnChanged`,
with `_adaptedOnChanged` = `(v) => _onChanged!(v!)` — safe, reached only in
two-state mode where `tristate: false` never yields null. `_isTristate` is
`_onChangedTristate != null`.

**Chosen over two sibling classes** (`PlatformCheckbox` +
`PlatformTristateCheckbox`) for the single discoverable name plus a `.tristate`
constructor. The costs are minor and accepted:
- One extra null pointer-slot per instance (the unused callback field). Not a
  heap allocation — `null` doesn't allocate — and object layout is per-class,
  so it isn't elided; ~8 bytes on an immutable widget.
- `value` is one `bool?` field, so `widget.value` reads back as `bool?` even on
  the two-state path (the default constructor still rejects `null` at the call
  site via the narrowing formal).

### Carve-outs

- **Callbacks tightly coupled to a single visual field** (e.g.
  `onActiveThumbImageError` for `activeThumbImage`) follow that visual field's
  bucket — not the general "callbacks are functional" rule. They're a parameter
  of the visual field, not an independent action.
- **Variant enums** (`MaterialButtonVariant`, `CupertinoButtonVariant`) live as
  flat fields on the widget. Each variant exists only on its own platform but
  the package exposes both at the widget level so callers pick per-platform
  without re-importing the underlying frameworks. Treated as functional for
  layout purposes (single source of truth on the widget).
- **`showPlatformXxx` helpers** apply the same rule: functional params flat on
  the function signature; visual via per-platform records.
- **Platform-only *capabilities*, not just fields.** A whole feature can exist
  on one platform and be disallowed on the other — then it's a platform-only
  field with no shared/common form. `MaterialTabScaffoldData.appBar` is the
  worked example: Material permits a persistent top app bar above tab content (a
  `Scaffold` with *both* `appBar` and `bottomNavigationBar`), but iOS's HIG
  structures each tab as its own navigation stack with its own nav bar and
  `CupertinoTabScaffold` has no top-bar slot — so the unified tab app bar is
  Material-only by design, never a shared param. (Contrast `bottomNavigationBar`,
  which `PlatformTabScaffold` *owns* — it builds the tab bar — so that slot is
  exposed on neither record.)

### What this rules out

- A public `PlatformXxxData` class — the shared-visual base is private.
- **Cross-platform** functional fields (callbacks, controllers, value,
  state-gating that exist on both platforms) on `MaterialXxxData` or
  `CupertinoXxxData`. If the concept exists on both, it must be flat on the
  widget — never in a per-platform record. (Platform-only functional fields
  — e.g. `MaterialProgressIndicatorData.value` — are the exception: they
  have no other home since the concept doesn't exist on the other side.)
- Direct passthrough to `Switch` / `CupertinoSwitch` constructor signatures.
  The widget still owns its public API; per-platform records do not leak the
  underlying widget's full surface.

---

<a id="cross-platform-field-mappings"></a>
## Cross-platform field mappings

Shared-visual fields where the package's unified surface diverges from the
underlying widget parameter on one or both platforms — either by **name**
(e.g. `activeThumbColor` ↔ `thumbColor`) or by **type / nullability** (e.g.
the package's `Color?` passed to a `Color` non-null Cupertino parameter).
Each row maps a single package field to its native counterparts.

| Widget | Package field | Material maps to | Cupertino maps to | Notes |
|--------|---------------|------------------|-------------------|-------|
| `PlatformSwitch` | `activeThumbColor` | `Switch.activeThumbColor` | `CupertinoSwitch.thumbColor` | Cupertino's `thumbColor` represents the active-state thumb color (no inactive equivalent on Cupertino's single-thumb design). The package's `active` prefix disambiguates. |
| `PlatformSwitch` | `mouseCursor` | `Switch.mouseCursor` (`MouseCursor?`) | `CupertinoSwitch.mouseCursor` (`WidgetStateProperty<MouseCursor>?`) | Package unifies as `WidgetStateProperty<MouseCursor>?`. Material branch resolves to a single `MouseCursor` via `.resolve({.selected, .hovered, .focused, .disabled})` at build time. |
| `PlatformSlider` | `thumbColor` | `Slider.thumbColor` (`Color?`) | `CupertinoSlider.thumbColor` (`Color`, non-null, default `CupertinoColors.white`) | Package exposes `Color?`. Material branch passes through (theme fallback intact when null); Cupertino branch falls back to `kDefaultCupertinoSliderThumbColor = CupertinoColors.white` when null. |
| `PlatformListTile` | `title` | `ListTile.title` (`Widget?`) | `CupertinoListTile.title` (`Widget`, required non-null) | Package requires `Widget title` non-null to satisfy Cupertino's stricter contract. The previous package crashed at runtime when both `title` and `materialListTileData?.title` were null on iOS. |
| `PlatformListTile` | `leadingWidth` | `ListTile.minLeadingWidth` (`double?`) | `CupertinoListTile.leadingSize` (`double`, non-null, default `28.0` for base / `30.0` for notched) | Package exposes `double?`. Material passes through; Cupertino branch substitutes `kDefaultCupertinoListTileLeadingSize` for the base variant or `kDefaultCupertinoNotchedListTileLeadingSize` for the notched variant when null. |
| `PlatformListTile` | `color` | `ListTile.tileColor` (`Color?`) | `CupertinoListTile.backgroundColor` (`Color?`) | Same `Color?` nullability on both — differ only by parameter name. Package's `color` chosen for brevity. |
| `PlatformListTile` | `padding` | `ListTile.contentPadding` (`EdgeInsetsGeometry?`) | `CupertinoListTile.padding` (`EdgeInsetsGeometry?`) | Same `EdgeInsetsGeometry?` nullability on both — differ only by parameter name. |
| `PlatformRadio` | `fillColor` | `Radio.fillColor` (`WidgetStateProperty<Color?>?`) | `CupertinoRadio.fillColor` (`Color?`) | Package exposes the richer `WidgetStateProperty<Color?>?`. Material passes through; Cupertino branch resolves to a single `Color?` via `.resolve({.selected, if (!isEnabled) .disabled})` — radios primarily render the fill colour when selected; the build-time-known `isEnabled` flag drives the disabled-state branch. |
| `PlatformExpansionTile` | `child` | `ExpansionTile.children` (`List<Widget>`, default `<Widget>[]`) | `CupertinoExpansionTile.child` (`Widget`, required non-null) | Package exposes a single `Widget child` (required non-null) since Cupertino requires it. Material branch wraps as `[child]`. Callers wanting multiple Material children wrap with `Column` at the call site. |
| `PlatformSearchBar` | `hintText` | `SearchBar.hintText` (`String?`) | `CupertinoSearchTextField.placeholder` (`String?`) | Same `String?` nullability on both — differ only by parameter name. Package's `hintText` chosen to mirror Material's term and the package's own `PlatformTextField.hintText`. |
| `PlatformSearchBar` | `leading` | `SearchBar.leading` (`Widget?`) | `CupertinoSearchTextField.prefixIcon` (`Widget`, non-null, default `Icon(CupertinoIcons.search)`) | Package exposes `Widget?`. Material passes through; Cupertino branch substitutes `kDefaultCupertinoSearchBarLeading` when null. |
| `PlatformSearchBar` | `autoFocus` | `SearchBar.autoFocus` (`bool`, default `false`) | `CupertinoSearchTextField.autofocus` (`bool`, default `false`) — note lower-`f` | Same `bool` default `false` on both — differ only by `F`/`f` case. Package picks Material's `autoFocus` (camelCase) as the canonical spelling. |
| `PlatformSearchBar` | `isEnabled` | `SearchBar.enabled` (`bool`, default `true`) | `CupertinoSearchTextField.enabled` (`bool?`, `null` means enabled) | Package collapses both to a single non-null `bool` named `isEnabled` per the package convention (see `#callback-nullability`). Cupertino's tri-state is reduced to the same boolean. |
| `PlatformTextField` | `hintText` | `TextField.decoration.hintText` (`String?` inside `InputDecoration`) | `CupertinoTextField.placeholder` (`String?`, top-level) | Material has no top-level placeholder — it lives inside the [InputDecoration] blob. The package surfaces a flat `hintText: String?` on the widget, merged into Material's decoration via `decoration.copyWith(hintText: …)` at build time (data-class `decoration.hintText` wins when set, flat fills the gap), and passed directly to Cupertino's top-level `placeholder` (with `cupertinoTextFieldData.placeholder` override when set). |
| `PlatformTextField` | `prefix` | `TextField.decoration.prefixIcon` (`Widget?` inside `InputDecoration`) | `CupertinoTextField.prefix` (`Widget?`, top-level, visibility via `prefixMode`) | Maps to Material's `prefixIcon` (always-visible icon slot) — *not* `decoration.prefix` (focus-dependent visibility). The flat slot is merged into Material's decoration the same way as `hintText`. Same data-class-wins precedence on each side. |
| `PlatformTextField` | `suffix` | `TextField.decoration.suffixIcon` (`Widget?` inside `InputDecoration`) | `CupertinoTextField.suffix` (`Widget?`, top-level, visibility via `suffixMode`) | Symmetric to `prefix` — maps to Material's `suffixIcon`. |
| `PlatformTextField` | `isEnabled` | `TextField.enabled` (`bool?`, `null` means enabled) | `CupertinoTextField.enabled` (`bool`, default `true`) | Package collapses both to a single non-null `bool` named `isEnabled` per the package convention. Material's nullable accepts the non-null `bool` straight through. |

### When to add an entry

During a widget's review phase, every shared-visual field where the underlying
parameter diverges from the package's chosen unified surface — either by name
or by type / nullability — gets a row here. **Same fact, three places to
repeat it**: this table, the dartdoc on the widget's flat field, and the
dartdoc on `_PlatformXxxData`'s field. All three say "maps to
`UnderlyingWidget.nativeParam` on iOS / Android", and where the type
diverges, name the conversion the build method performs.

### Choosing the unified surface

When the two underlying parameters diverge:

- **Names differ.** Prefer the less ambiguous name — `activeThumbColor` beats
  `thumbColor` because the latter silently raises "active or inactive?".
- **Names match, types / nullability differ.** Prefer the looser type so
  neither platform's full surface is lost: Material `Color?` + Cupertino
  `Color` → package exposes `Color?` and the Cupertino branch supplies a
  default when null; Material `MouseCursor?` + Cupertino
  `WidgetStateProperty<MouseCursor>?` → package exposes the richer
  `WidgetStateProperty<MouseCursor>?` and the Material branch resolves at
  build time.
- Don't invent a third name unless both native names are bad. Pick one,
  document the mapping for the other side.
- If the two native parameters agree on both name and type (e.g.
  `activeTrackColor: Color?` on both sides), no mapping is needed and no row
  goes here.

### Why centralise

Per-field dartdoc handles the dev writing one `PlatformSwitch(activeThumbColor: …)`
call. The table is for the **maintainer** — when a Flutter SDK update renames a
parameter, this is the canonical list of fields whose mapping could silently
break. Without it, a renamed underlying parameter slips through as a runtime
mismatch.

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

### Enforcement: regression guards on every PR

Two complementary CI checks defend the pruning contract; both run on every PR
via `.github/workflows/package.yml`.

1. **Static AST lint** — [`test/aot_pruning_regression_test.dart`](./test/aot_pruning_regression_test.dart).
   Walks `lib/src/` and fails if any file (other than
   [`context_extensions.dart`](./lib/src/extensions/context_extensions.dart),
   where they're defined) calls `platformValue` / `platformLazyValue` /
   `platformValueNullable` / `platformLazyNullable`, or if any private helper
   declares both a `material*`- and a `cupertino*`-named function-typed
   parameter. Catches the dominant regression modes — re-using the
   closure-arg helpers, or factoring dispatch into a sub-helper — in
   sub-second wall time, locally and in CI.
2. **AOT size benchmark** — [`tool/check_size_regression.dart`](./tool/check_size_regression.dart)
   over [`tool/size_harness/`](./tool/size_harness/). CI builds the harness
   for `android-arm64` with `--analyze-size`, walks the symbol JSON, and
   fails if the total bytes whose path contains "cupertino" exceed the
   budget set at the top of the parser. The harness exercises every
   `showPlatformXxx`, one `PlatformWidgetBase` subclass, the
   `context.platformIcon` extension, and the `isAndroid` getter — so a
   pruning failure on any of those surfaces fails the build empirically,
   even if it slips past the static lint.

Necessary-but-not-sufficient (static) plus empirical (size) is the two-layer
contract. When the size budget needs raising because a Flutter SDK update
genuinely grew the Cupertino baseline, retune the constant in
`check_size_regression.dart` — never to silence a real leak, only to
re-baseline noise.

---

<a id="two-entry-point-example"></a>
## Two entry points in `example/`: `main.dart` and `main_go_router.dart`

- **Chosen:** the demo app under `example/lib/` ships two `main()` functions:
  - [`example/lib/main.dart`](./example/lib/main.dart) — boots `PlatformApp` with a
    scaffold-managed tab structure (Catalog / Under the hood / About) where
    `PlatformTabScaffold` owns the selected-index state.
  - [`example/lib/main_go_router.dart`](./example/lib/main_go_router.dart) — boots
    `PlatformApp.router` with `go_router`'s `StatefulNavigationShell`, where tab
    selection is driven by the router rather than the scaffold.
- **Why two entry points instead of one?** `PlatformApp` and `PlatformApp.router`
  are *both* part of the public API, and they exercise meaningfully different
  navigation invariants. A single entry point would force a choice between the
  router-less ergonomic demo and the router-integrated showcase; shipping both as
  separate `main` files keeps the example honest about both modes. `flutter run -t
  lib/main.dart` and `flutter run -t lib/main_go_router.dart` pick between them.
- **What stays shared.** The `features/` tree,
  `features/core/data/constants/const_theme.dart`, and the feature view-models are
  reused across both entry points. Only the bootstrap and the `app/router/` subtree
  are router-specific. New features should work under both entry points where the
  navigation shape allows. `AppArgs.isUsingGoRouter`
  ([`example/lib/features/core/data/models/app_args.dart`](./example/lib/features/core/data/models/app_args.dart))
  carries which backend is active — the About tab surfaces it in its "This build"
  readout.
- **Verification implication.** When changing anything that touches
  `PlatformApp`, `PlatformTabScaffold`, or navigation state more broadly, run *both*
  entry points on both Android and iOS before claiming the change is done.
