use Mix.Config

config :logger, :console,
  format: "$metadata $message\n",
  metadata: [:module]
