# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- **Swiss French layout** (`ch_fr`): Support for the Swiss French QWERTZ keyboard (è/é/à direct keys, dead keys for circumflex, grave, and diaeresis)
- **Variant-aware detection**: `setxkbmap`/`localectl` auto-detection now reads the XKB variant and prefers a matching variant layout file (e.g. `ch` + `fr` → `ch_fr`)

## [v1.2.0] - 2026-04-16

### Added

- **Multi-layout support**: Support for French AZERTY, German QWERTZ, Belgian AZERTY, Italian, and Spanish keyboards
- **Auto-layout detection**: Cascading detection, fallback to French

### Changed

- **Project structure**: Reorganized to follow Bash conventions (bin/, lib/, share/layouts/)
- **Installation path**: Moved from /usr/bin to /usr/local
- **Code modularization**: Split into lib/translate.sh, lib/layout.sh, lib/utils.sh

## [v1.1.0] - 2026-03-20

### Added

- Initial release of ydotool-rebind
- Automatic AZERTY to QWERTY translation for text typed with ydotool
- Support for common French accented characters and symbols
- Support for ligatures (ae, oe)
- Support for typing text directly or from a file
- Support for dead keys
- Compatibility with ydotool file mode typing
- Compatibility with regular ydotool commands outside of type

## Notes

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
