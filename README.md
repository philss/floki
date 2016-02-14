# Floki

[![Build status](https://travis-ci.org/philss/floki.svg?branch=master)](https://travis-ci.org/philss/floki)
[![Floki version](https://img.shields.io/hexpm/v/floki.svg)](https://hex.pm/packages/floki)
[![Hex.pm](https://img.shields.io/hexpm/dt/floki.svg)](https://hex.pm/packages/floki)
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
# =>  [{"p", [{"class", "headline"}], ["Floki"]},
# =>   {"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]}]}]


Floki.find(html, "p.headline")
# => [{"p", [{"class", "headline"}], ["Floki"]}]

Floki.find(html, "p.headline")
|> Floki.raw_html
# => <p class="headline">Floki</p>


Floki.find(html, "a")
# => [{"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
# =>  {"a", [{"href", "https://hex.pm/packages/floki"}], ["Hex package"]}]


Floki.find(html, "a[href^=https]")
# => [{"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]},
# =>  {"a", [{"href", "https://hex.pm/packages/floki"}], ["Hex package"]}]


Floki.find(html, "#content a")
# => [{"a", [{"href", "http://github.com/philss/floki"}], ["Github page"]}]


Floki.find(html, "[data-model=user]")
# => [{"span", [{"data-model", "user"}], ["philss"]}]


Floki.find(html, ".headline, a")
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

Add Floki in your `mix.exs`, as a dependency:

```elixir
defp deps do
  [
    {:floki, "~> 0.7"}
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

## More about the API

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
