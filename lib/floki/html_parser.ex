defmodule Floki.HTMLParser do
  @moduledoc """
  A entry point to dynamic dispatch functions to
  the configured HTML parser.

  The configuration can be done with the `:html_parser`
  option when calling the functions, or for the `:floki` application:

      Floki.parse_document(document, html_parser: Floki.HTMLParser.FastHtml)

  Or:

      use Mix.Config
      config :floki, :html_parser, Floki.HTMLParser.Mochiweb

  The default parser is Mochiweb, which comes with Floki.
  You can also choose between Html5ever or FastHtml.

  This module is also a behaviour that those parsers must implement.
  """

  @default_parser Floki.HTMLParser.Mochiweb

  @callback parse_document(binary(), list()) :: {:ok, Floki.html_tree()} | {:error, String.t()}
  @callback parse_fragment(binary(), list()) :: {:ok, Floki.html_tree()} | {:error, String.t()}

  def parse_document(html, opts \\ []) do
    parser_args = opts[:parser_args] || []

    parser(opts).parse_document(html, parser_args)
  end

  def parse_fragment(html, opts \\ []) do
    parser_args = opts[:parser_args] || []

    parser(opts).parse_fragment(html, parser_args)
  end

  defp parser(opts) do
    opts[:html_parser] || Application.get_env(:floki, :html_parser, @default_parser)
  end
end
