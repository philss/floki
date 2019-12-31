defmodule Floki.HTMLParser.FastHtml do
  @moduledoc false

  def parse(html) do
    case Code.ensure_loaded(:fast_html) do
      {:module, module} ->
        case module.decode(html) do
          {:ok, result} -> result
          {:error, _message} = error -> error
        end

      {:error, _reason} ->
        raise "Expected module :fast_html to be available."
    end
  end
end
