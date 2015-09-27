defmodule Floki.Finder do
  @moduledoc """
  The finder engine transverse the HTML tree searching for nodes matching
  selectors.
  """

  alias Floki.Selector
  alias Floki.SelectorParser
  alias Floki.SelectorTokenizer

  @type html_tree :: tuple | list

  @doc """
  Find elements inside a HTML tree.
  """

  @spec find(html_tree, binary) :: html_tree

  def find(html_tree, selector_as_string) do
    selectors = get_selectors(selector_as_string)

    html_tree
    |> transverse([], selectors, [])
    |> Enum.reverse
  end

  defp get_selectors(selector_as_string) do
    Enum.map String.split(selector_as_string, ","), fn(s) ->
      SelectorTokenizer.tokenize(s) |> SelectorParser.parse
    end
  end

  defp transverse(_, _, [], acc), do: acc
  defp transverse({}, _, _, acc), do: acc
  defp transverse([], _, _, acc), do: acc
  defp transverse(string, _, _, acc) when is_binary(string), do: acc
  defp transverse({:comment, _comment},_, _, acc), do: acc
  defp transverse({:pi, _xml, _xml_attrs},_, _, acc), do: acc
  defp transverse([node|sibling_nodes], _, selectors, acc) do
    acc = transverse(node, sibling_nodes, selectors, acc)
    transverse(sibling_nodes, [], selectors, acc)
  end
  defp transverse(node, sibling_nodes, [head_selector|tail_selectors], acc) do
    acc = transverse(node, sibling_nodes, head_selector, acc)
    transverse(node, sibling_nodes, tail_selectors, acc)
  end
  defp transverse({_, _, children_nodes} = node, sibling_nodes, selector, acc) do
    acc =
      if Selector.match?(node, selector) do
        combinator = selector.combinator
        case combinator do
          nil -> [node|acc]
          _ ->
            case combinator.match_type do
              :descendant ->
                transverse(children_nodes, sibling_nodes, combinator.selector, acc)
              :child ->
                transverse_child(children_nodes, sibling_nodes, combinator.selector, acc)
              :sibling ->
                transverse_sibling(children_nodes, sibling_nodes, combinator.selector, acc)
              other ->
                raise "Combinator of type \"#{other}\" not implemented"
            end
        end
      else
        acc
      end

    transverse(children_nodes, sibling_nodes, selector, acc)
  end

  defp transverse_child(nodes, sibling_nodes, selector, acc) do
    Enum.reduce(nodes, acc, fn(n, res_acc) ->
      if Selector.match?(n, selector) do
        case selector.combinator do
          nil -> [n|res_acc]
          _ ->
            {_, _, children_nodes} = n
            transverse(children_nodes, sibling_nodes, selector.combinator.selector, res_acc)
        end
      else
        res_acc
      end
    end)
  end

  defp transverse_sibling(_nodes, sibling_nodes, selector, acc) do
    droper_fn = fn
      {:comment, _} -> true
      {:pi, _, _} -> true
      _ -> false
    end

    sibling_node = Enum.drop_while(sibling_nodes, droper_fn) |> hd

    if Selector.match?(sibling_node, selector) do
      case selector.combinator do
        nil -> [sibling_node|acc]
        _ ->
          {_, _, children_nodes} = sibling_node
          transverse(children_nodes, sibling_nodes, selector.combinator.selector, acc)
      end
    else
      acc
    end
  end
end
