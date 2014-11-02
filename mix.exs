defmodule Floki.Mixfile do
  use Mix.Project

  def project do
    [app: :floki,
     version: "0.0.1",
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
    [
      {:mochiweb, git: "https://github.com/mochi/mochiweb.git", tag: "v2.9.2"}
    ]
  end

  defp description do
    """
    Floki is useful to search elements inside HTML documents using query selectors (like jQuery).
    """
  end

  defp package do
    %{
      contributors: ["Philip Sampaio Silva"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/philss/floki"}
    }
  end
end
