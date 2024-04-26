defmodule Floki.Mixfile do
  use Mix.Project

  @description "Floki is a simple HTML parser that enables search for nodes using CSS selectors."
  @source_url "https://github.com/philss/floki"
  @version "0.36.2"

  def project do
    [
      app: :floki,
      name: "Floki",
      version: @version,
      description: @description,
      elixir: "~> 1.13",
      package: package(),
      erlc_paths: ["src", "gen"],
      compilers: [:leex] ++ Mix.compilers(),
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", {:"README.md", [title: "Overview"]}],
      main: "readme",
      assets: "assets",
      logo: "assets/images/floki-logo.svg",
      source_url: @source_url,
      source_ref: "v#{@version}",
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1", only: [:dev, :test, :docs]},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.32.0", only: :dev, runtime: false},
      {:benchee, "~> 1.3.0", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:html5ever, ">= 0.8.0", optional: true, only: [:dev, :test]},
      {:fast_html, ">= 0.0.0", optional: true, only: [:dev, :test]}
    ]
  end

  defp aliases do
    # Hardcoded because we can't load the floki application and get the module list at this point.
    parsers = [Floki.HTMLParser.Mochiweb, Floki.HTMLParser.FastHtml, Floki.HTMLParser.Html5ever]

    {aliases, cli_names} =
      Enum.map_reduce(parsers, [], fn parser, acc ->
        cli_name =
          parser
          |> Module.split()
          |> List.last()
          |> Macro.underscore()

        {{:"test_#{cli_name}", &test_with_parser(parser, &1)}, [cli_name | acc]}
      end)

    Keyword.put(aliases, :test_all, &test_with_parser(cli_names, &1))
  end

  defp test_with_parser(parser_cli_names, args) when is_list(parser_cli_names) do
    Enum.each(parser_cli_names, fn cli_name ->
      Mix.shell().cmd("mix test_#{cli_name} --color #{Enum.join(args, " ")}",
        env: [{"MIX_ENV", "test"}]
      )
    end)
  end

  defp test_with_parser(parser, args) do
    Mix.shell().info("Running tests with #{parser}")
    Application.put_env(:floki, :html_parser, parser, persistent: true)
    Mix.env(:test)
    Mix.Tasks.Test.run(args)
  end

  defp package do
    %{
      maintainers: ["Philip Sampaio Silva"],
      licenses: ["MIT"],
      files: [
        # We don't want to ship mix tasks.
        "lib/floki",
        "lib/floki.ex",
        "src/*.xrl",
        "src/floki_mochi_html.erl",
        "mix.exs",
        "README.md",
        "LICENSE",
        "CODE_OF_CONDUCT.md",
        "CONTRIBUTING.md",
        "CHANGELOG.md"
      ],
      links: %{
        "Changelog" => "https://hexdocs.pm/floki/changelog.html",
        "Sponsor" => "https://github.com/sponsors/philss",
        "GitHub" => @source_url
      }
    }
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]
end
