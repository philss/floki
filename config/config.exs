use Mix.Config

config :logger, :console,
  format: "$metadata $message\n",
  metadata: [:module]

config :floki, :html_parser, Floki.HTMLParser.Mochiweb
