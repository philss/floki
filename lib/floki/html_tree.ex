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

    {node_ids, nodes} =
      build_tree(
        [root_id],
        [],
        children,
        root_node,
        []
      )

    %HTMLTree{
      root_nodes_ids: [root_id],
      node_ids: node_ids,
      nodes: Map.new(nodes)
    }
  end

  def build(html_tuples) when is_list(html_tuples) do
    reducer = fn
      {:pi, _, _}, state ->
        state

      {tag, attrs, children}, {root_nodes_ids, node_ids, nodes} ->
        root_id = IDSeeder.seed(node_ids)
        root_node = %HTMLNode{type: tag, attributes: attrs, node_id: root_id}

        root_nodes_ids = [root_id | root_nodes_ids]
        node_ids = [root_id | node_ids]

        {node_ids, nodes} =
          build_tree(
            node_ids,
            nodes,
            children,
            root_node,
            []
          )

        {root_nodes_ids, node_ids, nodes}

      text, {root_nodes_ids, node_ids, nodes} when is_binary(text) ->
        root_id = IDSeeder.seed(node_ids)
        root_node = %Text{content: text, node_id: root_id}

        root_nodes_ids = [root_id | root_nodes_ids]
        node_ids = [root_id | node_ids]

        {node_ids, nodes} =
          build_tree(
            node_ids,
            nodes,
            [],
            root_node,
            []
          )

        {root_nodes_ids, node_ids, nodes}

      {:comment, comment}, {root_nodes_ids, node_ids, nodes} ->
        root_id = IDSeeder.seed(node_ids)
        root_node = %Comment{content: comment, node_id: root_id}

        root_nodes_ids = [root_id | root_nodes_ids]
        node_ids = [root_id | node_ids]

        {node_ids, nodes} =
          build_tree(
            node_ids,
            nodes,
            [],
            root_node,
            []
          )

        {root_nodes_ids, node_ids, nodes}

      _, state ->
        state
    end

    {root_nodes_ids, node_ids, nodes} = Enum.reduce(html_tuples, {[], [], []}, reducer)

    %HTMLTree{
      root_nodes_ids: root_nodes_ids,
      node_ids: node_ids,
      nodes: Map.new(nodes)
    }
  end

  def build(_), do: %HTMLTree{}

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

  defp build_tree(node_ids, nodes, [], parent_node, []) do
    {node_ids, [{parent_node.node_id, parent_node} | nodes]}
  end

  defp build_tree(node_ids, nodes, [{:pi, _, _} | children], parent_node, stack) do
    build_tree(node_ids, nodes, children, parent_node, stack)
  end

  defp build_tree(node_ids, nodes, [{tag, attrs, child_children} | children], parent_node, stack) do
    new_id = IDSeeder.seed(node_ids)

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
      [new_id | node_ids],
      nodes,
      child_children,
      new_node,
      [{parent_node, children} | stack]
    )
  end

  defp build_tree(node_ids, nodes, [{:comment, comment} | children], parent_node, stack) do
    new_id = IDSeeder.seed(node_ids)
    new_node = %Comment{content: comment, node_id: new_id, parent_node_id: parent_node.node_id}

    parent_node = %{
      parent_node
      | children_nodes_ids: [new_id | parent_node.children_nodes_ids]
    }

    build_tree(
      [new_id | node_ids],
      [{new_id, new_node} | nodes],
      children,
      parent_node,
      stack
    )
  end

  defp build_tree(node_ids, nodes, [text | children], parent_node, stack) when is_binary(text) do
    new_id = IDSeeder.seed(node_ids)
    new_node = %Text{content: text, node_id: new_id, parent_node_id: parent_node.node_id}

    parent_node = %{
      parent_node
      | children_nodes_ids: [new_id | parent_node.children_nodes_ids]
    }

    build_tree(
      [new_id | node_ids],
      [{new_id, new_node} | nodes],
      children,
      parent_node,
      stack
    )
  end

  defp build_tree(node_ids, nodes, [_other | children], parent_node, stack) do
    build_tree(node_ids, nodes, children, parent_node, stack)
  end

  defp build_tree(
         node_ids,
         nodes,
         [],
         parent_node,
         [{next_parent_node, next_parent_children} | stack]
       ) do
    build_tree(
      node_ids,
      [{parent_node.node_id, parent_node} | nodes],
      next_parent_children,
      next_parent_node,
      stack
    )
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

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(html_tree, opts) do
      open = "#Floki.HTMLTree["
      close = "]"
      container_opts = [separator: "", break: :flex]

      container_doc(
        open,
        nodes_with_tree(html_tree, html_tree.root_nodes_ids),
        close,
        opts,
        &fun/2,
        container_opts
      )
    end

    defp fun({html_tree, %HTMLNode{} = html_node}, opts) do
      {open, close, container_opts} = build_node(html_node, opts)

      container_doc(
        open,
        nodes_with_tree(html_tree, html_node.children_nodes_ids),
        close,
        opts,
        &fun/2,
        container_opts
      )
    end

    defp fun(%Comment{content: comment}, opts),
      do: color(concat(["<!-- ", comment, " -->"]), :comment, opts)

    defp fun(%Text{content: text}, opts), do: color(text, :string, opts)

    defp nodes_with_tree(html_tree, nodes_ids) do
      nodes_ids
      |> Enum.reverse()
      |> Enum.map(fn node_id ->
        with %HTMLNode{} = html_node <- Map.get(html_tree.nodes, node_id) do
          {html_tree, html_node}
        end
      end)
    end

    defp build_node(%HTMLNode{} = node, opts) do
      tag_color = :map
      attribute_color = :map

      built_attributes =
        for {name, value} <- node.attributes do
          concat([
            color(" #{name}=", attribute_color, opts),
            color("\"#{value}\"", :string, opts)
          ])
        end
        |> concat()

      open =
        concat([
          color("<#{node.type}", tag_color, opts),
          built_attributes,
          color(">", tag_color, opts)
        ])

      close = color("</#{node.type}>", tag_color, opts)
      container_opts = [separator: "", break: :strict]

      {open, close, container_opts}
    end
  end
end
