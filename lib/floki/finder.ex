defmodule Floki.Finder do
  @moduledoc false

  # The finder engine traverse the HTML tree searching for nodes matching
  # selectors.

  alias Floki.{HTMLTree, Selector}
  alias HTMLTree.HTMLNode
  alias Selector.PseudoClass
  import Floki, only: [is_html_node: 1]

  @spec find_by_id(Floki.html_tree() | Floki.html_node(), String.t()) :: Floki.html_node() | nil
  def find_by_id(html_tree_as_tuple, id) do
    html_tree_as_tuple = List.wrap(html_tree_as_tuple)
    traverse_find_by_id(html_tree_as_tuple, id)
  end

  defp traverse_find_by_id([{_type, _attributes, children} = html_tuple | rest], id) do
    if Selector.id_match?(html_tuple, id) do
      html_tuple
    else
      traverse_find_by_id(children, id) || traverse_find_by_id(rest, id)
    end
  end

  defp traverse_find_by_id([_ | rest], id) do
    traverse_find_by_id(rest, id)
  end

  defp traverse_find_by_id([], _id) do
    nil
  end

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
      [selector] = selectors
      html_tree_as_tuple = List.wrap(html_tree_as_tuple)
      results = traverse_html_tuples(html_tree_as_tuple, selector, [])
      Enum.reverse(results)
    else
      tree = HTMLTree.build(html_tree_as_tuple)
      results = find(tree, selectors)
      Enum.map(results, fn html_node -> HTMLTree.to_tuple(tree, html_node) end)
    end
  end

  def find(%HTMLTree{} = tree, selectors) when is_list(selectors) do
    Enum.flat_map(selectors, fn s -> traverse_html_tree(tree.node_ids, s, tree, []) end)
    |> Enum.sort_by(& &1.node_id)
    |> Enum.uniq()
  end

  # some selectors can be applied with the raw html tree tuples instead of
  # using an intermediate HTMLTree:
  # - single selector
  # - single child or adjacent sibling combinator, and as the last combinator
  # - no pseudo classes
  defp traverse_html_tuples?([%Selector{} = selector]), do: traverse_html_tuples?(selector)

  defp traverse_html_tuples?(%Selector{combinator: nil, pseudo_classes: pseudo_classes}),
    do: traverse_html_tuples?(pseudo_classes)

  defp traverse_html_tuples?(%Selector{combinator: combinator, pseudo_classes: pseudo_classes}),
    do: traverse_html_tuples?(pseudo_classes) and traverse_html_tuples?(combinator)

  defp traverse_html_tuples?(%Selector.Combinator{match_type: match_type, selector: selector})
       when match_type in [:descendant, :general_sibling],
       do: traverse_html_tuples?(selector)

  defp traverse_html_tuples?(%Selector.Combinator{
         match_type: match_type,
         selector: %Selector{combinator: nil} = selector
       })
       when match_type in [:child, :adjacent_sibling],
       do: traverse_html_tuples?(selector)

  defp traverse_html_tuples?([%PseudoClass{name: name} | rest])
       when name in ["checked", "disabled"],
       do: traverse_html_tuples?(rest)

  defp traverse_html_tuples?([%PseudoClass{name: "not", value: value} | rest]) do
    Enum.all?(value, &traverse_html_tuples?(&1)) and traverse_html_tuples?(rest)
  end

  defp traverse_html_tuples?([]), do: true
  defp traverse_html_tuples?(_), do: false

  defp traverse_html_tree([], _selector, _tree, acc), do: acc

  defp traverse_html_tree(
         [node_id | rest],
         %Selector{combinator: nil} = selector,
         tree,
         acc
       ) do
    html_node = get_node(node_id, tree)

    acc =
      if Selector.match?(html_node, selector, tree) do
        [html_node | acc]
      else
        acc
      end

    traverse_html_tree(rest, selector, tree, acc)
  end

  defp traverse_html_tree(
         [node_id | rest],
         %Selector{combinator: combinator} = selector,
         tree,
         acc
       ) do
    html_node = get_node(node_id, tree)

    acc =
      if Selector.match?(html_node, selector, tree) do
        nodes = get_selector_nodes(combinator, html_node, tree)
        traverse_html_tree(nodes, combinator.selector, tree, acc)
      else
        acc
      end

    traverse_html_tree(rest, selector, tree, acc)
  end

  # When a selector has a combinator with match type descendant or
  # general_sibling we are able to use the combinator selector directly it's
  # siblings or children for the traversal when there's a match.
  # For selectors with child and adjacent_sibling combinators we have to make
  # sure we don't propagate the selector to more elements than the combinator
  # specifies. For matches of these combinators we use the Selector.Combinator
  # term in the traversal to keep track of this information.
  defp traverse_html_tuples([], _selector, acc) do
    acc
  end

  defp traverse_html_tuples(
         [{_type, _attributes, children} = html_tuple | siblings],
         %Selector{combinator: nil} = selector,
         acc
       ) do
    acc =
      if Selector.match?(html_tuple, selector, nil) do
        [html_tuple | acc]
      else
        acc
      end

    acc = traverse_html_tuples(children, selector, acc)
    traverse_html_tuples(siblings, selector, acc)
  end

  defp traverse_html_tuples(
         [{_type, _attributes, children} = html_tuple | siblings],
         %Selector{
           combinator: %Selector.Combinator{
             match_type: :descendant,
             selector: combinator_selector
           }
         } = selector,
         acc
       ) do
    acc =
      if Selector.match?(html_tuple, selector, nil) do
        traverse_html_tuples(children, combinator_selector, acc)
      else
        traverse_html_tuples(children, selector, acc)
      end

    traverse_html_tuples(siblings, selector, acc)
  end

  defp traverse_html_tuples(
         [{_type, _attributes, children} = html_tuple | siblings],
         %Selector{
           combinator: %Selector.Combinator{match_type: :child} = combinator
         } = selector,
         acc
       ) do
    acc =
      if Selector.match?(html_tuple, selector, nil) do
        traverse_html_tuples(children, combinator, acc)
      else
        acc
      end

    acc = traverse_html_tuples(children, selector, acc)
    traverse_html_tuples(siblings, selector, acc)
  end

  defp traverse_html_tuples(
         [{_type, _attributes, children} = html_tuple | siblings],
         %Selector{
           combinator: %Selector.Combinator{match_type: :adjacent_sibling} = combinator
         } = selector,
         acc
       ) do
    acc =
      if Selector.match?(html_tuple, selector, nil) do
        traverse_html_tuples(siblings, combinator, acc)
      else
        acc
      end

    acc = traverse_html_tuples(children, selector, acc)
    traverse_html_tuples(siblings, selector, acc)
  end

  defp traverse_html_tuples(
         [{_type, _attributes, children} = html_tuple | siblings],
         %Selector{
           combinator: %Selector.Combinator{
             match_type: :general_sibling,
             selector: combinator_selector
           }
         } = selector,
         acc
       ) do
    acc = traverse_html_tuples(children, selector, acc)

    if Selector.match?(html_tuple, selector, nil) do
      traverse_html_tuples(siblings, combinator_selector, acc)
    else
      traverse_html_tuples(siblings, selector, acc)
    end
  end

  defp traverse_html_tuples(
         [{_type, _attributes, _children} = html_tuple | siblings],
         %Selector.Combinator{match_type: :child, selector: selector} = combinator,
         acc
       ) do
    acc =
      if Selector.match?(html_tuple, selector, nil) do
        [html_tuple | acc]
      else
        acc
      end

    traverse_html_tuples(siblings, combinator, acc)
  end

  defp traverse_html_tuples(
         [{_type, _attributes, _children} = html_tuple | _siblings],
         %Selector.Combinator{match_type: :adjacent_sibling, selector: selector},
         acc
       ) do
    # adjacent_sibling combinator targets only the first html_tag, so we don't
    # continue the traversal
    if Selector.match?(html_tuple, selector, nil) do
      [html_tuple | acc]
    else
      acc
    end
  end

  defp traverse_html_tuples(
         [_ | siblings],
         selector,
         acc
       ) do
    traverse_html_tuples(siblings, selector, acc)
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
