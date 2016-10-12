defmodule Floki.Mixfile do
  use Mix.Project

  @description "Floki is a simple HTML parser that enables search for nodes using CSS selectors."
  @version "0.11.0"

  def project do
    [app: :floki,
     name: "Floki",
     version: @version,
     description: @description,
     elixir: ">= 1.1.0",
     package: package,
     deps: deps,
     source_url: "https://github.com/philss/floki",
     docs: [extras: ["README.md"], main: "Floki"]]
  end

  def application do
    [applications: [:logger, :mochiweb]]
  end

  defp deps do
    [
      {:mochiweb, "~> 2.15"},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},
      {:inch_ex,">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    %{
      maintainers: ["Philip Sampaio Silva"],
      licenses: ["MIT"],
      files: ["lib", "src/*.xrl", "mix.exs", "README.md", "LICENSE"],
      links: %{
        "GitHub" => "https://github.com/philss/floki",
        "Docs"   => "http://hexdocs.pm/floki"
      }
    }
  end
end
