defmodule Floki.HTMLParser do
  @moduledoc false

  def parse(html) do
    parser = Application.get_env(:floki, :html_parser)
    parser.parse(html)
  end
end
