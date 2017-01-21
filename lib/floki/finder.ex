defmodule Floki.Finder do
  require Logger

  @moduledoc false

  # The finder engine traverse the HTML tree searching for nodes matching
  # selectors.

  alias Floki.{Combinator, Selector, SelectorParser, SelectorTokenizer}
  alias Floki.HTMLTree
  alias Floki.HTMLTree.HTMLNode
  alias Floki.Selector.PseudoClass

  @type html_tree :: tuple | list
  @type selector :: binary | %Selector{} | [%Selector{}]

  # Find elements inside a HTML tree.
  # Second argument can be either a selector string, a selector struct or a list of selector structs.

  @spec find(html_tree, selector) :: html_tree

  def find([], _), do: {:empty_tree, []}
  def find(html_as_string, _) when is_binary(html_as_string), do: {:empty_tree, []}
  def find(html_tree, selector_as_string) when is_binary(selector_as_string) do
    selectors = get_selectors(selector_as_string)
    find_selectors(html_tree, selectors)
  end
  def find(html_tree, selectors) when is_list(selectors) do
    find_selectors(html_tree, selectors)
  end
  def find(html_tree, selector = %Selector{}) do
    find_selectors(html_tree, [selector])
  end

  # Not documented yet because it's an experimental API
  def apply_transformation({name, attrs, rest}, transformation) do
    {new_name, new_attrs} = transformation.({name, attrs})

    new_rest = Enum.map(rest, fn(html_tree) ->
      apply_transformation(html_tree, transformation)
    end)

    {new_name, new_attrs, new_rest}
  end
  def apply_transformation(other, _transformation), do: other

  defp find_selectors(html_tuple_or_list, selectors) do
    tree = HTMLTree.build(html_tuple_or_list)

    results =
      tree.node_ids
      |> Enum.reverse
      |> get_nodes(tree)
      |> Enum.flat_map(fn(html_node) -> get_matches_for_selectors(tree, html_node, selectors) end)
      |> Enum.uniq

    {tree, results}
  end

  defp get_selectors(selector_as_string) do
    selector_as_string
    |> String.split(",")
    |> Enum.map(fn(s) ->
      tokens = SelectorTokenizer.tokenize(s)

      SelectorParser.parse(tokens)
    end)
  end

  defp get_matches_for_selectors(tree, html_node, selectors) do
    selectors
    |> Enum.flat_map(fn(selector) -> get_matches(tree, html_node, selector) end)
  end

  defp get_matches(tree, html_node, selector = %Selector{combinator: nil}) do
    if selector_match?(tree, html_node, selector) do
      [html_node]
    else
      []
    end
  end
  defp get_matches(tree, html_node, selector = %Selector{combinator: combinator}) do
    if selector_match?(tree, html_node, selector) do
      traverse_with(combinator, tree, [html_node])
    else
      []
    end
  end

  defp selector_match?(_tree, html_node, selector = %Selector{pseudo_class: nil}) do
    Selector.match?(html_node, selector)
  end
  defp selector_match?(tree, html_node, selector) do
    Selector.match?(html_node, selector) && pseudo_class_match?(tree, html_node, selector)
  end

  defp pseudo_class_match?(tree, html_node, selector) do
    pseudo_class = selector.pseudo_class

    case pseudo_class.name do
      "nth-child" ->
        PseudoClass.match_nth_child?(tree, html_node, pseudo_class)
      "first-child" ->
        PseudoClass.match_nth_child?(tree, html_node, %PseudoClass{name: "nth-child", value: 1})
      unknown_pseudo_class ->
        Logger.warn("Pseudo-class #{inspect unknown_pseudo_class} is not implemented. Ignoring.")
        false
    end
  end

  # The stack serves as accumulator when there is another combinator to traverse.
  # So the scope of one combinator is the stack (or acc) or the parent one.
  defp traverse_with(_, _, []), do: []
  defp traverse_with(nil, _, result), do: result
  defp traverse_with(%Combinator{match_type: :child, selector: s}, tree, stack) do
    results =
      Enum.flat_map(stack, fn(html_node) ->
        nodes = html_node.children_nodes_ids
                |> Enum.reverse
                |> get_nodes(tree)

        Enum.filter(nodes, fn(html_node) -> Selector.match?(html_node, s) end)
      end)

    traverse_with(s.combinator, tree, results)
  end
  defp traverse_with(%Combinator{match_type: :sibling, selector: s}, tree, stack) do
    results =
      Enum.flat_map(stack, fn(html_node) ->
        # It treats sibling as list to easily ignores those that didn't match
        sibling_id = html_node
                     |> get_siblings(tree)
                     |> Enum.take(1)

        nodes = get_nodes(sibling_id, tree)

        # Finally, try to match those siblings with the selector
        Enum.filter(nodes, fn(html_node) -> Selector.match?(html_node, s) end)
      end)

    traverse_with(s.combinator, tree, results)
  end
  defp traverse_with(%Combinator{match_type: :general_sibling, selector: s}, tree, stack) do
    results =
      Enum.flat_map(stack, fn(html_node) ->
        sibling_ids = get_siblings(html_node, tree)

        nodes = get_nodes(sibling_ids, tree)

        # Finally, try to match those siblings with the selector
        Enum.filter(nodes, fn(html_node) -> Selector.match?(html_node, s) end)
      end)

    traverse_with(s.combinator, tree, results)
  end
  defp traverse_with(%Combinator{match_type: :descendant, selector: s}, tree, stack) do
    results =
      Enum.flat_map(stack, fn(html_node) ->
        ids_to_match = get_descendant_ids(html_node.node_id, tree)
        nodes = ids_to_match
                |> get_nodes(tree)

        Enum.filter(nodes, fn(html_node) -> Selector.match?(html_node, s) end)
      end)

    traverse_with(s.combinator, tree, results)
  end

  defp get_nodes(ids, tree) do
    Enum.map(ids, fn(id) -> Map.get(tree.nodes, id) end)
  end

  defp get_node(id, tree) do
    Map.get(tree.nodes, id)
  end

  defp get_sibling_ids_from([], _html_node), do: []
  defp get_sibling_ids_from(ids, html_node) do
    ids
    |> Enum.reverse
    |> Enum.drop_while(fn(id) -> id != html_node.node_id end)
    |> tl()
  end
  defp get_siblings(html_node, tree) do
    parent = get_node(html_node.parent_node_id, tree)

    ids = if parent do
            get_sibling_ids_from(parent.children_nodes_ids, html_node)
          else
            get_sibling_ids_from(tree.root_nodes_ids, html_node)
          end

    Enum.filter(ids, fn(id) ->
      case get_node(id, tree) do
        %HTMLNode{} -> true
        _ -> false
      end
    end)
  end

  # finds all descendant node ids recursively through the tree
  defp get_descendant_ids(node_id, tree) do
    case get_node(node_id, tree) do
      %{children_nodes_ids: node_ids} ->
        Enum.reverse(node_ids) ++ Enum.flat_map(node_ids, &( get_descendant_ids(&1, tree) ))
      _ ->
        []
    end
  end
end
