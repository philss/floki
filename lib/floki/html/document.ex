defmodule Floki.HTML.Document do
  @moduledoc """
  It represents a HTML Document with its tree and doctype.
  """

  alias __MODULE__
  alias Floki.HTML.Doctype
  alias Floki.HTMLTree
  alias Floki.HTMLTree.HTMLNode

  defstruct doctype: nil,
            tree: %HTMLTree{},
            mode: nil

  @doc """
  Sets the doctype for this Document.

  ## Examples

      iex> Floki.HTML.Document.set_doctype(%Document{doctype: nil}, %Doctype{name: "html"})
      %Document{doctype: %Doctype{name: "html"}}

  """
  def set_doctype(document = %Document{}, doctype = %Doctype{}) do
    %{document | doctype: doctype}
  end

  def set_mode(document = %Document{}, mode) do
    %{document | mode: mode}
  end

  @doc """
  Creates a new node without a parent.
  """
  def add_node(document = %Document{tree: tree}, node) do
    new_id = id(tree.node_ids)

    new_node = %{node | node_id: new_id, parent_node_id: nil}

    new_tree = %{
      tree
      | node_ids: [new_id | tree.node_ids],
        root_nodes_ids: [new_id | tree.root_nodes_ids],
        nodes: Map.put(tree.nodes, new_id, new_node)
    }

    {:ok, %{document | tree: new_tree}, new_node}
  end

  @doc """
  Creates a new node with a parent node.
  """
  def add_node(document = %Document{tree: tree}, node, parent_node_id) do
    new_id = id(tree.node_ids)

    new_node = %{node | node_id: new_id, parent_node_id: parent_node_id}

    nodes = put_new_node(tree.nodes, new_node)
    new_tree = %{tree | node_ids: [new_id | tree.node_ids], nodes: nodes}

    {:ok, %{document | tree: new_tree}, new_node}
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
