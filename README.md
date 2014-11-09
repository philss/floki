Floki - search inside HTML documents
=====

[![Build Status](https://travis-ci.org/philss/floki.svg?branch=master)](https://travis-ci.org/philss/floki)

Floki is useful to search inside HTML documents using query selectors (like jQuery).
Under the hood, it uses the [Mochiweb](https://github.com/mochi/mochiweb) HTML parser.

This version works with simple CSS selectors (without nesting or group).
List of selectors:

  * class selectors - Ex.: `.class-name`
  * id selectors - Ex.: `#element-id`
  * tag selectors - Ex.: `img`

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

## License

Floki is under MIT license. Check the `LICENSE` file for more details.
