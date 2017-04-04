defmodule Floki.SelectorParser do
  require Logger

  @moduledoc false
  # Parses a list of tokens returned from `SelectorTokenizer` and transfor into a `Selector`.

  alias Floki.{Selector, SelectorTokenizer, AttributeSelector, Combinator}
  alias Floki.Selector.PseudoClass

  @attr_match_types [:equal, :dash_match, :includes, :prefix_match, :sufix_match, :substring_match]

  # Returns a `Selector` struct with the parsed selector.
  # Note that this parser does not deal with groups of selectors.

  def parse(selector) when is_binary(selector) do
    token_list = SelectorTokenizer.tokenize(selector)
    parse(token_list)
  end
  def parse(tokens) do
    do_parse(tokens, %Selector{})
  end

  defp do_parse([], selector), do: selector
  defp do_parse([{:identifier, _, namespace}, {:namespace_pipe, _} | t], selector) do
    do_parse(t, %{selector | namespace: to_string(namespace)})
  end
  defp do_parse([{:identifier, _, type} | t], selector) do
    do_parse(t, %{selector | type: to_string(type)})
  end
  defp do_parse([{'*', _} | t], selector) do
    do_parse(t, %{selector | type: "*"})
  end
  defp do_parse([{:hash, _, id} | t], selector) do
    do_parse(t, %{selector | id: to_string(id)})
  end
  defp do_parse([{:class, _, class} | t], selector) do
    do_parse(t, %{selector | classes: [to_string(class) | selector.classes]})
  end
  defp do_parse([{'[', _} | t], selector) do
    {t, result} = consume_attribute(t)

    do_parse(t, %{selector | attributes: [result | selector.attributes]})
  end
  defp do_parse([{:pseudo_not, _} | t], selector) do
    {t, pseudo_class} = do_parse_pseudo_not(t, %PseudoClass{name: "not"})

    do_parse(t, %{selector | pseudo_class: pseudo_class})
  end
  defp do_parse([{:pseudo, _, pseudo_class} | t], selector) do
    do_parse(t, %{selector | pseudo_class: %PseudoClass{name: to_string(pseudo_class)}})
  end
  defp do_parse([{:pseudo_class_int, _, pseudo_class_int} | t], selector) do
    pseudo_class = selector.pseudo_class
    do_parse(t, %{selector | pseudo_class: %{pseudo_class | value: pseudo_class_int}})
  end
  defp do_parse([{:pseudo_class_even, _} | t], selector) do
    pseudo_class = selector.pseudo_class
    do_parse(t, %{selector | pseudo_class: %{pseudo_class | value: "even"}})
  end
  defp do_parse([{:pseudo_class_odd, _} | t], selector) do
    pseudo_class = selector.pseudo_class
    do_parse(t, %{selector | pseudo_class: %{pseudo_class | value: "odd"}})
  end
  defp do_parse([{:pseudo_class_pattern, _, pattern} | t], selector) do
    pseudo_class = selector.pseudo_class
    do_parse(t, %{selector | pseudo_class: %{pseudo_class | value: to_string(pattern)}})
  end
  defp do_parse([{:pseudo_class_generic_value, _, value} | t], selector) do
    s = case selector.pseudo_class do
          %PseudoClass{name: "not"} ->
            not_selector = parse(to_string(value))

            if not_selector.combinator do
              Logger.warn("Only simple selectors are allowed in :not() pseudo-class. Ignoring.")
              %{selector | pseudo_class: nil}
            else
              %{selector | pseudo_class: %{selector.pseudo_class | value: not_selector}}
            end
          _ ->
            selector
        end

    do_parse(t, s)
  end
  defp do_parse([{:space, _} | t], selector) do
    {t, combinator} = consume_combinator(t, :descendant)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:greater, _} | t], selector) do
    {t, combinator} = consume_combinator(t, :child)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:plus, _} | t], selector) do
    {t, combinator} = consume_combinator(t, :sibling)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:tilde, _} | t], selector) do
    {t, combinator} = consume_combinator(t, :general_sibling)

    do_parse(t, %{selector | combinator: combinator})
  end
  defp do_parse([{:unknown, _, unknown} | t], selector) do
    Logger.warn("Unknown token #{inspect unknown}. Ignoring.")

    do_parse(t, selector)
  end

  defp consume_attribute(tokens), do: consume_attribute(:consuming, tokens, %AttributeSelector{})
  defp consume_attribute(_, [], attr_selector), do: {[], attr_selector}
  defp consume_attribute(:done, tokens, attr_selector), do: {tokens, attr_selector}
  defp consume_attribute(:consuming, [{:identifier, _, identifier} | t], attr_selector) do
    new_selector = set_attribute_name_or_value(attr_selector, identifier)
    consume_attribute(:consuming, t, new_selector)
  end
  defp consume_attribute(:consuming, [{match_type, _} | t], attr_selector) when match_type in @attr_match_types do
    new_selector = %{attr_selector | match_type: match_type}
    consume_attribute(:consuming, t, new_selector)
  end
  defp consume_attribute(:consuming, [{:quoted, _, value} | t], attr_selector) do
    new_selector = %{attr_selector | value: to_string(value)}
    consume_attribute(:consuming, t, new_selector)
  end
  defp consume_attribute(:consuming, [{']', _} | t], attr_selector) do
    consume_attribute(:done, t, attr_selector)
  end
  defp consume_attribute(:consuming, [unknown | t], attr_selector) do
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

  defp do_parse_pseudo_not([{:close_parentesis, _} | t], pseudo_class) do
    {t, pseudo_class}
  end
  defp do_parse_pseudo_not(tokens, pseudo_class) do
    {after_parentesis, before_parentesis} = split_list_for_not_tokens(tokens, [])

    selector = before_parentesis
               |> Enum.reverse
               |> parse

    if selector.combinator do
      Logger.warn("Only simple selectors are allowed in :not() pseudo-class. Ignoring.")
      {after_parentesis, nil}
    else
      {after_parentesis, %{pseudo_class | value: selector}}
    end
  end

  defp split_list_for_not_tokens([{:close_parentesis, _} | t], tokens_before) do
    {t, tokens_before}
  end
  defp split_list_for_not_tokens([], tokens_before) do
    {[], tokens_before}
  end
  defp split_list_for_not_tokens([h | t], tokens_before) do
    split_list_for_not_tokens(t, [h | tokens_before])
  end
end
