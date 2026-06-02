Library-package code style. Project facts (goal, stack, repo layout, hard rules) live in
[`.ai/AGENTS.md`](./.ai/AGENTS.md); design rationale lives in
[`APPENDIX.md`](./APPENDIX.md); example-app code style lives in
[`example/CODESTYLE.md`](./example/CODESTYLE.md).

The lint posture is deliberately strict (see
[`analysis_options.yaml`](./analysis_options.yaml) — the `errors:` block promotes many
lints to errors). The house style values explicit types, no ambient mutability, and
small focused classes.

Each heading below carries an explicit `<a id="…">` anchor. Link by anchor, not by
heading text, so renames don't break callers.

<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [Type safety & nullability](#type-safety-nullability)
- [Naming](#naming)
- [Formatting](#formatting)
- [Constants & magic numbers](#constants-magic-numbers)
- [Class structure](#class-structure)
- [Platform-adaptive widget patterns](#platform-adaptive-widget-patterns)
    * [Subclass `PlatformWidgetBase`, override the two builders](#subclass-platformwidgetbase-override-the-two-builders)
    * [Field classification: functional vs visual](#field-classification-functional-vs-visual)
- [Idioms](#idioms)
    * [Static dot shorthands (Dart 3.10+)](#static-dot-shorthands-dart-310)
    * [Drop redundant `<Type>` on collection literals](#drop-redundant-collection-literal-type-args)
    * [`Row.spacing` / `Column.spacing` / `Wrap.spacing` over interleaved `SizedBox` gaps](#flex-spacing-over-sizedbox-gaps)
    * [Enhanced enums for per-variant config](#enhanced-enums-for-per-variant-config)
    * [Collection-for / collection-if over `Iterable.map(…).toList()`](#collection-for-collection-if-over-iterablemaptolist)
    * [`dart:async` `wait` extensions over static `Future.wait(...)`](#dartasync-wait-extensions-over-static-futurewait)
    * [`List.unmodifiable(…)` over `UnmodifiableListView(…)`](#listunmodifiable-over-unmodifiablelistview)
    * [`part` / `part of` only when structurally needed](#part-part-of-only-when-structurally-needed)
- [Comments & dartdoc](#comments-dartdoc)
- [DCM rules (applied by hand)](#dcm-rules-applied-by-hand)
- [Documentation conventions (Markdown)](#documentation-conventions-markdown)

<!-- TOC end -->

<a id="type-safety-nullability"></a>
## Type safety & nullability

- **Type-annotate every public symbol.** Inference is fine on locals; public surfaces
  are not the place to rely on inference.
- **`final` by default for fields and locals.** Parameters are *not* required to be
  `final` — `avoid_final_parameters` allows mutation-shaped parameters, and
  `parameter_assignments` forbids the actual bad behaviour (mutating a parameter inside
  the body).
- **Nullability is explicit.** Use `T?` everywhere a value can be missing.
  `cast_nullable_to_non_nullable` is on — `as T` on a `T?` will fail lint.
- **Constrain generic type parameters to `<T extends Object>` by default.** Unbounded
  `<T>` lets `null` and `dynamic` satisfy `T` — the same failure modes the explicit-
  nullability rule and the [`dynamic`-escape-hatch ban](./.ai/AGENTS.md#hard-rules)
  guard against elsewhere. Bind to `Object` so the type system enforces "some real
  value, not null"; if a particular call site needs `null`, the call site spells it as
  `T?` and the binding stays put.

  Exception: when `T` flows directly into an external library API that itself uses
  unbounded `<T>` *and* relies on `null` as a sentinel `T` value — e.g. a dialog
  helper that pops with `context.pop()` (a `T = void` / null result for "dismissed
  without a value"). In those cases, leave `<T>` raw so callers can instantiate it
  with `void` / a nullable type. Don't reach for the exception speculatively — bind
  by default, loosen only when a real call site demands it.

  ```dart
  // Prefer:
  class PlatformRadio<T extends Object> extends PlatformWidgetKeyedBase { … }
  class PlatformSegmentButton<T extends Object> extends PlatformWidgetKeyedBase { … }

  // Over:
  class PlatformRadio<T> extends PlatformWidgetKeyedBase { … }

  // Exception (dialog result type may be null / void):
  Future<T?> showPlatformDialog<T>(…) { … }
  ```

  Bounded `T` is a subtype of unbounded `T` in parameter positions, so wrapping
  Flutter's raw-`<T>` widgets (e.g. `Radio<T>`, `RadioGroup<T>`) with a
  `<T extends Object>`-bound package widget is type-safe — the bound narrows the
  accepted set; the upstream's looser slot still accepts the narrower value.
- **No Java ceremony.** No getter-only abstract base classes, no `AbstractFooFactory`,
  no interface-per-class. Use mixins / sealed classes / records / extension types where
  they add clarity, not weight. The `PlatformWidgetBase` hierarchy is the legitimate
  exception — it encodes the dispatch invariant that defines the package.

The `dynamic`-escape-hatch ban and the `print()`-in-library ban are listed under
[*Hard rules* in `.ai/AGENTS.md`](./.ai/AGENTS.md#hard-rules) — they're contracts, not
style.

---

<a id="naming"></a>
## Naming

- **Prefer abbreviations over initialisms for domain terms.** In code, comments,
  dartdocs, and log messages alike, expand. Widely-known protocol initialisms (HTTP,
  DNS, TCP, TLS, …) and platform-name initialisms (iOS, OS) stay as-is; novel project
  terms get spelt out.
- **Local-variable names carry a concise type-suffix.** Dart is strongly typed, but a
  reader without IDE inlay-hints can't see the inferred type — the *name* has to do
  that work. Suffix a local with what it *is* so the next reader doesn't have to scroll
  back to the assignment (or install a plugin) to recover the type. **Callback
  parameters** are exempt and stay single-word (`value`, `direction`, `selectedDate`)
  — the enclosing call site already pins the type. Single-letter callback params are
  out, *except* symmetric pair-wise params in comparators / reducers where `(a, b)` is
  the genre convention. Regular method parameters follow the local-variable rule, not
  the callback exemption. **When a domain type exists, the suffix is the type name** —
  `cupertinoButtonData` (not `cupertinoData`), `platformAdaptiveIcons` (not `icons`),
  `tabDestinations` (not `destinations`). Generic suffixes (`Data`, `Info`, `Result`)
  lose the disambiguation the rule is meant to provide.

  ```dart
  // Prefer:
  final platformTheme = PlatformTheme.of(context);
  final selectedDirection = viewModel.directionalityListenable.value;

  // Over:
  final theme = PlatformTheme.of(context);
  final selected = viewModel.directionalityListenable.value;
  ```

  Strong format-string conventions (`hh`/`mm`/`ss` in a timestamp formatter, etc.)
  override this — the rule targets *type ambiguity*, not all short names.

- **Widget files mirror class names.** `PlatformButton` lives in
  `platform_button.dart`; `PlatformAlertDialogData` lives in
  `platform_alert_dialog_data.dart`. The model file always sits at
  `lib/src/models/<category>/<widget>_data.dart` and the widget file at
  `lib/src/widgets/<category>/<widget>.dart` — the linter enforces `file_names`, but
  the *category* placement is by convention (see
  [`APPENDIX.md#models-widgets-mirror-layout`](./APPENDIX.md#models-widgets-mirror-layout)).

---

<a id="formatting"></a>
## Formatting

- **Wrap text-file content at 100 columns.** `formatter.page_width: 100` in
  `analysis_options.yaml` is authoritative for Dart code; Markdown and **dartdoc
  comments** should follow the same cap manually. `dart format` does *not* reflow
  doc-comment prose — so a `///`-block hand-wrapped at 70 / 80 columns is invisible
  to the formatter and stays narrow forever unless someone refactors it. Default to
  ~95 columns of content (the leading `/// ` counts toward the 100-col limit) so a
  single trailing word doesn't push the line over. Reflow opportunistically when
  touching a doc block; don't churn unrelated files just to widen them.
- **Blank lines separate logical chunks within a method.** Group guard checks, setup,
  the main action, and finalisation with one blank line between groups. Lets readers
  scan past chunks they don't need without re-parsing them line-by-line.
- **Prefer expression bodies** (single-statement methods write as `=>` returns) and
  **single quotes** (`prefer_single_quotes`).

---

<a id="constants-magic-numbers"></a>
## Constants & magic numbers

- **No magic numbers in `lib/` code.** Pull constants to named `static const`s with a
  descriptive identifier. Most existing examples sit on the `*Data` class itself
  (`static const _shrunkCupertinoButtonData = CupertinoButtonData(padding: .zero);`) or
  in a dedicated `const_values.dart` next to the model
  (e.g. [`lib/src/models/dialogs/const_values.dart`](./lib/src/models/dialogs/const_values.dart)).
- **Cross-cutting defaults belong in a `const_values.dart` co-located with their
  consumers.** When more than one widget in the same category needs the same default,
  promote it; when only one widget needs it, keep it as a `static const` on that
  widget's `*Data` class. The reference package's `Values` god-class is **not** the
  pattern here — Flutter packages get a thicker per-category const file. Before
  introducing a new magic number or default, check the existing `const_values.dart`
  files in the same category first.
- **Inline single-use defaults; don't promote to a named `kDefault…` constant.** A
  `kDefaultXxx` declaration earns its name when the value is read from **more than
  one place** — typically a data class's field default *and* a widget's
  `build*`-method substitution
  (`materialFooData?.bar ?? kDefaultFooBar`). When the value appears only as one
  constructor's parameter default — no second reader, no cross-file substitution —
  leave it as a literal at the constructor and skip the constant. Two reasons:
  1. **API pollution.** Top-level `kDefaultXxx` constants (and public
     `static const` defaults on data classes) appear in auto-complete and in
     the rendered dartdoc. Each one a downstream user has to skim past.
  2. **No drift risk.** Constants exist partly to keep two readers from
     diverging on the same value. With only one reader, there's nothing to
     diverge from.

  Counts as a real second use:
  - A `build*` branch substituting the constant when a per-platform record's
    field is `null` (the literal would otherwise appear in both the data class
    default and the build branch).
  - Multiple constructors / call sites in different files reading the same
    upstream-Flutter sentinel — e.g.
    [`kDefaultUseRootNavigator`](./lib/src/models/dialogs/const_values.dart)
    feeding every `show*` helper.

  Does **not** count:
  - A dartdoc reference (`Defaults to [kDefaultXxx]`) — that's documentation of
    the value, not a second reader. Once inlined, the dartdoc just spells out
    the literal: `Defaults to \`false\``.

---

<a id="class-structure"></a>
## Class structure

- **Any class with fields and constructors: fields → constructors → other members.**
  Lets a reader scan the state shape first, then how to construct it, then how to use
  it. Within constructors, unnamed first, then factories. Static helpers go after the
  methods. Applies to data classes (`PlatformDialogData`, `PlatformButtonData`, …),
  widget classes (`PlatformButton`, `PlatformScaffold`), and helper types
  (`TabDestination`, `HomeViewArgs`) — wherever a class has both state and a
  constructor. The abstract `PlatformWidgetBase` family follows the same ordering
  even though most members are abstract.
- **`assert` for dev-time errors, `throw` for runtime ones.** Constraints a caller can
  see violated during development (negative number where non-negative is required,
  empty list where non-empty is expected, etc.) belong in `assert` — stripped in
  release mode, zero runtime cost. Reserve `throw` and `Exception` for genuine runtime
  conditions the caller cannot guarantee at compile/dev time (unsupported platform at
  runtime, missing required platform channel, etc.). The
  `PlatformWidgetBase.build`-throws-`UnsupportedError` pattern is the legitimate
  example: at compile time we can't know what platform the user runs on, so the
  unsupported-platform case is a runtime condition.
- **Enforce constructor invariants with `assert(condition, message)` in the
  initializer list, not by silently accepting params and ignoring them downstream.**
  When two parameters are mutually exclusive (only one of `child` / `icon`+`label`
  should be set), or one parameter is only meaningful when another flag is set
  (`emptySelectionAllowed: true` requires the `selected` set type to accept empty
  state, etc.), say so loudly at construction time:

  ```dart
  const PlatformFoo({
    this.child,
    this.icon,
    this.label,
  }) : assert(
         (child != null) ^ (icon != null && label != null),
         'Provide either child OR (icon, label) — not both, not neither.',
       );
  ```

  **Why.** A param that gets silently dropped is a footgun: the user sets it,
  reads the dartdoc once to confirm it's wired, and never realises the value
  isn't reaching the underlying widget. An `assert` fires the first time the
  invalid combination runs in debug mode, with a message pointing at the fix.

  **Prefer compile-time exclusivity when feasible.** If the invariant can be
  encoded by splitting into two constructors (`PlatformButton(...)` vs
  `PlatformButton.icon(...)`), do that — the type system enforces it without any
  runtime check at all. Reach for `assert` when the invariant can't be expressed
  in the constructor signature (cross-parameter conditions, value-range checks,
  Iterable-length constraints, etc.).
- **Value types override `toString`.** Immutable data classes (`Date`,
  `TabDestination`, the various `*Data` value records, `HomeViewArgs`) implement
  `toString()` returning `'ClassName(field1: value1, field2: value2)'`. The default
  `Instance of 'ClassName'` is hostile in logs, exception traces, and `print`
  debugging. Include every field with a meaningful string representation;
  expression-bodied one-liner placed after the constructors, before any static helpers.
  Opaque fields (controllers, listenables, builder callbacks, anything whose
  `.toString()` is just `Closure: …` or `Instance of …`) are omitted: they add noise
  without informing the reader, and bare interpolation of a callable trips DCM's
  `avoid-missed-calls`. Widget subclasses of `PlatformWidgetBase` and abstract
  interfaces are exempt — Flutter's diagnostics already wire `toString` on
  `StatelessWidget`.

---

<a id="platform-adaptive-widget-patterns"></a>
## Platform-adaptive widget patterns

These rules are specific to this package; they encode the load-bearing dispatch
invariant and the data-class composition shape.

<a id="paw-subclass-base"></a>
### Subclass `PlatformWidgetBase`, override the two builders

Every `PlatformXxx` widget in `lib/src/widgets/` subclasses one of the four base
classes in [`lib/src/models/platform_widget_base.dart`](./lib/src/models/platform_widget_base.dart):

| Base                            | Use when                                                       |
|---------------------------------|----------------------------------------------------------------|
| `PlatformWidgetBase`            | Leaf widget, no child slot, no separate inner-widget `key`.    |
| `PlatformWidgetKeyedBase`       | Leaf widget needing a `widgetKey` for the inner platform impl. |
| `PlatformWidgetBuilderBase`     | Wrapper widget with a required `child`.                        |
| `PlatformWidgetKeyedBuilderBase`| Wrapper widget needing both `widgetKey` and `child`.           |

Override `buildMaterial(context)` and `buildCupertino(context)`. The base's
`@nonVirtual` `build` switches on `targetPlatform` and dispatches — **do not override
`build` directly.** Why: the base's `build` is the only place the dispatch invariant
lives, and overriding it forks the invariant per widget. See
[`APPENDIX.md#platform-widget-base-hierarchy`](./APPENDIX.md#platform-widget-base-hierarchy).

```dart
// Prefer:
final class PlatformSwitch extends PlatformWidgetBase {
  final PlatformSwitchData platformSwitchData;
  final MaterialSwitchData? materialSwitchData;
  final CupertinoSwitchData? cupertinoSwitchData;

  const PlatformSwitch({
    required this.platformSwitchData,
    this.materialSwitchData,
    this.cupertinoSwitchData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Switch(
    value: platformSwitchData.value,
    onChanged: platformSwitchData.onChanged,
    // …Material-only fields from materialSwitchData
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSwitch(
    value: platformSwitchData.value,
    onChanged: platformSwitchData.onChanged,
    // …Cupertino-only fields from cupertinoSwitchData
  );
}

// Over (forks the dispatch invariant — invisible drift surface):
class PlatformSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Platform.isIOS ? CupertinoSwitch(…) : Switch(…);
}
```

<a id="paw-field-classification"></a>
### Field classification: functional vs visual

Every widget parameter falls into one of three buckets:

- **Functional** (identity, control, callbacks, state-gating, input data,
  behavioral tuning) — declared as **flat `const` params on the widget itself**.
  Single source of truth; no per-platform override possible.
- **Visual, shared across platforms** — declared **both** as a flat widget
  param (the default) **and** on a private `_PlatformXxxData` abstract base
  inherited by `MaterialXxxData` and `CupertinoXxxData`. The per-platform
  record's value overrides the widget default on its branch.
- **Visual, platform-only** — declared on `MaterialXxxData` or
  `CupertinoXxxData`, whichever platform exposes the concept.

Field-ordering inside the `_PlatformXxxData` base and the per-platform records:
keep the same field order across the trio for the shared-visual fields, so
readers diffing the three see only real differences. Platform-only visual
fields come after the inherited block.

For the full rule (which fields land where, carve-outs, field-mapping
discipline), see
[`APPENDIX.md#field-classification`](./APPENDIX.md#field-classification) and
[`APPENDIX.md#cross-platform-field-mappings`](./APPENDIX.md#cross-platform-field-mappings).

---

<a id="idioms"></a>
## Idioms

<a id="static-dot-shorthands-dart-310"></a>
### Static dot shorthands (Dart 3.10+)

Use static dot shorthands wherever the context type is known. They resolve from the
parameter / return / variable type, not from inference of arbitrary expressions. Drop
the leading type name in *all* of these positions, not just the obvious enum case:

- Enum values in patterns and arg slots:
  `case .android => buildMaterial(context)`, `crossAxisAlignment: .start`,
  `mainAxisSize: .min`, `mainAxisAlignment: .center`.
- Named constructors when the return / context type pins it:
  inside `Widget buildMaterial(BuildContext context)`, write
  `return .center(child: …)` rather than `return Center(child: …)` *only* when the
  static factory delegates through the param type. In practice, prefer it on
  `EdgeInsets`-typed parameters (`padding: const .all(16)`,
  `padding: const .symmetric(horizontal: 12, vertical: 4)`,
  `margin: .zero`), `Alignment` slots, and similar value types.
- Cupertino / Material variant enums on this package's own data records:
  `materialButtonVariant: .text`, `cupertinoButtonVariant: .tinted`,
  `cupertinoButtonData: CupertinoButtonData(padding: .zero)`.
- **Constructor field defaults** — when the field's declared type pins the context,
  the default literal drops its prefix:
  ```dart
  final Axis direction;
  final DragStartBehavior dragStartBehavior;
  const Foo({
    this.direction = .horizontal,            // not Axis.horizontal
    this.dragStartBehavior = .start,         // not DragStartBehavior.start
  });
  ```
  Top-level / `static const` initializations are the exception — without an explicit
  type annotation on the LHS, Dart infers the constant's type from the RHS, so the
  prefix has to stay (`const kDefaultDirection = Axis.horizontal;` cannot become
  `= .horizontal` without also writing `const Axis kDefaultDirection`, which adds
  more noise than it removes).

Skip when it hurts readability — `.new(…)` for unnamed constructors typically does;
cases where the surrounding context type isn't obvious without re-reading.

After dropping a fully-qualified prefix, the type name often disappears from the file
entirely — remove it from any `show` clauses too. Re-running analyze surfaces
`unused_shown_name` warnings for orphaned ones.

<a id="drop-redundant-collection-literal-type-args"></a>
### Drop redundant `<Type>` on collection literals

When the surrounding context already pins the element / key / value type of a list,
set, or map literal — most often a parameter slot or assignment target — the
explicit `<Type>` prefix is dead weight:

```dart
// Prefer:
set.resolve({WidgetState.selected, if (!isEnabled) WidgetState.disabled})

// Over:
set.resolve(<WidgetState>{WidgetState.selected, if (!isEnabled) WidgetState.disabled})
```

The parameter slot here is `Set<WidgetState>`, so Dart infers the literal's
element type. The explicit prefix duplicates information the call site already has.
Combines well with [Static dot shorthands](#static-dot-shorthands-dart-310) — once
the literal's element type is inferred, the elements themselves often dot-shorthand:
`{.selected, if (!isEnabled) .disabled}`.

Keep `<Type>` when inference would otherwise fall back to `dynamic`:

- **Empty literals without a slot.** `final xs = <Foo>[];` — the local has no
  context, so `[]` infers `List<dynamic>`. The annotation is doing real work.
- **Top-level / `static const` initialisers without a type annotation on the LHS.**
  `const kDefault = <Never>{};` typed as `Set<Never>` (covariantly assignable to
  any `Set<T>`) needs the explicit `<Never>` — `const kDefault = {}` infers
  `Map<dynamic, dynamic>` and breaks.

<a id="flex-spacing-over-sizedbox-gaps"></a>
### `Row.spacing` / `Column.spacing` / `Wrap.spacing` over interleaved `SizedBox` gaps

Flutter's flex widgets ([`Row`], [`Column`], [`Wrap`], [`Flex`]) take a `spacing`
parameter (and `runSpacing` on `Wrap`) that inserts a uniform gap between adjacent
children. Use it instead of interleaving `SizedBox(width: …)` / `SizedBox(height: …)`
between every pair.

```dart
// Prefer:
Row(
  mainAxisSize: .min,
  spacing: 8,
  children: [icon, label],
)

// Over:
Row(
  mainAxisSize: .min,
  children: [icon, SizedBox(width: 8), label],
)
```

**Why.** The `spacing` form keeps `children` purely about content — the layout
metadata (gap size) lives on the parent where it belongs. The `SizedBox`-interleaved
form bloats the children list, ties the gap to a fixed position in the list (re-ordering
children means re-positioning the spacers), and reads as "data + filler" instead of
"data with spacing". `spacing` is also the only correct shape when the gap is *uniform
across all adjacencies* — the interleaved form misleads about whether per-position
overrides exist.

**Doesn't apply.** When gaps differ between adjacent pairs, fall back to explicit
`SizedBox` for the non-uniform gaps (or wrap groups with their own uniform-spacing
`Row` / `Column`). When the gap depends on a sibling's resolved size (rare),
`spacing` can't help.

<a id="enhanced-enums-for-per-variant-config"></a>
### Enhanced enums for per-variant config

When a variant enum's values each carry a piece of configuration that diverges
*per value* — a default colour, a size, a layout-direction flag — attach the
data to the enum via Dart 3's enhanced-enum syntax. Don't define parallel
top-level `kDefault<Variant>Xxx` constants that the build site has to branch on.

```dart
// Prefer:
enum CupertinoButtonVariant {
  normal(defaultDisabledColor: CupertinoColors.quaternarySystemFill),
  filled(defaultDisabledColor: CupertinoColors.tertiarySystemFill),
  tinted(defaultDisabledColor: CupertinoColors.tertiarySystemFill);

  final Color defaultDisabledColor;
  const CupertinoButtonVariant({required this.defaultDisabledColor});
}

// Build site:
disabledColor: disabledColor ?? cupertinoButtonVariant.defaultDisabledColor,

// Over:
const kDefaultCupertinoButtonDisabledColor = CupertinoColors.quaternarySystemFill;
const kDefaultCupertinoFilledTintedButtonDisabledColor = CupertinoColors.tertiarySystemFill;

enum CupertinoButtonVariant { normal, filled, tinted }

// Build site:
.normal => CupertinoButton(disabledColor: disabledColor ?? kDefaultCupertinoButtonDisabledColor, ...)
.filled => CupertinoButton.filled(disabledColor: disabledColor ?? kDefaultCupertinoFilledTintedButtonDisabledColor, ...)
.tinted => CupertinoButton.tinted(disabledColor: disabledColor ?? kDefaultCupertinoFilledTintedButtonDisabledColor, ...)
```

**Why.** Three real wins:
- **Locality.** The default lives on the variant it describes. Adding a new
  variant requires picking a default — the const constructor parameter forces
  the choice at compile time. Top-level constants are easy to add then forget
  to plumb through.
- **Discoverability.** A user hovering `CupertinoButtonVariant.filled` in the
  IDE sees `defaultDisabledColor` in the same hovercard. Separate `kDefault…`
  constants are reachable only by name.
- **Build-site uniformity.** Every switch arm references the same expression
  (`variant.defaultDisabledColor`). No per-arm constant lookup, no chance of
  pasting the wrong constant into a new arm.

**When to reach for it.** The config is genuinely per-value *and* needed by
the package's own code (build site, default-substitution, etc.). If the
"default" is the same across every value, a single top-level constant
suffices. If the config is purely external to the package (callers reach
for it but the package never reads it), a constants module is fine.

**Don't force it.** A discriminator-only variant enum
(`MaterialButtonVariant`, where the package doesn't intercept any per-variant
defaults — each underlying Material button has its own upstream defaults we
pass straight through) stays plain. Adding empty enum fields for symmetry is
ceremony.

<a id="collection-for-collection-if-over-iterablemaptolist"></a>
### Collection-for / collection-if over `Iterable.map(…).toList()`

In widget trees especially, a literal list with embedded control flow reads as data;
a `.map(…).toList()` reads as a pipeline that incidentally produces data. The literal
form also doesn't bloat the file with `<T>` annotations the list-literal context
already infers:

```dart
// Prefer:
RadioGroup<AxisDirection>(
  groupValue: directionality,
  onChanged: viewModel.onDirectionalityChanged,
  child: Row(
    spacing: 16,
    children: [
      for (final dir in AxisDirection.values)
        Row(
          mainAxisSize: .min,
          children: [
            PlatformRadio(value: dir),
            Text(dir.name),
          ],
        ),
    ],
  ),
)

// Over:
RadioGroup<AxisDirection>(
  groupValue: directionality,
  onChanged: viewModel.onDirectionalityChanged,
  child: Row(
    spacing: 16,
    children: AxisDirection.values
        .map((dir) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [PlatformRadio(value: dir), Text(dir.name)],
            ))
        .toList(),
  ),
)
```

Drop explicit generic type arguments when the surrounding context (other args, the
assignment target, the return slot) already pins them. Keep them when inference would
otherwise fall back to `dynamic` — e.g. `MaterialPageRoute<void>(builder: …)` stays,
because nothing else constrains the route's `T`.

<a id="dartasync-wait-extensions-over-static-futurewait"></a>
### `dart:async` `wait` extensions over static `Future.wait(...)`

The extensions (`Iterable<Future<T>>.wait` and the record forms `FutureRecord2`…
`FutureRecord9`) live in `dart:async`'s `future_extensions.dart` and supersede the
static call for everyday use. Most of this package is synchronous UI code, so the
opportunities are rare — but when concurrent async setup happens (e.g. parallel
platform-channel calls, parallel image preloads), use the extensions.

- **Fixed number of differently-typed futures → record form.** `(f1, f2).wait`
  returns `Future<(T1, T2)>` and destructures directly.
- **Dynamic number of same-typed futures → iterable form.** `iterable.wait` returns
  `Future<List<T>>` just like `Future.wait(iterable)`, but errors surface as
  `ParallelWaitError` carrying both per-slot values and per-slot errors.

<a id="listunmodifiable-over-unmodifiablelistview"></a>
### `List.unmodifiable(…)` over `UnmodifiableListView(…)`

Default to `List.unmodifiable(…)` for exposing immutable collections (same for
`Set.unmodifiable` / `Map.unmodifiable` vs their `…View` counterparts in
`dart:collection`). The constructor *copies*: snapshot semantics, decoupled from
whatever the caller passed in. The `…View` only *wraps*: anyone who still holds the
underlying collection can mutate it, and the view silently follows.

Reach for `UnmodifiableListView` only when you specifically want **read-through
visibility** into private mutable internal state — rare in this package.

<a id="part-part-of-only-when-structurally-needed"></a>
### `part` / `part of` only when structurally needed

Not a smell on its own. Legitimate uses: sealed-class cases across files (Dart 3
requires same library for sealed subtypes), code-generation outputs (`*.g.dart` from
`freezed`, `json_serializable`, etc.). Avoid for general code organisation —
imports/exports are explicit, parts hide dependencies and leak `_private` symbols
across files within the library.

---

<a id="comments-dartdoc"></a>
## Comments & dartdoc

Public symbols carry `///` dartdoc that explains *why*, not *what* — types already
carry the *what*. See
[hard rule 4 in `.ai/AGENTS.md`](./.ai/AGENTS.md#hard-rules) for the contract.

### `@docImport` for dartdoc-only references

When a file needs a symbol *only* for `[Name]` references in dartdoc (not in code), do
**not** add a regular `import` — that pulls the dependency into the runtime import
graph and hides intent. Use Dart's dartdoc-only directive instead:

```dart
/// @docImport '../widgets/layout/platform_app.dart';
library;

import '../models/layout/platform_app_data.dart'; // Real code import.
```

**Why.** A regular `import` declares a runtime dependency. If the only reason is
`comment_references` resolution, the runtime graph lies — readers and tooling can't tell
the import is documentation-only, and dead-code elimination has nothing to lean on.
`@docImport` keeps `comment_references` satisfied without polluting the real import
set.

**How to apply.** Put the `@docImport` directive(s) as `///` comments directly above
the file's `library;` directive. Code imports stay where they are (regular `import`
lines). The `library;` directive is required for `@docImport` to attach to anything —
but `unnecessary_library_directive` does not fire when a docImport is present.

---

<a id="dcm-rules-applied-by-hand"></a>
## DCM rules (applied by hand)

`flutter analyze` does not run them; the project treats them as non-negotiable
(`dart_code_metrics` is referenced in `pubspec.yaml`'s dev-dependencies comment block
and the project is expected to be runnable through DCM checks):

- **`no-empty-block`** — every block (function literal, `if`, `for`, `try`…) must
  contain code or a flutter-style `// TODO(handle): …` comment explaining the gap.
  Empty catch clauses are excused. `onPressed: () {}` is a violation; give it work to
  do (e.g. a tear-off or a `debugPrint`) or add a TODO comment. **The "disabled
  button" pattern in the example** uses `// ignore: no-empty-block` with a one-line
  explanation — that's the intended escape valve, not a routine override.
- **`newline-before-return`** — separate a block-final `return` from preceding
  statements with one blank line. Inline guards like `if (cond) return;` do not need
  the blank line — the rule is about returns whose preceding sibling is a non-return
  statement in the same block.
- **`prefer-commenting-analyzer-ignores`** — every `// ignore:` line needs a `//`
  explanation adjacent to it (immediately above, immediately below, or appended after
  the directive). Dartdoc (`///`) above the line does not count — the rule looks for a
  regular `//` comment.
- **`avoid-returning-widgets`** — building-block helpers that return a `Widget`
  fragment trip this rule. The project allows it (e.g. `_SectionHeader` and other
  small `final class` helpers in the example), but every occurrence needs a
  `// ignore_for_file: avoid-returning-widgets` (or a single-line `// ignore:`) with a
  reason. Prefer subclassing `StatelessWidget` for any helper that is reused or
  appears more than once — the `final class _SectionHeader extends StatelessWidget`
  pattern in [`example/lib/features/home/home_view.dart`](./example/lib/features/home/home_view.dart)
  is the model.
- **`prefer-correct-edge-insets-constructor`** — always pick the simplest valid
  `EdgeInsets[Directional]` constructor. The rule collapses redundant forms:
  - `EdgeInsets.fromLTRB(a, b, a, b)` / `EdgeInsetsDirectional.fromSTEB(a, b, a, b)`
    (start == end **and** top == bottom) → `EdgeInsets.symmetric(horizontal: a, vertical: b)`
    — directional flipping is a no-op when start == end, so the non-directional
    `EdgeInsets.symmetric` is the canonical form.
  - `EdgeInsetsDirectional.fromSTEB(a, b, 0, c)` or `fromSTEB(0, b, c, d)` (any side
    is zero) → `EdgeInsetsDirectional.only(...)` listing only the non-zero sides.
  - `EdgeInsets.symmetric(horizontal: 0, vertical: v)` → `EdgeInsets.only(top: v, bottom: v)`.
  - `EdgeInsets.all(0)` → `EdgeInsets.zero`.
  - All four sides equal → `EdgeInsets.all(v)`.

  Applies even when mirroring an upstream Flutter constant verbatim — Flutter's source
  uses `.fromSTEB` defensively, but the simplified form is functionally identical and
  the rule fires regardless. If the upstream form is preserved for traceability
  (e.g. a `kDefault…` constant intentionally matched to Flutter's source), record the
  upstream form in the constant's dartdoc alongside the simplified value:

  ```dart
  /// Matches upstream `CupertinoSearchTextField.padding`
  /// (`EdgeInsetsDirectional.fromSTEB(5.5, 8, 5.5, 8)` — simplified here since
  /// start == end makes the directional form redundant).
  const kDefaultCupertinoSearchBarPadding = EdgeInsets.symmetric(horizontal: 5.5, vertical: 8);
  ```

---

<a id="documentation-conventions-markdown"></a>
## Documentation conventions (Markdown)

- **APPENDIX.md is the source of truth for rationale.** Hard rules, pitfalls, and
  workflow stay in `.ai/AGENTS.md` and `.ai/CLAUDE.md`; the "why we do it this way"
  essays live in [`APPENDIX.md`](./APPENDIX.md).
- **Explicit `<a id="…">` anchors** sit above every APPENDIX (and CODESTYLE) heading.
  Link to sections via the anchor, not the heading text.
- **Anchor stability is load-bearing.** When renaming a heading, keep the existing
  anchor. If you must change it, grep `'#<old-anchor>'` across the repo and update
  every caller in the same change.
- **Bare `flutter` / `dart` in command examples, never `fvm flutter` / `fvm dart`.**
  FVM is a local implementation detail — `.fvmrc` pins the channel. Docs (this file,
  README.md, AGENTS.md, CLAUDE.md, APPENDIX.md) stay tool-agnostic so external
  contributors aren't forced into FVM. The maintainer's shell aliases `flutter` /
  `dart` to the pinned toolchain for interactive use.
