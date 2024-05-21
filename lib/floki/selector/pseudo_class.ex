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

  def match_nth_child?(tree, html_node, %__MODULE__{value: value}) do
    tree
    |> pseudo_nodes(html_node)
    |> Enum.reverse()
    |> node_position(html_node)
    |> match_position?(value, "nth-child")
  end

  def match_nth_of_type?(tree, html_node, %__MODULE__{value: value}) do
    tree
    |> pseudo_nodes(html_node)
    |> filter_nodes_by_type(tree.nodes, html_node.type)
    |> Enum.reverse()
    |> node_position(html_node)
    |> match_position?(value, "nth-of-type")
  end

  def match_nth_last_child?(tree, html_node, %__MODULE__{value: value}) do
    tree
    |> pseudo_nodes(html_node)
    |> node_position(html_node)
    |> match_position?(value, "nth-last-child")
  end

  def match_nth_last_of_type?(tree, html_node, %__MODULE__{value: value}) do
    tree
    |> pseudo_nodes(html_node)
    |> filter_nodes_by_type(tree.nodes, html_node.type)
    |> node_position(html_node)
    |> match_position?(value, "nth-last-of-type")
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

  # Case insensitive contains
  def match_icontains?(tree, html_node, %__MODULE__{value: value}) do
    downcase_value = String.downcase(value)

    res =
      Enum.find(html_node.children_nodes_ids, fn id ->
        case Map.get(tree.nodes, id) do
          %Text{content: content} -> String.downcase(content) =~ downcase_value
          _ -> false
        end
      end)

    res != nil
  end

  defp match_position?(relative_position, value, name) do
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
        Logger.debug(fn ->
          "Pseudo-class #{name} with expressions like #{inspect(expression)} are not supported yet. Ignoring."
        end)

        false
    end
  end

  def match_checked?(%{type: "input"} = html_node) do
    attribute_is_present?(html_node.attributes, "checked")
  end

  def match_checked?(%{type: "option"} = html_node) do
    attribute_is_present?(html_node.attributes, "selected")
  end

  def match_checked?({"input", attributes, _children}) do
    attribute_is_present?(attributes, "checked")
  end

  def match_checked?({"option", attributes, _children}) do
    attribute_is_present?(attributes, "selected")
  end

  def match_checked?(_), do: false

  defp attribute_is_present?(attributes, attribute_name) when is_list(attributes) do
    match?({^attribute_name, _}, List.keyfind(attributes, attribute_name, 0))
  end

  defp attribute_is_present?(attributes, attribute_name) when is_map(attributes) do
    not is_nil(attributes[attribute_name])
  end

  @disableable_html_nodes ~w[button input select option textarea]

  def match_disabled?(%{type: type} = html_node) when type in @disableable_html_nodes do
    attribute_is_present?(html_node.attributes, "disabled")
  end

  def match_disabled?({type, attributes, _children}) when type in @disableable_html_nodes do
    attribute_is_present?(attributes, "disabled")
  end

  def match_disabled?(_html_node), do: false

  def match_root?(html_node, tree) do
    html_node.node_id in tree.root_nodes_ids
  end

  defp node_position(ids, %HTMLNode{node_id: node_id}) do
    position = Enum.find_index(ids, fn id -> id == node_id end)
    position + 1
  end

  defp pseudo_nodes(tree, %HTMLNode{parent_node_id: nil}) do
    tree.root_nodes_ids
    |> filter_only_html_nodes(tree.nodes)
  end

  defp pseudo_nodes(tree, %HTMLNode{parent_node_id: parent_node_id}) do
    parent_node = Map.fetch!(tree.nodes, parent_node_id)

    parent_node.children_nodes_ids
    |> filter_only_html_nodes(tree.nodes)
  end

  defp filter_only_html_nodes(ids, nodes) do
    Enum.filter(ids, fn id ->
      case nodes do
        %{^id => %HTMLNode{}} -> true
        _ -> false
      end
    end)
  end

  defp filter_nodes_by_type(ids, nodes, type) do
    Enum.filter(ids, fn id ->
      case nodes do
        %{^id => %HTMLNode{type: ^type}} -> true
        _ -> false
      end
    end)
  end
end
