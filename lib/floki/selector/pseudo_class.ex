defmodule Floki.Selector.PseudoClass do
  @moduledoc false

  require Logger

  # Represents a pseudo-class selector
  defstruct name: "", value: nil

  alias Floki.HTMLTree.{HTMLNode, Text}
  alias Floki.Selector.Functional

  @type t :: %__MODULE__{
          name: String.t(),
          value: String.t() | [Floki.Selector.t()]
        }

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

  def match_nth_child?(_tree, %HTMLNode{parent_node_id: nil}, _pseudo_class), do: false

  def match_nth_child?(tree, html_node, %__MODULE__{value: value}) do
    relative_position =
      tree
      |> children_nodes(html_node.parent_node_id)
      |> Enum.with_index(1)
      |> node_position(html_node)

    match_position?(value, relative_position, "nth-child")
  end

  def match_nth_of_type?(_, %HTMLNode{parent_node_id: nil}, _), do: false

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: value}) do
    relative_position =
      tree
      |> children_nodes(html_node.parent_node_id)
      |> filter_nodes_by_type(tree.nodes, html_node.type)
      |> Enum.with_index(1)
      |> node_position(html_node)

    match_position?(value, relative_position, "nth-of-type")
  end

  def match_nth_last_child?(_, %HTMLNode{parent_node_id: nil}, _), do: false

  def match_nth_last_child?(tree, html_node, %__MODULE__{value: value}) do
    relative_position =
      tree
      |> reverse_children_nodes(html_node.parent_node_id)
      |> Enum.with_index(1)
      |> node_position(html_node)

    match_position?(value, relative_position, "nth-last-child")
  end

  def match_nth_last_of_type?(_, %HTMLNode{parent_node_id: nil}, _), do: false

  def match_nth_last_of_type?(tree, html_node, %__MODULE__{value: value}) do
    relative_position =
      tree
      |> reverse_children_nodes(html_node.parent_node_id)
      |> filter_nodes_by_type(tree.nodes, html_node.type)
      |> Enum.with_index(1)
      |> node_position(html_node)

    match_position?(value, relative_position, "nth-last-of-type")
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

  defp match_position?(value, relative_position, name) do
    case value do
      position when is_integer(position) ->
        relative_position == position

      "even" ->
        rem(relative_position, 2) == 0

      "odd" ->
        rem(relative_position, 2) == 1

      %Functional{stream: s} ->
        relative_position in s

      expression ->
        Logger.info(fn ->
          "Pseudo-class #{name} with expressions like #{inspect(expression)} are not supported yet. Ignoring."
        end)

        false
    end
  end

  def match_checked?(%{type: "input"} = html_node) do
    case List.keyfind(html_node.attributes, "checked", 0) do
      {"checked", _} -> true
      _ -> false
    end
  end

  def match_checked?(%{type: "option"} = html_node) do
    case List.keyfind(html_node.attributes, "selected", 0) do
      {"selected", _} -> true
      _ -> false
    end
  end

  def match_checked?(_) do
    false
  end

  @disableable_html_nodes ~w[button input select option textarea]

  def match_disabled?(%{type: type} = html_node) when type in @disableable_html_nodes do
    case List.keyfind(html_node.attributes, "disabled", 0) do
      {"disabled", _} -> true
      _ -> false
    end
  end

  def match_disabled?(_html_node) do
    false
  end

  def match_root?(html_node, tree) do
    html_node.node_id in tree.root_nodes_ids
  end

  defp node_position(ids, %HTMLNode{node_id: node_id}) do
    {_node_id, position} = Enum.find(ids, fn {id, _} -> id == node_id end)

    position
  end

  defp children_nodes(tree, parent_node_id) do
    parent_node = Map.get(tree.nodes, parent_node_id)

    parent_node.children_nodes_ids
    |> Enum.reverse()
    |> filter_only_html_nodes(tree.nodes)
  end

  defp reverse_children_nodes(tree, parent_node_id) do
    parent_node = Map.get(tree.nodes, parent_node_id)

    parent_node.children_nodes_ids
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
