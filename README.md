# Floki

[![Build status](https://travis-ci.org/philss/floki.svg?branch=master)](https://travis-ci.org/philss/floki)
[![Floki version](https://img.shields.io/hexpm/v/floki.svg)](https://hex.pm/packages/floki)
[![Hex.pm](https://img.shields.io/hexpm/dt/floki.svg)](https://hex.pm/packages/floki)
[![Inline docs](https://inch-ci.org/github/philss/floki.svg?branch=master)](https://inch-ci.org/github/philss/floki)
[![Ebert](https://ebertapp.io/github/philss/floki.svg)](https://ebertapp.io/github/philss/floki)

Floki is a simple HTML parser that enables search for nodes using CSS selectors.

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
Floki.find(html, "p.headline")
# => [{"p", [{"class", "headline"}], ["Floki"]}]


Floki.find(html, "p.headline")
|> Floki.raw_html
# => <p class="headline">Floki</p>
```

Each HTML node is represented by a tuple like:

    {tag_name, attributes, children_nodes}

Example of node:

    {"p", [{"class", "headline"}], ["Floki"]}

So even if the only child node is the element text, it is represented inside a list.

You can write a simple HTML crawler with Floki and [HTTPoison](https://github.com/edgurgel/httpoison):

```elixir
html
|> Floki.find(".pages a")
|> Floki.attribute("href")
|> Enum.map(fn(url) -> HTTPoison.get!(url) end)

```

It is simple as that!

## Installation

Add Floki to your `mix.exs`:

```elixir
defp deps do
  [
    {:floki, "~> 0.19.0"}
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

### Optional - Using http5ever as the HTML parser

You can configure Floki to use [html5ever](https://github.com/servo/html5ever) as your HTML parser.
This is recommended if you need [better performance](https://gist.github.com/philss/70b4b0294f29501c3c7e0f60338cc8bd)
and a more accurate parser. However `html5ever` is being under active development and **may be unstable**.

Since it's written in Rust, we need to install Rust and compile the project.
Luckily we have have the [html5ever Elixir NIF](https://github.com/hansihe/html5ever_elixir) that makes the integration very easy.

You still need to install Rust in your system. To do that, please
[follow the instruction](https://www.rust-lang.org/en-US/install.html) presented in the official page.

#### Installing html5ever

After setup Rust, you need to add `html5ever` NIF to your dependency list:

```elixir
defp deps do
  [
    {:floki, "~> 0.19.0"},
    {:html5ever, "~> 0.5.0"}
  ]
end
```

Run `mix deps.get` and compiles the project with `mix compile` to make sure it works.

Then you need to configure your app to use `html5ever`:

```elixir
# in config/config.exs

config :floki, :html_parser, Floki.HTMLParser.Html5ever
```

After that you are able to use `html5ever` as your HTML parser with Floki.

For more info, check the article [Rustler - Safe Erlang and Elixir NIFs in Rust](http://hansihe.com/2017/02/05/rustler-safe-erlang-elixir-nifs-in-rust.html).

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

Floki.parse(html)
# => {"html", [], [{"body", [], [{"div", [{"class", "example"}], []}]}]}
```

To find elements with the class `example`, try:

```elixir
Floki.find(html, ".example")
# => [{"div", [{"class", "example"}], []}]
```

To convert your node tree back to raw HTML (spaces are ignored):

```elixir
Floki.find(html, ".example")
|> Floki.raw_html
# =>  <div class="example"></div>
```

To fetch some attribute from elements, try:

```elixir
Floki.attribute(html, ".example", "class")
# => ["example"]
```

You can get attributes from elements that you already have:

```elixir
Floki.find(html, ".example")
|> Floki.attribute("class")
# => ["example"]
```

If you want to get the text from an element, try:

```elixir
Floki.find(html, ".headline")
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
| E:first-child   | an E element, first child of its parent |
| E:last-child   | an E element, last child of its parent |
| E:nth-of-type(n)  | an E element, the n-th child of its type among its siblings |
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

## License

Floki is under MIT license. Check the `LICENSE` file for more details.
