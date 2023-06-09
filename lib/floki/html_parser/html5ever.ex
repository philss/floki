defmodule Floki.HTMLParser.Html5ever do
  @behaviour Floki.HTMLParser

  @moduledoc false

  @impl true
  def parse_document(html, _args) do
    case Code.ensure_loaded(Html5ever) do
      {:module, module} ->
        case module.parse(html) do
          {:ok, result} ->
            {:ok, result}

          {:error, _message} = error ->
            error
        end

      {:error, _reason} ->
        raise "Expected module Html5ever to be available."
    end
  end

  # NOTE: html5ever does not implement parse_fragment yet.
  @impl true
  def parse_fragment(html, args), do: parse_document(html, args)

  @impl true
  def parse_document_with_attributes_as_maps(_html, _args) do
    raise "parsing with attributes as maps is not supported yet for Html5ever"
  end

  @impl true
  def parse_fragment_with_attributes_as_maps(_html, _args) do
    raise "parsing with attributes as maps is not supported yet for Html5ever"
  end
end
