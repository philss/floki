defmodule Floki.SelectorParser do
  require Logger

  @moduledoc """
  Parses a list of tokens returned from `SelectorTokenizer` and transfor into a `Selector`.
  """

  alias Floki.Selector
  alias Floki.AttributeSelector
  alias Floki.Combinator
  @attr_match_types [:equal, :dash_match, :includes, :prefix_match, :sufix_match, :substring_match]

  @doc """
  Returns a `Selector` struct with the parsed selector.
  Note that this parser does not deal with groups of selectors.
  """

  def parse(tokens) do
    do_parse(tokens, %Selector{})
  end

  defp do_parse([], selector), do: selector
  defp do_parse([{:identifier, _, namespace}, {:namespace_pipe, _}|t], selector) do
    do_parse(t, %{selector | namespace: to_string(namespace)})
  end
  defp do_parse([{:identifier, _, type}|t], selector) do
    do_parse(t, %{selector | type: to_string(type)})
  end
  defp do_parse([{'*', _}|t], selector) do
    do_parse(t, %{selector | type: "*"})
  end
  defp do_parse([{:hash, _, id}|t], selector) do
    do_parse(t, %{selector | id: to_string(id)})
  end
  defp do_parse([{:class, _, class}|t], selector) do
    do_parse(t, %{selector | classes: [to_string(class)|selector.classes]})
  end
  defp do_parse([{'[', _}|t], selector) do
      {t, result} = consume_attribute(t)

      do_parse(t, %{selector | attributes: [result|selector.attributes]})
  end
  defp do_parse([{:space, _}|t], selector) do
    {t, combinator} = consume_combinator(t, :descendant)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:greater, _}|t], selector) do
    {t, combinator} = consume_combinator(t, :child)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:plus, _}|t], selector) do
    {t, combinator} = consume_combinator(t, :sibling)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:tilde, _}|t], selector) do
    {t, combinator} = consume_combinator(t, :general_sibling)

   do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:unknown, _, unknown}|t], selector) do
    Logger.warn("Unknown token #{inspect unknown}. Ignoring.")

    do_parse(t, selector)
  end

  defp consume_attribute(tokens), do: consume_attribute(:consuming, tokens, %AttributeSelector{})
  defp consume_attribute(_, [], attr_selector), do: {[], attr_selector}
  defp consume_attribute(:done, tokens, attr_selector), do: {tokens, attr_selector}
  defp consume_attribute(:consuming, [{:identifier, _, identifier}|t], attr_selector) do
    new_selector = set_attribute_name_or_value(attr_selector, identifier)
    consume_attribute(:consuming, t, new_selector)
  end
  defp consume_attribute(:consuming, [{match_type, _}|t], attr_selector) when match_type in @attr_match_types do
    new_selector = %{attr_selector | match_type: match_type}
    consume_attribute(:consuming, t, new_selector)
  end
  defp consume_attribute(:consuming, [{:quoted, _, value}|t], attr_selector) do
    new_selector = %{attr_selector | value: to_string(value)}
    consume_attribute(:consuming, t, new_selector)
  end
  defp consume_attribute(:consuming, [{']', _}|t], attr_selector) do
    consume_attribute(:done, t, attr_selector)
  end
  defp consume_attribute(:consuming, [unknown|t], attr_selector) do
    Logger.warn("Unknown token #{inspect unknown}. Ignoring.")
    consume_attribute(:consuming, t, attr_selector)
  end

  defp set_attribute_name_or_value(attr_selector, identifier) do
    # When match type is not defined, this is an attribute name.
    # Otherwise, it is an attribute value.
    case attr_selector.match_type do
      nil -> %{attr_selector | attribute: to_string(identifier)}
      _ -> %{attr_selector | value: to_string(identifier)}
    end
  end

  defp consume_combinator(tokens, combinator_type) when is_atom(combinator_type) do
    consume_combinator(tokens, %Combinator{match_type: combinator_type, selector: %Selector{}})
  end
  defp consume_combinator([], combinator), do: {[], combinator}
  defp consume_combinator(tokens, combinator) do
    selector = parse(tokens)

    {[], %{combinator | selector: selector}}
  end
end
