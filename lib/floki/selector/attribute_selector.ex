defmodule Floki.Selector.AttributeSelector do
  @moduledoc false

  # It is very similar to the `Selector` module, but is specialized in attributes
  # and attribute selectors.

  alias Floki.Selector.AttributeSelector

  defstruct match_type: nil, attribute: nil, value: nil

  defimpl String.Chars do
    def to_string(selector) do
      "[#{selector.attribute}#{type(selector.match_type)}'#{selector.value}']"
    end

    defp type(match_type) do
      case match_type do
        :equal -> "="
        :includes -> "~="
        :dash_match -> "|="
        :prefix_match -> "^="
        :sufix_match -> "$="
        :substring_match -> "*="
        _ -> ""
      end
    end
  end

  # Returns if attributes of a node matches with a given attribute selector.
  def match?(attributes, s = %AttributeSelector{match_type: nil, value: nil}) do
    attribute_present?(s.attribute, attributes)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :equal}) do
    get_value(s.attribute, attributes) == s.value
  end

  def match?(attributes, s = %AttributeSelector{match_type: :includes}) do
    value = get_value(s.attribute, attributes)

    whitespace_values = String.split(value, " ")

    Enum.any?(whitespace_values, fn v -> v == s.value end)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :dash_match}) do
    value = get_value(s.attribute, attributes)

    value == s.value || String.starts_with?(value, "#{s.value}-")
  end

  def match?(attributes, s = %AttributeSelector{match_type: :prefix_match}) do
    s.attribute |> get_value(attributes) |> String.starts_with?(s.value)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :sufix_match}) do
    s.attribute |> get_value(attributes) |> String.ends_with?(s.value)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :substring_match}) do
    s.attribute |> get_value(attributes) |> String.contains?(s.value)
  end

  defp get_value(attr_name, attributes) do
    {_attr_name, value} =
      Enum.find(attributes, {attr_name, ""}, fn {k, _v} ->
        k == attr_name
      end)

    value
  end

  defp attribute_present?(name, attributes) do
    Enum.any?(attributes, fn {k, _v} -> k == name end)
  end
end
