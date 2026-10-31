# Costs

What a widget or a pattern adds to an app's release build, so the next comparison starts from the
numbers. Each section ends with the Flutter and package versions it was measured on, since its
numbers only hold for those (the older entries have none). A rerun replaces them, and git keeps the
old ones.

## How to measure

Build [`tool/size_harness`](../tool/size_harness/lib/main.dart) as it is and with the change, once
per platform. Each build prints where its report went:

```bash
flutter build apk --release --analyze-size --target-platform=android-arm64
```

```bash
flutter build ios --release --no-codesign --analyze-size
```

Then list what moved, with `cupertino` as the filter for Android or `material` for iOS to count only
the look the platform doesn't draw:

```bash
dart tool/diff_size_reports.dart <before.json> <after.json> [filter]
```

The Android base, the Cupertino code the harness keeps, is what the
[size check](../.github/workflows/size-regression.yml) prints on every run.

## What each widget keeps of the other look

Bytes of the look a platform doesn't draw, Cupertino on Android and Material on iOS, that adding the
widget to the harness brings in.

| Widget                     | Android | iOS           | What stays                                                                                                                            |
|----------------------------|---------|---------------|---------------------------------------------------------------------------------------------------------------------------------------|
| `PlatformSlider`           | 10.8 KB | 20.9 KB       | Android: cupertino_ui's slider, which material_ui's `Slider` keeps for its `.adaptive` arm. iOS: material_ui's slider theme and parts |
| `PlatformTextField`        | 1.8 KB  | 3.1 KB        | Android: parts of `CupertinoTextField`'s state and gestures. iOS: bits of Material's theme. Neither is traced yet                     |
| `PlatformSearchBar`        | 1.5 KB  | 8.7 KB        | Android: the same `CupertinoTextField` parts. iOS: material_ui's search bar theme and ink                                             |
| `PlatformSingleSelectList` | 8.9 KB  | not split out | cupertino_ui's radio, which material_ui's `Radio` keeps whole. The size check leaves it out                                           |
| `PlatformMultiSelectList`  | 10.2 KB | not split out | cupertino_ui's checkbox, which material_ui's `Checkbox` keeps whole. The size check leaves it out                                     |

The iOS base already keeps about 497 KB of Material, so a widget that needs some of it adds less here
than it would to an app with none.

*2026-10-31, Flutter 3.47.8, material_ui 1.9.0, cupertino_ui 1.1.5.*

## Patterns

<a id="both-looks-in-one-call"></a>
### Both looks handed to one call

A value selector (`platformValue` and co, lazy forms too) or a helper taking both builders. **The
losing look stays in the release build.**

- **Android:** a `CupertinoDatePicker` routed through one stays at ≈342 KB with what it pulls in,
  where an inline `switch (designLanguage)` drops it. *Size harness, 2026-06-08.* The example app
  carried about 192 KB of it. *2026-05-30.*
- **iOS:** not measured.

<a id="runtime-override"></a>
### A look the app could switch at runtime

- **Android:** both looks stay in every release build, 42 KB more Cupertino on the size harness.
  *2026-10-20.*
- **iOS:** not measured.

<a id="base-dispatch"></a>
### Dispatching through `PlatformWidgetBase`

- **Android:** about 30 B per subclass. Its `buildCupertino` vtable slot and name stay, the body
  goes. *2026-10-20.*
- **iOS:** not measured.

<a id="cupertino-const-defaults"></a>
### `static const` defaults in `*Data` classes that name Cupertino types

- **Android:** no code. AOT keeps them as metadata, and drops them when unused. *2026-10-20.*
- **iOS:** not measured.

<a id="target-platform-shim"></a>
### `defaultTargetPlatform` through a re-exporting shim

- **Android:** nothing. Importing it directly built a byte-identical `libapp.so`. *2026-05-30.*
- **iOS:** not measured.

<a id="plain-widget-read"></a>
### A default read off a plain upstream widget, instead of copied

`cursorRadius ?? const CupertinoTextField().cursorRadius`, or a menu default that calls
`const TextField().contextMenuBuilder!`. **A few hundred bytes per place**, from switching 4 places
from copy to read in the harness, with a text field, search bar and slider added.

- **Android:** +800 B, where 2 builds of the same code came out 0 B apart. About 350 B of it is the
  slider: a plain `CupertinoSlider` with no `onChanged` keeps cupertino_ui's code for a disabled
  slider.
- **iOS:** +320 B, where 2 builds of the same code came out 8 B apart. The slider is about 350 B here
  too, and the rest nets out.

*2026-10-30, Flutter 3.47.8, material_ui 1.9.0, cupertino_ui 1.1.5.*
