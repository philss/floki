defmodule Floki.HTMLTree do
  @moduledoc false

  # Builds a `Map` representing a HTML tree based on tuples or list of tuples.
  #
  # It is useful because keeps references for each node, and the possibility to
  # update the tree.

  alias Floki.HTMLTree
  alias Floki.HTMLTree.{HTMLNode, Text, Comment, IDSeeder}

  defstruct nodes: %{}, root_nodes_ids: [], node_ids: []

  @type t :: %__MODULE__{
          nodes: %{optional(pos_integer()) => HTMLNode.t() | Text.t() | Comment.t()},
          root_nodes_ids: [pos_integer()],
          node_ids: [pos_integer()]
        }

  def build({:comment, comment}) do
    %HTMLTree{
      root_nodes_ids: [1],
      node_ids: [1],
      nodes: %{
        1 => %Comment{content: comment, node_id: 1}
      }
    }
  end

  def build({tag, attrs, children}) do
    root_id = IDSeeder.seed([])
    root_node = %HTMLNode{type: tag, attributes: attrs, node_id: root_id}

    tree =
      build_tree(
        %HTMLTree{root_nodes_ids: [root_id], node_ids: [root_id], nodes: []},
        children,
        root_node,
        []
      )

    build_nodes_map(tree)
  end

  def build(html_tuples) when is_list(html_tuples) do
    reducer = fn
      {:pi, _, _}, tree ->
        tree

      {tag, attrs, children}, tree ->
        root_id = IDSeeder.seed(tree.node_ids)

        root_node = %HTMLNode{type: tag, attributes: attrs, node_id: root_id}

        build_tree(
          %{
            tree
            | node_ids: [root_id | tree.node_ids],
              root_nodes_ids: [root_id | tree.root_nodes_ids]
          },
          children,
          root_node,
          []
        )

      text, tree when is_binary(text) ->
        root_id = IDSeeder.seed(tree.node_ids)

        root_node = %Text{content: text, node_id: root_id}

        build_tree(
          %{
            tree
            | node_ids: [root_id | tree.node_ids],
              root_nodes_ids: [root_id | tree.root_nodes_ids]
          },
          [],
          root_node,
          []
        )

      {:comment, comment}, tree ->
        root_id = IDSeeder.seed(tree.node_ids)

        root_node = %Comment{content: comment, node_id: root_id}

        build_tree(
          %{
            tree
            | node_ids: [root_id | tree.node_ids],
              root_nodes_ids: [root_id | tree.root_nodes_ids]
          },
          [],
          root_node,
          []
        )

      _, tree ->
        tree
    end

    tree = Enum.reduce(html_tuples, %HTMLTree{nodes: []}, reducer)
    build_nodes_map(tree)
  end

  def build(_), do: %HTMLTree{}

  defp build_nodes_map(tree) do
    %{tree | nodes: Map.new(tree.nodes)}
  end

  def delete_node(tree, html_node) do
    do_delete(tree, [html_node], [])
  end

  def to_tuple_list(html_tree) do
    html_tree.root_nodes_ids
    |> Enum.reverse()
    |> Enum.map(fn node_id ->
      root = Map.get(html_tree.nodes, node_id)

      HTMLTree.to_tuple(html_tree, root)
    end)
  end

  def to_tuple(_tree, %Text{content: text}), do: text
  def to_tuple(_tree, %Comment{content: comment}), do: {:comment, comment}

  def to_tuple(tree, html_node) do
    children =
      html_node.children_nodes_ids
      |> Enum.reverse()
      |> Enum.map(fn id -> to_tuple(tree, Map.get(tree.nodes, id)) end)

    {html_node.type, html_node.attributes, children}
  end

  defp do_delete(tree, [], []), do: tree

  defp do_delete(tree, [html_node | t], stack_ids) do
    new_tree_nodes = delete_node_from_nodes(tree.nodes, html_node)

    ids_for_stack = get_ids_for_delete_stack(html_node)

    do_delete(
      %{
        tree
        | nodes: new_tree_nodes,
          node_ids: List.delete(tree.node_ids, html_node.node_id),
          root_nodes_ids: List.delete(tree.root_nodes_ids, html_node.node_id)
      },
      t,
      ids_for_stack ++ stack_ids
    )
  end

  defp do_delete(tree, [], stack_ids) do
    html_nodes =
      tree.nodes
      |> Map.take(stack_ids)
      |> Map.values()

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

  defp build_tree(tree, [], parent_node, []) do
    %{tree | nodes: [{parent_node.node_id, parent_node} | tree.nodes]}
  end

  defp build_tree(tree, [{:pi, _, _} | children], parent_node, stack) do
    build_tree(tree, children, parent_node, stack)
  end

  defp build_tree(tree, [{tag, attrs, child_children} | children], parent_node, stack) do
    new_id = IDSeeder.seed(tree.node_ids)

    new_node = %HTMLNode{
      type: tag,
      attributes: attrs,
      node_id: new_id,
      parent_node_id: parent_node.node_id
    }

    parent_node = %{
      parent_node
    | children_nodes_ids: [new_id | parent_node.children_nodes_ids]
    }

    build_tree(
      %{tree | node_ids: [new_id | tree.node_ids]},
      child_children,
      new_node,
      [{parent_node, children} | stack]
    )
  end

  defp build_tree(tree, [{:comment, comment} | children], parent_node, stack) do
    new_id = IDSeeder.seed(tree.node_ids)
    new_node = %Comment{content: comment, node_id: new_id, parent_node_id: parent_node.node_id}

    {tree, parent_node} = put_new_node(tree, new_node, parent_node)

    build_tree(
      tree,
      children,
      parent_node,
      stack
    )
  end

  defp build_tree(tree, [text | children], parent_node, stack) when is_binary(text) do
    new_id = IDSeeder.seed(tree.node_ids)
    new_node = %Text{content: text, node_id: new_id, parent_node_id: parent_node.node_id}

    {tree, parent_node} = put_new_node(tree, new_node, parent_node)

    build_tree(
      tree,
      children,
      parent_node,
      stack
    )
  end

  defp build_tree(tree, [_other | children], parent_node, stack) do
    build_tree(tree, children, parent_node, stack)
  end

  defp build_tree(tree, [], parent_node, [{next_parent_node, next_parent_children} | stack]) do

    build_tree(
      %{tree | nodes: [{parent_node.node_id, parent_node} | tree.nodes]},
      next_parent_children,
      next_parent_node,
      stack
    )
  end

  defp put_new_node(tree, new_node, parent_node) do
    new_node_id = new_node.node_id

    updated_tree = %{
      tree
      | nodes: [{new_node_id, new_node} | tree.nodes],
        node_ids: [new_node_id | tree.node_ids]
    }

    updated_parent_node = %{
      parent_node
      | children_nodes_ids: [new_node_id | parent_node.children_nodes_ids]
    }

    {updated_tree, updated_parent_node}
  end

  def patch_nodes(html_tree, operation_with_nodes) do
    Enum.reduce(operation_with_nodes, html_tree, fn node_with_op, tree ->
      case node_with_op do
        {:update, node} ->
          put_in(tree.nodes[node.node_id], node)

        {:delete, node} ->
          delete_node(tree, node)

        {:no_op, _node} ->
          tree
      end
    end)
  end

  # Enables using functions from `Enum` and `Stream` modules
  defimpl Enumerable do
    def count(html_tree) do
      {:ok, length(html_tree.node_ids)}
    end

    def member?(html_tree, html_node = %{node_id: node_id}) do
      a_node = Map.get(html_tree.nodes, node_id)

      {:ok, a_node === html_node}
    end

    def member?(_, _) do
      {:ok, false}
    end

    def slice(_) do
      {:error, __MODULE__}
    end

    def reduce(html_tree, state, fun) do
      do_reduce(%{html_tree | node_ids: Enum.reverse(html_tree.node_ids)}, state, fun)
    end

    defp do_reduce(_, {:halt, acc}, _fun), do: {:halted, acc}
    defp do_reduce(tree, {:suspend, acc}, fun), do: {:suspended, acc, &do_reduce(tree, &1, fun)}
    defp do_reduce(%HTMLTree{node_ids: []}, {:cont, acc}, _fun), do: {:done, acc}

    defp do_reduce(html_tree = %HTMLTree{node_ids: [h | t]}, {:cont, acc}, fun) do
      tree = %{html_tree | node_ids: t}
      head_node = Map.get(html_tree.nodes, h)
      do_reduce(tree, fun.(head_node, acc), fun)
    end
  end
end
