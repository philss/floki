defmodule Floki.Selector do
  require Logger
  @moduledoc false

  # Represents a CSS selector. It also have functions to match nodes with a given selector.

  alias Floki.{Selector, HTMLTree}
  alias Selector.{AttributeSelector, PseudoClass}
  alias HTMLTree.{HTMLNode, Text, Comment}

  defstruct id: nil,
            type: nil,
            classes: [],
            attributes: [],
            namespace: nil,
            pseudo_classes: [],
            combinator: nil

  @type t :: %__MODULE__{
          id: String.t() | nil,
          type: String.t() | nil,
          classes: [String.t()],
          attributes: [AttributeSelector.t()],
          namespace: String.t() | nil,
          pseudo_classes: [PseudoClass.t()],
          combinator: Selector.Combinator.t() | nil
        }

  defimpl String.Chars do
    def to_string(selector) do
      Enum.join([
        namespace(selector),
        selector.type,
        id(selector),
        classes(selector),
        Enum.join(selector.attributes),
        Enum.join(selector.pseudo_classes),
        selector.combinator
      ])
    end

    defp namespace(%{namespace: nil}), do: ""
    defp namespace(%{namespace: ns}), do: "#{ns} | "

    defp id(%{id: nil}), do: ""
    defp id(%{id: id}), do: "##{id}"

    defp classes(%{classes: []}), do: ""
    defp classes(%{classes: classes}), do: ".#{Enum.join(classes, ".")}"
  end

  @wildcards [nil, "*"]
  defguardp is_wildcard(x) when x in @wildcards

  @doc false

  # Returns if a given node matches with a given selector.
  def match?(
        _node,
        %Selector{
          id: nil,
          type: nil,
          classes: [],
          attributes: [],
          namespace: nil,
          pseudo_classes: [],
          combinator: nil
        },
        _tree
      ) do
    false
  end

  def match?(nil, _selector, _tree), do: false
  def match?({:comment, _comment}, _selector, _tree), do: false
  def match?({:pi, _xml, _xml_attrs}, _selector, _tree), do: false
  def match?(%Text{}, _selector, _tree), do: false
  def match?(%Comment{}, _selector, _tree), do: false

  def match?(html_node, selector, tree) do
    can_match_combinator?(html_node, selector.combinator) &&
      id_match?(html_node, selector.id) &&
      namespace_match?(html_node, selector.namespace) &&
      type_match?(html_node, selector.type) &&
      classes_matches?(html_node, selector.classes) &&
      attributes_matches?(html_node, selector.attributes) &&
      pseudo_classes_match?(html_node, selector.pseudo_classes, tree)
  end

  defp can_match_combinator?(_node, nil), do: true

  defp can_match_combinator?(
         %HTMLNode{children_nodes_ids: []},
         %Selector.Combinator{match_type: match_type}
       )
       when match_type in [:child, :descendant] do
    false
  end

  defp can_match_combinator?(_node, _combinator), do: true

  defp id_match?(_node, nil), do: true
  defp id_match?(node, id), do: attribute_value(node, "id") == id

  defp namespace_match?(_node, namespace) when is_wildcard(namespace), do: true

  defp namespace_match?(node, namespace) do
    namespace_size = byte_size(namespace)

    case type_maybe_with_namespace(node) do
      <<^namespace::binary-size(namespace_size), ":", _::binary>> -> true
      _ -> false
    end
  end

  defp type_match?(_node, type) when is_wildcard(type), do: true

  defp type_match?(node, type) do
    case type_maybe_with_namespace(node) do
      ^type ->
        true

      type_maybe_with_namespace when byte_size(type_maybe_with_namespace) > byte_size(type) ->
        expected_namespace_size = byte_size(type_maybe_with_namespace) - byte_size(type) - 1

        Kernel.match?(
          <<
            _ns::binary-size(expected_namespace_size),
            ":",
            ^type::binary
          >>,
          type_maybe_with_namespace
        )

      _ ->
        false
    end
  end

  defp classes_matches?(_node, []), do: true

  defp classes_matches?(node, classes) do
    class_attr_value = attribute_value(node, "class")
    do_classes_matches?(class_attr_value, classes)
  end

  defp do_classes_matches?(nil, _classes), do: false

  defp do_classes_matches?(class_attr_value, [class | _])
       when bit_size(class_attr_value) < bit_size(class) do
    false
  end

  defp do_classes_matches?(class_attr_value, [class])
       when bit_size(class_attr_value) == bit_size(class) do
    class == class_attr_value
  end

  defp do_classes_matches?(class_attr_value, [class]) do
    class_attr_value
    |> String.split([" ", "\t", "\n"], trim: true)
    |> Enum.member?(class)
  end

  defp do_classes_matches?(class_attr_value, classes) do
    min_size = Enum.reduce(classes, -1, fn item, acc -> acc + 1 + bit_size(item) end)
    can_match? = bit_size(class_attr_value) >= min_size
    can_match? && classes -- String.split(class_attr_value, [" ", "\t", "\n"], trim: true) == []
  end

  defp attributes_matches?(_node, []), do: true

  defp attributes_matches?(node, attributes_selectors) do
    attributes = attributes(node)

    not Enum.empty?(attributes) and
      Enum.all?(attributes_selectors, fn attribute_selector ->
        AttributeSelector.match?(attributes, attribute_selector)
      end)
  end

  defp pseudo_classes_match?(_html_node, [], _tree), do: true

  defp pseudo_classes_match?(html_node, pseudo_classes, tree) do
    Enum.all?(pseudo_classes, &pseudo_class_match?(html_node, &1, tree))
  end

  defp pseudo_class_match?(html_node, pseudo_class = %{name: "nth-child"}, tree) do
    PseudoClass.match_nth_child?(tree, html_node, pseudo_class)
  end

  defp pseudo_class_match?(html_node, %{name: "first-child"}, tree) do
    PseudoClass.match_nth_child?(tree, html_node, %PseudoClass{name: "nth-child", value: 1})
  end

  defp pseudo_class_match?(html_node, %{name: "last-child"}, tree) do
    PseudoClass.match_nth_last_child?(tree, html_node, %PseudoClass{
      name: "nth-last-child",
      value: 1
    })
  end

  defp pseudo_class_match?(html_node, pseudo_class = %{name: "nth-last-child"}, tree) do
    PseudoClass.match_nth_last_child?(tree, html_node, pseudo_class)
  end

  defp pseudo_class_match?(html_node, pseudo_class = %{name: "nth-of-type"}, tree) do
    PseudoClass.match_nth_of_type?(tree, html_node, pseudo_class)
  end

  defp pseudo_class_match?(html_node, %{name: "first-of-type"}, tree) do
    PseudoClass.match_nth_of_type?(tree, html_node, %PseudoClass{
      name: "nth-of-type",
      value: 1
    })
  end

  defp pseudo_class_match?(html_node, %{name: "last-of-type"}, tree) do
    PseudoClass.match_nth_last_of_type?(tree, html_node, %PseudoClass{
      name: "nth-last-of-type",
      value: 1
    })
  end

  defp pseudo_class_match?(html_node, pseudo_class = %{name: "nth-last-of-type"}, tree) do
    PseudoClass.match_nth_last_of_type?(tree, html_node, pseudo_class)
  end

  defp pseudo_class_match?(html_node, pseudo_class = %{name: "not"}, tree) do
    Enum.all?(pseudo_class.value, &(!Selector.match?(html_node, &1, tree)))
  end

  defp pseudo_class_match?(html_node, %{name: "checked"}, _tree) do
    PseudoClass.match_checked?(html_node)
  end

  defp pseudo_class_match?(html_node, %{name: "disabled"}, _tree) do
    PseudoClass.match_disabled?(html_node)
  end

  defp pseudo_class_match?(html_node, pseudo_class = %{name: "fl-contains"}, tree) do
    PseudoClass.match_contains?(tree, html_node, pseudo_class)
  end

  # Case insensitive contains
  defp pseudo_class_match?(html_node, pseudo_class = %{name: "fl-icontains"}, tree) do
    PseudoClass.match_icontains?(tree, html_node, pseudo_class)
  end

  defp pseudo_class_match?(html_node, %{name: "root"}, tree) do
    PseudoClass.match_root?(html_node, tree)
  end

  defp pseudo_class_match?(_html_node, %{name: unknown_pseudo_class}, _tree) do
    Logger.debug(fn ->
      "Pseudo-class #{inspect(unknown_pseudo_class)} is not implemented. Ignoring."
    end)

    false
  end

  defp type_maybe_with_namespace({type, _attributes, _children}) when is_binary(type), do: type
  defp type_maybe_with_namespace(%HTMLNode{type: type}) when is_binary(type), do: type
  defp type_maybe_with_namespace(_), do: nil

  defp attribute_value(node, attribute_name) do
    attributes = attributes(node)
    get_attribute_value(attributes, attribute_name)
  end

  defp attributes({_type, attributes, _children}), do: attributes
  defp attributes(%HTMLNode{type: :pi}), do: []
  defp attributes(%HTMLNode{attributes: attributes}), do: attributes

  defp get_attribute_value(attributes, attribute_name) when is_list(attributes) do
    :proplists.get_value(attribute_name, attributes, nil)
  end

  defp get_attribute_value(attributes, attribute_name) when is_map(attributes) do
    Map.get(attributes, attribute_name)
  end
end
