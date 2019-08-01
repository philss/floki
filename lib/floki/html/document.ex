defmodule Floki.HTML.Document do
  @moduledoc """
  It represents a HTML Document with its tree and doctype.
  """
  alias __MODULE__
  alias Floki.HTMLTree
  alias Floki.HTMLTree.HTMLNode

  defmodule Doctype do
    defstruct name: nil,
              public_id: nil,
              system_id: nil,
              force_quirks: :off
  end

  defstruct doctype: nil,
            tree: %HTMLTree{},
            mode: nil

  def set_doctype(document = %Document{}, doctype = %Doctype{}) do
    %{document | doctype: doctype}
  end

  def add_node(document = %Document{tree: tree}, node, parent = %HTMLNode{}) do
    new_id = id(tree.node_ids)

    new_node = %{node | node_id: new_id, parent_node_id: parent.node_id}

    nodes = put_new_node(tree.nodes, new_node)
    new_tree = %{tree | node_ids: [new_id | tree.node_ids], nodes: nodes}

    %{document | tree: new_tree}
  end

  defp id([]), do: 1
  defp id([num | _]), do: num + 1

  defp put_new_node(nodes, new_node) do
    parent_node = Map.get(nodes, new_node.parent_node_id)
    children_ids = parent_node.children_nodes_ids
    updated_parent = %{parent_node | children_nodes_ids: [new_node.node_id | children_ids]}

    nodes
    |> Map.put(new_node.node_id, new_node)
    |> Map.put(new_node.parent_node_id, updated_parent)
  end
end
