Floki
=====

Floki is useful to search inside HTML documents using query selectors (like jQuery).
Under the hood, it uses the [Mochiweb](https://github.com/mochi/mochiweb) HTML parser.

This version works with simple CSS class selectors (without nesting or group),
like `.class-name`.

## API

To parse a HTML document, try:

```elixir
Floki.parse(html)
```

To find elements with the class `js-link`, try:

```elixir
Floki.find(html, ".js-link")
```

To fetch some attribute from elements, try:

```elixir
Floki.attribute(html, ".js-link", "href")
```

You can also get attributes from elements that you already have:

```elixir
Floki.find(html, ".js-link")
|> Floki.attribute("href")
```

## License

Floki is under MIT license. Check the `LICENSE` file for more details.
