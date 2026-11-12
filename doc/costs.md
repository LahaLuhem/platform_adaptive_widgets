# Costs

What a widget or a pattern adds to an app's release build, so the next comparison starts from the
numbers. The table holds for the versions pinned by the commit that wrote its stamp, so a rerun
replaces it whole. A pattern's date marks the evidence behind its rule, and git has what it ran on.

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

Each platform's base, what the harness keeps of the other look, is what the
[size check](../.github/workflows/size-regression.yml) prints on every run. Android's is all
material_ui's own Cupertino, none of it this package's: mostly the adaptive text selection toolbar
behind `TextField` and `SearchBar`, the `CupertinoTheme` that `Theme` wraps around its child,
`Checkbox` and `Radio`'s `.adaptive` arms, and the page transitions `ThemeData` defaults to on iOS
and macOS. `Theme` adds its `CupertinoTheme` on every platform, and the rest pick their arm from
`Theme.of(context).platform` at runtime, so none of it folds.

## What each widget keeps of the other look

Bytes of the look a platform doesn't draw that adding the widget to the harness brings in, on top of
the base.

| Widget                            | Cupertino on Android | Material on iOS | What stays                                                                                                                                                                 |
|-----------------------------------|----------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `PlatformSlider`                  | 10.1 KB              | 0 B             | Android: cupertino_ui's slider, which material_ui's `Slider` keeps for its `.adaptive` arm                                                                                 |
| `PlatformTextField`               | 0 B                  | 0 B             | Nothing the search bar doesn't already keep                                                                                                                                |
| `PlatformSearchBar`               | 217 B                | 0 B             | Android: cupertino_ui's text selection toolbar, which material_ui's adaptive toolbar keeps                                                                                 |
| `PlatformSingleSelectList`        | 8.9 KB               | 0 B             | cupertino_ui's radio, which material_ui's `Radio` keeps whole. The size check leaves it out                                                                                |
| `PlatformMultiSelectList`         | 9.3 KB               | 0 B             | cupertino_ui's checkbox, which material_ui's `Checkbox` keeps whole. The size check leaves it out                                                                          |
| `showPlatformRawModalBottomSheet` | 0 B                  | 0 B             | Nothing. smooth_sheets, the iOS side, drops out of Android. iOS grows 133 KB, 84.6 KB of it smooth_sheets itself                                                           |
| `PlatformBarAction.debounced`     | 4.1 KB               | 0 B             | Android: cupertino_ui's activity indicator, which material_ui's `CircularProgressIndicator` keeps for its `.adaptive` arm. The app grows 26 KB on Android and 15 KB on iOS |

The iOS base is material_ui's bundled shaders and icon font, and the `TimeOfDay` the time picker
takes.

*Measured 2026-11-12, on the versions this line's commit pins.*

## Patterns

<a id="both-looks-in-one-call"></a>
### Both looks handed to one call

A value selector (`platformValue` and co, lazy forms too) or a helper taking both builders. **The
losing look stays in the release build.**

- **Android:** a `CupertinoDatePicker` routed through one stays at ≈342 KB with what it pulls in,
  where an inline `switch (designLanguage)` drops it. *Size harness, 2026-06-08.* The example app
  carried about 192 KB of it. *2026-05-30.*
- **iOS:** not measured.

<a id="design-language-pragma"></a>
### `designLanguage` without its pragma

A switch on it still drops the losing arm's own code, but not what that arm builds.

- **Android:** 29.8 KB more of the app on the size harness, 6.1 KB of it Cupertino. *2026-10-31.*
- **iOS:** 885 KB more of the app, 395 KB of it Material. *2026-10-31.*

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
- **iOS:** +320 B, where 2 builds of the same code came out 8 B apart. The slider is about 350 B
  here too, and the rest nets out.

*2026-10-30.*

In a `*Data` record's default, such a function stays in the other look's build with everything it
builds, though only its own look reads the field. **Switch its body on `designLanguage`.**

- **iOS:** the search bar's menu default took the Material kept from 7,634 to 247,724 B: `SearchBar`
  and the whole theme. Inside a switch it was back to 7,634 B. *Size harness.*
- **Android:** not measured.

*2026-11-02.*
