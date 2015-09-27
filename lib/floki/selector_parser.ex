defmodule Floki.SelectorParser do
  @moduledoc """
  Parses a list of tokens returned from `SelectorTokenizer` and transfor into a `Selector`.
  """

  alias Floki.Selector
  alias Floki.AttributeSelector
  alias Floki.Combinator

  @doc """
  Returns a `Selector` struct with the parsed selector.
  Note that this parser does not deal with groups of selectors.
  """

  def parse(tokens) do
    parse(tokens, %Selector{})
  end

  defp parse([], selector), do: selector
  defp parse([h|t], selector) do
    new_selector =
      case h do
        {:identifier, _, type} ->
          %{selector | type: to_string(type)}
        {'*', _} ->
          %{selector | type: "*"}
        {:hash, _, id} ->
          %{selector | id: to_string(id)}
        {:class, _, class} ->
          %{selector | classes: [to_string(class)|selector.classes]}
        {'[', _} ->
          {t, result} = consume_attribute(t)

          %{selector | attributes: [result|selector.attributes]}
        {:space, _} ->
          {t, combinator} = consume_combinator(t, :descendant)

          %{selector | combinator: combinator}
        {:greater, _} ->
          {t, combinator} = consume_combinator(t, :child)

          %{selector | combinator: combinator}
        {:plus, _} ->
          {t, combinator} = consume_combinator(t, :sibling)

          %{selector | combinator: combinator}
        {:tilde, _} ->
          {t, combinator} = consume_combinator(t, :general_sibling)

          %{selector | combinator: combinator}
        {:unknown, _, unknown} ->
          # TODO: find a better way to notify unknown tokens
          IO.puts("Unknown token #{inspect unknown}. Ignoring.")

          selector
      end

    parse(t, new_selector)
  end

  defp consume_attribute(tokens) do
    consume_attribute(:consuming, tokens, %AttributeSelector{})
  end
  defp consume_attribute(_, [], attr_selector) do
    {[], attr_selector}
  end
  defp consume_attribute(:done, tokens, attr_selector) do
    {tokens, attr_selector}
  end
  defp consume_attribute(status = :consuming, [h|t], attr_selector) do
    new_attr_selector =
      case h do
        {:identifier, _, identifier} ->
          set_attribute_name_or_value(attr_selector, identifier)
        {:equal, _} ->
          %{attr_selector | match_type: :equal}
        {:dash_match, _} ->
          %{attr_selector | match_type: :dash_match}
        {:includes, _} ->
          %{attr_selector | match_type: :includes}
        {:prefix_match, _} ->
          %{attr_selector | match_type: :prefix_match}
        {:sufix_match, _} ->
          %{attr_selector | match_type: :sufix_match}
        {:substring_match, _} ->
          %{attr_selector | match_type: :substring_match}
        {:quoted, 1, value} ->
          %{attr_selector | value: to_string(value)}
        {']', _} ->
          status = :done
          attr_selector
        unknown ->
          # TODO: find a better way to notify unknown tokens
          IO.puts("Unknown token #{inspect unknown}. Ignoring.")

          attr_selector
      end

    consume_attribute(status, t, new_attr_selector)
  end

  defp set_attribute_name_or_value(attr_selector, identifier) do
    # When match type is not defined, this is attribute name.
    # Otherwise, it is an attribute value.
    case attr_selector.match_type do
      nil ->
        %{attr_selector | attribute: to_string(identifier)}
      _ ->
        %{attr_selector | value: to_string(identifier)}
    end
  end

  defp consume_combinator(tokens, combinator_type) when is_atom(combinator_type) do
    consume_combinator(tokens, %Combinator{match_type: combinator_type, selector: %Selector{}})
  end
  defp consume_combinator([], combinator) do
    {[], combinator}
  end
  defp consume_combinator(tokens, combinator) do
    selector = parse(tokens)

    {[], %{combinator | selector: selector}}
  end
end
