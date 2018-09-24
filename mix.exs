defmodule Floki.Mixfile do
  use Mix.Project

  @description "Floki is a simple HTML parser that enables search for nodes using CSS selectors."
  @version "0.20.4"

  def project do
    [
      app: :floki,
      name: "Floki",
      version: @version,
      description: @description,
      elixir: ">= 1.3.0",
      package: package(),
      deps: deps(),
      source_url: "https://github.com/philss/floki",
      docs: [extras: ["README.md"], main: "Floki"]
    ]
  end

  def application do
    [applications: [:logger, :mochiweb, :html_entities]]
  end

  defp deps do
    [
      {:mochiweb, "~> 2.15"},
      {:html_entities, "~> 0.4.0"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.18", only: :dev},
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    %{
      maintainers: ["Philip Sampaio Silva"],
      licenses: ["MIT"],
      files: [
        "lib",
        "src/*.xrl",
        "mix.exs",
        "README.md",
        "LICENSE",
        "CODE_OF_CONDUCT.md",
        "CONTRIBUTING.md"
      ],
      links: %{
        "GitHub" => "https://github.com/philss/floki"
      }
    }
  end
end
