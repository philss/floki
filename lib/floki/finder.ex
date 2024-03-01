defmodule Floki.Finder do
  @moduledoc false

  # The finder engine traverse the HTML tree searching for nodes matching
  # selectors.

  alias Floki.{HTMLTree, Selector}
  alias HTMLTree.HTMLNode
  import Floki, only: [is_html_node: 1]

  # Find elements inside a HTML tree.
  # Second argument can be either a selector string, a selector struct or a list of selector structs.

  @spec find(HTMLTree.t(), Floki.css_selector()) :: [HTMLTree.HTMLNode.t()]
  @spec find(Floki.html_tree() | Floki.html_node(), Floki.css_selector()) :: [Floki.html_node()]

  def find([], _), do: []
  def find(html_as_string, _) when is_binary(html_as_string), do: []

  def find(html_tree, selector_as_string) when is_binary(selector_as_string) do
    selectors = Selector.Parser.parse(selector_as_string)
    find(html_tree, selectors)
  end

  def find(html_tree, selector = %Selector{}) do
    find(html_tree, [selector])
  end

  def find(html_tree_as_tuple, selectors)
      when (is_list(html_tree_as_tuple) or is_html_node(html_tree_as_tuple)) and
             is_list(selectors) do
    if traverse_html_tuples?(selectors) do
      html_tree_as_tuple = List.wrap(html_tree_as_tuple)
      stack = Enum.map(selectors, fn s -> {s, html_tree_as_tuple} end)

      results = traverse_html_tuples(stack, [])
      Enum.reverse(results)
    else
      tree = HTMLTree.build(html_tree_as_tuple)
      results = find(tree, selectors)
      Enum.map(results, fn html_node -> HTMLTree.to_tuple(tree, html_node) end)
    end
  end

  def find(%HTMLTree{} = tree, selectors) when is_list(selectors) do
    node_ids = Enum.reverse(tree.node_ids)
    stack = Enum.map(selectors, fn s -> {s, node_ids} end)

    traverse_html_tree(stack, tree, [])
    |> Enum.sort_by(& &1.node_id)
    |> Enum.uniq()
  end

  # some selectors can be applied with the raw html tree tuples instead of
  # using an intermediate HTMLTree:
  # - single selector
  # - single child or adjacent sibling combinator, and as the last combinator
  # - no pseudo classes
  defp traverse_html_tuples?([selector]), do: traverse_html_tuples?(selector)
  defp traverse_html_tuples?(selectors) when is_list(selectors), do: false
  defp traverse_html_tuples?(%Selector{pseudo_classes: [_ | _]}), do: false
  defp traverse_html_tuples?(%Selector{combinator: nil}), do: true

  defp traverse_html_tuples?(%Selector{combinator: combinator}),
    do: traverse_html_tuples?(combinator)

  defp traverse_html_tuples?(%Selector.Combinator{match_type: match_type, selector: selector})
       when match_type in [:descendant, :general_sibling],
       do: traverse_html_tuples?(selector)

  defp traverse_html_tuples?(%Selector.Combinator{
         match_type: match_type,
         selector: %Selector{combinator: nil} = selector
       })
       when match_type in [:child, :adjacent_sibling],
       do: traverse_html_tuples?(selector)

  defp traverse_html_tuples?(_), do: false

  # The stack serves as accumulator when there is another combinator to traverse.
  # So the scope of one combinator is the stack (or acc) or the parent one.
  defp traverse_html_tree(
         [{%Selector{combinator: nil} = selector, [node_id | selector_rest]} | stack],
         tree,
         acc
       ) do
    stack = [{selector, selector_rest} | stack]
    html_node = get_node(node_id, tree)

    acc =
      if Selector.match?(html_node, selector, tree) do
        [html_node | acc]
      else
        acc
      end

    traverse_html_tree(stack, tree, acc)
  end

  defp traverse_html_tree(
         [{%Selector{combinator: combinator} = selector, [node_id | selector_rest]} | stack],
         tree,
         acc
       ) do
    stack = [{selector, selector_rest} | stack]
    html_node = get_node(node_id, tree)

    stack =
      if Selector.match?(html_node, selector, tree) do
        nodes = get_selector_nodes(combinator, html_node, tree)
        [{combinator.selector, nodes} | stack]
      else
        stack
      end

    traverse_html_tree(stack, tree, acc)
  end

  defp traverse_html_tree([{_selector, []} | rest], tree, acc) do
    traverse_html_tree(rest, tree, acc)
  end

  defp traverse_html_tree([], _, acc) do
    acc
  end

  # `stack` is a list of tuples composed of a Selector or Selector.Combinator
  # and html_node tuple.
  # When a selector has a combinator with match type descendant or
  # general_sibling we are able to use the combinator selector directly to add
  # it's siblings or children to the stack when there's a match.
  # For selectors with child and adjacent_sibling combinators we have to make
  # sure we don't propagate the selector to more elements than the combinator
  # specifies. For matches of these combinators we put the Selector.Combinator
  # term to the stack to keep track of this information.
  defp traverse_html_tuples(
         [
           {
             %Selector{combinator: nil} = selector,
             [{_type, _attributes, children} = html_tuple | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack = [{selector, children}, {selector, siblings} | stack]

    acc =
      if Selector.match?(html_tuple, selector, nil) do
        [html_tuple | acc]
      else
        acc
      end

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             %Selector{
               combinator: %Selector.Combinator{
                 match_type: :descendant,
                 selector: combinator_selector
               }
             } = selector,
             [{_type, _attributes, children} = html_tuple | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack = [{selector, siblings} | stack]

    stack =
      if Selector.match?(html_tuple, selector, nil) do
        [{combinator_selector, children} | stack]
      else
        [{selector, children} | stack]
      end

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             %Selector{
               combinator: %Selector.Combinator{match_type: :child} = combinator
             } = selector,
             [{_type, _attributes, children} = html_tuple | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack = [{selector, children}, {selector, siblings} | stack]

    stack =
      if Selector.match?(html_tuple, selector, nil) do
        [{combinator, children} | stack]
      else
        stack
      end

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             %Selector{
               combinator: %Selector.Combinator{match_type: :adjacent_sibling} = combinator
             } = selector,
             [{_type, _attributes, children} = html_tuple | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack =
      if Selector.match?(html_tuple, selector, nil) do
        [{combinator, siblings} | stack]
      else
        stack
      end

    stack = [{selector, children}, {selector, siblings} | stack]

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             %Selector{
               combinator: %Selector.Combinator{
                 match_type: :general_sibling,
                 selector: combinator_selector
               }
             } = selector,
             [{_type, _attributes, children} = html_tuple | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack =
      if Selector.match?(html_tuple, selector, nil) do
        [{combinator_selector, siblings} | stack]
      else
        [{selector, siblings} | stack]
      end

    stack = [{selector, children} | stack]

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             %Selector.Combinator{match_type: :child, selector: selector} = combinator,
             [{_type, _attributes, _children} = html_tuple | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack = [{combinator, siblings} | stack]

    acc =
      if Selector.match?(html_tuple, selector, nil) do
        [html_tuple | acc]
      else
        acc
      end

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             %Selector.Combinator{match_type: :adjacent_sibling, selector: selector},
             [{_type, _attributes, _children} = html_tuple | _siblings]
           }
           | stack
         ],
         acc
       ) do
    # adjacent_sibling combinator targets only the first html_tag, so we don't
    # add the siblings back to the stack
    acc =
      if Selector.match?(html_tuple, selector, nil) do
        [html_tuple | acc]
      else
        acc
      end

    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples(
         [
           {
             selector,
             [_ | siblings]
           }
           | stack
         ],
         acc
       ) do
    stack = [{selector, siblings} | stack]
    traverse_html_tuples(stack, acc)
  end

  defp traverse_html_tuples([{_selector, []} | rest], acc) do
    traverse_html_tuples(rest, acc)
  end

  defp traverse_html_tuples([], acc) do
    acc
  end

  defp get_selector_nodes(%Selector.Combinator{match_type: :child}, html_node, _tree) do
    Enum.reverse(html_node.children_nodes_ids)
  end

  defp get_selector_nodes(%Selector.Combinator{match_type: :adjacent_sibling}, html_node, tree) do
    case get_siblings(html_node, tree) do
      [sibling_id | _] -> [sibling_id]
      _ -> []
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
