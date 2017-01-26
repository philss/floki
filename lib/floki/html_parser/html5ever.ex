defmodule Floki.HTMLParser.Html5ever do
  @moduledoc false
  @root_node "floki"

  def parse(html) do
    case Code.ensure_loaded(Html5ever) do
      {:module, module} ->
        case module.parse(html) do
          {:ok, result} -> result
          {:error, error} -> {:error, error}
        end
      {:error, _reason} ->
        raise "Expected module Html5ever to be available."
    end
  end
end
