defmodule Floki.FilterOut do
  @moduledoc false

  # Helper functions for filtering out a specific element from the tree.

  @type html_tree :: tuple | list
  @type selector :: binary

  @spec filter_out(html_tree, selector) :: tuple | list

  def filter_out(html_tree, :comment) do
    mapper(html_tree, :comment)
  end
  def filter_out(html_tree, selector) do
    case Floki.Finder.find(html_tree, selector) do
      {:empty_tree, _} ->
        html_tree
      {tree, results} ->
        new_tree = Enum.reduce(results, tree, fn(html_node, tree) ->
          Floki.HTMLTree.delete_node(tree, html_node)
        end)

        html_as_tuples = Enum.map(new_tree.root_nodes_ids, fn(node_id) ->
          root = Map.get(new_tree.nodes, node_id)

          as_tuple(new_tree, root)
        end)

        case html_tree do
          tree when is_tuple(tree) ->
            hd(html_as_tuples)
          trees when is_list(trees) ->
            html_as_tuples
        end
    end
  end

  defp filter({nodetext, _, _}, selector) when nodetext === selector, do: false
  defp filter({nodetext, _}, selector) when nodetext === selector, do: false
  defp filter(_, _), do: true

  defp mapper(nodes, selector) when is_list(nodes) do
    Enum.filter_map(nodes, &filter(&1, selector), &mapper(&1, selector))
  end
  defp mapper({nodetext, x, y}, selector) do
    {nodetext, x, mapper(y, selector)}
  end
  defp mapper(nodetext, _), do: nodetext

  defp as_tuple(_tree, %Floki.HTMLTree.Text{content: text}), do: text
  defp as_tuple(tree, html_node) do
    children = html_node.children_nodes_ids
               |> Enum.reverse
               |> Enum.map(fn(id) -> Map.get(tree.nodes, id) end)
               |> Enum.map(fn(node) -> as_tuple(tree, node) end)

    {html_node.type, html_node.attributes, children}
  end
end
