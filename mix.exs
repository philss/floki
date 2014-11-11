defmodule Floki.Mixfile do
  use Mix.Project

  def project do
    [app: :floki,
     version: "0.0.4",
     elixir: "~> 1.0.0",
     package: package,
     description: description,
     docs: [readme: true, main: "README.md"],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev}]
  end

  defp description do
    """
    A HTML parser and seeker.

    You can search inside HTML documents using CSS like selectors.
    """
  end

  defp package do
    %{
      contributors: ["Philip Sampaio Silva"],
      licenses: ["MIT"],
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*", "src"],
      links: %{
        "GitHub" => "https://github.com/philss/floki",
        "Docs"   => "http://hexdocs.pm/floki"
      }
    }
  end
end
