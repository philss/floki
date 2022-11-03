# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased][unreleased]

## [0.34.0] - 2022-11-03

### Added

- User configurable "self-closing" tags. Now it's possible to define which tags are considered
"self-closing". Thanks [@inoas](https://github.com/inoas).

### Fixed

- Allow attribute values to not be escaped. This fixes `Floki.raw_html/2` when used with the
option `encode: false`. Thanks [@juanazam](https://github.com/juanazam). 
- Fix `traverse_and_update/3` spec. Thanks [@WLSF](https://github.com/WLSF).

### Changed

- Drop support for Elixir 1.9 and 1.10.
- Remove `html_entities` dependency. We now use an internal encoder/decoder for entities.
- Change the main branch name to `main`.

## [0.33.1] - 2022-06-28

### Fixed

- Remove some warnings for unused code.

## [0.33.0] - 2022-06-28

### Added

- Add support for searching elements that contains text in a case-insensitive manner with
`fl-icontains` - thanks [@nuno84](https://github.com/nuno84)

### Changed

- Drop support for Elixir 1.8 and 1.9.
- Fix and improve internal things - thanks [@derek-zhou](https://github.com/derek-zhou) and [@hissssst](https://github.com/hissssst)

## [0.32.1] - 2022-03-24

### Fixed

- Allow root nodes to be selected using pseudo-classes - thanks [@rzane](https://github.com/rzane)

## [0.32.0] - 2021-10-18

### Added

- Add an HTML tokenizer written in Elixir - this still experimental and it's not stable API yet.
- Add support for HTML IDs containing periods in the selectors - thanks [@Hugo-Hache](https://github.com/Hugo-Hache)
- Add support for case-insensitive CSS attribute selectors - thanks [@fcapovilla](https://github.com/fcapovilla)
- Add the `:root` pseudo-class selector - thanks [@fcapovilla](https://github.com/fcapovilla)

## [0.31.0] - 2021-06-11

### Changed

- Treat `style` and `title` tags as plaintext in Mochiweb - thanks [@SweetMNM](https://github.com/SweetMNM)

## [0.30.1] - 2021-03-29

### Fixed

- Fix typespecs of `Floki.traverse_and_update/2` to make clear that it does not accept text nodes directly.

## [0.30.0] - 2021-02-06

### Added

- Add ":disabled" pseudo selector - thanks [@vnegrisolo](https://github.com/vnegrisolo)
- Add [Gleam](https://github.com/gleam-lang/gleam) adapter - thanks [@CrowdHailer](https://github.com/CrowdHailer)
- Add pretty option to `Floki.raw_html/2` - thanks [@evaldobratti](https://github.com/evaldobratti)
- Add `html_parser` option to `parse_` functions. This enables a more dynamic and functional
configuration of the HTML parser in use.

### Changed

- Remove support for Elixir 1.7 - thanks [@carlosfrodrigues](https://github.com/carlosfrodrigues)
- Replace `IO.warn` by `Logger.info` for deprecation warnings - thanks [@juulSme](https://github.com/juulSme)

### Fixed

- Fix typespecs for `find`, `attr` and `attribute` functions - thanks [@mtarnovan](https://github.com/mtarnovan)
- Documentation Improvements - thanks [@kianmeng](https://github.com/kianmeng)

## [0.29.0] - 2020-10-02

### Added

- Add `Floki.find_and_update/3` that updates nodes inside a tree, like traverse and update
but without allowing changes in the children nodes. There for the tree cannot grow in size,
but can have nodes removed.

### Changed

- Deprecate `Floki.map/2` because we have now `Floki.find_and_update/3` and `Floki.traverse_and_update/2` that
are powerful APIs. `Floki.map/2` can be replaced by `Enum.map/2` as well - thanks [@josevalim](https://github.com/josevalim) for the idea!
- Update optional dependency `fast_html` to `v2.0.4`

### Fixed

- Fix a bug when parsing a HTML with a XML inside using Mochiweb's parser

### Improvements

- Add more typespecs

## [0.28.0] - 2020-08-26

### Added

- Add support for `:checked` pseudo-class selector - thanks [@wojtekmach](https://github.com/wojtekmach)

### Changed

- Drop support for Elixir 1.6
- Update version of `fast_html` to 2.0 in docs and CI - thanks [@rinpatch](https://github.com/rinpatch)

### Fixed

- Fix docs by mentioning HTML nodes supported for `traverse_and_update` - thanks [@hubertlepicki](https://github.com/hubertlepicki)

## [0.27.0] - 2020-07-07

### Added

- `Floki.filter_out/2` now can filter text nodes - thanks [@ckruse](https://github.com/ckruse)
- Support more encoding entities in `Floki.raw_html/1` - thanks [@ntenczar](https://github.com/ntenczar)

### Fixed

- Fix `Floki.attribute/2` when there is only text nodes in the document - thanks [@ckruse](https://github.com/ckruse)

### Improvements

- Performance improvements of `Floki.raw_html/1` function - thanks [@josevalim](https://github.com/josevalim)
- Improvements in the docs and specs of `Floki.traverse_and_update/2` and `Floki.children/1` - thanks [@josevalim](https://github.com/josevalim)
- Improvements in the spec of `Floki.traverse_and_update/2` - thanks [@Dalgona](https://github.com/Dalgona)
- Improve the CI setup to run the formatter correctly - thanks [@Cleidiano](https://github.com/Cleidiano)

## [0.26.0] - 2020-02-17

### Added

- Add support for the pseudo-class selectors `:nth-last-child` and `:nth-last-of-type`

### Fixed

- Fix the typespecs of `Floki.traverse_and_update/3` - thanks [@RichMorin](https://github.com/RichMorin)

### Changed

- Update optional dependency `fast_html` to `v1.0.3`

## [0.25.0] - 2020-01-26

### Added

- Add `Floki.parse_fragment!/1` and `Floki.parse_document!/1` that has the same functionality of
the functions without the bang, but they return the document or fragment without the either tuple
and will raise exception in case of errors - thanks [@schneiderderek](https://github.com/schneiderderek)
- Add `Floki.traverse_and_update/3` which accepts an accumulator which is useful to keep
the state while traversing the HTML tree - thanks [@Dalgona](https://github.com/Dalgona)

### Changed

- Update the `html_entities` dependency from `v0.5.0` to `v0.5.1`

## [0.24.0] - 2020-01-01

### Added

- Add support for [`fast_html`](https://hexdocs.pm/fast_html), which is a "C Node" wrapping
Lexborisov's [myhtml](https://github.com/lexborisov/myhtml) - thanks [@rinpatch](https://github.com/rinpatch)
- Add setup to run our test suite against all parsers on CI - thanks [@rinpatch](https://github.com/rinpatch)
- Add `Floki.parse_document/1` and `Floki.parse_fragment/1` in order to correct parse documents
and fragments of documents - it also prevents the confusion and inconsistency of `parse/1`.
- Configure `dialyxir` in order to run Dialyzer easily.

### Changed

- Deprecate `Floki.parse/1` and all the functions that uses it underneath. This means that all
the functions that accepted HTML as binary are deprecated as well. This includes `find/2`, `attr/4`,
`filter_out/2`, `text/2` and `attribute/2`. The recommendation is to use those functions with an
already parsed document or fragment.
- Remove support for `Elixir 1.5`.

## [0.23.1] - 2019-12-01

### Fixed

- It fixes the Mochiweb parser when there is an invalid charref.

## [0.23.0] - 2019-09-11

### Changed

- Remove Mochiweb as a hex dependency. It brings the code from the original project
to Floki's codebase - thanks [@josevalim](https://github.com/josevalim)

## [0.22.0] - 2019-08-21

### Added

- Add `Floki.traverse_and_update/2` that works in similar way to `Floki.map/2` but
traverse the tree and update the children elements. The difference from "map" is that
this function can create a tree with more or less nodes. - thanks [@ericlathrop](https://github.com/ericlathrop)

### Changed

- Remove support for Elixir 1.4.

## [0.21.0] - 2019-04-17

### Added

- Add a possibility to filter `style` tags on `Floki.text/2` - thanks [@Vict0rynox](https://github.com/Vict0rynox)

### Fixed

- Fix `Floki.text/2` to consider the previous filter of `js` when filtering `style` - thanks [@Vict0rynox](https://github.com/Vict0rynox)
- Fix typespecs for `Floki.filter_out/2` - thanks [@myfreeweb](https://github.com/myfreeweb)

### Changed

- Drop support for Elixir 1.3 and below - thanks [@herbstrith](https://github.com/herbstrith)

## [0.20.4] - 2018-09-24

### Fixed

- Fix `Floki.raw_html` to accept lists as attribute values - thanks [@katehedgpeth](https://github.com/katehedgpeth)

## [0.20.3] - 2018-06-22

### Fixed

- Fix style and script tags with comments - thanks [@francois2metz](https://github.com/francois2metz)

## [0.20.2] - 2018-05-09

### Fixed

- Fix `Floki.raw_html/1` to correct handle quotes and double quotes on attributes - thanks [@grych](https://github.com/grych)

## [0.20.1] - 2018-04-05

### Fixed

- Remove `Enumerable.slice/1` compile warning for `Floki.HTMLTree` - thanks [@thecodeboss](https://github.com/thecodeboss)
- Fix `Floki.find/2` that was failing on HTML that consists entirely of a comment - thanks [@ShaneWilton](https://github.com/ShaneWilton)

## [0.20.0] - 2018-02-06

### Added

- Configurable raw_html/2 to allow optional encode of HTML entities - thanks [@davydog187](https://github.com/davydog187)

### Fixed

- Fix serialization of the tree after updating attribute - thanks [@francois2metz](https://github.com/francois2metz)

## [0.19.3] - 2018-01-25

### Fixed

- Skip HTML entities encode for `Floki.raw_html/1` for `script` or `style` tags
- Add `:html_entities` app to the list of OTP applications. It fixes production releases.

## [0.19.2] - 2017-12-22

### Fixed

- **(BREAKING CHANGE)** Re-encode HTML entities on `Floki.raw_html/1`.

## [0.19.1] - 2017-12-04

### Fixed

- Fixed doctype serialization for `Floki.raw_html/1` - thanks [@jhchen][https://github.com/jhchen]

## [0.19.0] - 2017-11-11

### Added

- Added support for `nth-of-type`, `first-of-type`, `last-of-type` and `last-child` pseudo-classes - thanks [@saleem1337](https://github.com/saleem1337).
- Added support for `nth-child` pseudo-class functional notation - thanks [@nirev](https://github.com/nirev).
- Added functional notation support for `nth-of-type` pseudo-class.
- Added a [Contributing guide](https://github.com/philss/floki/blob/main/CONTRIBUTING.md).

### Fixed

- Format all files according to the Elixir 1.6 formatter - thanks [@fcevado](https://github.com/fcevado).
- Fix `Floki.raw_html` to support raw text - thanks [@craig-day](https://github.com/craig-day).

## [0.18.1] - 2017-10-13

### Added

- Added a [Code of Conduct](https://github.com/philss/floki/blob/main/CODE_OF_CONDUCT.md).

### Fixed

- Fix XML tag when building HTML tree.
- Return empty list when `Floki.filter_out/2` result is empty.

## [0.18.0] - 2017-08-05

### Added

- Added `Floki.attr/4` that receives a function enabling manipulation of attribute values - thanks [@erikdsi](https://github.com/erikdsi).
- Implement the String.Chars protocol for Floki.Selector.
- Implement the Enumerable protocol for Floki.HTMLTree.

### Changed

- Changed `Floki.transform/2` to `Floki.map/2` and `Floki.Finder.apply_transform/2` to `Floki.Finder.map/2` - thanks [@aphillipo](https://github.com/aphillipo).

### Fixed

- Fix `Floki.raw_html/1` to consider XML prefixes - thanks [@sergey-kintsel](https://github.com/sergey-kintsel).
- Fix `raw_html` for self closing tags with content - thanks [@navinpeiris](https://github.com/navinpeiris).

### Removed

- Removed support for Elixir 1.2.

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

- Using Logger to notify unknown tokens in selector parser - thanks [@teamon](https://github.com/teamon) and [@geonnave](https://github.com/geonnave)
- Replace `mochiweb_html` with `mochiweb` package. This is needed to fix conflict with other
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

- Using a smaller package with only the Mochiweb HTML parser.

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

- Fix find for sibling nodes when the precedent selector match an element
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
- Include `mochiweb` in the applications list at mix.exs - thanks [@EricDykstra](https://github.com/EricDykstra)

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
E.g: `Floki.find(html, "[data-model=user]")` - [@nelsonr](https://github.com/nelsonr)

## [0.2.1] - 2015-06-04

### Fixed

- Fix `parse/1` when parsing a part of HTML without a root node - [@antonmi](https://github.com/antonmi)

## [0.2.0] - 2015-05-03

### Added

- Support HTML string when searching for attributes with `Floki.attribute/2`.
- Option for `Floki.text/2` to disable deep search and use flat search instead.

### Changed

- Change `Floki.text/1` to perform a deep search of text nodes.
- Consider doctests in the test suite.

## [0.1.1] - 2015-03-25

### Added

- Add CHANGELOG.md following the [Keep a changelog](http://keepachangelog.com/).

### Changed

- Using MochiWeb as a hex dependency instead of embedded code.
It closes the [issue #5](https://github.com/philss/floki/issues/5)

## [0.1.0] - 2015-02-15

### Added

- Descendant selectors, like ".class tag" to Floki.find/2.
- Multiple selection, like ".class1, .class2" to Floki.find/2.

## [0.0.5] - 2014-12-21

### Added

- `Floki.text/1`, which returns all text in the same level
of the parent element inside HTML.

### Changed

- Elixir version requirement from "~> 1.0.0" to ">= 1.0.0".

[unreleased]: https://github.com/philss/floki/compare/v0.34.0...HEAD
[0.34.0]: https://github.com/philss/floki/compare/v0.33.1...v0.34.0
[0.33.1]: https://github.com/philss/floki/compare/v0.33.0...v0.33.1
[0.33.0]: https://github.com/philss/floki/compare/v0.32.1...v0.33.0
[0.32.1]: https://github.com/philss/floki/compare/v0.32.0...v0.32.1
[0.32.0]: https://github.com/philss/floki/compare/v0.31.0...v0.32.0
[0.31.0]: https://github.com/philss/floki/compare/v0.30.1...v0.31.0
[0.30.1]: https://github.com/philss/floki/compare/v0.30.0...v0.30.1
[0.30.0]: https://github.com/philss/floki/compare/v0.29.0...v0.30.0
[0.29.0]: https://github.com/philss/floki/compare/v0.28.0...v0.29.0
[0.28.0]: https://github.com/philss/floki/compare/v0.27.0...v0.28.0
[0.27.0]: https://github.com/philss/floki/compare/v0.26.0...v0.27.0
[0.26.0]: https://github.com/philss/floki/compare/v0.25.0...v0.26.0
[0.25.0]: https://github.com/philss/floki/compare/v0.24.0...v0.25.0
[0.24.0]: https://github.com/philss/floki/compare/v0.23.1...v0.24.0
[0.23.1]: https://github.com/philss/floki/compare/v0.23.0...v0.23.1
[0.23.0]: https://github.com/philss/floki/compare/v0.22.0...v0.23.0
[0.22.0]: https://github.com/philss/floki/compare/v0.21.0...v0.22.0
[0.21.0]: https://github.com/philss/floki/compare/v0.20.4...v0.21.0
[0.20.4]: https://github.com/philss/floki/compare/v0.20.3...v0.20.4
[0.20.3]: https://github.com/philss/floki/compare/v0.20.2...v0.20.3
[0.20.2]: https://github.com/philss/floki/compare/v0.20.1...v0.20.2
[0.20.1]: https://github.com/philss/floki/compare/v0.20.0...v0.20.1
[0.20.0]: https://github.com/philss/floki/compare/v0.19.3...v0.20.0
[0.19.3]: https://github.com/philss/floki/compare/v0.19.2...v0.19.3
[0.19.2]: https://github.com/philss/floki/compare/v0.19.1...v0.19.2
[0.19.1]: https://github.com/philss/floki/compare/v0.19.0...v0.19.1
[0.19.0]: https://github.com/philss/floki/compare/v0.18.1...v0.19.0
[0.18.1]: https://github.com/philss/floki/compare/v0.18.0...v0.18.1
[0.18.0]: https://github.com/philss/floki/compare/v0.17.2...v0.18.0
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
