# Change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

### Fixed

- Fix `Floki.find/2` to consider XML trees.

## [0.3.0] - 2015-06-07

### Added

- Add attribute equals selector. This feature enables the user to search using
HTML attributes other than "class" or "id".
E.g: Floki.find(html, "[data-model=user]") - @nelsonr

## [0.2.1] - 2015-06-04

### Fixed

- Fix `parse/1` when parsing a part of HTML without a root node - @antonmi

## [0.2.0] - 2015-05-03

### Added

- Support HTML string when searching for attributes with Floki.attribute/2.
- Option for Floki.text/2 to disable deep search and use flat search instead.

### Changed

- Change Floki.text/1 to perform a deep search of text nodes.
- Consider doctests in the test suite.

## [0.1.1] - 2015-03-25

### Added

- Add CHANGELOG.md following the [Keep a changelog](http://keepachangelog.com/).

### Changed

- Using MochiWeb as a hex dependency instead of embedded code.
It closes the [issue #5](https://github.com/philss/floki/issues/5)

## [0.1.0] - 2015-02-15

### Added

- Descendent selectors, like ".class tag" to Floki.find/2.
- Multiple selection, like ".class1, .class2" to Floki.find/2.

## [0.0.5] - 2014-12-21

### Added

- Floki.text/1, which returns all text in the same level
of the parent element inside HTML.

### Changed

- Elixir version requirement from "~> 1.0.0" to ">= 1.0.0".

[unreleased]: https://github.com/philss/floki/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/philss/floki/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/philss/floki/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/philss/floki/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/philss/floki/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/philss/floki/compare/v0.0.5...v0.1.0
[0.0.5]: https://github.com/philss/floki/compare/v0.0.3...v0.0.5
