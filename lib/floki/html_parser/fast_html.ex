defmodule Floki.HTMLParser.FastHtml do
  @behaviour Floki.HTMLParser
  @moduledoc false

  @impl true
  def parse_document(html, args) do
    execute_with_module(fn module -> module.decode(IO.chardata_to_string(html), args) end)
  end

  @impl true
  def parse_fragment(html, args) do
    execute_with_module(fn module ->
      module.decode_fragment(IO.chardata_to_string(html), args)
    end)
  end

  @impl true
  def parse_document_with_attributes_as_maps(_html, _args) do
    raise "parsing with attributes as maps is not supported yet for FastHTML"
  end

  @impl true
  def parse_fragment_with_attributes_as_maps(_html, _args) do
    raise "parsing with attributes as maps is not supported yet for FastHTML"
  end

  defp execute_with_module(fun) do
    case Code.ensure_loaded(:fast_html) do
      {:module, module} ->
        case fun.(module) do
          {:ok, result} ->
            {:ok, result}

          {:error, _message} = error ->
            error
        end

      {:error, _reason} ->
        raise "Expected module :fast_html to be available."
    end
  end
end
