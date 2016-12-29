defmodule Floki.Selector.PseudoClass do
  @moduledoc false

  require Logger

  # Represents a pseudo-class selector
  defstruct name: "", value: nil

  alias Floki.HTMLTree.HTMLNode

  def match_nth_child?(_, %HTMLNode{parent_node_id: nil}, _), do: false
  def match_nth_child?(tree, html_node, %__MODULE__{value: position}) when is_integer(position) do
    node_position(tree, html_node) == position
  end
  def match_nth_child?(tree, html_node, %__MODULE__{value: "even"}) do
    position = node_position(tree, html_node)
    rem(position, 2) == 0
  end
  def match_nth_child?(tree, html_node, %__MODULE__{value: "odd"}) do
    position = node_position(tree, html_node)
    rem(position, 2) == 1
  end
  def match_nth_child?(_, _, %__MODULE__{value: expression}) do
    Logger.warn("Pseudo-class nth-child with expressions like #{inspect expression} are not supported yet. Ignoring.")
    false
  end

  defp node_position(tree, html_node) do
    parent_node = Map.get(tree.nodes, html_node.parent_node_id)
    children_nodes_ids = parent_node.children_nodes_ids
                         |> Enum.reverse
                         |> Enum.with_index(1)

    {_node_id, position} = Enum.find(children_nodes_ids, fn({id, _}) -> id == html_node.node_id end)

    position
  end
end
