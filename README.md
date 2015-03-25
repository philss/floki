Floki
=====

[![Build status](https://travis-ci.org/philss/floki.svg?branch=master)](https://travis-ci.org/philss/floki)
[![Floki version](https://img.shields.io/hexpm/v/floki.svg)](https://hex.pm/packages/floki)

This is a simple HTML parser that enables search using CSS like selectors.

You can search elements by class, tag name and id.

[Check the documentation](http://hexdocs.pm/floki).

## Example

Assuming that you have the following HTML:

```html
<!doctype html>
<html>
<body>
<section id="content">
  <p class="headline">Floki</p>
  <a href="http://github.com/philss/floki">Github page</a>
</section>
</body>
</html>
```

You can perform the following queries:

```elixir
Floki.find(html, "#content") # returns the section with all children
Floki.find(html, ".headline") # returns a list with the `p` element
Floki.find(html, "a") # returns a list with the `a` element
Floki.find(html, "#content a") # returns all links inside content section
Floki.find(html, ".headline, a") # returns the .headline elements and links
```

Each HTML node is represented by a tuple like:

    {tag_name, attributes, children_nodes}

Example of node:

    {"p", [{"class", "headline"}], ["Floki"]}

So even if the only child node is the element text, it is represented
inside a list.

You can write a simple HTML crawler (with support of [HTTPoison](https://github.com/edgurgel/httpoison)) with a few lines of code:

```elixir
html
|> Floki.find(".pages a")
|> Floki.attribute("href")
|> Enum.map(fn(url) -> HTTPoison.get!(url) end)
```

It is simple as that!

## API

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

To fetch some attribute from elements, try:

```elixir
Floki.attribute(html, ".example", "class") # href or src are good possibilities to fetch links
# => ["example"]
```

You can also get attributes from elements that you already have:

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
