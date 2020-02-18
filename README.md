[![Actions Status](https://github.com/philss/floki/workflows/CI/badge.svg?branch=master)](https://github.com/philss/floki/actions)
[![Floki version](https://img.shields.io/hexpm/v/floki.svg)](https://hex.pm/packages/floki)
[![Hex.pm](https://img.shields.io/hexpm/dt/floki.svg)](https://hex.pm/packages/floki)
[![Inline docs](https://inch-ci.org/github/philss/floki.svg?branch=master)](https://inch-ci.org/github/philss/floki)
[![SourceLevel](https://app.sourcelevel.io/github/philss/floki.svg)](https://app.sourcelevel.io/github/philss/floki)

<img src="assets/images/floki-logo-with-type.svg" width="500" alt="Floki logo">

**Floki is a simple HTML parser that enables search for nodes using CSS selectors**.

[Check the documentation](https://hexdocs.pm/floki).

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
    {:floki, "~> 0.26.0"}
  ]
end
```

After that, run `mix deps.get`.

## Dependencies

Floki needs the `leex` module in order to compile.
Normally this module is installed with Erlang in a complete installation.

If you get this [kind of error](https://github.com/philss/floki/issues/35),
you need to install the `erlang-dev` and `erlang-parsetools` packages in order get the `leex` module.
The packages names may be different depending on your OS.

### Alternative HTML parsers

By default Floki uses a patched version of `mochiweb_html` for parsing fragments
due to its ease of installation (it's written in Erlang and has no outside dependencies).

However one might want to use an alternative parser due to the following
concerns:

- Performance - It can be [up to 20 times slower than the alternatives](https://hexdocs.pm/fast_html/readme.html#benchmarks) on big HTML
  documents.
- Correctness - in some cases `mochiweb_html` will produce different results
  from what is specified in [HTML5 specification](https://html.spec.whatwg.org/)](https://html.spec.whatwg.org/).
  For example, a correct parser would parse `<title> <b> bold </b> text </title>`
  as `{"title", [], [" <b> bold </b> text "]}` since content inside `<title>` is
  to be [treated as plaintext](https://html.spec.whatwg.org/#the-title-element).
  Albeit `mochiweb_html` would parse it as `{"title", [], [{"b", [], [" bold "]}, " text "]}`.

Floki supports the following alternative parsers:

- `fast_html` - A wrapper for lexborisov's [myhtml](https://github.com/lexborisov/myhtml/). A pure C HTML parser.
- `html5ever` - A wrapper for [html5ever](https://github.com/servo/html5ever) written in Rust, developed as a part of the Servo project.

`fast_html` is generally faster, according to the
[benchmarks](https://hexdocs.pm/fast_html/readme.html#benchmarks) conducted by
its developers. Though `html5ever` does have an advantage on really small
(~4kb) fragments due to it being implemented as a NIF.

#### Using `html5ever` as the HTML parser

Rust needs to be installed on the system in order to compile html5ever. To do that, please
[follow the instruction](https://www.rust-lang.org/en-US/install.html) presented in the official page.

After Rust is set up, you need to add `html5ever` NIF to your dependency list:

```elixir
defp deps do
  [
    {:floki, "~> 0.26.0"},
    {:html5ever, "~> 0.7.0"}
  ]
end
```

Run `mix deps.get` and compiles the project with `mix compile` to make sure it works.

Then you need to configure your app to use `html5ever`:

```elixir
# in config/config.exs

config :floki, :html_parser, Floki.HTMLParser.Html5ever
```

For more info, check the article [Rustler - Safe Erlang and Elixir NIFs in Rust](http://hansihe.com/2017/02/05/rustler-safe-erlang-elixir-nifs-in-rust.html).

#### Using `fast_html` as the HTML parser

A C compiler and GNU\Make needs to be installed on the system in order to
compile myhtml. It's likely that your machine has them already.

Note that you also need to have `epmd` started/available to start due to `fast_html` relying on a
C-Node worker, usually it will be started automatically, but some distributions
(i.e Gentoo Linux) enforce only being able to start it as a service.

First, add `fast_html` to your dependencies:

```elixir
defp deps do
  [
    {:floki, "~> 0.26.0"},
    {:fast_html, "~> 1.0"}
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
| E.warning       | an E element whose class is "warning" |
| E#myid          | an E element with ID equal to "myid" |
| E:not(s)        | an E element that does not match simple selector s |
| E F             | an F element descendant of an E element |
| E > F           | an F element child of an E element |
| E + F           | an F element immediately preceded by an E element |
| E ~ F           | an F element preceded by an E element |

There are also some selectors based on non-standard specifications. They are:

| Pattern              | Description                                         |
|----------------------|-----------------------------------------------------|
| E:fl-contains('foo') | an E element that contains "foo" inside a text node |

## Special thanks

* [@arasatasaygin](https://github.com/arasatasaygin) for Floki's logo from the [Open Logos project](http://openlogos.org/).

## License

Floki is under MIT license. Check the `LICENSE` file for more details.
