defmodule Floki.FlatText do
  @moduledoc """
  FlatText is a strategy to get text nodes from a HTML tree without search deep
  in the tree. It only gets the text nodes from the first level of nodes.
  """

  @type html_tree :: tuple | list

  @spec get(html_tree) :: binary

  @doc """
  Get text nodes from first level of HTML nodes.


  ## Examples

      iex> Floki.FlatText.get([{"a", [], ["The meaning of life is...", {"strong", [], ["something else"]}] }])
      "The meaning of life is..."

  """
  def get(html_nodes) when is_list(html_nodes) do
    Enum.reduce(html_nodes, "", fn(html_node, acc) ->
      text_from_node(html_node, acc)
    end)
  end
  def get(html_node) do
    text_from_node(html_node, "")
  end

  defp text_from_node({ _tag, _attrs, html_nodes}, acc) do
    Enum.reduce(html_nodes, acc, &capture_text/2)
  end
  defp text_from_node(text, acc) when is_binary(text), do: acc <> text
  defp text_from_node(_, acc), do: acc

  defp capture_text(text, acc) when is_binary(text), do: acc <> text
  defp capture_text(_html_node, acc), do: acc
end
