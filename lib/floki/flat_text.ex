defmodule Floki.FlatText do
  @moduledoc """
  FlatText is a strategy to get text nodes from a HTML tree without search deep
  in the tree. It only gets the text nodes from the first level of nodes.
  """

  @type html_tree :: tuple | list

  @spec get(html_tree, binary) :: binary

  @doc """
  Get text nodes from first level of HTML nodes.


  ## Examples

      iex> Floki.FlatText.get([{"a", [], ["The meaning of life is...", {"strong", [], ["something else"]}] }])
      "The meaning of life is..."

      iex> Floki.FlatText.get([{"a", [], ["The meaning of life is...", {"strong", [], ["something else"]}] }], " ")
      "The meaning of life is..."

  """
  def get(html_nodes, sep \\ "")
  def get(html_nodes, sep) when is_list(html_nodes) do
    Enum.reduce(html_nodes, "", fn(html_node, acc) ->
      text_from_node(html_node, acc, sep)
    end)
  end
  def get(html_node, sep) do
    text_from_node(html_node, "", sep)
  end

  defp text_from_node({ _tag, _attrs, html_nodes}, acc, sep) do
    Enum.reduce(html_nodes, acc, fn(node, acc) ->
      capture_text(node, acc, sep)
    end)
  end
  defp text_from_node(text, "", _sep) when is_binary(text), do: text
  defp text_from_node(text, acc, sep) when is_binary(text), do: Enum.join([acc, text], sep)
  defp text_from_node(_, acc, _), do: acc

  defp capture_text(text, "", _sep) when is_binary(text), do: text
  defp capture_text(text, acc, sep) when is_binary(text), do: Enum.join([acc, text], sep)
  defp capture_text(_html_node, acc, _), do: acc
end
