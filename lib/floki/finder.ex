defmodule Floki.Finder do
  @moduledoc false

  alias Floki.Selector
  alias Floki.SelectorParser
  alias Floki.SelectorTokenizer

  def find(html_tree, selector) do
    selectors = Enum.map String.split(selector, ","), fn(s) ->
      SelectorTokenizer.tokenize(s)
      |> SelectorParser.parse
    end

    html_tree
    |> transverse(selectors, [])
    |> Enum.reverse
  end

  defp transverse(_, [], acc), do: acc
  defp transverse({}, _, acc), do: acc
  defp transverse([], _, acc), do: acc
  defp transverse(string, _, acc) when is_binary(string), do: acc
  defp transverse({:comment, _comment}, _, acc), do: acc
  defp transverse({:pi, _xml, _xml_attrs}, _, acc), do: acc
  defp transverse([head_node|tail_nodes], selectors, acc) do
    acc = transverse(head_node, selectors, acc)
    transverse(tail_nodes, selectors, acc)
  end
  defp transverse(node, [head_selector|tail_selectors], acc) do
    acc = transverse(node, head_selector, acc)
    transverse(node, tail_selectors, acc)
  end
  defp transverse({_, _, children_nodes} = node, selector = %Selector{combinator: nil}, acc) do
    acc =
      case Selector.match?(node, selector) do
        true ->
          [node|acc]
        false ->
          acc
      end

    transverse(children_nodes, selector, acc)
  end
  defp transverse({_, _, children_nodes} = node, selector = %Selector{combinator: combinator}, acc) do
    acc =
      case Selector.match?(node, selector) do
        true ->
          case combinator.match_type do
            :descendant ->
              transverse(children_nodes, combinator.selector, acc)
            other ->
              raise "Combinator of type \"#{other}\" not implemented yet"
          end
        false ->
          acc
      end

    transverse(children_nodes, selector, acc)
  end
end
