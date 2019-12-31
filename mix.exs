defmodule Floki.Mixfile do
  use Mix.Project

  @description "Floki is a simple HTML parser that enables search for nodes using CSS selectors."
  @version "0.23.1"

  def project do
    [
      app: :floki,
      name: "Floki",
      version: @version,
      description: @description,
      elixir: "~> 1.5",
      package: package(),
      deps: deps(),
      aliases: aliases(),
      source_url: "https://github.com/philss/floki",
      docs: [extras: ["README.md"], main: "Floki", assets: "assets"]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    # Needed to avoid installing unnecessary deps on the CI
    parsers =
      case System.get_env("PARSER") do
        nil -> [:fast_html, :html5ever]
        parser -> [String.to_atom(parser)]
      end
      |> Enum.map(fn name -> {name, ">= 0.0.0", optional: true, only: [:dev, :test]} end)

    [
      {:html_entities, "~> 0.5.0"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.18", only: :dev},
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ] ++ parsers
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

        {{:"test.#{cli_name}", &test_with_parser(parser, &1)}, [cli_name | acc]}
      end)

    aliases
    |> Keyword.put(:test, &test_with_parser(cli_names, &1))
  end

  defp test_with_parser(parser_cli_names, args) when is_list(parser_cli_names) do
    Enum.each(parser_cli_names, fn cli_name ->
      Mix.shell().cmd("mix test.#{cli_name} --color #{Enum.join(args, " ")}",
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
        "lib",
        "src/*.xrl",
        "src/floki_mochi_html.erl",
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
