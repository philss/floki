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

  And it's possible to pass down options to the parsers using
  the `parser_args` option.

  This module is also a behaviour that those parsers must implement.
  """

  @default_parser Floki.HTMLParser.Mochiweb

  @typep result(success) :: {:ok, success} | {:error, String.t()}
  @typep html :: binary() | iodata()

  @callback parse_document(html(), Keyword.t()) :: result(Floki.html_tree())
  @callback parse_fragment(html(), Keyword.t()) :: result(Floki.html_tree())

  @callback parse_document_with_attributes_as_maps(html(), Keyword.t()) ::
              result(Floki.html_tree())
  @callback parse_fragment_with_attributes_as_maps(html(), Keyword.t()) ::
              result(Floki.html_tree())

  def parse_document(html, opts \\ []) do
    opts =
      Keyword.validate!(opts, attributes_as_maps: false, html_parser: parser(), parser_args: [])

    parser_args = opts[:parser_args]

    parser = opts[:html_parser]

    if opts[:attributes_as_maps] do
      parser.parse_document_with_attributes_as_maps(html, parser_args)
    else
      parser.parse_document(html, parser_args)
    end
  end

  def parse_fragment(html, opts \\ []) do
    opts =
      Keyword.validate!(opts, attributes_as_maps: false, html_parser: parser(), parser_args: [])

    parser_args = opts[:parser_args]

    parser = opts[:html_parser]

    if opts[:attributes_as_maps] do
      parser.parse_fragment_with_attributes_as_maps(html, parser_args)
    else
      parser.parse_fragment(html, parser_args)
    end
  end

  defp parser do
    Application.get_env(:floki, :html_parser, @default_parser)
  end
end
