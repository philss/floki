# Floki

[![Build status](https://travis-ci.org/philss/floki.svg?branch=master)](https://travis-ci.org/philss/floki)
[![Floki version](https://img.shields.io/hexpm/v/floki.svg)](https://hex.pm/packages/floki)
[![Hex.pm](https://img.shields.io/hexpm/dt/floki.svg)](https://hex.pm/packages/floki)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/philss/floki.svg)](https://beta.hexfaktor.org/github/philss/floki)
[![Inline docs](http://inch-ci.org/github/philss/floki.svg?branch=master)](http://inch-ci.org/github/philss/floki)

Floki is a simple HTML parser that enables search for nodes using CSS selectors.

[Check the documentation](http://hexdocs.pm/floki).

## Usage

Take this HTML as an example:

```html
<!doctype html>
<html>
<body>
  <section id="content">
    <p class="headline">Floki</p>
    <span class="headline">Enables search using CSS selectors</span>
    <a href="http://github.com/philss/floki">Github page</a>
    <span data-model="user">philss</span>
  </section>
  <a href="https://hex.pm/packages/floki">Hex package</a>
</body>
</html>
```

Here are some queries that you can perform (with return examples):

```elixir
Floki.find(html, "#content")
# => [{"section", [{"id", "content"}],
# =>   [{"p", [{"class", "headline"}], ["Floki"]},
# =>    {"span", [{"class", "headline"}], ["Enables search using CSS selectors"]},
# =>    {"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
# =>    {"span", [{"data-model", "user"}], ["philss"]}]}]


Floki.find(html, "p.headline")
# => [{"p", [{"class", "headline"}], ["Floki"]}]


Floki.find(html, "p.headline")
|> Floki.raw_html
# => <p class="headline">Floki</p>


Floki.find(html, "a")
# => [{"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
# =>  {"a", [{"href", "https://hex.pm/packages/floki"}], ["Hex package"]}]


Floki.find(html, "a[href^=https]")
# => [{"a", [{"href", "https://hex.pm/packages/floki"}], ["Hex package"]}]


Floki.find(html, "#content a")
# => [{"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]}]


Floki.find(html, "[data-model=user]")
# => [{"span", [{"data-model", "user"}], ["philss"]}]


Floki.find(html, ".headline:nth-child(1), a")
# => [{"p", [{"class", "headline"}], ["Floki"]},
# =>  {"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
# =>  {"a", [{"href", "https://hex.pm/packages/floki"}], ["Hex package"]}]
```

Each HTML node is represented by a tuple like:

    {tag_name, attributes, children_nodes}

Example of node:

    {"p", [{"class", "headline"}], ["Floki"]}

So even if the only child node is the element text, it is represented
inside a list.

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
    {:floki, "~> 0.14.0"}
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

Since it's written in Rust, we need to install Rust and compile the project. Luckily we have have the
[html5ever Elixir NIF](https://github.com/hansihe/html5ever_elixir) that makes the integration very easy.

You still need to install Rust in your system. To do that, please
[follow the instruction](https://www.rust-lang.org/en-US/install.html) presented in the official page.

#### Installing html5ever

After setup Rust, you need to add `html5ever` NIF to your dependency list:

```elixir
defp deps do
  [
    {:floki, "~> 0.14.0"},
    {:html5ever, "~> 0.2.0"}
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

To know more about NIFs, check the [Erlang docs](http://erlang.org/doc/man/erl_nif.html).
And to know why Rust NIFs can be better, check the [Rustler](https://github.com/hansihe/rustler) project.

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
Floki.attribute(html, ".example", "class") # href or src are good possibilities to fetch links
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

## License

Floki is under MIT license. Check the `LICENSE` file for more details.
