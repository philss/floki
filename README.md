Floki
=====

Floki parses and query HTML documents using query selectors (like jQuery)

## API

To parse a document, try:

```elixir
Floki.parse(html)
```

To find elements with the class `js-action`, try:

```elixir
Floki.find(".js-action", html)
```

To fetch some attribute from elements, try:

```elixir
Floki.get_attribute("href", ".js-action", html)
```
