defmodule Floki.Selector do
  @moduledoc """
  Represents a CSS selector. It also have functions to match nodes with a given selector.
  """

  alias Floki.Selector
  alias Floki.AttributeSelector

  defstruct id: nil, type: nil, classes: [], attributes: [], combinator: nil

  @doc """
  Returns if a given node matches with a given selector.
  """
  def match?(_node, %Selector{id: nil, type: nil, classes: [], attributes: []}) do
    false
  end
  def match?(nil, _selector), do: false
  def match?({:comment, _comment}, _selector), do: false
  def match?({:pi, _xml, _xml_attrs}, _selector), do: false
  def match?(html_node, selector) do
    id_match?(html_node, selector.id)
      && type_match?(html_node, selector.type)
      && classes_matches?(html_node, selector.classes)
      && attributes_matches?(html_node, selector.attributes)
  end

  defp id_match?(_node, nil), do: true
  defp id_match?({_, [], _}, _), do: false
  defp id_match?({_, attributes, _}, id) do
    Enum.any? attributes, fn(attribute) ->
      case attribute do
        {"id", ^id} -> true
        _ -> false
      end
    end
  end

  defp type_match?(_node, nil), do: true
  defp type_match?({type, _, _}, type), do: true
  defp type_match?({_type, _, _}, "*"), do: true
  defp type_match?(_, _), do: false

  defp classes_matches?(_node, []), do: true
  defp classes_matches?({_, [], _}, _), do: false
  defp classes_matches?({_, attributes, _}, classes) do
    Enum.all? classes, fn(class) ->
      selector = %AttributeSelector{match_type: :includes,
        attribute: "class",
        value: class}

      AttributeSelector.match?(attributes, selector)
    end
  end

  defp attributes_matches?(_node, []), do: true
  defp attributes_matches?({_, [], _}, _), do: false
  defp attributes_matches?({_, attributes, _}, attributes_selectors) do
    Enum.all? attributes_selectors, fn(attribute_selector) ->
      AttributeSelector.match?(attributes, attribute_selector)
    end
  end
end
