defmodule Floki.HTMLParser.Mochiweb do
  @moduledoc false
  @root_node "floki"

  def parse(html) do
    html = "<#{@root_node}>#{html}</#{@root_node}>"
    {@root_node, [], parsed} = :mochiweb_html.parse(html)

    if length(parsed) == 1, do: hd(parsed), else: parsed
  end
end
