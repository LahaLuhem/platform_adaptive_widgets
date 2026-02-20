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
