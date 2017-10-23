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
    id_match?(html_node, selector.id) && namespace_match?(html_node, selector.namespace) &&
      type_match?(html_node, selector.type) && classes_matches?(html_node, selector.classes) &&
      attributes_matches?(html_node, selector.attributes) &&
      pseudo_classes_match?(html_node, selector.pseudo_classes, tree)
  end

  defp id_match?(_node, nil), do: true
  defp id_match?(%HTMLNode{attributes: []}, _), do: false
  defp id_match?(%HTMLNode{type: :pi}, _), do: false

  defp id_match?(%HTMLNode{attributes: attributes}, id) do
    Enum.any?(attributes, fn attribute ->
      case attribute do
        {"id", ^id} -> true
        _ -> false
      end
    end)
  end

  defp namespace_match?(_node, nil), do: true
  defp namespace_match?(_node, "*"), do: true
  defp namespace_match?(%HTMLNode{type: :pi}, _type), do: false

  defp namespace_match?(%HTMLNode{type: type_maybe_with_namespace}, namespace) do
    case String.split(type_maybe_with_namespace, ":") do
      [ns, _type] ->
        ns == namespace

      [_type] ->
        false
    end
  end

  defp type_match?(_node, nil), do: true
  defp type_match?(_node, "*"), do: true
  defp type_match?(%HTMLNode{type: :pi}, _type), do: false

  defp type_match?(%HTMLNode{type: type_maybe_with_namespace}, type) do
    case String.split(type_maybe_with_namespace, ":") do
      [_ns, tp] ->
        tp == type

      [tp] ->
        tp == type

      _ ->
        false
    end
  end

  defp type_match?(_, _), do: false

  defp classes_matches?(_node, []), do: true
  defp classes_matches?(%HTMLNode{attributes: []}, _), do: false

  defp classes_matches?(%HTMLNode{attributes: attributes}, classes) do
    Enum.all?(classes, fn class ->
      selector = %AttributeSelector{match_type: :includes, attribute: "class", value: class}

      AttributeSelector.match?(attributes, selector)
    end)
  end

  defp attributes_matches?(_node, []), do: true
  defp attributes_matches?(%HTMLNode{attributes: []}, _), do: false

  defp attributes_matches?(%HTMLNode{attributes: attributes}, attributes_selectors) do
    Enum.all?(attributes_selectors, fn attribute_selector ->
      AttributeSelector.match?(attributes, attribute_selector)
    end)
  end

  defp pseudo_classes_match?(_html_node, [], _tree), do: true

  defp pseudo_classes_match?(html_node, pseudo_classes, tree) do
    Enum.all?(pseudo_classes, &pseudo_class_match?(html_node, &1, tree))
  end

  defp pseudo_class_match?(html_node, pseudo_class, tree) do
    case pseudo_class.name do
      "nth-child" ->
        PseudoClass.match_nth_child?(tree, html_node, pseudo_class)

      "first-child" ->
        PseudoClass.match_nth_child?(tree, html_node, %PseudoClass{name: "nth-child", value: 1})

      "last-child" ->
        PseudoClass.match_nth_child?(tree, html_node, %PseudoClass{name: "nth-child", value: -1})
      "nth-of-type" ->
        PseudoClass.match_nth_of_type?(tree, html_node, pseudo_class)

      "first-of-type" ->
        PseudoClass.match_nth_of_type?(tree, html_node, %PseudoClass{name: "nth-of-type", value: 1})

      "last-of-type" ->
        PseudoClass.match_nth_of_type?(tree, html_node, %PseudoClass{name: "nth-of-type", value: -1})

      "not" ->
        Enum.all?(pseudo_class.value, &(!Selector.match?(html_node, &1, tree)))

      "fl-contains" ->
        PseudoClass.match_contains?(tree, html_node, pseudo_class)

      unknown_pseudo_class ->
        Logger.warn(fn ->
          "Pseudo-class #{inspect(unknown_pseudo_class)} is not implemented. Ignoring."
        end)

        false
    end
  end
end
