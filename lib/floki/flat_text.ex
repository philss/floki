defmodule Floki.FlatText do
  @moduledoc false

  # FlatText is a strategy to get text nodes from a HTML tree without search deep
  # in the tree. It only gets the text nodes from the first level of nodes.

  # Example

  #   iex> Floki.FlatText.get([{"a", [], ["The meaning of life is...", {"strong", [], ["something else"]}] }])
  #   "The meaning of life is..."

  @type html_tree :: tuple | list

  @spec get(html_tree, binary, boolean) :: binary

  def get(html_nodes, sep \\ "", include_inputs? \\ false)

  def get(html_nodes, sep, include_inputs?) when is_list(html_nodes) do
    html_nodes
    |> Enum.reduce([], fn html_node, acc ->
      text_from_node(html_node, acc, 0, sep, include_inputs?)
    end)
    |> IO.iodata_to_binary()
  end

  def get(html_node, sep, include_inputs?) do
    html_node
    |> text_from_node([], 0, sep, include_inputs?)
    |> IO.iodata_to_binary()
  end

  defp text_from_node({"input", attrs, []}, acc, _, _, true) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp text_from_node({"textarea", attrs, []}, acc, _, _, true) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp text_from_node({_tag, _attrs, html_nodes}, acc, depth, sep, include_inputs?)
       when depth < 1 do
    Enum.reduce(html_nodes, acc, fn html_node, acc ->
      text_from_node(html_node, acc, depth + 1, sep, include_inputs?)
    end)
  end

  defp text_from_node(text, [], _, _sep, _) when is_binary(text), do: text
  defp text_from_node(text, acc, _, sep, _) when is_binary(text), do: [acc, sep, text]
  defp text_from_node(_, acc, _, _, _), do: acc
end
