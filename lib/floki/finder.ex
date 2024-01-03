defmodule Floki.Finder do
  @moduledoc false

  # The finder engine traverse the HTML tree searching for nodes matching
  # selectors.

  alias Floki.{HTMLTree, Selector}
  alias HTMLTree.HTMLNode

  # Find elements inside a HTML tree.
  # Second argument can be either a selector string, a selector struct or a list of selector structs.

  @spec find(Floki.html_tree(), Floki.css_selector()) :: {HTMLTree.t(), [HTMLTree.HTMLNode.t()]}

  def find([], _), do: {%HTMLTree{}, []}
  def find(html_as_string, _) when is_binary(html_as_string), do: {%HTMLTree{}, []}

  def find(html_tree, selector_as_string) when is_binary(selector_as_string) do
    selectors = Selector.Parser.parse(selector_as_string)
    find(html_tree, selectors)
  end

  def find(html_tree, selector = %Selector{}) do
    find(html_tree, [selector])
  end

  def find(html_tree, selectors) when is_list(selectors) do
    tree = HTMLTree.build(html_tree)

    node_ids = Enum.reverse(tree.node_ids)
    stack = Enum.map(selectors, fn s -> {s, node_ids} end)

    results =
      traverse_with(:cont, tree, [], stack)
      |> Enum.reverse()
      |> Enum.uniq()

    {tree, results}
  end

  # The stack serves as accumulator when there is another combinator to traverse.
  # So the scope of one combinator is the stack (or acc) or the parent one.
  defp traverse_with(:cont, _, acc, []) do
    acc
  end

  defp traverse_with(:cont, tree, acc, [next | rest]) do
    traverse_with(next, tree, acc, rest)
  end

  defp traverse_with({selector, [node_id]}, tree, acc, stack) do
    traverse_with({selector, node_id}, tree, acc, stack)
  end

  defp traverse_with({selector, [next | rest]}, tree, acc, stack) do
    stack = [{selector, rest} | stack]
    traverse_with({selector, next}, tree, acc, stack)
  end

  defp traverse_with({%Selector{combinator: nil} = selector, node_id}, tree, acc, stack) do
    html_node = get_node(node_id, tree)

    acc =
      if Selector.match?(html_node, selector, tree) do
        [html_node | acc]
      else
        acc
      end

    traverse_with(:cont, tree, acc, stack)
  end

  defp traverse_with({%Selector{combinator: combinator} = selector, node_id}, tree, acc, stack) do
    html_node = get_node(node_id, tree)

    stack =
      if Selector.match?(html_node, selector, tree) do
        nodes = get_selector_nodes(combinator, html_node, tree)
        [{combinator.selector, nodes} | stack]
      else
        stack
      end

    traverse_with(:cont, tree, acc, stack)
  end

  defp get_selector_nodes(%Selector.Combinator{match_type: :child}, html_node, _tree) do
    Enum.reverse(html_node.children_nodes_ids)
  end

  defp get_selector_nodes(%Selector.Combinator{match_type: :sibling}, html_node, tree) do
    case get_siblings(html_node, tree) do
      [sibling_id | _] -> sibling_id
      _ -> nil
    end
  end

  defp get_selector_nodes(%Selector.Combinator{match_type: :general_sibling}, html_node, tree) do
    get_siblings(html_node, tree)
  end

  defp get_selector_nodes(%Selector.Combinator{match_type: :descendant}, html_node, tree) do
    get_descendant_ids(html_node.node_id, tree)
  end

  defp get_node(id, tree) do
    Map.get(tree.nodes, id)
  end

  defp get_sibling_ids_from([], _html_node), do: []

  defp get_sibling_ids_from(ids, html_node) do
    ids
    |> Enum.reverse()
    |> Enum.drop_while(fn id -> id != html_node.node_id end)
    |> tl()
  end

  defp get_siblings(html_node, tree) do
    parent = get_node(html_node.parent_node_id, tree)

    ids =
      if parent do
        get_sibling_ids_from(parent.children_nodes_ids, html_node)
      else
        get_sibling_ids_from(Enum.reverse(tree.root_nodes_ids), html_node)
      end

    Enum.filter(ids, fn id ->
      case get_node(id, tree) do
        %HTMLNode{} -> true
        _ -> false
      end
    end)
  end

  # finds all descendant node ids recursively through the tree preserving the order
  defp get_descendant_ids(node_id, tree) do
    case get_node(node_id, tree) do
      %{children_nodes_ids: node_ids} ->
        reversed_ids = Enum.reverse(node_ids)
        reversed_ids ++ Enum.flat_map(reversed_ids, &get_descendant_ids(&1, tree))

      _ ->
        []
    end
  end

  @spec map(Floki.html_tree() | Floki.html_node(), function()) ::
          Floki.html_tree() | Floki.html_node()

  def map({name, attrs, rest}, fun) do
    {new_name, new_attrs} = fun.({name, attrs})

    {new_name, new_attrs, Enum.map(rest, &map(&1, fun))}
  end

  def map(other, _fun), do: other
end
