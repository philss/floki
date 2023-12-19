defmodule Floki.HTMLParser.Html5ever do
  @behaviour Floki.HTMLParser

  @moduledoc false

  @impl true
  def parse_document(html, _args) when is_binary(html) do
    case Code.ensure_loaded(Html5ever) do
      {:module, module} ->
        case apply(module, :parse, [html]) do
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
  def parse_fragment(html, args) when is_binary(html), do: parse_document(html, args)

  @impl true
  def parse_document_with_attributes_as_maps(html, _args) when is_binary(html) do
    apply(ensure_module!(), :parse_with_attributes_as_maps, [html])
  end

  @impl true
  def parse_fragment_with_attributes_as_maps(html, _args) when is_binary(html) do
    apply(ensure_module!(), :parse_with_attributes_as_maps, [html])
  end

  defp ensure_module!() do
    case Code.ensure_loaded(Html5ever) do
      {:module, module} ->
        module

      {:error, _reason} ->
        raise "Expected module Html5ever to be available."
    end
  end
end
