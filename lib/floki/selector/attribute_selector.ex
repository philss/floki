defmodule Floki.Selector.AttributeSelector do
  @moduledoc false

  # It is very similar to the `Selector` module, but is specialized in attributes
  # and attribute selectors.

  alias Floki.Selector.AttributeSelector

  defstruct match_type: nil, attribute: nil, value: nil, flag: nil

  @type match_type ::
          nil
          | :equal
          | :includes
          | :dash_match
          | :prefix_match
          | :suffix_match
          | :substring_match

  @type t :: %__MODULE__{
          match_type: match_type(),
          attribute: String.t(),
          value: String.t() | nil,
          flag: String.t() | nil
        }

  defimpl String.Chars do
    def to_string(selector) do
      "[#{selector.attribute}#{type(selector.match_type)}'#{selector.value}'#{flag(selector.flag)}]"
    end

    defp type(match_type) do
      case match_type do
        :equal -> "="
        :includes -> "~="
        :dash_match -> "|="
        :prefix_match -> "^="
        :suffix_match -> "$="
        :substring_match -> "*="
        _ -> ""
      end
    end

    defp flag(nil), do: ""
    defp flag(flag), do: " " <> flag
  end

  # Returns if attributes of a node matches with a given attribute selector.
  def match?(attributes, s = %AttributeSelector{match_type: nil, value: nil}) do
    attribute_present?(s.attribute, attributes)
  end

  # Case-insensitive matches

  def match?(attributes, s = %AttributeSelector{match_type: :equal, flag: "i"}) do
    String.downcase(get_value(s.attribute, attributes)) == String.downcase(s.value)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :includes, flag: "i"}) do
    selector_value = String.downcase(s.value)

    s.attribute
    |> get_value(attributes)
    # Splits by whitespaces ("a  b c" -> ["a", "b", "c"])
    |> String.split(~r/\s+/)
    |> Enum.any?(fn v -> String.downcase(v) == selector_value end)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :dash_match, flag: "i"}) do
    selector_value = String.downcase(s.value)
    value = String.downcase(get_value(s.attribute, attributes))

    value == selector_value || String.starts_with?(value, "#{selector_value}-")
  end

  def match?(attributes, s = %AttributeSelector{match_type: :prefix_match, flag: "i"}) do
    s.attribute
    |> get_value(attributes)
    |> String.downcase()
    |> String.starts_with?(String.downcase(s.value))
  end

  def match?(attributes, s = %AttributeSelector{match_type: :suffix_match, flag: "i"}) do
    s.attribute
    |> get_value(attributes)
    |> String.downcase()
    |> String.ends_with?(String.downcase(s.value))
  end

  def match?(attributes, s = %AttributeSelector{match_type: :substring_match, flag: "i"}) do
    s.attribute
    |> get_value(attributes)
    |> String.downcase()
    |> String.contains?(String.downcase(s.value))
  end

  # Case-sensitive matches

  def match?(attributes, s = %AttributeSelector{match_type: :equal}) do
    get_value(s.attribute, attributes) == s.value
  end

  def match?(attributes, s = %AttributeSelector{match_type: :includes, value: value}) do
    get_value(s.attribute, attributes)
    |> String.split(~r/\s+/)
    |> Enum.any?(fn v -> v == value end)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :dash_match}) do
    value = get_value(s.attribute, attributes)

    value == s.value || String.starts_with?(value, "#{s.value}-")
  end

  def match?(attributes, s = %AttributeSelector{match_type: :prefix_match}) do
    s.attribute |> get_value(attributes) |> String.starts_with?(s.value)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :suffix_match}) do
    s.attribute |> get_value(attributes) |> String.ends_with?(s.value)
  end

  def match?(attributes, s = %AttributeSelector{match_type: :substring_match}) do
    s.attribute |> get_value(attributes) |> String.contains?(s.value)
  end

  defp get_value(attr_name, attributes) do
    Enum.find_value(attributes, "", fn
      {^attr_name, value} -> value
      _ -> false
    end)
  end

  defp attribute_present?(name, attributes) do
    Enum.any?(attributes, fn
      {^name, _v} -> true
      _ -> false
    end)
  end
end
