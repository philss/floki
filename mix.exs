defmodule Floki.Mixfile do
  use Mix.Project

  @description "Floki is a simple HTML parser that enables search for nodes using CSS selectors."
  @version "0.7.2"

  def project do
    [app: :floki,
     name: "Floki",
     version: @version,
     description: @description,
     elixir: ">= 1.0.0",
     package: package,
     deps: deps,
     source_url: "https://github.com/philss/floki",
     docs: [extras: ["README.md"], main: "Floki"]]
  end

  def application do
    [applications: [:mochiweb]]
  end

  defp deps do
    [
      {:mochiweb, "~> 2.12.2"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:inch_ex,">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    %{
      maintainers: ["Philip Sampaio Silva"],
      licenses: ["MIT"],
      files: ["lib", "priv", "src/*.xrl", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      links: %{
        "GitHub" => "https://github.com/philss/floki",
        "Docs"   => "http://hexdocs.pm/floki"
      }
    }
  end
end
