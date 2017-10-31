defmodule Floki.Selector.PseudoClass do
  @moduledoc false

  require Logger

  # Represents a pseudo-class selector
  defstruct name: "", value: nil

  alias Floki.HTMLTree.{HTMLNode, Text}
  alias Floki.Selector.Functional

  defimpl String.Chars do
    def to_string(%{name: name, value: nil}) do
      ":#{name}"
    end

    def to_string(%{name: name, value: selectors}) when is_list(selectors) do
      ":#{name}(#{Enum.join(selectors)})"
    end

    def to_string(pseudo_class) do
      ":#{pseudo_class.name}(#{pseudo_class.value})"
    end
  end

  def match_nth_child?(_, %HTMLNode{parent_node_id: nil}, _), do: false

  def match_nth_child?(tree, html_node, %__MODULE__{value: -1}) do
    children_nodes_ids = get_children_nodes_indexed(tree, html_node.parent_node_id)
    {last_child_id, _} = Enum.max_by(children_nodes_ids, fn {_, pos} -> pos end)
    last_child_id == html_node.node_id
  end

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

  def match_nth_child?(tree, html_node, %__MODULE__{value: %Functional{stream: s}}) do
    position = node_position(tree, html_node)
    position in s
  end

  def match_nth_child?(_tree, _html_node, %__MODULE__{value: expression}) do
    Logger.warn(fn ->
      "Pseudo-class nth-child with expressions like #{inspect(expression)} are not supported yet. Ignoring."
    end)

    false
  end

  def match_nth_of_type?(_, %HTMLNode{parent_node_id: nil}, _), do: false

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: -1}) do
    children_nodes_ids = get_children_nodes_indexed_by_type(tree, html_node)
    {last_child_id, _} = Enum.max_by(children_nodes_ids, fn {_, pos} -> pos end)
    last_child_id == html_node.node_id
  end

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: position}) when is_integer(position) do
    node_type_position(tree, html_node) == position
  end

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: "even"}) do
    position = node_type_position(tree, html_node)
    rem(position, 2) == 0
  end

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: "odd"}) do
    position = node_type_position(tree, html_node)
    rem(position, 2) == 1
  end

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: %Functional{stream: s}}) do
    position = node_type_position(tree, html_node)
    position in s
  end

  def match_nth_of_type?(_, _, %__MODULE__{value: expression}) do
    Logger.warn(fn ->
      "Pseudo-class nth-of-type with expressions like #{inspect(expression)} are not supported yet. Ignoring."
    end)

    false
  end

  def match_contains?(tree, html_node, %__MODULE__{value: value}) do
    res =
      Enum.find(html_node.children_nodes_ids, fn id ->
        case Map.get(tree.nodes, id) do
          %Text{content: content} -> content =~ value
          _ -> false
        end
      end)

    res != nil
  end

  defp node_position(tree, html_node) do
    children_nodes_ids = get_children_nodes_indexed(tree, html_node.parent_node_id)
    find_node_position(children_nodes_ids, html_node.node_id)
  end

  defp node_type_position(tree, html_node) do
    children_nodes_ids = get_children_nodes_indexed_by_type(tree, html_node)
    find_node_position(children_nodes_ids, html_node.node_id)
  end

  defp find_node_position(ids, node_id) do
    {_node_id, position} = Enum.find(ids, fn {id, _} -> id == node_id end)

    position
  end

  defp get_children_nodes_indexed(tree, parent_node_id) do
    nodes = get_children_nodes(tree, parent_node_id)
    Enum.with_index(nodes, 1)
  end

  defp get_children_nodes_indexed_by_type(tree, html_node) do
    get_children_nodes(tree, html_node.parent_node_id)
    |> filter_nodes_by_type(tree.nodes, html_node.type)
    |> Enum.with_index(1)
  end

  defp get_children_nodes(tree, parent_node_id) do
    parent_node = Map.get(tree.nodes, parent_node_id)

    parent_node.children_nodes_ids
    |> Enum.reverse()
    |> filter_only_html_nodes(tree.nodes)
  end

  defp filter_only_html_nodes(ids, nodes) do
    Enum.filter(ids, fn id ->
      case Map.get(nodes, id) do
        %HTMLNode{} -> true
        _ -> false
      end
    end)
  end

  defp filter_nodes_by_type(ids, nodes, type) do
    Enum.filter(ids, fn id ->
      case Map.get(nodes, id) do
        %HTMLNode{type: ^type} -> true
        _ -> false
      end
    end)
  end
end
