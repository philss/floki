defmodule Floki.Mixfile do
  use Mix.Project

  def project do
    [app: :floki,
     version: "0.7.1",
     name: "Floki",
     elixir: ">= 1.0.0",
     package: package,
     description: description,
     docs: [extras: ["README.md"]],
     source_url: "https://github.com/philss/floki",
     deps: deps]
  end

  def application do
    [applications: [:mochiweb]]
  end

  defp deps do
    [
      {:mochiweb, "~> 2.12.2"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.8", only: :dev},
      {:inch_ex, only: :docs}
    ]
  end

  defp description do
    """
    A HTML parser and searcher.

    You can search inside HTML documents using CSS selectors.
    """
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
