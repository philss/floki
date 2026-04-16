defmodule Floki.FlatText do
  @moduledoc false

  # FlatText is a strategy to get text nodes from a HTML tree without search deep
  # in the tree. It only gets the text nodes from the first level of nodes.

  # Example

  #   iex> Floki.FlatText.get([{"a", [], ["The meaning of life is...", {"strong", [], ["something else"]}] }])
  #   "The meaning of life is..."

  @type html_tree :: tuple | list

  @spec get(html_tree, binary, boolean) :: binary

  def get(html_nodes, sep_or_opts \\ "", include_inputs? \\ false)

  def get(html_nodes, opts, _) when is_list(opts) do
    sep = Keyword.get(opts, :sep, "")
    include_inputs? = Keyword.get(opts, :include_inputs, false)
    js? = Keyword.get(opts, :js, false)
    style? = Keyword.get(opts, :style, true)

    if is_list(html_nodes) do
      text_from_nodes(html_nodes, [], 0, sep, include_inputs?, js?, style?)
    else
      text_from_node(html_nodes, [], 0, sep, include_inputs?, js?, style?)
    end
    |> IO.iodata_to_binary()
  end

  def get(html_nodes, sep, include_inputs?) when is_list(html_nodes) do
    html_nodes
    |> text_from_nodes([], 0, sep, include_inputs?, true, true)
    |> IO.iodata_to_binary()
  end

  def get(html_node, sep, include_inputs?) do
    html_node
    |> text_from_node([], 0, sep, include_inputs?, true, true)
    |> IO.iodata_to_binary()
  end

  defp text_from_nodes([], acc, _, _, _, _, _), do: acc

  defp text_from_nodes([node | rest], acc, depth, sep, include_inputs?, js?, style?) do
    acc = text_from_node(node, acc, depth, sep, include_inputs?, js?, style?)
    text_from_nodes(rest, acc, depth, sep, include_inputs?, js?, style?)
  end

  defp text_from_node({"script", _, _}, acc, _, _, _, false, _), do: acc
  defp text_from_node({"style", _, _}, acc, _, _, _, _, false), do: acc

  defp text_from_node({"input", attrs, []}, acc, _, _, true, _, _) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp text_from_node({"textarea", attrs, []}, acc, _, _, true, _, _) do
    [acc, Floki.TextExtractor.extract_input_value(attrs)]
  end

  defp text_from_node({_tag, _attrs, html_nodes}, acc, depth, sep, include_inputs?, js?, style?)
       when depth < 1 do
    text_from_nodes(html_nodes, acc, depth + 1, sep, include_inputs?, js?, style?)
  end

  defp text_from_node(text, [], _, _sep, _, _, _) when is_binary(text), do: text
  defp text_from_node(text, acc, _, "", _, _, _) when is_binary(text), do: [acc, text]
  defp text_from_node(text, acc, _, sep, _, _, _) when is_binary(text), do: [acc, sep, text]
  defp text_from_node(_, acc, _, _, _, _, _), do: acc
end
