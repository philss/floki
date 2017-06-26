# Change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

## [0.17.2] - 2017-05-25

### Fixed

- Fix attribute selectors in :not() - thanks [@jjcarstens](https://github.com/jjcarstens) and [@Eiji7](https://github.com/Eiji7)
- Fix selector parser to consider combinators across selectors separated by commas.
For further details, please check the [pull request](https://github.com/philss/floki/pull/115) - thanks [@jjcarstens](https://github.com/jjcarstens) and [@mischov](https://github.com/mischov)

## [0.17.1] - 2017-05-22

### Fixed

- Fix search when body has unencoded angles (`<` and `>`) - thanks [@sergey-kintsel](https://github.com/sergey-kintsel)
- Fix crash caused by XML declaration inside body - thanks [@erikdsi](https://github.com/erikdsi)
- Fix issue when finding fails if HTML begins with XML tag - thanks [@sergey-kintsel](https://github.com/sergey-kintsel)

## [0.17.0] - 2017-04-12

### Added

- Add support for multiple pseudo-selectors, line :not() and :nth-child() - thanks [@jjcarstens](https://github.com/jjcarstens)
- Add support for multiple selectors inside the :not() pseudo-class selector - thanks [@jjcarstens](https://github.com/jjcarstens)

## [0.16.0] - 2017-04-05

### Added

- Add support for selectors that only include a pseudo-class selector - thanks [@buhman](https://github.com/buhman)
- Add support for a new selector: `fl-contains`, which returns elements that contains a given text - thanks [@buhman](https://github.com/buhman)

### Fixed

- Fix `:not()` pseudo-class selector to accept simple pseudo-class selectors as well - thanks [@mischov](https://github.com/mischov)

## [0.15.0] - 2017-03-14

### Added

- Added support for the `:not()` pseudo-class selector.

### Fixed

- Fixed pseudo-class selectors that are used in conjunction with combinators - thanks [@Eiji7](https://github.com/Eiji7)
- Fixed order of elements after search using descendant combinator - thanks [@Eiji7](https://github.com/Eiji7)

## [0.14.0] - 2017-02-07

### Added

- Added support for configuring `html5ever` as the HTML parser. Issue #83 - thanks [@hansihe](https://github.com/hansihe)
and [@aphillipo](https://github.com/aphillipo)!

## [0.13.2] - 2017-02-07

### Fixed

- Fixed bug that was causing Floki.text/1 and Floki.filter_out/2
to ignore "trees" with only text nodes. Issue #91 - thanks [@boydm](https://github.com/boydm).

## [0.13.1] - 2017-01-22

### Fixed

- Fix ordering of duplicated descendant matches - thanks [@mmmries](https://github.com/mmmries)
- Fix ordering of `Floki.text/1` when there are only root nodes - thanks [@mmmries](https://github.com/mmmries)

## [0.13.0] - 2017-01-22

### Added

- Floki.filter_out/2 is now able to understand complex selectors to filter out from the tree.

## [0.12.1] - 2017-01-20

### Fixed

- Fix search for elements using descendant combinator - issue #84 - thanks [@mmmries](https://github.com/mmmries)

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
the tree yet, but works good with results from `Floki.find/2` - thanks [@bobjflong](https://github.com/bobjflong)

### Changed

- Using Logger to notify unkwon tokens in selector parser - thanks [@teamon](https://github.com/teamon) and [@geonnave](https://github.com/geonnave)
- Replace `mochiweb_html` with `mochiweb` package. This is needed to fix conflics with other
packages that are using `mochiweb`. - thanks [@aphillipo](https://github.com/aphillipo)

## [0.10.1] - 2016-08-28

### Fixed

- Fix sibling search after immediate children - thanks [@gmile](https://github.com/gmile).

## [0.10.0] - 2016-08-05

### Changed

- Change the search for namespaced elements using the correct CSS3 syntax.

### Fixed

- Fix the search for child elements when is more than two elements deep - thanks [@gmile](https://github.com/gmile)

## [0.9.0] - 2016-06-16

### Added

- A separator between text when getting text from nodes - thanks [@rochdi](https://github.com/rochdi).

## [0.8.1] - 2016-05-20

### Added

- Support rendering boolean attributes on `Floki.raw_html/1` - thanks [@iamvery](https://github.com/iamvery).

### Changed

- Update Mochiweb HTML parser dependency to version 2.15.0.

## [0.8.0] - 2016-03-06

### Added

- Add possibility to search tags with namespaces.
- Accept `Floki.Selector` as parameter of `Floki.find/2` instead of only strings - thanks [@hansihe](https://github.com/hansihe).

### Changed

- Using a smaller package with only the mochiweb HTML parser.

## [0.7.2] - 2016-02-23

### Fixed

- Replace `<br>` nodes by newline (`\n`) in `DeepText` - thanks [@maxneuvians](https://github.com/maxneuvians).
- Allow `FilterOut` to filter special nodes, like `comment`.

## [0.7.1] - 2015-11-14

### Fixed

- Ignore PHP scripts when finding nodes.

## [0.7.0] - 2015-11-03

### Added

- Add support for excluding script notes in `Floki.text`.
By default, it will exclude those nodes, but it can be enabled with
the flag `js: true` - thanks [@vikeri](https://github.com/vikeri)!

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
Huge thanks to [@henrik](https://github.com/henrik) and [@licyeus](https://github.com/licyeus) that pointed the
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
Thanks to [@licyeus](https://github.com/licyeus) to point out the [issue](https://github.com/philss/floki/issues/18)!
- Include mochiweb in the applications list at mix.exs - thanks [@EricDykstra](https://github.com/EricDykstra)

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
E.g: Floki.find(html, "[data-model=user]") - [@nelsonr](https://github.com/nelsonr)

## [0.2.1] - 2015-06-04

### Fixed

- Fix `parse/1` when parsing a part of HTML without a root node - [@antonmi](https://github.com/antonmi)

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

[unreleased]: https://github.com/philss/floki/compare/v0.17.2...HEAD
[0.17.2]: https://github.com/philss/floki/compare/v0.17.1...v0.17.2
[0.17.1]: https://github.com/philss/floki/compare/v0.17.0...v0.17.1
[0.17.0]: https://github.com/philss/floki/compare/v0.16.0...v0.17.0
[0.16.0]: https://github.com/philss/floki/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/philss/floki/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/philss/floki/compare/v0.13.2...v0.14.0
[0.13.2]: https://github.com/philss/floki/compare/v0.13.1...v0.13.2
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
