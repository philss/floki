[![Actions Status](https://github.com/philss/floki/workflows/CI/badge.svg?branch=main)](https://github.com/philss/floki/actions)
[![Floki version](https://img.shields.io/hexpm/v/floki.svg)](https://hex.pm/packages/floki)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/floki/)
[![Hex.pm](https://img.shields.io/hexpm/dt/floki.svg)](https://hex.pm/packages/floki)
[![License](https://img.shields.io/hexpm/l/floki.svg)](https://github.com/philss/floki/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/philss/floki.svg)](https://github.com/philss/floki/commits/main)

<img src="assets/images/floki-logo-with-type.svg" width="500" alt="Floki logo">

**Floki is a simple HTML parser that enables search for nodes using CSS selectors**.

[Check the documentation 📙](https://hexdocs.pm/floki).

## Usage

Take this HTML as an example:

```html
<!doctype html>
<html>
<body>
  <section id="content">
    <p class="headline">Floki</p>
    <span class="headline">Enables search using CSS selectors</span>
    <a href="https://github.com/philss/floki">Github page</a>
    <span data-model="user">philss</span>
  </section>
  <a href="https://hex.pm/packages/floki">Hex package</a>
</body>
</html>
```

Here are some queries that you can perform (with return examples):

```elixir
{:ok, document} = Floki.parse_document(html)

Floki.find(document, "p.headline")
# => [{"p", [{"class", "headline"}], ["Floki"]}]

document
|> Floki.find("p.headline")
|> Floki.raw_html
# => <p class="headline">Floki</p>
```

Each HTML node is represented by a tuple like:

    {tag_name, attributes, children_nodes}

Example of node:

    {"p", [{"class", "headline"}], ["Floki"]}

So even if the only child node is the element text, it is represented inside a list.

## Installation

Add Floki to your `mix.exs`:

```elixir
defp deps do
  [
    {:floki, "~> 0.37.0"}
  ]
end
```

After that, run `mix deps.get`.

If you are running on [Livebook](https://livebook.dev) or a script, you can install with `Mix.install/2`:

```elixir
Mix.install([
  {:floki, "~> 0.37.0"}
])
```

You can check the [changelog](CHANGELOG.md) for changes.

## Dependencies

Floki needs the `:leex` module in order to compile.
Normally this module is installed with Erlang in a complete installation.

If you get this ["module :leex is not available"](https://github.com/philss/floki/issues/35) error message, you need to install the `erlang-dev` and `erlang-parsetools` packages in order get the `:leex` module. The packages names may be different depending on your OS.

### Alternative HTML parsers

By default Floki uses a patched version of `mochiweb_html` for parsing fragments
due to its ease of installation (it's written in Erlang and has no outside dependencies).

However one might want to use an alternative parser due to the following
concerns:

- Performance - It can be [up to 20 times slower than the alternatives](https://hexdocs.pm/fast_html/readme.html#benchmarks) on big HTML
  documents.
- Correctness - in some cases `mochiweb_html` will produce different results
  from what is specified in [HTML5 specification](https://html.spec.whatwg.org/).
  For example, a correct parser would parse `<title> <b> bold </b> text </title>`
  as `{"title", [], [" <b> bold </b> text "]}` since content inside `<title>` is
  to be [treated as plaintext](https://html.spec.whatwg.org/#the-title-element).
  Albeit `mochiweb_html` would parse it as `{"title", [], [{"b", [], [" bold "]}, " text "]}`.

Floki supports the following alternative parsers:

- `fast_html` - A wrapper for [lexbor](https://github.com/lexbor/lexbor). A pure C HTML parser.
- `html5ever` - A wrapper for [html5ever](https://github.com/servo/html5ever) written in Rust, developed as a part of the Servo project.

`fast_html` is generally faster, according to the
[benchmarks](https://hexdocs.pm/fast_html/readme.html#benchmarks) conducted by
its developers.

You can perform a benchmark by running the following:

```sh
sh benchs/extract.sh
mix run benchs/parse_document.exs
```

Extracting the files is needed only once.

#### Using `html5ever` as the HTML parser

This dependency is written with a NIF using [Rustler](https://github.com/rusterlium/rustler), but
you don't need to install anything to compile it thanks to [RustlerPrecompiled](https://hexdocs.pm/rustler_precompiled/).

```elixir
defp deps do
  [
    {:floki, "~> 0.37.0"},
    {:html5ever, "~> 0.15.0"}
  ]
end
```

Run `mix deps.get` and compiles the project with `mix compile` to make sure it works.

Then you need to configure your app to use `html5ever`:

```elixir
# in config/config.exs

config :floki, :html_parser, Floki.HTMLParser.Html5ever
```

Notice that you can pass the HTML parser as an option in `parse_document/2` and `parse_fragment/2`.

#### Using `fast_html` as the HTML parser

A C compiler, GNU\Make and CMake need to be installed on the system in order to
compile lexbor.

First, add `fast_html` to your dependencies:

```elixir
defp deps do
  [
    {:floki, "~> 0.37.0"},
    {:fast_html, "~> 2.0"}
  ]
end
```

Run `mix deps.get` and compiles the project with `mix compile` to make sure it works.

Then you need to configure your app to use `fast_html`:

```elixir
# in config/config.exs

config :floki, :html_parser, Floki.HTMLParser.FastHtml
```

## More about Floki API

To parse a HTML document, try:

```elixir
html = """
  <html>
  <body>
    <div class="example"></div>
  </body>
  </html>
"""

{:ok, document} = Floki.parse_document(html)
# => {:ok, [{"html", [], [{"body", [], [{"div", [{"class", "example"}], []}]}]}]}
```

To find elements with the class `example`, try:

```elixir
Floki.find(document, ".example")
# => [{"div", [{"class", "example"}], []}]
```

To convert your node tree back to raw HTML (spaces are ignored):

```elixir
document
|> Floki.find(".example")
|> Floki.raw_html
# =>  <div class="example"></div>
```

To fetch some attribute from elements, try:

```elixir
Floki.attribute(document, ".example", "class")
# => ["example"]
```

You can get attributes from elements that you already have:

```elixir
document
|> Floki.find(".example")
|> Floki.attribute("class")
# => ["example"]
```

If you want to get the text from an element, try:

```elixir
document
|> Floki.find(".headline")
|> Floki.text

# => "Floki"
```

## Supported selectors

Here you find all the [CSS selectors](https://www.w3.org/TR/selectors/#selectors) supported in the current version:

| Pattern         | Description                  |
|-----------------|------------------------------|
| *               | any element                  |
| E               | an element of type `E`       |
| E[foo]          | an `E` element with a "foo" attribute |
| E[foo="bar"]    | an E element whose "foo" attribute value is exactly equal to "bar" |
| E[foo~="bar"]   | an E element whose "foo" attribute value is a list of whitespace-separated values, one of which is exactly equal to "bar" |
| E[foo^="bar"]   | an E element whose "foo" attribute value begins exactly with the string "bar" |
| E[foo$="bar"]   | an E element whose "foo" attribute value ends exactly with the string "bar" |
| E[foo*="bar"]   | an E element whose "foo" attribute value contains the substring "bar" |
| E[foo\|="en"]    | an E element whose "foo" attribute has a hyphen-separated list of values beginning (from the left) with "en" |
| E:nth-child(n)  | an E element, the n-th child of its parent |
| E:nth-last-child(n)  | an E element, the n-th child of its parent, counting from bottom to up |
| E:first-child   | an E element, first child of its parent |
| E:last-child   | an E element, last child of its parent |
| E:nth-of-type(n)  | an E element, the n-th child of its type among its siblings |
| E:nth-last-of-type(n)  | an E element, the n-th child of its type among its siblings, counting from bottom to up |
| E:first-of-type   | an E element, first child of its type among its siblings |
| E:last-of-type   | an E element, last child of its type among its siblings |
| E:checked       | An E element (checkbox, radio, or option) that is checked |
| E:disabled      | An E element (button, input, select, textarea, or option) that is disabled |
| E.warning       | an E element whose class is "warning" |
| E#myid          | an E element with ID equal to "myid" (for ids containing periods, use `#my\\.id` or `[id="my.id"]`) |
| E:not(s)        | an E element that does not match simple selector s |
| :root           | the root node or nodes (in case of fragments) of the document. Most of the times this is the `html` tag |
| E F             | an F element descendant of an E element |
| E > F           | an F element child of an E element |
| E + F           | an F element immediately preceded by an E element |
| E ~ F           | an F element preceded by an E element |

There are also some selectors based on non-standard specifications. They are:

| Pattern               | Description                                                            |
|-----------------------|------------------------------------------------------------------------|
| E:fl-contains('foo')  | an E element that contains "foo" inside a text node                    |
| E:fl-icontains('foo') | an E element that contains "foo" inside a text node (case insensitive) |

## Suppressing log messages

Floki may log debug messages related to problems in the parsing of selectors, or parsing of the HTML tree.
It also may log some "info" messages related to deprecated APIs. If you want to suppress these log messages,
please consider setting the `:compile_time_purge_matching` option for `:logger` in your compile time configuration.

See https://hexdocs.pm/logger/Logger.html#module-compile-configuration for details.

## Special thanks

* [@arasatasaygin](https://github.com/arasatasaygin) for Floki's logo from the [Open Logos project](http://openlogos.org/).

## License

Copyright (c) 2014 Philip Sampaio Silva

Floki is under MIT license. Check the [LICENSE](https://github.com/philss/floki/blob/main/LICENSE) file for more details.
