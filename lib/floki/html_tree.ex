defmodule Floki.HTMLTree do
  @moduledoc false

  # Internal: Builds a `Map` representing a HTML tree based on tuples or list of tuples.
  #
  # It is useful because keeps references for each node, and the possibility to
  # update the tree.

  defstruct nodes: %{}, root_nodes_ids: [], node_ids: []

  alias Floki.HTMLTree
  alias Floki.HTMLTree.{HTMLNode, Text, IDSeeder}

  def build({tag, attrs, children}) do
    root_id = IDSeeder.seed([])

    %HTMLTree{root_nodes_ids: [root_id],
              node_ids: [root_id],
              nodes: %{ root_id => %HTMLNode{type: tag, attributes: attrs, node_id: root_id} }}
    |> build_tree(children, root_id, [])
  end

  def build(html_tuples) when is_list(html_tuples) do
    reducer = fn
      ({tag, attrs, children}, tree) ->
        root_id = IDSeeder.seed(tree.node_ids)

        root_node = %HTMLNode{type: tag, attributes: attrs, node_id: root_id}

        %{tree | nodes: Map.put(tree.nodes, root_id, root_node),
                 node_ids: [root_id | tree.node_ids],
                 root_nodes_ids: [root_id | tree.root_nodes_ids]}
        |> build_tree(children, root_id, [])
      (_, tree) ->
        tree
    end

    Enum.reduce(html_tuples, %HTMLTree{}, reducer)
  end

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
