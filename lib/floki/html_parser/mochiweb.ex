defmodule Floki.HTMLParser.Mochiweb do
  @behaviour Floki.HTMLParser

  @moduledoc false
  @root_node "floki"

  @impl true
  def parse_document(html, _args) do
    html = "<#{@root_node}>#{html}</#{@root_node}>"
    {@root_node, [], parsed} = :floki_mochi_html.parse(html)

    {:ok, parsed}
  end

  # NOTE: mochi_html cannot make a distinction of a fragment and document.
  @impl true
  def parse_fragment(html, args), do: parse_document(html, args)
end
