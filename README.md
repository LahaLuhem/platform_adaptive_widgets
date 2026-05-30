
# Platform Adaptive Widgets

![MIT License](https://img.shields.io/badge/License-MIT-green.svg)

A spiritual rewrite and continuation of [flutter_platform_widgets](https://pub.dev/packages/flutter_platform_widgets) library.

Platform-adaptive widgets that automatically render **Material** widgets on Android and **Cupertino** widgets on iOS — with zero platform checks in your app code.

---

## Widgets Catalog

### Dialogs

| Widget / Function                                                  | Material                                      | Cupertino                                                                                                    | Data Classes                                          |
|--------------------------------------------------------------------|-----------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| `showPlatformDatePicker()`                                         | `showDatePicker`                              | `CupertinoDatePicker` + `showCupertinoModalPopup`                                                            | `MaterialDatePickerData`, `CupertinoDatePickerData`   |
| `showPlatformTimePicker()`                                         | `showTimePicker`                              | `CupertinoDatePicker` (time mode) + `showCupertinoModalPopup`                                                | `MaterialTimePickerData`, `CupertinoDatePickerData`   |
| `PlatformMenuPicker<T>`                                            | `DropdownMenu` + `DropdownMenuEntry`          | `PullDownButton` / `PullDownMenuItem` (≤5 items) or `CupertinoPicker` + `showCupertinoModalPopup` (>5 items) | `MaterialMenuPickerData`, `CupertinoMenuPickerData`   |
| `showPlatformDialog<T>()`                                          | `showDialog` + `Dialog` / `Dialog.fullscreen` | `showCupertinoDialog`                                                                                        | `PlatformDialogData`, `MaterialDialogData`            |
| `showPlatformAlertDialog<T>()` + `PlatformAlertDialogActionButton` | `AlertDialog` + `TextButton`                  | `CupertinoAlertDialog` + `CupertinoDialogAction`                                                             | `MaterialAlertDialogData`, `CupertinoAlertDialogData` |
| `showPlatformModalBottomSheet<T>()`                                | `showModalBottomSheet`                        | `showCupertinoModalPopup`                                                                                    | —                                                     |
| `showPlatformSimpleAlert()`                                        | `SnackBar` via `ScaffoldMessenger`            | `CupertinoAlertDialog` via `showCupertinoDialog`                                                             | `PlatformDialogData`                                  |

---

### Interaction

| Widget                     | Material                                                                                       | Cupertino                                                                                            | Data Classes                                                                                         |
|----------------------------|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| `PlatformButton`           | `TextButton`, `ElevatedButton`, `OutlinedButton`, `FilledButton` (via `MaterialButtonVariant`) | `CupertinoButton`, `CupertinoButton.filled`, `CupertinoButton.tinted` (via `CupertinoButtonVariant`) | `MaterialButtonData`, `CupertinoButtonData`                                                          |
| `PlatformCheckbox`         | `Checkbox`                                                                                     | `CupertinoCheckbox`                                                                                  | `PlatformCheckboxData`, `MaterialCheckboxData`, `CupertinoCheckboxData`                              |
| `PlatformExpansionTile`    | `ExpansionTile`                                                                                | `CupertinoExpansionTile`                                                                             | `MaterialExpansionTileData`, `CupertinoExpansionTileData`                                            |
| `PlatformRadioGroup<T>`    | `RadioGroup` + `Radio`                                                                         | `RadioGroup` + `CupertinoRadio`                                                                      | `PlatformRadioGroupData<T>`, `PlatformRadioData<T>`, `MaterialRadioData<T>`, `CupertinoRadioData<T>` |
| `PlatformScrollbar`        | `Scrollbar`                                                                                    | `CupertinoScrollbar`                                                                                 | `MaterialScrollbarData`, `CupertinoScrollbarData`                                                    |
| `PlatformSearchBar`        | `SearchBar`                                                                                    | `CupertinoSearchTextField`                                                                           | `PlatformSearchBarData`, `MaterialSearchBarData`, `CupertinoSearchBarData`                           |
| `PlatformSegmentButton<T>` | `SegmentedButton` + `ButtonSegment`                                                            | `CupertinoSlidingSegmentedControl`                                                                   | `MaterialSegmentButtonData<T>`, `CupertinoSegmentButtonData<T>`                                      |
| `PlatformSlider`           | `Slider`                                                                                       | `CupertinoSlider`                                                                                    | `PlatformSliderData`, `MaterialSliderData`                                                           |
| `PlatformSwitch`           | `Switch`                                                                                       | `CupertinoSwitch`                                                                                    | `PlatformSwitchData`, `MaterialSwitchData`, `CupertinoSwitchData`                                    |
| `PlatformTextField`        | `TextField`                                                                                    | `CupertinoTextField`                                                                                 | `PlatformTextFieldData`, `MaterialTextFieldData`, `CupertinoTextFieldData`                           |

---

### Layout

| Widget                               | Material                                               | Cupertino                                                       | Data Classes                                                                                                                 |
|--------------------------------------|--------------------------------------------------------|-----------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `PlatformApp` / `PlatformApp.router` | `MaterialApp` / `MaterialApp.router`                   | `CupertinoApp` / `CupertinoApp.router`                          | `AppData`, `PlatformAppRouterData`, `MaterialAppData`, `MaterialAppRouterData`, `CupertinoAppData`, `CupertinoAppRouterData` |
| `PlatformAppBar`                     | `AppBar`                                               | `CupertinoNavigationBar`                                        | `MaterialAppBarData`, `CupertinoNavigationBarData`                                                                           |
| `PlatformScaffold`                   | `Scaffold`                                             | `CupertinoPageScaffold`                                         | `MaterialScaffoldData`, `CupertinoScaffoldData`                                                                              |
| `PlatformTabScaffold`                | `Scaffold` + `NavigationBar` + `NavigationDestination` | `CupertinoTabScaffold` + `CupertinoTabBar` + `CupertinoTabView` | `MaterialTabScaffoldData`, `CupertinoTabScaffoldData`, `TabDestination`                                                      |

---

### Painting

| Widget                      | Material                    | Cupertino                                         | Data Classes                                                      |
|-----------------------------|-----------------------------|---------------------------------------------------|-------------------------------------------------------------------|
| `PlatformListTile`          | `ListTile`                  | `CupertinoListTile` / `CupertinoListTile.notched` | `MaterialListTileData`, `CupertinoListTileData`                   |
| `PlatformProgressIndicator` | `CircularProgressIndicator` | `CupertinoActivityIndicator`                      | `MaterialProgressIndicatorData`, `CupertinoProgressIndicatorData` |

---

### Utilities

#### Generic Platform Widgets

| Widget                  | Description                                                                                        |
|-------------------------|----------------------------------------------------------------------------------------------------|
| `PlatformWidget`        | Takes `materialBuilder` and `cupertinoBuilder` callbacks to render any custom widget per platform. |
| `PlatformWidgetBuilder` | Same as `PlatformWidget` but also passes a shared `child` widget to both builders.                 |

#### Platform Theme

`PlatformTheme.of(context)` — provides unified access to theme properties across platforms:

| Property                  | Material                                        | Cupertino                                            |
|---------------------------|-------------------------------------------------|------------------------------------------------------|
| `barBackgroundColor`      | `Theme.of(context).appBarTheme.backgroundColor` | `CupertinoTheme.of(context).barBackgroundColor`      |
| `primaryColor`            | `Theme.of(context).primaryColor`                | `CupertinoTheme.of(context).primaryColor`            |
| `primaryContrastingColor` | `Theme.of(context).colorScheme.onPrimary`       | `CupertinoTheme.of(context).primaryContrastingColor` |
| `scaffoldBackgroundColor` | `Theme.of(context).scaffoldBackgroundColor`     | `CupertinoTheme.of(context).scaffoldBackgroundColor` |
| `selectionHandleColor`    | `Theme.of(context).colorScheme.onSurface`       | `CupertinoTheme.of(context).selectionHandleColor`    |

#### Context Extensions

Extensions on `BuildContext` for inline platform-specific values:

| Extension                                         | Description                                                  |
|---------------------------------------------------|--------------------------------------------------------------|
| `platformValue<T>(material:, cupertino:)`         | Returns the value matching the current platform.             |
| `platformValueNullable<T>(material:, cupertino:)` | Nullable variant of `platformValue`.                         |
| `platformLazyValue<T>(material:, cupertino:)`     | Lazily evaluates only the callback for the current platform. |
| `platformLazyNullable<T>(material:, cupertino:)`  | Nullable variant of `platformLazyValue`.                     |
| `platformIcon(material:, cupertino:)`             | Convenience for selecting platform-specific `IconData`.      |

#### Other Extensions

| Extension                          | Description                        |
|------------------------------------|------------------------------------|
| `DateTimeExtensions.toDate()`      | Converts `DateTime` → `Date`.      |
| `TimeOfDayExtensions.toDateTime()` | Converts `TimeOfDay` → `DateTime`. |

#### Models

| Model                   | Description                                                                                                          |
|-------------------------|----------------------------------------------------------------------------------------------------------------------|
| `Date`                  | An immutable gregorian calendar date (`year`, `month`, `day`) with comparison, arithmetic, and conversion utilities. |
| `PlatformAdaptiveIcons` | A class that provides adaptive icons based on the current platform.                                                  |

---

## Base Classes

All platform widgets extend one of these base classes, which use compile-time `defaultTargetPlatform` resolution:

| Base Class                       | Description                                                                    |
|----------------------------------|--------------------------------------------------------------------------------|
| `PlatformWidgetBase`             | Core abstract `StatelessWidget` with `buildMaterial()` and `buildCupertino()`. |
| `PlatformWidgetKeyedBase`        | Adds an optional `widgetKey` for the underlying platform widget.               |
| `PlatformWidgetBuilderBase`      | Adds a required `child` widget passed through to the platform builder.         |
| `PlatformWidgetKeyedBuilderBase` | Combines both `widgetKey` and `child`.                                         |

---

## Compile-time platform pruning, verified

Release builds of consumers ship **no Cupertino code on Android** and **no Material
code on iOS** — `defaultTargetPlatform` is const-folded at AOT, so the unused
platform's widget bodies become dead code and the Dart compiler tree-shakes them.
Two CI checks defend that contract on every PR: a **static AST guard**
([`test/aot_pruning_regression_test.dart`](./test/aot_pruning_regression_test.dart))
that fails if any helper re-introduces the closure-arg dispatch pattern that
defeats pruning, and an **empirical size benchmark**
([`tool/check_size_regression.dart`](./tool/check_size_regression.dart)) that
builds an Android-only harness with `--analyze-size` and fails if Cupertino-pathed
bytes exceed a calibrated budget. See
[`APPENDIX.md#aot-pruning-rules`](./APPENDIX.md#aot-pruning-rules) for the mechanism
and empirical numbers.

---

## Contributing

Issues and PRs welcome at
<https://github.com/LahaLuhem/platform_adaptive_widgets>. Before sending a
non-trivial change, read [`CODESTYLE.md`](./CODESTYLE.md) for the house style,
[`.ai/AGENTS.md`](./.ai/AGENTS.md) for the hard rules and contributor / AI-agent
guidelines, and [`APPENDIX.md`](./APPENDIX.md) for the design rationale.

### Optional: AI-agent discovery symlinks

The canonical text for `AGENTS.md` and `CLAUDE.md` lives under `.ai/`. The repo root
holds **gitignored symlinks** (`AGENTS.md → .ai/AGENTS.md`,
`CLAUDE.md → .ai/CLAUDE.md`, `example/AGENTS.md → example/.ai/AGENTS.md`) so coding
agents that auto-discover root-level guidance files (Claude Code, Codex, Cursor,
Copilot, …) find them without polluting the file tree with two extra Markdown files at
each level. The arrangement is opt-in per contributor:

- **If you use a coding agent**, set the symlinks up once from the repo root:

  ```bash
  ln -s .ai/AGENTS.md AGENTS.md
  ln -s .ai/CLAUDE.md CLAUDE.md
  ln -s .ai/AGENTS.md example/AGENTS.md
  ```

- **If you don't use one**, skip the step entirely. The canonical files under `.ai/`
  are committed; nothing in the build, lint, or test pipeline depends on the symlinks
  existing.
- **If you want different agent guidance for your own workflow**, drop a real
  `AGENTS.md` or `CLAUDE.md` at the repo root. A real file beats the symlink
  convention — your agent reads the root file you put there instead of the canonical
  one under `.ai/`. The committed `.ai/` copies remain the project default for
  everyone else.

The `CODESTYLE.md` files are not symlinked — they sit directly at the repo root and at
`example/`, since style serves humans and agents alike and is not AI-specific. See
[`APPENDIX.md`](./APPENDIX.md#ai-files-symlinked) for the rationale
behind the `.ai/` arrangement.

## Contributors

<a href="https://github.com/LahaLuhem/platform_adaptive_widgets/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=LahaLuhem/platform_adaptive_widgets"  alt="Contributors"/>
</a>

Made with [contrib.rocks](https://contrib.rocks).

## Authors

- [@LahaLuhem](https://www.github.com/LahaLuhem)

## Used By

This project is used by the following companies:

- Didata Automatisering B.V
- Dimerce B.V

## License

[MIT](https://choosealicense.com/licenses/mit/)

