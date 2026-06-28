## [Unreleased]
### Added
- \[#0\] Widget parity test

### Changed
- \[#9\] Create initital depandabot workflow
- \[#0\] Refactor to the docker-based linters

## [2.1.0] - 2026-06-09
### Added
- \[#6\] Property playground added for the example app
- showPlatformRawDialog for maximum control
- showPlatformRawModalBottomSheet for maximum control

### Changed
- Dialogs and bottom-modal-sheet for iOS automatically added CupertinoPopupSurface to mirror Material

## [2.0.0] - 2026-06-06
### Added
- PlatformToast (showPlatformToast): a transient, self-dismissing message - Material SnackBar on Android and a custom HUD-style banner on iOS; configured via MaterialToastData / CupertinoToastData
- PlatformAcknowledge (showPlatformAcknowledge): a must-acknowledge single-OK alert built on showPlatformAlertDialog
- showPlatformFullscreenDialog (with MaterialFullscreenDialogData): split out of showPlatformDialog; wraps content in Dialog.fullscreen and exposes only the fullscreen-valid Material knobs
- PlatformModalBottomSheet is now configurable via MaterialModalBottomSheetData / CupertinoModalPopupData, with per-platform materialBuilder / cupertinoBuilder
- PlatformButton.icon constructor and the MaterialButtonVariant.tonal variant (FilledButton.tonal)
- PlatformRadioGroupBuilder: a convenience widget bundling RadioGroup with a Wrap layout
- New per-platform fields: MaterialAppBarData.automaticallyImplyActions, CupertinoNavigationBarData.large, MaterialScaffoldData.bottomNavigationBar, MaterialSliderData.showValueIndicator, MaterialExpansionTileData.statesController, a new CupertinoSliderData, and the widget-level PlatformListTile.isEnabled

### Changed
- \[#4\] Debloated widget params across the package: shared functional params (value, callbacks, content slots, focusNode, autofocus, enabled, controller) are now flat params directly on each PlatformXxx widget, and the MaterialXxxData / CupertinoXxxData classes are slimmed to platform-only overrides. The enabled flag is renamed isEnabled; primary callbacks (onPressed / onChanged / onSelectionChanged) are now required and non-null (disable via isEnabled instead of a null callback); the per-Data widgetKey is dropped in favor of the widget-level widgetKey
- showPlatformDialog: dropped PlatformDialogData and the per-platform Material flat knobs (now on MaterialDialogData); added flat anchorPoint / barrierColor / barrierDismissible / barrierLabel / routeSettings / useRootNavigator / requestFocus; fullscreen moved to the new showPlatformFullscreenDialog
- showPlatformAlertDialog: removed the data-object params; renamed key to widgetKey; actions is now non-null (defaults to an empty list); added the flat barrier / route args
- PlatformMenuPicker: MaterialMenuPickerData and CupertinoMenuPickerData no longer take leadingIcon or labelText - set them on the widget instead
- showPlatformModalBottomSheet: builder is now optional, with materialBuilder / cupertinoBuilder for per-platform content (mutually exclusive with builder); added routeSettings / useRootNavigator / anchorPoint / requestFocus
- PlatformButton: child is now positional and onPressed is required; mouseCursor moved to CupertinoButtonData / Material style; MaterialButtonData no longer carries icon / label / iconAlignment (use PlatformButton.icon)
- PlatformTextField: shared text-field params are now flat on the widget (the PlatformTextFieldData base class is gone); added flat hintText / prefix / suffix
- PlatformSegmentButton: the selection param is now the public selectedChoice; choices / segmentBuilder / onSelectionChanged are required and non-null; MaterialSegmentButtonData is no longer generic
- PlatformExpansionTile: title and child are required and non-null; MaterialExpansionTileData no longer accepts children (single-child only - wrap multiple in a Column)
- PlatformListTile: title is now required and non-null; the common slots moved from the per-platform data classes onto the widget
- PlatformApp: the AppData hierarchy is flattened onto PlatformApp / PlatformApp.router (app-level params such as title, locale, localizationsDelegates, builder and routing); materialAppData / cupertinoAppData now hold only platform-specific fields
- PlatformTabScaffold: redesigned - tabDestinations and selectedIndex are now required and non-null; MaterialTabScaffoldData is a thin MaterialScaffoldData subclass with its tab fields removed
- Example app rebuilt as an interactive, platform-switching widget showcase

### Fixed
- showPlatformDialog: the centered-only Material knobs (alignment, shape, clipBehavior, constraints, elevation, insetPadding, shadowColor, surfaceTintColor) are no longer silently dropped when shown fullscreen - they now live on MaterialDialogData under showPlatformDialog
- PlatformMenuPicker (iOS wheel): the modal picker now opens highlighted on the current selection instead of always the first item
- PlatformSearchBar (Cupertino): default itemColor changed from placeholderText to secondaryLabel and default padding to EdgeInsets.symmetric(horizontal: 5.5, vertical: 8), matching upstream CupertinoSearchTextField
- PlatformButton: the tonal and tonalIcon variants are now supported, and the Cupertino filled / tinted variants honor isEnabled
- PlatformDialogAction: a null onPressed now genuinely disables the action on both platforms instead of wiring an always-present no-op
- PlatformExpansionTile (Material): expanded-alignment and feedback defaults now defer to the Material theme instead of being hard-coded

### Removed
- PlatformSimpleAlert (showPlatformSimpleAlert): split into showPlatformToast (its SnackBar half) and showPlatformAcknowledge (its alert half)
- PlatformRadioGroup and PlatformRadioGroupData: replaced by PlatformRadio (a single leaf radio that requires an ancestor RadioGroup) plus PlatformRadioGroupBuilder; the PlatformRadioData base class and the ValueAndButton typedef are also removed
- PlatformAlertDialogActionButton: renamed to PlatformDialogAction
- The shared cross-platform data base classes PlatformDialogData, PlatformTextFieldData, PlatformSearchBarData, PlatformCheckboxData, PlatformSwitchData and PlatformSliderData (their fields are now flat on the widgets)
- AppData, PlatformAppRouterData, MaterialAppRouterData and CupertinoAppRouterData, along with PlatformApp.appData and the router-data params - flattened onto PlatformApp
- CupertinoTabScaffoldData and PlatformTabScaffold.cupertinoTabScaffoldData; the tab fields on MaterialTabScaffoldData; MaterialListTileData.enabled (now PlatformListTile.isEnabled); and MaterialProgressIndicatorData.key
- All per-class kDefault static-const members - replaced by top-level kDefault-prefixed constants (e.g. MaterialAlertDialogData.kDefaultScrollable is now kDefaultMaterialAlertDialogScrollable)

## [1.1.0] - 2026-05-31
### Changed
- Use the new CupertinoMenuAnchor instead of (deprecated) PullDownButton
- Migrate example android to AGP 9.0.0

### Fixed
- \[#1\] Fix platform assets pruning leaks + add regression tests

## 1.0.5 - 2026-03-03
### Changed
- (Cupertino) Add a minimum length assertion to the items for MenuPicker

### Fixed
- (Material) remove unnecessary assertion from ExpansionTile

## 1.0.4 - 2026-02-26
### Removed
- CupertinoTabController from PlatformTabScaffold data. This causes issues with an external tab-management solution like GoRouter

## 1.0.3 - 2026-02-26
### Fixed
- \[iOS\] navigation shell not switching when rebuilt with a different index

## 1.0.2 - 2026-02-20
### Fixed
- common-level specification do not override platform-level specs for PlatformApp

## 1.0.1 - 2026-02-20
### Changed
- Use the new material\_ui and cupertino\_ui packages instead

## 1.0.0 - 2026-02-19
### Added
- usage with GoRouter example

### Changed
- rename TabDestinationData -> TabDestination
- Material side of PlatformTabScaffold also handles the caching internally, preventing rebuilds when switching tabs

### Fixed
- router type not detected if not giving in specific data
- state holding by PlatformTabScaffold
- maxLines > minLines assertion error when data empty

### Removed
- PlatformTabController for simplicity
- PlatformTabScaffoldOriginal impl

## 0.1.0 - 2026-02-17
### Added
- Date picker
- Time picker
- Menu picker
- A lot of new widgets (see README.md for the catalog)
- example catalog
- Documentation
- Platform Adaptive Icons legacy class
- New options to configure PlatformMenuPicker's items
- Platform check utilities

### Changed
- Much better Readme

### Fixed
- exception when something other than base child is used in platform button

### Removed
- `dense` option for any data. Full compliance with M3 atleast

## 0.0.2 - 2026-01-03
### Added
- Readme

### Changed
- example restored

## 0.0.1 - 2026-01-03
### Added
- Platform progress indicator
- Platform list tile
- Platform theme
- Platform context extensions (value, valueLazy, nullable)
- Platform checkbox
- Platform expansion list tile
- Platform radio group
- Platform search bar
- Platform segment button
- Platform slider
- Platform switch
- Platform scrollbar
- Platform text-field

[Unreleased]: https://github.com/LahaLuhem/platform_adaptive_widgets/compare/2.1.0...HEAD
[2.1.0]: https://github.com/LahaLuhem/platform_adaptive_widgets/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/LahaLuhem/platform_adaptive_widgets/compare/1.1.0...2.0.0
[1.1.0]: https://github.com/LahaLuhem/platform_adaptive_widgets/compare/1.0.5...1.1.0
