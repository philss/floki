defmodule Floki.SelectorTokenizer do
  @moduledoc """
  It decodes a given selector and returns the tokens inside it.
  Check the rules in "src/floki_selector_lexer.xrl"
  """
  def tokenize(""), do: []
  def tokenize(selector) do
    char_list = selector |> String.strip |> String.to_char_list

    {:ok, token_list, _} = :floki_selector_lexer.string(char_list)

    token_list
  end
end
