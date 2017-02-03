defmodule Floki.HTMLParser do
  @moduledoc false
  @default_parser Floki.HTMLParser.Mochiweb

  def parse(html) do
    parser = Application.get_env(:floki, :html_parser, @default_parser)
    parser.parse(html)
  end
end
