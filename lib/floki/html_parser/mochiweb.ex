defmodule Floki.HTMLParser.Mochiweb do
  @moduledoc """
  The default HTML parser engine for Floki.

  This parser is historically not compliant to the HTML5 specs, but will
  parse faster and in most of the cases it will produce a valid HTML tree.

  For alternative, please check the `README.md` file.
  """

  @behaviour Floki.HTMLParser
  @root_node "floki"

  @impl true
  def parse_document(html, args) do
    html = ["<#{@root_node}>", html, "</#{@root_node}>"]
    {@root_node, _, parsed} = :floki_mochi_html.parse(html, args)

    {:ok, parsed}
  end

  # NOTE: mochi_html cannot make a distinction of a fragment and document.
  @impl true
  def parse_fragment(html, args), do: parse_document(html, args)

  @impl true
  def parse_document_with_attributes_as_maps(html, args) do
    parse_document(html, Keyword.put(args, :attributes_as_maps, true))
  end

  @impl true
  def parse_fragment_with_attributes_as_maps(html, args) do
    parse_document(html, Keyword.put(args, :attributes_as_maps, true))
  end
end
