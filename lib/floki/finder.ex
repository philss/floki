defmodule Floki.Finder do
  @moduledoc """
  The finder engine traverse the HTML tree searching for nodes matching
  selectors.
  """

  alias Floki.Selector
  alias Floki.SelectorParser
  alias Floki.SelectorTokenizer

  @type html_tree :: tuple | list
  @type selector :: binary | %Selector{} | [%Selector{}]

  @doc """
  Find elements inside a HTML tree.

  Second argument can be either a selector string, a selector struct or an array of selector structs.
  """

  @spec find(html_tree, selector) :: html_tree

  def find(html_tree, selector_as_string) when is_binary(selector_as_string) do
    selectors = get_selectors(selector_as_string)
    find_selectors(html_tree, selectors)
  end
  def find(html_tree, selectors) when is_list(selectors) do
    find_selectors(html_tree, selectors)
  end
  def find(html_tree, %Selector{} = selector) do
    find_selectors(html_tree, [selector])
  end

  defp find_selectors(html_tree, selectors) do
    html_tree
    |> traverse([], selectors, [])
    |> Enum.reverse
  end

  defp get_selectors(selector_as_string) do
    selector_as_string
    |> String.split(",")
    |> Enum.map(fn(s) ->
      tokens = SelectorTokenizer.tokenize(s)

      SelectorParser.parse(tokens)
    end)
  end

  defp traverse(_, _, [], acc), do: acc
  defp traverse({}, _, _, acc), do: acc
  defp traverse([], _, _, acc), do: acc
  defp traverse(string, _, _, acc) when is_binary(string), do: acc
  defp traverse({:comment, _comment}, _, _, acc), do: acc
  defp traverse({:pi, _xml, _xml_attrs}, _, _, acc), do: acc
  defp traverse({:pi, _php_script}, _, _, acc), do: acc
  defp traverse([html_node|sibling_nodes], _, selectors, acc) do
    acc = traverse(html_node, sibling_nodes, selectors, acc)
    traverse(sibling_nodes, [], selectors, acc)
  end
  defp traverse(html_node, sibling_nodes, [head_selector|tail_selectors], acc) do
    acc = traverse(html_node, sibling_nodes, head_selector, acc)
    traverse(html_node, sibling_nodes, tail_selectors, acc)
  end
  defp traverse({_, _, children_nodes} = html_node, sibling_nodes, selector, acc) do
    acc =
      if Selector.match?(html_node, selector) do
        combinator = selector.combinator
        case combinator do
          nil -> [html_node|acc]
          _ ->
            case combinator.match_type do
              :descendant ->
                traverse(children_nodes, sibling_nodes, combinator.selector, acc)
              :child ->
                traverse_child(children_nodes, sibling_nodes, combinator.selector, acc)
              :sibling ->
                traverse_sibling(children_nodes, sibling_nodes, combinator.selector, acc)
              :general_sibling ->
                traverse_general_sibling(children_nodes, sibling_nodes, combinator.selector, acc)
              other ->
                raise "Combinator of type \"#{other}\" not implemented"
            end
        end
      else
        acc
      end

    traverse(children_nodes, sibling_nodes, selector, acc)
  end

  defp traverse_child(nodes, sibling_nodes, selector, acc) do
    Enum.reduce(nodes, acc, fn(n, res_acc) ->
      if Selector.match?(n, selector) do
        case selector.combinator do
          nil -> [n|res_acc]
          _ ->
            {_, _, children_nodes} = n
            traverse(children_nodes, sibling_nodes, selector.combinator.selector, res_acc)
        end
      else
        res_acc
      end
    end)
  end

  defp traverse_sibling(_nodes, sibling_nodes, selector, acc) do
    sibling_nodes = Enum.drop_while(sibling_nodes, &ignore_node?/1)

    sibling_node = case sibling_nodes do
                     [] -> nil
                     _  -> hd(sibling_nodes)
                   end

    if Selector.match?(sibling_node, selector) do
      case selector.combinator do
        nil -> [sibling_node|acc]
        _ ->
          {_, _, children_nodes} = sibling_node
          traverse(children_nodes, sibling_nodes, selector.combinator.selector, acc)
      end
    else
      acc
    end
  end

  defp traverse_general_sibling(_nodes, sibling_nodes, selector, acc) do
    sibling_nodes = Enum.drop_while(sibling_nodes, &ignore_node?/1)

    Enum.reduce(sibling_nodes, acc, fn(sibling_node, res_acc) ->
      if Selector.match?(sibling_node, selector) do
        case selector.combinator do
          nil -> [sibling_node|res_acc]
          _ ->
            {_, _, children_nodes} = sibling_node
            traverse(children_nodes, sibling_nodes, selector.combinator.selector, res_acc)
        end
      else
        res_acc
      end
    end)
  end

  defp ignore_node?({:comment, _}), do: true
  defp ignore_node?({:pi, _, _}), do: true
  defp ignore_node?({:pi, _}), do: true
  defp ignore_node?(_), do: false
end
