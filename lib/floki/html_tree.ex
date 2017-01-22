defmodule Floki.HTMLTree do
  @moduledoc false

  # Builds a `Map` representing a HTML tree based on tuples or list of tuples.
  #
  # It is useful because keeps references for each node, and the possibility to
  # update the tree.

  defstruct nodes: %{}, root_nodes_ids: [], node_ids: []

  alias Floki.HTMLTree
  alias Floki.HTMLTree.{HTMLNode, Text, Comment, IDSeeder}

  def build({tag, attrs, children}) do
    root_id = IDSeeder.seed([])

    %HTMLTree{root_nodes_ids: [root_id],
              node_ids: [root_id],
              nodes: %{root_id => %HTMLNode{type: tag, attributes: attrs, node_id: root_id}}}
    |> build_tree(children, root_id, [])
  end

  def build(html_tuples) when is_list(html_tuples) do
    reducer = fn
      ({tag, attrs, children}, tree) ->
        root_id = IDSeeder.seed(tree.node_ids)

        root_node = %HTMLNode{type: tag, attributes: attrs, node_id: root_id}

        %{tree | nodes: Map.put(tree.nodes, root_id, root_node),
                 node_ids: [root_id | tree.node_ids],
                 root_nodes_ids: tree.root_nodes_ids ++ [root_id]}
        |> build_tree(children, root_id, [])
      (_, tree) ->
        tree
    end

    Enum.reduce(html_tuples, %HTMLTree{}, reducer)
  end

  def delete_node(tree, html_node) do
    do_delete(tree, [html_node], [])
  end

  def to_tuple(_tree, %Text{content: text}), do: text
  def to_tuple(_tree, %Comment{content: comment}), do: {:comment, comment}
  def to_tuple(tree, html_node) do
    children = html_node.children_nodes_ids
               |> Enum.reverse
               |> Enum.map(fn(id) -> to_tuple(tree, Map.get(tree.nodes, id)) end)

    {html_node.type, html_node.attributes, children}
  end

  defp do_delete(tree, [], []), do: tree
  defp do_delete(tree, [html_node | t], stack_ids) do
    new_tree_nodes = delete_node_from_nodes(tree.nodes, html_node)

    ids_for_stack = get_ids_for_delete_stack(html_node)

    do_delete(%{tree | nodes: new_tree_nodes,
                       node_ids: List.delete(tree.node_ids, html_node.node_id),
                       root_nodes_ids: List.delete(tree.root_nodes_ids, html_node.node_id)},
              t, ids_for_stack ++ stack_ids)
  end
  defp do_delete(tree, [], stack_ids) do
    html_nodes = tree.nodes
                 |> Map.take(stack_ids)
                 |> Map.values

    do_delete(tree, html_nodes, [])
  end

  defp delete_node_from_nodes(nodes, html_node) do
    tree_nodes = Map.delete(nodes, html_node.node_id)
    parent_node = Map.get(nodes, html_node.parent_node_id)

    if parent_node do
      children_ids = List.delete(parent_node.children_nodes_ids, html_node.node_id)
      new_parent = %{parent_node | children_nodes_ids: children_ids}
      %{tree_nodes | new_parent.node_id => new_parent}
    else
      tree_nodes
    end
  end

  defp get_ids_for_delete_stack(%HTMLNode{children_nodes_ids: ids}), do: ids
  defp get_ids_for_delete_stack(_), do: []

  defp build_tree(tree, [], _, []), do: tree
  defp build_tree(tree, [{tag, attrs, child_children} | children], parent_id, stack) do
    new_id = IDSeeder.seed(tree.node_ids)
    new_node = %HTMLNode{type: tag,
                         attributes: attrs,
                         node_id: new_id,
                         parent_node_id: parent_id}

    nodes = put_new_node(tree.nodes, new_node)

    %{tree | nodes: nodes, node_ids: [new_id | tree.node_ids]}
    |> build_tree(child_children, new_id, [{parent_id, children} | stack])
  end
  defp build_tree(tree, [{:comment, comment} | children], parent_id, stack) do
    new_id = IDSeeder.seed(tree.node_ids)
    new_node = %Comment{content: comment, node_id: new_id, parent_node_id: parent_id}

    nodes = put_new_node(tree.nodes, new_node)

    %{tree | nodes: nodes, node_ids: [new_id | tree.node_ids]}
    |> build_tree(children, parent_id, stack)
  end
  defp build_tree(tree, [text | children], parent_id, stack) when is_binary(text) do
    new_id = IDSeeder.seed(tree.node_ids)
    new_node = %Text{content: text, node_id: new_id, parent_node_id: parent_id}

    nodes = put_new_node(tree.nodes, new_node)

    %{tree | nodes: nodes, node_ids: [new_id | tree.node_ids]}
    |> build_tree(children, parent_id, stack)
  end
  defp build_tree(tree, [_other | children], parent_id, stack) do
    build_tree(tree, children, parent_id, stack)
  end
  defp build_tree(tree, [], _, [{parent_node_id, children} | stack]) do
    build_tree(tree, children, parent_node_id, stack)
  end

  defp put_new_node(nodes, new_node) do
    parent_node = Map.get(nodes, new_node.parent_node_id)
    children_ids = parent_node.children_nodes_ids
    updated_parent = %{parent_node | children_nodes_ids: [new_node.node_id | children_ids]}

    nodes
    |> Map.put(new_node.node_id, new_node)
    |> Map.put(new_node.parent_node_id, updated_parent)
  end
end
