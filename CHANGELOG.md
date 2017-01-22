# Change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

## [0.13.1] - 2017-12-22

### Fixed

- Fix ordering of duplicated descendant matches - thanks @mmmries
- Fix ordering of `Floki.text/1` when there are only root nodes - thanks @mmmries

## [0.13.0] - 2017-12-22

### Added

- Floki.filter_out/2 is now able to understand complex selectors to filter out from the tree.

## [0.12.1] - 2017-12-20

### Fixed

- Fix search for elements using descendant combinator - issue #84 - thanks @mmmries

## [0.12.0] - 2016-12-28

### Added

- Add basic support for nth-child pseudo-class selector.
Closes [issue #64](https://github.com/philss/floki/issues/64).

### Changed

- Remove support for Elixir 1.1 and below.
- Remove public documentation for internal code.

## [0.11.0] - 2016-10-12

### Added

- First attempt to transform nodes with `Floki.transform/2`. It is not able to update
the tree yet, but works good with results from `Floki.find/2` - thanks @bobjflong

### Changed

- Using Logger to notify unkwon tokens in selector parser - thanks @teamon and @geonnave
- Replace `mochiweb_html` with `mochiweb` package. This is needed to fix conflics with other
packages that are using `mochiweb`. - thanks @aphillipo

## [0.10.1] - 2016-08-28

### Fixed

- Fix sibling search after immediate children - thanks @gmile.

## [0.10.0] - 2016-08-05

### Changed

- Change the search for namespaced elements using the correct CSS3 syntax.

### Fixed

- Fix the search for child elements when is more than two elements deep - thanks @gmile

## [0.9.0] - 2016-06-16

### Added

- A separator between text when getting text from nodes - thanks @rochdi.

## [0.8.1] - 2016-05-20

### Added

- Support rendering boolean attributes on `Floki.raw_html/1` - thanks @iamvery.

### Changed

- Update Mochiweb HTML parser dependency to version 2.15.0.

## [0.8.0] - 2016-03-06

### Added

- Add possibility to search tags with namespaces.
- Accept `Floki.Selector` as parameter of `Floki.find/2` instead of only strings - thanks @hansihe.

### Changed

- Using a smaller package with only the mochiweb HTML parser.

## [0.7.2] - 2016-02-23

### Fixed

- Replace `<br>` nodes by newline (`\n`) in `DeepText` - thanks @maxneuvians.
- Allow `FilterOut` to filter special nodes, like `comment`.

## [0.7.1] - 2015-11-14

### Fixed

- Ignore PHP scripts when finding nodes.

## [0.7.0] - 2015-11-03

### Added

- Add support for excluding script notes in `Floki.text`.
By default, it will exclude those nodes, but it can be enabled with
the flag `js: true` - thanks @vikeri!

### Fixed

- Fix find for sibling nodes when the precendent selector match an element
at the end of sibling list - fix [issue #39](https://github.com/philss/floki/issues/39)

## [0.6.1] - 2015-10-11

### Fixed

- Fix the `Floki.raw_html/1` to build HTML comments properly.

## [0.6.0] - 2015-10-07

### Added

- Add `Floki.raw_html/2`.

## [0.5.0] - 2015-09-27

### Added

- Add the child combinator to `Floki.find/2`.
- Add the adjacent sibling combinator to `Floki.find/2`.
- Add the general adjacent sibling combinator to `Floki.find/2`.

## [0.4.1] - 2015-09-18

### Fixed

- Ignoring other files that are not lexer files (".xrl") under `src/` directory
in Hex package. This fixes a crash when compiling using OTP 17.5 on Mac OS X.
Huge thanks for @henrik and @licyeus that pointed the
[issue](https://github.com/philss/floki/issues/24)!

## [0.4.0] - 2015-09-17

### Added

- A robust representation of selectors in order to enable queries using a mix of selector types,
such as classes with attributes, attributes with types, classes with classes and so on.
Here is a list with examples of what is possible now:
  - `Floki.find(html, "a.foo")`
  - `Floki.find(html, "a.foo[data-action=post]")`
  - `Floki.find(html, ".foo.bar")`
  - `Floki.find(html, "a.foo[href$='.org']")`
Thanks to @licyeus to point out the [issue](https://github.com/philss/floki/issues/18)!
- Include mochiweb in the applications list at mix.exs - thanks @EricDykstra

### Changed

- `Floki.find/2` will now return a list instead of tuple when searching only by IDs.
For now on, Floki should always return the results inside a list, even if it's an ID match.

### Removed

- `Floki.find/2` does not accept tuples as selectors anymore.
This is because with the robust selectors representation, it won't be necessary to query directly using
tuples or another data structures rather than string.

## [0.3.3] - 2015-08-23

### Fixed

- Fix `Floki.find/2` when there is a non-HTML input.
It closes the [issue #17](https://github.com/philss/floki/issues/17)

## [0.3.2] - 2015-06-27

### Fixed

- Fix `Floki.DeepText` when there is a comment inside nodes.

## [0.3.1] - 2015-06-21

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

[unreleased]: https://github.com/philss/floki/compare/v0.13.1...HEAD
[0.13.1]: https://github.com/philss/floki/compare/v0.13.0...v0.13.1
[0.13.0]: https://github.com/philss/floki/compare/v0.12.1...v0.13.0
[0.12.1]: https://github.com/philss/floki/compare/v0.12.0...v0.12.1
[0.12.0]: https://github.com/philss/floki/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/philss/floki/compare/v0.10.1...v0.11.0
[0.10.1]: https://github.com/philss/floki/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/philss/floki/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/philss/floki/compare/v0.8.1...v0.9.0
[0.8.1]: https://github.com/philss/floki/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/philss/floki/compare/v0.7.2...v0.8.0
[0.7.2]: https://github.com/philss/floki/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/philss/floki/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/philss/floki/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/philss/floki/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/philss/floki/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/philss/floki/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/philss/floki/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/philss/floki/compare/v0.3.3...v0.4.0
[0.3.3]: https://github.com/philss/floki/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/philss/floki/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/philss/floki/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/philss/floki/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/philss/floki/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/philss/floki/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/philss/floki/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/philss/floki/compare/v0.0.5...v0.1.0
[0.0.5]: https://github.com/philss/floki/compare/v0.0.3...v0.0.5
