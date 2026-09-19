Library-package code style. Project facts (goal, stack, repo layout, hard rules) live in
[`.ai/AGENTS.md`](./.ai/AGENTS.md), design rationale lives in
[`APPENDIX.md`](./APPENDIX.md), example-app code style lives in
[`example/CODESTYLE.md`](./example/CODESTYLE.md).

The lint posture is deliberately strict (see
[`analysis_options.yaml`](./analysis_options.yaml), the `errors:` block promotes many
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
    * [Subclass `PlatformWidgetBase`, override the 2 builders](#subclass-platformwidgetbase-override-the-2-builders)
    * [Field classification: functional vs visual](#field-classification-functional-vs-visual)
- [Idioms](#idioms)
    * [Static dot shorthands (Dart 3.10+)](#static-dot-shorthands-dart-310)
    * [Drop redundant `<Type>` on collection literals](#drop-redundant-collection-literal-type-args)
    * [`Row.spacing` / `Column.spacing` / `Wrap.spacing` over interleaved `SizedBox` gaps](#flex-spacing-over-sizedbox-gaps)
    * [Enhanced enums for per-variant config](#enhanced-enums-for-per-variant-config)
    * [`Navigator.maybeOf` over `Navigator.of` for fire-and-forget pops](#navigator-maybeof-over-of)
    * [Collection-for / collection-if over `Iterable.map(…).toList()`](#collection-for-collection-if-over-iterablemaptolist)
    * [`dart:async` `wait` extensions over static `Future.wait(...)`](#dartasync-wait-extensions-over-static-futurewait)
    * [`List.unmodifiable(…)` over `UnmodifiableListView(…)`](#listunmodifiable-over-unmodifiablelistview)
    * [`part` / `part of` only when structurally needed](#part-part-of-only-when-structurally-needed)
- [Prose & voice](#prose)
- [Comments & dartdoc](#comments-dartdoc)
- [DCM rules (applied by hand)](#dcm-rules-applied-by-hand)
- [Documentation conventions (Markdown)](#documentation-conventions-markdown)

<!-- TOC end -->

<a id="type-safety-nullability"></a>
## Type safety & nullability

- **Type-annotate every public symbol.** Inference is fine on locals. Public surfaces
  are not the place to rely on inference.
- **`final` by default for fields and locals.** Parameters are *not* required to be
  `final`: `avoid_final_parameters` allows mutation-shaped parameters, and
  `parameter_assignments` forbids the actual bad behaviour (mutating a parameter inside
  the body).
- **Nullability is explicit.** Use `T?` everywhere a value can be missing.
  `cast_nullable_to_non_nullable` is on, `as T` on a `T?` will fail lint.
- **Constrain generic type parameters to `<T extends Object>` by default.** Unbounded
  `<T>` lets `null` and `dynamic` satisfy `T`: the same failure modes the explicit-
  nullability rule and the [`dynamic`-escape-hatch ban](./.ai/AGENTS.md#hard-rules)
  guard against elsewhere. Bind to `Object` so the type system enforces "some real
  value, not null". If a particular call site needs `null`, the call site spells it as
  `T?` and the binding stays put.

  Exception: when `T` flows directly into an external library API that itself uses
  unbounded `<T>` *and* relies on `null` as a sentinel `T` value, e.g. a dialog
  helper that pops with `context.pop()` (a `T = void` / null result for "dismissed
  without a value"). In those cases, leave `<T>` raw so callers can instantiate it
  with `void` / a nullable type. Don't reach for the exception speculatively, bind
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
  `<T extends Object>`-bound package widget is type-safe, the bound narrows the
  accepted set. The upstream's looser slot still accepts the narrower value.
- **No Java ceremony.** No getter-only abstract base classes, no `AbstractFooFactory`,
  no interface-per-class. Use mixins / sealed classes / records / extension types where
  they add clarity, not weight. The `PlatformWidgetBase` hierarchy is the legitimate
  exception, it encodes the dispatch invariant that defines the package.

The `dynamic`-escape-hatch ban and the `print()`-in-library ban are listed under
[*Hard rules* in `.ai/AGENTS.md`](./.ai/AGENTS.md#hard-rules), they're contracts, not
style.

---

<a id="naming"></a>
## Naming

- **Prefer abbreviations over initialisms for domain terms.** In code, comments,
  dartdocs, and log messages alike, expand. Widely-known protocol initialisms (HTTP,
  DNS, TCP, TLS, …) and platform-name initialisms (iOS, OS) stay as-is. Novel project
  terms get spelt out. The general-programming initialisms below also expand,
  shorthand that's "obvious" to the author is opaque to the next reader and indistinguishable
  from a typo:

  | Don't write | Write instead             |
  |-------------|---------------------------|
  | `cb`        | `callback` (with the type-suffix rule below: `<context>Callback` if shared scope makes bare `callback` ambiguous) |
  | `fn`        | `function` / `handler` / spell out the semantic role |
  | `cfg`       | `config` |
  | `idx`       | `index` (loop counters keep `i` / `j` per genre convention. See local-variable rule) |
  | `tmp`       | `temporary` / a name describing what it actually holds |
  | `req` / `res` / `resp` | `request` / `response` |
  | `ctx`       | `context` (Flutter's `BuildContext` arg stays `context` by convention) |
  | `evt`       | `event` |

  This rule binds *every* identifier, fields, locals, parameters, pattern bindings (`switch (x) { final cb => … }` is **out**, spell it). The only carve-outs are the genre conventions: single-letter loop counters (`i`, `j`), `e` in `catch (e)`, `(a, b)` in symmetric comparator pairs, `x`/`y` for coordinates.
- **Local-variable names carry a concise type-suffix.** Dart is strongly typed, but a
  reader without IDE inlay-hints can't see the inferred type, the *name* has to do
  that work. Suffix a local with what it *is* so the next reader doesn't have to scroll
  back to the assignment (or install a plugin) to recover the type. **Callback
  parameters** are exempt and stay single-word (`value`, `direction`, `selectedDate`)
 , the enclosing call site already pins the type. Single-letter callback params are
  out, *except* symmetric pair-wise params in comparators / reducers where `(a, b)` is
  the genre convention. Regular method parameters follow the local-variable rule, not
  the callback exemption. **When a domain type exists, the suffix is the type name**,
  `cupertinoButtonData` (not `cupertinoData`), `platformAdaptiveIcons` (not `icons`),
  `tabDestinations` (not `destinations`). Generic suffixes (`Data`, `Info`, `Result`)
  lose the disambiguation the rule is meant to provide.
- **Unused closure parameters take the discard `_`, not a real name.** Don't declare
  an identifier you don't reference, `_` makes the unused-ness immediate and removes
  a name the reader otherwise has to mentally scan the body for.

  ```dart
  // Prefer:
  builder: (_) => AlertDialog(...)
  onPressed: (_) => doSomething()
  builder: (_, value, _) => Text('$value')              // ValueListenableBuilder, two of three unused

  // Over:
  builder: (ctx) => AlertDialog(...)                    // ctx never referenced
  builder: (context, value, child) => Text('$value')    // context + child never referenced
  ```

  Applies in dartdoc examples too, `(_)` is the idiomatic Dart form and users
  copy-pasting will inherit it. If a reader needs the context they can rename `_` at
  the call site. Multiple discards in one signature are written as `_` each (Dart
  permits the repetition for positional discards in records and patterns. Same in
  parameter lists).

  **Doesn't apply** to genre-conventional single-letter names that are intentionally
  short (`i`/`j` in counters, `e` in `catch (e)`), those stay as their letter even
  when unused locally. The rule targets *unused multi-letter declarations*.

- **Don't rename callback params to disambiguate from a same-named outer-scope
  variable.** Dart's lexical scoping always picks the innermost binding, there's no
  ambiguity for the *compiler*, and a reader who knows the scoping rule sees the
  intent immediately. Renaming (`(dialogContext) => …`, `(innerContext) => …`,
  `(buildContext) => …`) signals to the next reader that the new name carries a
  distinction worth tracking, when in fact it carries none.

  ```dart
  // Prefer:
  Widget build(BuildContext context) {
    return PlatformDialogAction(
      onPressed: (context) => Navigator.maybeOf(context)?.pop(),   // inner shadows outer, fine
      child: const Text('OK'),
    );
  }

  // Over:
  Widget build(BuildContext context) {
    return PlatformDialogAction(
      onPressed: (dialogContext) => Navigator.maybeOf(dialogContext)?.pop(),
      child: const Text('OK'),
    );
  }
  ```

  **The legitimate exception** is when the closure body needs to reference *both* the
  inner and outer same-named variable, e.g. the closure receives the dialog's
  context but also needs the surrounding screen's context for a `ScaffoldMessenger`
  call. Then renaming the inner (`(dialogContext) { … context …; … dialogContext …;
  }`) is the only way to keep both reachable. If you only ever reference the
  closure's value, keep the canonical name.

  Document the semantic distinction (which-context-is-which) in the **dartdoc on the
  callback**, not in the parameter name, that's where future readers go looking
  for the answer anyway.

  ```dart
  // Prefer:
  final platformTheme = PlatformTheme.of(context);
  final selectedDirection = viewModel.directionalityListenable.value;

  // Over:
  final theme = PlatformTheme.of(context);
  final selected = viewModel.directionalityListenable.value;
  ```

  Strong format-string conventions (`hh`/`mm`/`ss` in a timestamp formatter, etc.)
  override this, the rule targets *type ambiguity*, not all short names.

- **Widget files mirror class names.** `PlatformButton` lives in
  `platform_button.dart`, `PlatformAlertDialogData` in
  `platform_alert_dialog_data.dart`. The model file always sits at
  `lib/src/models/<category>/<widget>_data.dart` and the widget file at
  `lib/src/widgets/<category>/<widget>.dart`: the linter enforces `file_names`, but
  the *category* placement is by convention (see
  [`APPENDIX.md#models-widgets-mirror-layout`](./APPENDIX.md#models-widgets-mirror-layout)).

---

<a id="formatting"></a>
## Formatting

- **Wrap text-file content at 100 columns.** `formatter.page_width: 100` in
  `analysis_options.yaml` is authoritative for Dart code. Markdown and **dartdoc
  comments** follow the same cap by hand, since `dart format` does *not* reflow
  comment prose.
- **Don't squash prose to fit the cap.** For docs and comments the 100 is a guide,
  not a hard stop: let the line run to the end of the word that crosses it, then
  break. Re-wrapping a paragraph so every line lands just under 100 churns the diff
  and reads worse than one slightly-long line. A `///` block hand-wrapped at 70
  columns is the opposite problem and is invisible to the formatter, so widen those
  opportunistically when you're already editing the block. Don't churn unrelated
  files just to re-wrap them.
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
  promote it. When only one widget needs it, keep it as a `static const` on that
  widget's `*Data` class. The reference package's `Values` god-class is **not** the
  pattern here. Flutter packages get a thicker per-category const file. Before
  introducing a new magic number or default, check the existing `const_values.dart`
  files in the same category first.
- **Inline single-use defaults. Don't promote to a named `kDefault…` constant.** A
  `kDefaultXxx` declaration earns its name when the value is read from **more than
  one place**: typically a data class's field default *and* a widget's
  `build*`-method substitution
  (`materialFooData?.bar ?? kDefaultFooBar`). When the value appears only as one
  constructor's parameter default, no second reader, no cross-file substitution,
  leave it as a literal at the constructor and skip the constant. 2 reasons:
  1. **API pollution.** Top-level `kDefaultXxx` constants (and public
     `static const` defaults on data classes) appear in auto-complete and in
     the rendered dartdoc. Each one a downstream user has to skim past.
  2. **No drift risk.** Constants exist partly to keep 2 readers from
     diverging on the same value. With only one reader, there's nothing to
     diverge from.

  Counts as a real second use:
  - A `build*` branch substituting the constant when a per-platform record's
    field is `null` (the literal would otherwise appear in both the data class
    default and the build branch).
  - Multiple constructors / call sites in different files reading the same
    upstream-Flutter sentinel, e.g.
    [`kDefaultUseRootNavigator`](./lib/src/models/dialogs/const_values.dart)
    feeding every `show*` helper.

  Does **not** count:
  - A dartdoc reference (`Defaults to [kDefaultXxx]`), that's documentation of
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
  (`TabDestination`, `AppArgs`), wherever a class has both state and a
  constructor. The abstract `PlatformWidgetBase` family follows the same ordering
  even though most members are abstract.
- **`assert` for dev-time errors, `throw` for runtime ones.** Constraints a caller can
  see violated during development (negative number where non-negative is required,
  empty list where non-empty is expected, etc.) belong in `assert`: stripped in
  release mode, zero runtime cost. Reserve `throw` and `Exception` for genuine runtime
  conditions the caller cannot guarantee at compile/dev time (unsupported platform at
  runtime, missing required platform channel, etc.). The
  `PlatformWidgetBase.build`-throws-`UnsupportedError` pattern is the legitimate
  example: at compile time we can't know what platform the user runs on, so the
  unsupported-platform case is a runtime condition.
- **Enforce constructor invariants with `assert(condition, message)` in the
  initializer list, not by silently accepting params and ignoring them downstream.**
  When 2 parameters are mutually exclusive (only one of `child` / `icon`+`label`
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
         'Provide either child OR (icon, label), not both, not neither.',
       );
  ```

  **Why.** A param that gets silently dropped is a footgun: the user sets it,
  reads the dartdoc once to confirm it's wired, and never realises the value
  isn't reaching the underlying widget. An `assert` fires the first time the
  invalid combination runs in debug mode, with a message pointing at the fix.

  **Prefer compile-time exclusivity when feasible.** If the invariant can be
  encoded by splitting into 2 constructors (`PlatformButton(...)` vs
  `PlatformButton.icon(...)`), do that, the type system enforces it without any
  runtime check at all. Reach for `assert` when the invariant can't be expressed
  in the constructor signature (cross-parameter conditions, value-range checks,
  Iterable-length constraints, etc.).
- **Value types override `toString`.** Immutable data classes
  (`TabDestination`, the various `*Data` value records) implement
  `toString()` returning `'ClassName(field1: value1, field2: value2)'`. The default
  `Instance of 'ClassName'` is hostile in logs, exception traces, and `print`
  debugging. Include every field with a meaningful string representation, as an
  expression-bodied one-liner placed after the constructors, before any static helpers.
  Opaque fields (controllers, listenables, builder callbacks, anything whose
  `.toString()` is just `Closure: …` or `Instance of …`) are omitted: they add noise
  without informing the reader, and bare interpolation of a callable trips DCM's
  `avoid-missed-calls`. Widget subclasses of `PlatformWidgetBase` and abstract
  interfaces are exempt. Flutter's diagnostics already wire `toString` on
  `StatelessWidget`.

---

<a id="platform-adaptive-widget-patterns"></a>
## Platform-adaptive widget patterns

These rules are specific to this package. They encode the load-bearing dispatch
invariant and the data-class composition shape.

<a id="paw-subclass-base"></a>
### Subclass `PlatformWidgetBase`, override the 2 builders

Every `PlatformXxx` widget in `lib/src/widgets/` subclasses one of the 4 base
classes in [`lib/src/models/platform_widget_base.dart`](./lib/src/models/platform_widget_base.dart):

| Base                            | Use when                                                       |
|---------------------------------|----------------------------------------------------------------|
| `PlatformWidgetBase`            | Leaf widget, no child slot, no separate inner-widget `key`.    |
| `PlatformWidgetKeyedBase`       | Leaf widget needing a `widgetKey` for the inner platform impl. |
| `PlatformWidgetBuilderBase`     | Wrapper widget with a required `child`.                        |
| `PlatformWidgetKeyedBuilderBase`| Wrapper widget needing both `widgetKey` and `child`.           |

Override `buildMaterial(context)` and `buildCupertino(context)`. The base's
`@nonVirtual` `build` switches on `targetPlatform` and dispatches, **do not override
`build` directly.** Why: the base's `build` is the only place the dispatch invariant
lives, and overriding it forks the invariant per widget. See
[`APPENDIX.md#platform-widget-base-hierarchy`](./APPENDIX.md#platform-widget-base-hierarchy).

```dart
// Prefer:
final class PlatformSwitch extends PlatformWidgetBase {
  // Functional fields (value, callbacks, …) are flat, there is no public
  // `PlatformSwitchData`. Shared-visual defaults are flat too, per-platform
  // visual tuning is opt-in via the two records.
  final bool value;
  final ValueChanged<bool> onChanged;
  final MaterialSwitchData? materialSwitchData;
  final CupertinoSwitchData? cupertinoSwitchData;

  const PlatformSwitch({
    required this.value,
    required this.onChanged,
    this.materialSwitchData,
    this.cupertinoSwitchData,
    super.key,
  });

  @override
  Widget buildMaterial(BuildContext context) => Switch(
    value: value,
    onChanged: onChanged,
    // …Material-only fields from materialSwitchData
  );

  @override
  Widget buildCupertino(BuildContext context) => CupertinoSwitch(
    value: value,
    onChanged: onChanged,
    // …Cupertino-only fields from cupertinoSwitchData
  );
}

// Over (forks the dispatch invariant, invisible drift surface):
class PlatformSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Platform.isIOS ? CupertinoSwitch(…) : Switch(…);
}
```

<a id="paw-field-classification"></a>
### Field classification: functional vs visual

Every widget parameter falls into one of 3 buckets:

- **Functional** (identity, control, callbacks, state-gating, input data,
  behavioral tuning), declared as **flat `const` params on the widget itself**.
  Single source of truth. No per-platform override possible.
- **Visual, shared across platforms**: declared **both** as a flat widget
  param (the default) **and** on a private `_PlatformXxxData` abstract base
  inherited by `MaterialXxxData` and `CupertinoXxxData`. The per-platform
  record's value overrides the widget default on its branch.
- **Visual, platform-only**: declared on `MaterialXxxData` or
  `CupertinoXxxData`, whichever platform exposes the concept.

Field-ordering inside the `_PlatformXxxData` base and the per-platform records:
keep the same field order across the trio for the shared-visual fields, so
readers diffing the 3 see only real differences. Platform-only visual
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
- **Constructor field defaults**: when the field's declared type pins the context,
  the default literal drops its prefix:
  ```dart
  final Axis direction;
  final DragStartBehavior dragStartBehavior;
  const Foo({
    this.direction = .horizontal,            // not Axis.horizontal
    this.dragStartBehavior = .start,         // not DragStartBehavior.start
  });
  ```
  Top-level / `static const` initializations are the exception, without an explicit
  type annotation on the LHS, Dart infers the constant's type from the RHS, so the
  prefix has to stay (`const kDefaultDirection = Axis.horizontal;` cannot become
  `= .horizontal` without also writing `const Axis kDefaultDirection`, which adds
  more noise than it removes).

Skip when it hurts readability. `.new(…)` for unnamed constructors typically does, as do
cases where the surrounding context type isn't obvious without re-reading.

After dropping a fully-qualified prefix, the type name often disappears from the file
entirely, remove it from any `show` clauses too. Re-running analyze surfaces
`unused_shown_name` warnings for orphaned ones.

<a id="drop-redundant-collection-literal-type-args"></a>
### Drop redundant `<Type>` on collection literals

When the surrounding context already pins the element / key / value type of a list,
set, or map literal, most often a parameter slot or assignment target, the
explicit `<Type>` prefix is dead weight:

```dart
// Prefer:
set.resolve({WidgetState.selected, if (!isEnabled) WidgetState.disabled})

// Over:
set.resolve(<WidgetState>{WidgetState.selected, if (!isEnabled) WidgetState.disabled})
```

The parameter slot here is `Set<WidgetState>`, so Dart infers the literal's
element type. The explicit prefix duplicates information the call site already has.
Combines well with [Static dot shorthands](#static-dot-shorthands-dart-310), once
the literal's element type is inferred, the elements themselves often dot-shorthand:
`{.selected, if (!isEnabled) .disabled}`.

Keep `<Type>` when inference would otherwise fall back to `dynamic`:

- **Empty literals without a slot.** `final xs = <Foo>[];`: the local has no
  context, so `[]` infers `List<dynamic>`. The annotation is doing real work.
- **Top-level / `static const` initialisers without a type annotation on the LHS.**
  `const kDefault = <Never>{};` typed as `Set<Never>` (covariantly assignable to
  any `Set<T>`) needs the explicit `<Never>`: `const kDefault = {}` infers
  `Map<dynamic, dynamic>` and breaks.

<a id="flex-spacing-over-sizedbox-gaps"></a>
### `Row.spacing` / `Column.spacing` / `Wrap.spacing` over interleaved `SizedBox` gaps

Use the flex widgets' `spacing` parameter rather than interleaving `SizedBox` between
every pair of children.

```dart
// Prefer:
Row(mainAxisSize: .min, spacing: 8, children: [icon, label])

// Over:
Row(mainAxisSize: .min, children: [icon, SizedBox(width: 8), label])
```

**Why.** `children` stays about content and the gap lives on the parent. The interleaved
form ties each gap to a list position, so re-ordering children means re-positioning
spacers, and it hides whether the spacing is uniform.

**Doesn't apply.** Gaps that differ between pairs, or that depend on a sibling's resolved
size. Use explicit `SizedBox` there, or group children into their own evenly-spaced
`Row` / `Column`.
<a id="enhanced-enums-for-per-variant-config"></a>
### Enhanced enums for per-variant config

When a variant enum's values each carry a piece of configuration that diverges
*per value*, a default colour, a size, a layout-direction flag, attach the
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

**Why.** 3 real wins:
- **Locality.** The default lives on the variant it describes. Adding a new
  variant requires picking a default, the const constructor parameter forces
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
defaults, each underlying Material button has its own upstream defaults we
pass straight through) stays plain. Adding empty enum fields for symmetry is
ceremony.

<a id="navigator-maybeof-over-of"></a>
### `Navigator.maybeOf` over `Navigator.of` for fire-and-forget pops

When dismissing a route (`pop`) from inside a callback whose only job is the
pop, dialog action buttons, snackbar action callbacks, modal close handlers,
etc., reach for `Navigator.maybeOf(ctx)?.pop(value)`, not
`Navigator.of(ctx).pop(value)` or the static `Navigator.pop(ctx, value)`.

```dart
// Prefer:
PlatformDialogAction(
  onPressed: (ctx) => Navigator.maybeOf(ctx)?.pop(true),
  child: const Text('OK'),
)

// Over:
PlatformDialogAction(
  onPressed: (ctx) => Navigator.of(ctx).pop(true),       // throws if no Navigator
  child: const Text('OK'),
)
PlatformDialogAction(
  onPressed: (ctx) => Navigator.pop(ctx, true),          // same, wraps `.of`
  child: const Text('OK'),
)
```

**Why.** `Navigator.of(ctx)` asserts in debug and throws in release if no
`Navigator` exists in the context's ancestry. For fire-and-forget pops there's
no value in the loud failure, if the route is already gone (because something
else popped it first, the widget was disposed mid-tap, a hot-reload reshuffled
the tree, or the action is being exercised in a unit test that pumps the
button in isolation), the right behaviour is to *silently no-op*. That's
exactly what `Navigator.maybeOf(ctx)?.pop(value)` gives, `maybeOf` returns
`null` instead of throwing, and `?.pop(...)` short-circuits.

The cost of the defensive `?` is zero. Dart's null-aware chaining compiles
to a null check, no allocations.

**When `Navigator.of` is still right.** When you need the return value of
`push` / `pushNamed` / etc. and the absence of a Navigator is a programmer
error you want to surface loudly (e.g. inside a screen's mainline navigation
flow, where missing-Navigator means a setup bug). The rule targets *dismissal*
callbacks specifically, the asymmetric cases where the caller doesn't care
about the result.

**Doesn't apply.** `Navigator.maybePop(ctx)`: different concept (checks
whether the current route *can* pop, used to handle back-press intercepts).
Keep using `maybePop` where you need that semantic.

<a id="collection-for-collection-if-over-iterablemaptolist"></a>
### Collection-for / collection-if over `Iterable.map(…).toList()`

In a widget tree a literal list with embedded control flow reads as data. A
`.map(…).toList()` reads as a pipeline that happens to produce data.

```dart
// Prefer:
children: [
  for (final dir in AxisDirection.values) DirectionTile(dir),
]

// Over:
children: AxisDirection.values.map((dir) => DirectionTile(dir)).toList(),
```
<a id="library-pipeline-methods-over-hand-rolled-loops"></a>
### Library pipeline methods over hand-rolled loops (for data manipulation)

The deliberate flip side of the
[collection-for rule](#collection-for-collection-if-over-iterablemaptolist) above.
That rule is about *constructing* a data / widget literal, there, `[for (…) …]`
reads as data. This rule is about *transforming, filtering, flattening, or reducing*
data, a genuine pipeline, where a stream-style chain reads as exactly what it is, and
re-deriving it with an imperative loop plus a mutable accumulator obscures the intent
(and re-implements a method the SDK already ships).

Prefer the `dart:core` `Iterable` / `Set` / `Map` methods, `where`, `whereType<T>()`,
`map`, `expand`, `Set.difference` / `intersection`, `Map.fromEntries`, `followedBy`,
over a `for` loop that pushes into a growable collection, and over a `[for … if …]`
comprehension when the work is filtering / flattening rather than literal construction:

```dart
// Prefer, set algebra states the intent directly:
final missingFields = baseFields.difference(widgetFields);

// Over, a loop that re-derives `difference` by hand:
final missingFields = <String>{};
for (final field in baseFields) {
  if (!widgetFields.contains(field)) missingFields.add(field);
}
```

```dart
// Prefer, whereType + where + expand + map + toSet:
Set<String> fieldNames(ClassDeclaration node) => node.body.members
    .whereType<FieldDeclaration>()
    .where((member) => !member.isStatic)
    .expand((member) => member.fields.variables)
    .map((variable) => variable.name.lexeme)
    .toSet();
```

When a symmetric check repeats per case (e.g. the Material vs Cupertino build
branches), key the variants in a `Map` and `.entries.expand(…)` over it rather than
duplicating the loop body, data-as-a-map beats copy-pasted control flow. The worked
example is [`test/data_widget_parity_test.dart`](test/data_widget_parity_test.dart).

**Boundary:** building a widget `children:` list or any data literal → collection-for
(the rule above). Running a filter / flatten / reduce / set-op pipeline → these
methods. A tell: if you seed an empty collection and mutate it in a loop, that's
usually a pipeline wearing a loop's clothes.

**Stay lazy. Materialise deliberately.** Don't end a chain with a reflexive
`.toList()`. Leave it an `Iterable` and let the terminal consumer drive evaluation,
`check(…)`, a `for`-in loop, `Map.fromEntries(…)`, or another pipeline stage all accept
an `Iterable` directly. Materialise only when (a) the result is iterated more than once,
a lazy chain re-runs end to end on every pass, including any I/O such as `parseFile`,
or (b) an API genuinely requires a `List`. When you do materialise a result that
won't be mutated, use `.toList(growable: false)` to say so. In the parity guard `bases`
is `.toList(growable: false)` (3 readers, never mutated) while each test's
`offenders` stays a lazy `Iterable` (read once, by `check`).

<a id="dartasync-wait-extensions-over-static-futurewait"></a>
### `dart:async` `wait` extensions over static `Future.wait(...)`

Prefer the `wait` extensions over the static call: the record form `(f1, f2).wait` for a
fixed number of differently-typed futures, `iterable.wait` for a dynamic number of
same-typed ones. Both report failures as `ParallelWaitError`, which carries the per-slot
values alongside the per-slot errors instead of throwing away the successes.

Most of this package is synchronous UI code, so the opportunities are rare.
<a id="listunmodifiable-over-unmodifiablelistview"></a>
### `List.unmodifiable(…)` over `UnmodifiableListView(…)`

Default to `List.unmodifiable(…)` when exposing an immutable collection, and likewise for
`Set` / `Map`. It copies, so the result is a snapshot that nobody else can mutate behind
your back. The `…View` types only wrap, so whoever still holds the original can change it
and the view quietly follows.

Reach for `UnmodifiableListView` only when you actually want that read-through view onto
private mutable state. Rare here.
<a id="part-part-of-only-when-structurally-needed"></a>
### `part` / `part of` only when structurally needed

Not a smell on its own. Legitimate uses: sealed-class cases across files (Dart 3
requires same library for sealed subtypes), code-generation outputs (`*.g.dart` from
`freezed`, `json_serializable`, etc.). Avoid for general code organisation,
imports/exports are explicit, parts hide dependencies and leak `_private` symbols
across files within the library.

---

<a id="prose"></a>
## Prose & voice

**Read <https://noslopgrenade.com/> before writing any prose here.** Open it, don't cite it from
memory. It is short and it carries the examples and the intent behind every line below.

Covers every surface a person reads: dartdoc, comments, READMEs, APPENDIX entries, commit messages,
PR and issue bodies.

- Keep it trimmed and compacted to reduce noise. Brief, concise, succinct. No over-explaining.
- Comment at the call site, rather than a preamble wall-of-text.
- No need to document what can easily be gleaned from the sites. Also reduces drift risk.
- Use the Markdown features that improve readability: subsection layout, tables, (un)ordered lists,
  show-hide sections.
- Prefer not using technical buzz-words, use ELI18 level instead.
- No AI-tell-tale signs like em-dashes, `;` and others.
- Numbers as numerals, not words: `1`, `2`, `1st`, `2nd`. "one" stays where it means single or
  sole, and "first" where it means earliest rather than a position.
- Keep the tone informal and light. Give it a natural flow.

---

<a id="comments-dartdoc"></a>
## Comments & dartdoc

Public symbols carry `///` dartdoc that explains *why*, not *what*, types already
carry the *what*. See
[hard rule 4 in `.ai/AGENTS.md`](./.ai/AGENTS.md#hard-rules) for the contract.

**Aim for 1 or 2 lines.** A guideline, not a cap: an explanation that earns its length keeps it,
and a decision a reader would otherwise question is worth the sentence. What doesn't earn it is
restating the signature, or rationale that belongs in [`APPENDIX.md`](./APPENDIX.md) behind a
one-line pointer. Surplus lines are noise the next reader pays for and they bury the comment that
mattered, so trim the neighbours whenever you edit a file.

### A field doc has to earn its place

`public_member_api_docs` does **not** cover primary-constructor field parameters, so
most `PlatformXxx` and `*Data` fields need no doc at all. Give one only when it says
something the name and type don't: a cross-platform mapping, a default the code can't
show, a gotcha. Otherwise leave the field bare. Classic-syntax classes (real `final`
fields, e.g. `PlatformButton`, `PlatformApp`) *are* covered by the lint, so there the
same judgement applies to the length instead: 1 short line, not 3.

**Why.** Restating the field name is the single biggest source of noise, and on
pub.dev a bare field still renders with its name and type.

**Where the lint does bite:** top-level `kDefault*` consts, classes, extensions, enums,
public getters and methods, and the primary constructor itself (which is what the
`this;` body exists to hang a doc on). Those keep a one-liner.

### Wrap dartdoc past 100, not before it

Fill a `///` line until a word takes it to or past column 100, keep that word on the
line, then wrap. Lines therefore end up slightly over 100 rather than short of it.
`dart format` never rewraps comments, and `lines_longer_than_80_chars` is `ignore`d in
`analysis_options.yaml`, so nothing fights this.

Never break inside a backtick span, since the code then straddles 2 lines in source
even though Markdown still renders it.

### `@docImport` for dartdoc-only references

When a file needs a symbol *only* for `[Name]` references in dartdoc (not in code), do
**not** add a regular `import`: that pulls the dependency into the runtime import
graph and hides intent. Use Dart's dartdoc-only directive instead:

```dart
/// @docImport '../widgets/layout/platform_app.dart';
library;

import '../models/layout/platform_app_data.dart'; // Real code import.
```

**Why.** A regular `import` declares a runtime dependency. If the only reason is
`comment_references` resolution, the runtime graph lies, readers and tooling can't tell
the import is documentation-only, and dead-code elimination has nothing to lean on.
`@docImport` keeps `comment_references` satisfied without polluting the real import
set.

**How to apply.** Put the `@docImport` directive(s) as `///` comments directly above
the file's `library;` directive. Code imports stay where they are (regular `import`
lines). The `library;` directive is required for `@docImport` to attach to anything,
but `unnecessary_library_directive` does not fire when a docImport is present.

---

<a id="dcm-rules-applied-by-hand"></a>
## DCM rules (applied by hand)

`flutter analyze` does not run these, and the project treats them as non-negotiable. Rule
definitions live at [dcm.dev/docs/rules](https://dcm.dev/docs/rules), which is also where
they change. What follows is only this project's policy on each.

- **`no-empty-block`**: give the block work to do, or a `// TODO(handle): …` saying why
  it's empty. The example's disabled-button pattern uses `// ignore: no-empty-block` with
  a one-line reason. That's the intended escape valve, not a routine override.
- **`newline-before-return`**: applies to a block-final `return` whose previous sibling is
  some other statement. Inline guards like `if (cond) return;` need no blank line.
- **`prefer-commenting-analyzer-ignores`**: every `// ignore:` needs a `//` explanation
  next to it. Dartdoc above the line does not count, the rule wants a plain comment.
  **Keep the reason to one line**, saying why the lint is wrong here and nothing else. A
  `// ignore:` binds to the next line only, so a diagnostic on an argument inside a
  multi-line call needs one `// ignore_for_file:` rather than a directive per argument.
  DCM flags a directive that suppresses nothing, so a misplaced one does not go unnoticed.
- **`avoid-returning-widgets`**: allowed, but each occurrence needs an `// ignore:` with a
  reason. If the helper is reused or appears twice, make it a `StatelessWidget` instead.
  [`example/lib/features/about/widgets/labeled_section.dart`](./example/lib/features/about/widgets/labeled_section.dart)
  is the model.
- **`prefer-correct-edge-insets-constructor`**: take the simplest valid constructor, even
  when mirroring an upstream Flutter constant verbatim. Flutter's source uses `.fromSTEB`
  defensively and the rule fires anyway. When you keep the upstream form for traceability,
  record it in the constant's dartdoc next to the simplified value:

  ```dart
  /// Matches upstream `CupertinoSearchTextField.padding`
  /// (`EdgeInsetsDirectional.fromSTEB(5.5, 8, 5.5, 8)`, simplified here since
  /// start == end makes the directional form redundant).
  const kDefaultCupertinoSearchBarPadding = EdgeInsets.symmetric(horizontal: 5.5, vertical: 8);
  ```
---

<a id="documentation-conventions-markdown"></a>
## Documentation conventions (Markdown)

- **Never restate what another file already states.** Point at it instead. A version
  constraint, a lint list, a dependency set, a file tree, a test count: all of these
  live in `pubspec.yaml`, `analysis_options.yaml` or the repo itself, and a prose copy
  is both redundant and quietly wrong the moment the real one moves. Write "the floor is
  whatever `pubspec.yaml`'s `environment:` says", not the numbers.

  **Why.** This isn't hypothetical. `.ai/AGENTS.md` claimed a Dart 3.10 / Flutter 3.38
  floor and `APPENDIX.md` claimed `sdk: >=3.12.0`, long after `pubspec.yaml` had moved
  past both. Nothing failed, because nothing checks prose. That's what makes it worse
  than a stale comment: it reads as authoritative and rots silently.

  **Doesn't apply** to a fact the other file doesn't carry. "Dot shorthands need Dart
  3.10+" is language history, not a copy of our constraint, so it stays.
- **APPENDIX.md is the source of truth for rationale.** Hard rules, pitfalls, and
  workflow stay in `.ai/AGENTS.md` and `.ai/CLAUDE.md`. The "why we do it this way"
  essays live in [`APPENDIX.md`](./APPENDIX.md).
- **Explicit `<a id="…">` anchors** sit above every APPENDIX (and CODESTYLE) heading.
  Link to sections via the anchor, not the heading text.
- **Anchor stability is load-bearing.** When renaming a heading, keep the existing
  anchor. If you must change it, grep `'#<old-anchor>'` across the repo and update
  every caller in the same change.
- **Bare `flutter` / `dart` in command examples, never `fvm flutter` / `fvm dart`.**
  FVM is a local implementation detail, `.fvmrc` pins the channel. Docs (this file,
  README.md, AGENTS.md, CLAUDE.md, APPENDIX.md) stay tool-agnostic so external
  contributors aren't forced into FVM. The maintainer's shell aliases `flutter` /
  `dart` to the pinned toolchain for interactive use.
