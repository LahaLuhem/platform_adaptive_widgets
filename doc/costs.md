# Costs

What a pattern in the package costs once compiled, so the next comparison starts from the numbers.
Each entry ends with the Flutter and package versions it was measured on, since its numbers only
hold for those (the older entries have none). A rerun replaces the entry, and git keeps the old one.

## How to measure

Times only compare on the same device, so each platform has one:

- **Android:** the Android 17 (API 37) emulator, arm64, on an Apple M3 Pro.
- **iOS:** an iPhone, since the Simulator only runs debug builds.

**Time**, only in a release (AOT) build. [`tool/aot_bench`](../tool/aot_bench/lib/main.dart) times
each way of doing something against the others, plus a control that makes a new object on every
call, so an allocation shows as the gap to it. Its `bench` lines show on screen and in the log:

```bash
cd tool/aot_bench && flutter create --platforms=android . && flutter run --release -d <device>
```

For iOS it's `--platforms=ios`, with your signing team set in Xcode, since `ios/` isn't tracked.

**App size.** Build [`tool/size_harness`](../tool/size_harness/lib/main.dart) once per variant, and
one variant twice to see how far apart 2 builds of the same code come out. Each build prints where
its report went:

```bash
flutter build apk --release --analyze-size --target-platform=android-arm64
```

```bash
flutter build ios --release --no-codesign --analyze-size
```

Then list the leaves whose bytes moved between 2 reports:

```bash
dart tool/diff_size_reports.dart <before.json> <after.json>
```

## Measured

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
`const TextField().contextMenuBuilder!`. **No runtime cost, and a few hundred bytes of app size per
place.** The app size comes from switching 4 places from copy to read in the size harness, with a
text field, search bar and slider added.

**Android.** Median ns per call:

| Group         | Copy | Read | New object |
|---------------|------|------|------------|
| cursor radius | 6.24 | 6.03 | 7.98       |
| slider thumb  | 6.31 | 6.13 | 9.24       |
| menu builder  | 6.14 | 6.07 | 8.66       |

App size: +800 B, where 2 builds of the same code came out 0 B apart. About 350 B of it is the
slider: a plain `CupertinoSlider` with no `onChanged` keeps cupertino_ui's code for a disabled
slider.

**iOS.** Time not measured. App size: +320 B, where 2 builds of the same code came out 8 B apart.
The slider is about 350 B here too, and the rest nets out.

*2026-10-30, Flutter 3.47.8, material_ui 1.9.0, cupertino_ui 1.1.5.*
